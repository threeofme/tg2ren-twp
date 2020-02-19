function Run()

	if not SquadGet("", "Squad") then
		return
	end
	if not SimGetWorkingPlace("","Base") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_THIEF)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"Base")
		else
			StopMeasure()
		end
	end
	if not AliasExists("Base") then
		return
	end
	if not HasProperty("Squad", "Victim") then
		return 
	end
	
	local	TargetID = GetProperty("Squad", "Victim")
	if TargetID < 1 then
		return 
	end	
	
	if not GetAliasByID(TargetID, "Victim") then
		return 
	end

	while true do
		if not ms_squadhijackmember_Check() then
			break
		end
		Sleep(Rand(20)*0.1+2)
	end
end

function Check()

	if GetState("Victim",STATE_HIJACKED) then
		return false
	end

	if not GetState("Victim",STATE_UNCONSCIOUS) then
		
		if GetInsideBuilding("Victim","CurrentBuilding") then
			if GetHPRelative("CurrentBuilding") > 0.3 then
				if GetOutdoorMovePosition("","CurrentBuilding","OutdoorPos") then
					f_MoveTo("","OutdoorPos")
				end
				return true
			end
		end
		
		if not f_Follow("", "Victim", GL_MOVESPEED_RUN, 800, true) then
			return
		end
		ms_squadhijackmember_Attack()
		
		return true
	end
	
	if HasProperty("Victim","LeaderID") then
		if GetAliasByID(GetProperty("Victim","LeaderID"),"Leader") then
			f_FollowNoWait("","Leader")
			while HasProperty("Victim","LeaderID") do
				Sleep(2)
			end
		end
	else 
		SetProperty("Victim","LeaderID",GetID(""))
		SetRepeatTimer("Base", GetMeasureRepeatName2("Hijack"), 48)
		ms_squadhijackmember_Hijack()
	end
	
	return true
end

function Attack()

	if DynastyIsAI("") then
		local 	Check = ai_CheckForces("", "Victim", 1500)
		if Check == false then
			Sleep(5 + Rand(11))
			return
		end
	end
	
	--check if destination has drunken boozybreathbeer
	if GetImpactValue("Victim","boozybreathbeer")==1 then	
		GetPosition("Victim", "ParticleSpawnPos")
		StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.7,3)
		PlaySound3DVariation("Victim","measures/boozybreathbeer",1)
		feedback_OverheadComment("", "@L_THIEF_065_HIJACKCHARACTER_BOOZYBREATHBEER_COMMENT_+0", false, true)

		GetFleePosition("", "Victim", 1000, "Away")
		f_MoveTo("", "Away", GL_MOVESPEED_RUN)
		
		feedback_MessageCharacter("Owner",
			"@L_THIEF_065_HIJACKCHARACTER_BOOZYBREATHBEER_FAILED_ACTOR_HEAD_+0",
			"@L_THIEF_065_HIJACKCHARACTER_BOOZYBREATHBEER_FAILED_ACTOR_BODY_+0", GetID("Victim"))
					
		feedback_MessageCharacter("Victim",
			"@L_THIEF_065_HIJACKCHARACTER_BOOZYBREATHBEER_FAILED_VICTIM_HEAD_+0",
			"@L_THIEF_065_HIJACKCHARACTER_BOOZYBREATHBEER_FAILED_VICTIM_BODY_+0", GetID("Victim"),ItemGetLabel("BoozyBreathBeer", true))			
		
		SquadDestroy("Squad")
		StopMeasure()
		return
	end

	SetData("DontLeave", 1)
	CommitAction("SLUGGING","","Victim","Victim")
	
	if not MeasureRun("","Victim","AttackEnemy",true) then
		return false
	end
	
	RemoveData("DontLeave")
	return true
end

function Hijack()
	if GetImpactValue("Victim","messagesent")==0 then
		AddImpact("Victim","messagesent",1,1)
		feedback_MessageCharacter("Victim",
			"@L_THIEF_065_HIJACKCHARACTER_MSG_VICTIM_HEAD",
			"@L_THIEF_065_HIJACKCHARACTER_MSG_VICTIM_BODY",GetID("Victim"))
	end
	
	if not f_MoveTo("","Victim",GL_MOVESPEED_WALK,100) then
		StopMeasure()
		return
	end
	
	if not SimGetWorkingPlace("","Base") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_THIEF)
			if not NextBuilding then
				StopMeasure()
				return
			end
			CopyAlias(NextBuilding,"Base")
		else
			StopMeasure()
			return
		end
	end
	
	if not GetLocatorByName("Base","Cell_Outside","CellPos") then
		StopMeasure()
		return
	end
	
	if not GetLocatorByName("Base","Cell_Door","CellWalkPos") then
		StopMeasure()
		return
	end
	
	AlignTo("","Victim")
	Sleep(1)
	
	
	local ActivityTime = MoveSetActivity("","carrywood")
	Sleep(1.5)
	CarryObject("","Handheld_Device/ANIM_Largesack.nif", false)
	chr_GainXP("", 250)
	
	--hide the victim
	CommitAction("hijack","","Victim","Victim")
	SetState("Victim",STATE_DUEL,true)
	AddImpact("Victim", "Hidden", 1 , -1)
	SetInvisible("Victim", true) 
	SimBeamMeUp("Victim","CellWalkPos", false) -- false added
	SetData("VictimHidden",1)
	
	Sleep(3)
	
	if not (f_MoveTo("", "CellPos",GL_MOVESPEED_WALK,400)) then
		StopMeasure()
		return
	end
	
	SetRoomAnimationTime("Base","","U_PrisonDoor",0)
	StartRoomAnimation("Base","","U_PrisonDoor")
	Sleep(1)
	StopRoomAnimation("Base","","U_PrisonDoor")
	
	GetLocatorByName("Base","EntryPrisonPos","EntryPrisonPos")
	f_MoveTo("","EntryPrisonPos",GL_MOVESPEED_WALK,0)
	
	SetData("VictimThere",1)
	SetState("Victim",STATE_DUEL,false)
	SetState("Victim", STATE_HIJACKED, true)
	ActivityTime = MoveSetActivity("","")
	Sleep(1.5)
	CarryObject("","",false)
	
	SetInvisible("Victim", false) 
	RemoveData("VictimHidden")
	
	Sleep(ActivityTime-1.5)
	
	f_MoveTo("","CellPos",GL_MOVESPEED_WALK,0)
	
	StartRoomAnimation("Base","","U_PrisonDoor")
	Sleep(1.3)
	StopRoomAnimation("Base","","U_PrisonDoor")
	SetRoomAnimationTime("Base","","U_PrisonDoor",0)
	RemoveImpact("Victim", "Hidden")
	SetRoomAnimationTime("Base","","U_PrisonDoor",0)
	StopMeasure()
end

function Captured()
	SetData("locked",1)
	
	while GetData("locked") == 1 do
		Sleep(0.8)
	end
end

function CleanUp()
	MoveSetActivity("","")
	if GetID("")==GetProperty("Victim","LeaderID") then
		RemoveProperty("Victim","LeaderID")
	end
	
	if HasData("VictimHidden") then	
		if AliasExists("Base") then
			if GetState("Victim",STATE_UNCONSCIOUS) then
				if GetInsideBuildingID("")~=GetID("Base") then
					GetPosition("","LayDownPos")
					SetState("Victim",STATE_DUEL,false)
					SimBeamMeUp("Victim","LayDownPos", false)
				else
					SetState("Victim", STATE_HIJACKED, true)
				end
			end
		end
		
		RemoveImpact("Victim", "Hidden")
		SetInvisible("Victim", false) 
	end
	
	if HasData("DontLeave") then
		RemoveData("DontLeave")
	else
		SquadRemoveMember("", true)
		if AliasExists("Squad") then
			if SquadGetMemberCount("Squad", true)<1 then
				SquadDestroy("Squad")
				return
			end
		end
	end
end



