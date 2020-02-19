function Run()
	local ExecID = 0
	if not AliasExists("Destination") then 
		-- no destination found (should never happen)
		return
	end
	if HasProperty("Destination","GettingTortured") then
		return
	end
	if GetID("Destination")==GetID("") then
		return
	end

	if not GetSettlement("", "CityAlias") then
	 	-- no city found (should never happen for a city guard)
		return 
	end

	if not CityGetRandomBuilding("CityAlias", -1, GL_BUILDING_TYPE_PRISON, -1, -1, FILTER_IGNORE, "Prison") then
		-- no prison found
		return
	end
	
	if not CityGetPenalty("CityAlias", "Destination", PENALTY_UNKNOWN, true, "Penalty") then
		return
	end
	
	if CityGetPenalty("CityAlias", "Destination", PENALTY_FUGITIVE, true, "Penalty") then
		if GetState("Destination",STATE_UNCONSCIOUS) and GetImpactValue("Destination", "REVOLT")==1 then
			MeasureRun("","Destination","Kill")
		else
			gameplayformulas_SimAttackWithRangeWeapon("", "Destination")
			BattleJoin("","Destination", true)
		end
		Sleep(3)
		return
	end
	
	if GetState("Destination",STATE_FIGHTING) or GetState("Destination",STATE_CAPTURED) then
		return
	end
	
	if not ai_StartInteraction("", "Destination", 500, 110,"Captured") then
		CopyAlias("Destination", "Backup")
		StopMeasure()
		return
	end
	
	AlignTo("", "Destination")
	--BattleWeaponPresent("")
	Sleep(0.5)
	PlayAnimationNoWait("", "propel")

	if GetState("Destination",STATE_UNCONSCIOUS) then 
		SetState("Destination", STATE_UNCONSCIOUS, false)
		Sleep(5)
	end

	local Time = MoveSetActivity("Destination","arrested") 
	Sleep(Time+4)

	--if the destination has penalty prison
	if CityGetPenalty("CityAlias", "Destination", PENALTY_PRISON, true, "Penalty") then
		SetData("arrester",1)
		RemoveProperty("Destination","NoEscape")
		CommitAction("gauntlet", "Destination", "Destination", "")
		SetData("Action_Started", "gauntlet")
		
		f_FollowNoWait("", "Destination", GL_MOVESPEED_WALK, 160)
		Sleep(1)
		if GetOutdoorMovePosition(nil, "Prison", "MovePos") then
			if not (f_MoveTo("Destination", "MovePos", GL_MOVESPEED_WALK)) then
				StopMeasure()
				return
			end			
		else
			if not (f_MoveTo("Destination", "Prison", GL_MOVESPEED_WALK)) then
				StopMeasure()
				return
			end		
		end		
		MoveStop("")
		MoveStop("Destination")
		BattleWeaponStore("")
	
		if not f_MoveTo("Destination", "Prison") then
			if GetInsideBuildingID("Destination")~=GetID("Prison") then
				StopMeasure()
				return
			end
		end
		MoveSetActivity("Destination","")
		if not GetInsideBuilding("Destination","CurrentBuilding") then
			StopMeasure()
		end
		if GetID("CurrentBuilding") == GetID("Prison") then
			SetState("Destination", STATE_IMPRISONED, true)
		end
			
		gameplayformulas_StartHighPriorMusic(MUSIC_DUNGEON) 
		StopMeasure()
	
	--if the destination has penalty pillory
	elseif CityGetPenalty("CityAlias", "Destination", PENALTY_PILLORY, true, "Penalty") then
		
		
		if not CityGetRandomBuilding("CityAlias", -1, GL_BUILDING_TYPE_EXECUTIONS_PLACE, -1, -1, FILTER_IGNORE, "Pillory") then
		-- no pillory found
			StopMeasure()
		end
		
		--go to the execution place
		GetLocatorByName("Pillory","pillory","PilloryPos")
		f_FollowNoWait("", "Destination", GL_MOVESPEED_WALK, 160) 
		Sleep(1)
		if GetInsideBuilding("Destination","CurrentBuilding") then
			f_ExitCurrentBuilding("Destination")
		end
		
		if not f_MoveTo("Destination","PilloryPos") then
			f_MoveTo("Destination","Pillory")
			SimBeamMeUp("Destination","PilloryPos",false)
		end
			
		f_MoveTo("","Destination",GL_MOVESPEED_WALK,100)
		BattleWeaponStore("")
		MoveSetActivity("Destination","")
		Sleep(3)
	
		SetProperty("Destination", "penalty_city", GetID("CityAlias"))
		SetState("Destination", STATE_PILLORY, true)
		
		PlayAnimation("","sentinel_idle")
		MeasureSetNotRestartable()
		SetData("locked",0)
		
		
	--if the destination has death penalty
	elseif CityGetPenalty("CityAlias", "Destination", PENALTY_DEATH, true, "Penalty") then

		if not CityGetRandomBuilding("CityAlias", -1, GL_BUILDING_TYPE_EXECUTIONS_PLACE, -1, -1, FILTER_IGNORE, "ExecutionPlace") then
		-- no execution place found
			StopMeasure()
		end
		
		GetLocatorByName("ExecutionPlace","executionPlace","ExecPos")
		
		f_FollowNoWait("", "Destination", GL_MOVESPEED_WALK, 200)
		Sleep(4)
		BlockChar("Destination")
		SetActiveAvoidance("Destination",true)
		if not f_BeginUseLocator("Destination","ExecPos",GL_STANCE_STAND,true) then
		
			SimBeamMeUp("Destination","ExecPos",false)
		end
		
		f_MoveTo("","Destination",GL_MOVESPEED_WALK,300)
		--BattleWeaponStore("")
		--MoveSetActivity("Destination","")
		CommitAction("pillory","Destination","Destination")
		SetData("Action_Started", "Pillory")
		SetProperty("Destination","NoEscape",1)
		gameplayformulas_StartHighPriorMusic(MUSIC_EXECUTION)
		local ActivityTime = MoveSetActivity("Destination","execute")
		
		

		PlayAnimationNoWait("","sentinel_idle")
		Sleep(ActivityTime)
		--create the executioner
		if FindNearestBuilding("", -1, GL_BUILDING_TYPE_TOWNHALL, -1, false, "TownHall") then
			GetLocatorByName("TownHall", "Entry1", "ExecutionerSpawnPos")
				
			if SimCreate(715, "TownHall", "ExecutionerSpawnPos", "SimExecutioner") then
				ExecID = GetID("SimExecutioner")
				CarryObject("SimExecutioner","weapons/axe_02.nif",false)
				SetData("SimExecutioner", 1)
				
				-- Avert the executioner from anything else but his duty !
				SetState("SimExecutioner", STATE_LOCKED, true)
				
				-- Let the executioner go to the dead sim
				
				if GetLocatorByName("ExecutionPlace","executioner","ExecutionerPos") then
					--if not f_BeginUseLocator("SimExecutioner", "ExecutionerPos", GL_STANCE_STAND, true) then
					if not f_MoveTo("SimExecutioner", "ExecutionerPos") then
						BlockChar("SimExecutioner")
						SimBeamMeUp("SimExecutioner","ExecutionerPos",false)
					end
					Sleep(1)
				end				
			end
		end
		
		GetPosition("Destination", "ParticleSpawnPos")
		SetData("locked",0)
		Sleep(2)
		PlayAnimationNoWait("SimExecutioner","finishing_move_02")
		Sleep(1)
		PlaySound3DVariation("Destination","Effects/combat_strike_metal",1)
		PlaySound3DVariation("Destination","combat/pain",1)
		SetProperty("Destination","Executed",1)
		--Time = PlayAnimationNoWait("Destination","execute_out")
--		Time = MoveSetActivity("","")
--		MeasureSetNotRestartable()
		
		Sleep(0.5)
		StopAction("Pillory", "Destination")
		
		--if mission
		if HasProperty("Destination","ExecutedBy") then
			GetAliasByID(GetProperty("Destination","ExecutedBy"),"accuser")
			mission_ScoreAccuse("accuser")
		end
		
		feedback_MessageCharacter("Destination",
			"@L_GENERAL_MEASURES_EXECUTED_MSG_DEAD_HEAD_+0",
			"@L_GENERAL_MEASURES_EXECUTED_MSG_DEAD_BODY_+0", GetID("Destination"))
		
		Kill("Destination")
		Sleep(2)
		ms_fightarrest_Terminate(ExecID)
	end
	
	StopMeasure()
end

function Captured()
	SetData("locked",1)
	MoveStop("")
	SetProperty("Destination","NoEscape",1)
	SetState("", STATE_CAPTURED, true)
	SetData("CapturedByMe", 1)
	AlignTo("", "Owner")
	Sleep(0.7)
			
	while GetData("locked") == 1 do
		Sleep(2.8)
	end
end

-- -----------------------
-- Terminate
-- -----------------------
function Terminate(ExecID)
	
	-- Get rid of the Executioner
	GetAliasByID(ExecID,"SimExec")
	if AliasExists("SimExecutioner") then
		-- Let the executioner go to the next townhall and disapear
		if FindNearestBuilding("SimExec", -1, GL_BUILDING_TYPE_TOWNHALL, -1, false, "Townhall") then
			f_MoveTo("SimExec", "Townhall")
		end
	
		InternalDie("SimExec")
		InternalRemove("SimExec")
	end
	
	
end

function CleanUp() 	
	--BattleWeaponStore("")
	
	local JoinBattle = false
	
	SetState("",STATE_SCANNING,true)
	if (GetData("arrester") == 1) then
		if not AliasExists("Destination") then
			return
		end
	
		if not (GetState("Destination", STATE_IMPRISONED) or GetState("Destination", STATE_PILLORY) or GetState("Destination", STATE_DEAD)) then
			
			if AliasExists("Penalty") then
				JoinBattle = true
			end
		end
	
		local Action_Name = GetData("Action_Started")
		if Action_Name then
			StopAction(Action_Name, "Destination")
		end
	end
	
	if HasData("CapturedByMe") and GetData("CapturedByMe")==1 then
		if AliasExists("Destination") then
			SetState("Destination", STATE_CAPTURED, false)
			RemoveProperty("Destination","NoEscape")
		end
	end
	
	if JoinBattle then
		PenaltyReset("Penalty")
		gameplayformulas_SimAttackWithRangeWeapon("", "Destination")
		BattleJoin("","Destination", true) 
	end
		
end
