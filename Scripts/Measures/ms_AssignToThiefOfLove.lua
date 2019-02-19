function Run()
	local TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end

	if not SimGetWorkingPlace("", "WorkBuilding") then
		if not AliasExists("WorkBuilding") then
			if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_PIRAT, "WorkBuilding") then
				StopMeasure() 
				return
			end
		end 
	end
	MeasureSetStopMode(STOP_NOMOVE)

	if not AliasExists("Destination") then
		if not GetSettlement("WorkBuilding", "City") then
			return
		end
		
		if CityFindCrowdedPlace("City", "", "Destination")==0 then
			return
		end	
	end

	local zielloc = Rand(50)+20
	if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,zielloc) then
		StopMeasure()
	end

	SetProperty("","ThiefOfLove",1)
	SetProperty("","CocotteHasClient",0)
	SetProperty("","CocotteProvidesLove",1)

	GetPosition("","CurrentPosition")
  local x,y,z = PositionGetVector("CurrentPosition")
	SetProperty("","MyPosX",x)
	SetProperty("","MyPosZ",z)

	GetAliasByID(GetID("WorkBuilding"),"Dest")
	BuildingGetOwner("Dest","Boss")

	local BreakNumber = 0

	-- start the labor
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)

	while true do
		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end
		
		-- some animation stuff
		-- random speech
		local SimFilter = "__F( (Object.GetObjectsByRadius(Sim)==500)AND(Object.HasDifferentSex())AND(Object.GetState(idle))AND NOT(Object.GetState(townnpc))AND NOT(Object.HasImpact(HaveBeenPickpocketed))AND NOT(Object.HasImpact(FullOfLove)))"
		local NumSims = Find("",SimFilter,"Sims",-1)
		if NumSims > 0 then
			local DestAlias = "Sims"..Rand(NumSims-1)
			CopyAlias(DestAlias, "VictimSim")

			local DoIt = true
			if GetCurrentMeasureName("VictimSim")=="AttendMass" then 
				DoIt = false
			end
			if DynastyGetDiplomacyState("Boss", "VictimSim") > DIP_NEUTRAL then
				DoIt = false
			end	
			
			if DoIt then
				if SendCommandNoWait("VictimSim", "BlockMe") then
					Sleep(1)
					local VictimSkill	
					if IsDynastySim("VictimSim") then
						VictimSkill = GetSkillValue("VictimSim",EMPATHY)
					else
						VictimSkill = Rand(6) + 1
					end
					StopAnimation("")
					f_MoveTo("", "VictimSim", GL_MOVESPEED_WALK,90)
					Sleep(0.3)
					AlignTo("", "VictimSim")
					Sleep(0.7)
					local AnimTime = PlayAnimation("", "pickpocket")						

					if CheckSkill("", 3, VictimSkill) then 
						--MsgSay("","@L Case 1")
						--Sleep(1)
						AddImpact("VictimSim","HaveBeenPickpocketed", 1, 8)
						local VictimSpendValue = Rand(SimGetLevel("") * 20) + 25
						IncrementXPQuiet("", 15)
						chr_RecieveMoney("Owner", VictimSpendValue, "IncomeThiefs")
						--for the mission
						mission_ScoreCrime("",VictimSpendValue)
						-- Play a coin sound for the local player
						if dyn_IsLocalPlayer("") then
							PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
						end
							
						if IsPartyMember("VictimSim") then
							local Value = GetMoney("VictimSim") * 0.005
							if VictimSpendValue > Value then
								VictimSpendValue = Value
							end
							f_SpendMoney("VictimSim", VictimSpendValue, "theft")
							
							if VictimSpendValue>25 then
								feedback_MessageCharacter("VictimSim",
									"@L_THIEF_068_PICKPOCKETPEOPLE_MSG_VICTIM_HEAD_+0",
									"@L_THIEF_068_PICKPOCKETPEOPLE_MSG_VICTIM_BODY_+0",GetID("VictimSim"), VictimSpendValue)
							end
						end

						Sleep(1)
						AlignTo("","VictimSim")
						Sleep(0.3)
						local AnimTime = PlayAnimationNoWait("","point_at")
						MsgSayNoWait("","@L_PIRATE_LABOROFLOVE_PROPOSE")
						Sleep(3)

						MeasureRun("VictimSim","","UseLaborOfLove", true)
						SetData("TLBlocked"..GetID("VictimSim"), 1)

					else
						if CheckSkill("",6,VictimSkill) then
						--MsgSay("","@L Case 2")
							AddImpact("VictimSim","HaveBeenPickpocketed", 1, 1)
							Sleep(1)
							AlignTo("","VictimSim")
							Sleep(0.3)
							local AnimTime = PlayAnimationNoWait("","point_at")
							MsgSayNoWait("","@L_PIRATE_LABOROFLOVE_PROPOSE")
							Sleep(3)
							MeasureRun("VictimSim","","UseLaborOfLove", true)
							SetData("TLBlocked"..GetID("VictimSim"), 1)
								--win
						else
							--MsgSay("","@L Case 3")
							--lose
							Sleep(1)
							AddImpact("VictimSim","HaveBeenPickpocketed", 1, 1)
							local Difficulty = math.floor(math.pow(ScenarioGetDifficulty(),0.54))
							local Badluck = Rand(70 + (GetSkillValue("",SHADOW_ARTS)*15))
							if ((chr_GetTitle("VictimSim") > 3) and (Badluck < (2+Difficulty))) or (Badluck < (Difficulty)) then
								CommitAction("pickpocket", "", "", "VictimSim")
								feedback_OverheadComment("VictimSim",
									"@L_THIEF_068_PICKPOCKETPEOPLE_SCREAM_+0", false, true)
								SetData("TLBlocked"..GetID("VictimSim"), 1)
								f_MoveToNoWait("", "WorkBuilding", GL_MOVESPEED_RUN)
								Sleep(5)
								StopAction("pickpocket","")
								Sleep(50)
							end
						end
						Sleep(2)

						if not AliasExists("Destination") then
							if HasProperty("","MyPosX") then
								ScenarioCreatePosition(GetProperty("","MyPosX"), GetProperty("","MyPosZ"), "Destination")
							else
								GetNearestSettlement("", "City")
								CityFindCrowdedPlace("City", "", "Destination")
							end
						end

						local Distance = GetDistance("", "Destination")
						if Distance > 80 then
							f_MoveTo("","Destination",GL_MOVESPEED_WALK)
							Sleep(1)
						end
					end
				end
				Sleep(1)
			end
			Sleep(1)
			BreakNumber = 0
		else
			if not DynastyIsPlayer("Boss") then
				BreakNumber = BreakNumber + 1
			end
			Sleep(1)
		end
		if BreakNumber > 30 then
			StopMeasure()
		end
		Sleep(5)
	end
end

function BlockMe()
	SetData("TLBlocked"..GetID("VictimSim"), 0)
	local Fcount = 0
	while GetData("TLBlocked"..GetID("VictimSim"))~=1 do
		Fcount = Fcount +1
		if Fcount > 250 then
			SetData("TLBlocked"..GetID("VictimSim"),1)
		end
		Sleep(0.5)
	end
	MoveSetActivity("VictimSim","")
end

function CleanUp()
	StopAction("pickpocket","")
	RemoveProperty("","CocotteProvidesLove")
	if HasProperty("","UnterVerdacht") then
		RemoveProperty("","UnterVerdacht")
	end

	if HasProperty("","MyPosX") then
		RemoveProperty("","MyPosX")
		RemoveProperty("","MyPosZ")
	end
end

function GetOSHData(MeasureID)
end


