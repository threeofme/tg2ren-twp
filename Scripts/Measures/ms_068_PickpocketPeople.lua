-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_068_PickpocketPeople"
----
----	with this measure, the player can send a thief, to pickpocket people
---- impact HaveBeenPickpocketed
-------------------------------------------------------------------------------

function Init()
end 

-- changes: added about 50 base gold to all successful pickpocketings

function Run()
--	LogMessage("::TOM::Pickpocket::"..GetName("").." Moving to position...")
	--f_ExitCurrentBuilding("")
	f_MoveTo("","Destination", GL_MOVESPEED_RUN)
--	LogMessage("::TOM::Pickpocket::"..GetName("").." Arrived at position")
	GetPosition("", "TargetDestination")
	local Destination = "TargetDestination"
	
	--the time, a thief must wait to rob the same person again
	local TimeToWait = 12
	local Value
	
	-- initialize working place
	if not SimGetWorkingPlace("","MyHome") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_THIEF)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"MyHome")
		else
			StopMeasure()
		end
	end
	
	local DestX, DestY, DestZ = PositionGetVector(Destination)
	local TargetX, TargetZ
	-- stop after 4 hours if started by AI
	local Endtime = GetGametime() + 4
	local NextPosition = "CurrentPosition"

	while true do
		-- check AI management of workshop
		if BuildingGetAISetting("MyHome", "Enable") > 0 and GetGametime() > Endtime then
			StopMeasure()
			return
		end
		
		PlayAnimation("", "watch_for_guard")
		local NumOfObjects = Find("Owner","__F( (Object.GetObjectsByRadius(Sim)==1000) AND NOT(Object.BelongsToMe())AND NOT(Object.GetState(cutscene))AND NOT(Object.HasImpact(HaveBeenPickpocketed))AND(Object.MinAge(16)))","Sims",-1)
--		LogMessage("::TOM::Pickpocket::"..GetName("Owner").." Looking for victims... Found "..NumOfObjects)
		if NumOfObjects <= 0 then
			-- change position			
--			LogMessage("::TOM::Pickpocket::"..GetName("").." Changing position")
			TargetX = DestX + (Rand(1500) - 750.0)
			TargetZ = DestZ + (Rand(1500) - 750.0)
--			LogMessage("::TOM::Pickpocket Position is:"..TargetX..", "..TargetZ)
			if ScenarioCreatePosition(TargetX, TargetZ, NextPosition) then
--				StartMagicalEffect(CurrentPosition,"particles/aimingpoint.nif",5,0,2000,2000)				
				f_MoveTo("",NextPosition,GL_MOVESPEED_WALK,10)
			end
		else
			local DestAlias = "Sims"..Rand(NumOfObjects-1)
			LogMessage("::TOM::Pickpocket::"..GetName("").." Going for "..GetName(DestAlias))
			local DoIt = 1
			if GetCurrentMeasureName(DestAlias)=="AttendMass" then 
				DoIt = 0
			end
			local VictimSkill
			if IsDynastySim(DestAlias) then 
				VictimSkill = GetSkillValue(DestAlias,EMPATHY)
			else
				VictimSkill = Rand(4) + 1
			end
			if DoIt==1 then
				LogMessage("::TOM::Pickpocket::"..GetName("").." I'll do it!")
				if SendCommandNoWait(DestAlias, "BlockMe") then 
					SetData("Blocked", 1)
					f_MoveTo("", DestAlias, GL_MOVESPEED_WALK, 140)
					AlignTo("", DestAlias)
					Sleep(0.7)
					PlayAnimation("", "pickpocket")
					AddImpact(DestAlias,"HaveBeenPickpocketed",1,TimeToWait)
					
					if CheckSkill("", DEXTERITY, VictimSkill) then
						-- successful theft
						local		ThiefLevel				= SimGetLevel("")
						local		VictimSpendValue	= Rand(40) + ThiefLevel * 20 + 15
						
						if Rand(100 ) > (100-ThiefLevel*2) then
							VictimSpendValue = VictimSpendValue*3
						end
						
						IncrementXPQuiet("",15)
						chr_RecieveMoney("", VictimSpendValue, "IncomeThiefs")
						economy_UpdateBalance("MyHome", "Theft", VictimSpendValue)
						--for the mission
						mission_ScoreCrime("",VictimSpendValue)
						-- Play a coin sound for the local player
						if dyn_IsLocalPlayer("") then
							PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
						end
						
						if IsPartyMember(DestAlias) then
						
							local Value = GetMoney(DestAlias) * 0.05
							if VictimSpendValue > Value then
								VictimSpendValue = Value
							end
							f_SpendMoney(DestAlias, VictimSpendValue, "theft")
							
							if VictimSpendValue>25 then
								feedback_MessageCharacter(DestAlias,
									"@L_THIEF_068_PICKPOCKETPEOPLE_MSG_VICTIM_HEAD_+0",
									"@L_THIEF_068_PICKPOCKETPEOPLE_MSG_VICTIM_BODY_+0",GetID(DestAlias), VictimSpendValue)
							end
						end
						Sleep(0.75)
						SetData("Blocked", 0)
					else
						SetData("Blocked", 0)
						if chr_GetTitle(DestAlias) > 3 and CheckSkill("", SHADOW_ARTS, VictimSkill) then
							chr_ModifyFavor(DestAlias,"",-5)
							CommitAction("pickpocket", "", "", DestAlias)
							feedback_OverheadComment(DestAlias,
								"@L_THIEF_068_PICKPOCKETPEOPLE_SCREAM_+0", false, true)
							if BuildingHasUpgrade("MyHome",543) then
							    if GetState("", STATE_FIGHTING) == false then
								    ms_068_pickpocketpeople_FastHide()
								end
							else
							    f_MoveTo("","MyHome",GL_MOVESPEED_RUN,0)
							    StopAction("pickpocket","")
							    Sleep(30)
--							    if IsAIDriven() then
--									StopMeasure()
--									return
--								end
							end
--							LogMessage("TWP::THIEF Move Around")
							TargetX = DestX + (Rand(1500) - 750.0)
							TargetZ = DestZ + (Rand(1500) - 750.0)
							if ScenarioCreatePosition(TargetX, TargetZ, NextPosition) then
								f_MoveTo("",NextPosition,GL_MOVESPEED_WALK,10)
							end
						end
					end
				end
			end	
		end
		Sleep(5)
	end
end

function BlockMe()
	while GetData("Blocked")==1 do
		Sleep(5)
	end
end

function FastHide()

    StopAction("pickpocket","")
    GetPosition("","standPos")
	PlayAnimationNoWait("","crouch_down")
	Sleep(1)
	local filter ="__F((Object.GetObjectsByRadius(Building)==1000))"
	local k = Find("",filter,"Umgebung",15)
	if k > 0 then
	    GfxAttachObject("tarn","Handheld_Device/barrel_new.nif")
	else
	    GfxAttachObject("tarn","Outdoor/Bushes/bush_08_big.nif")
	end
	GfxSetPositionTo("tarn","standPos")
	SetState("", STATE_INVISIBLE, true)
	Sleep(10)

	SimBeamMeUp("","standPos",false)
	GfxDetachAllObjects()
    SetState("", STATE_INVISIBLE, false)
	PlayAnimationNoWait("","crouch_up")

end

function CleanUp()
	--stop hiding
	--SetState("",STATE_HIDDEN,false)

	StopAnimation("")
	StopAction("pickpocket","")
end

