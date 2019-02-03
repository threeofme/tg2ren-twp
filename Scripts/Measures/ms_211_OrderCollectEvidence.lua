function Run()
	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand
	local ActionDistance = 80

--	StartGameTimer(24)
	--MeasureSetStopMode(STOP_NOMOVE)
	
	f_ExitCurrentBuilding("Owner")
	
	--MeasureSetNotRestartable() 
	f_MoveTo("","Destination")
	
	if not SimGetWorkingPlace("Owner","WorkBuilding") then
		return
	end
	local IsMonitor = false
	if not BuildingGetOwner("WorkBuilding","BuildingOwner") then
		if SimGetProfession("")==GL_PROFESSION_MONITOR then
			SimGetServantDynasty("","BuildingOwner")
			IsMonitor = true
		--sim is monitor
		else
			return
		end
	end

	MsgMeasure("","@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_ACTION_+0")

	local Total = 0
	--ai timeout
	local TimeOut
	if SimGetWorkingPlace("", "MyWork") and DynastyIsAI("MyWork") then
		TimeOut = GetData("TimeOut") or 4
		if TimeOut then
			TimeOut = GetGametime() + TimeOut
		end
	end
		
	while true do
		if TimeOut and TimeOut < GetGametime() then
			StopMeasure()
			return
		end
		
		if not AliasExists("Destination") then
			GetSettlement("","City")
			if CityFindCrowdedPlace("City","","Destination")==0 then
				break
			end
		end
		
		local NumOfObjects = Find("Owner","__F( (Object.GetObjectsByRadius(Sim)==1000) AND NOT(Object.BelongsToMe())AND(Object.CanBeInterrupted(OrderCollectEvidence))AND NOT(Object.GetState(cutscene))AND NOT(Object.HasImpact(HasBeenTalked))AND NOT(Object.GetProfession() == 25)AND NOT(Object.GetProfession() == 21)AND NOT(Object.GetProfession() == 22))","Sims",-1)
		if NumOfObjects>0 then
			local DestAlias = "Sims"..Rand(NumOfObjects)
			
			local Check = true
			if IsDynastySim(DestAlias) and DynastyIsPlayer(DestAlias) then
				Check = false
			end
			
			if HasProperty(DestAlias,"QuestActive") then
				Check = false
			end
		
			if Check then
			
				SetData("Blocked", 0)
				if ai_StartInteraction("", DestAlias, MaxDistance, ActionDistance, "BlockMe") then
					AddImpact(DestAlias,"HasBeenTalked",1,6)
					AlignTo(DestAlias,"")
					Sleep(0.7)
					PlayAnimationNoWait("Owner", "talk")
					if SimGetGender("")==GL_GENDER_MALE then
						PlaySound3DVariation("","CharacterFX/male_neutral",1)
					else
						PlaySound3DVariation("","CharacterFX/female_neutral",1)
					end
					Sleep(0.75)
					PlayAnimation(DestAlias, "talk")
					local Cnt = Talk("", DestAlias, true)
					if Cnt>0 then
						if SimGetGender("")==GL_GENDER_MALE then
							PlaySound3DVariation("","CharacterFX/male_amazed",1)
						else
							PlaySound3DVariation("","CharacterFX/female_amazed",1)
						end
						if IsMonitor then
							feedback_MessageCharacter("BuildingOwner",
								"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_SUCCESS_HEAD_+0",
								"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_SUCCESS_BODY_+0",GetID(""))
							Total = Total + Cnt
						else
							feedback_MessageCharacter("",
								"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_SUCCESS_HEAD_+0",
								"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_SUCCESS_BODY_+0",GetID(""))
							Total = Total + Cnt
							IncrementXP("",25)
						end
					end
				else
					f_MoveTo("","Destination",GL_MOVESPEED_RUN)
					Sleep(1)
				end
				SetData("Blocked", 1)
			end
		else
			if GetDistance("","Destination")>500 then
				f_MoveTo("","Destination")
			end
			Sleep(2)
		end
		Sleep(2)
	end
		
	if Total == 0 then
		if IsMonitor then
			feedback_MessageCharacter("BuildingOwner",
				"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_FAILED_HEAD_+0",
				"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_FAILED_BODY_+0",GetID(""))
		else
			feedback_MessageCharacter("",
				"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_FAILED_HEAD_+0",
				"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_FAILED_BODY_+0",GetID(""))
		end
	end
	
--	MeasureRun("","Destination",2110,true)
	
	--f_MoveTo("","Workbuilding")
end

function BlockMe()
	if HasData("Blocked") then
		while GetData("Blocked")~=1 do
			Sleep(1.5)
		end
	end
end

function CleanUp()
	StopAnimation("Owner")
end

