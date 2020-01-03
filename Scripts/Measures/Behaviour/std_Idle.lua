function Run()

-- *******************************************
--
-- Prepare everything
--
-- *******************************************

	local Time 	= math.mod(GetGametime(),24)
	
	if HasProperty("","Berserker") then
		RemoveProperty("","Berserker")   
	end
	
	if GetState("", STATE_WORKING) and SimIsWorkingTime("") then
		Sleep(5)
		std_idle_Worker(true)
		return
	end
	
	-- check if any activity is allowed for this sim
	
	local Activity = idlelib_GetActivity() -- 40 to 90
	local ActiveMovement = false
	if Activity > Rand(101) then
		ActiveMovement = true
	end
	
	-- What kind of sim are you?
	
	if IsDynastySim("") and SimGetAge("") >= 16 then
		
		-- check for missing title
		if GetNobilityTitle("") < 2 then
			SetNobilityTitle("", 2, true)
		end
		
		Sleep(15)
		std_idle_DynastyIdle()
		return
	else
		-- check for missing home
		if not GetHomeBuilding("", "HomeBuilding") then
			if GetNearestSettlement("", "City") then
				if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_WORKER_HOUSING, -1, -1, FILTER_IGNORE, "HomeBuilding") then
					SetHomeBuilding("", "HomeBuilding")
				end
			end
		end
	end
	
	-- Non-dynasty sims sometimes don't do anything and just stay at the worker's hut (performance reasons)
	
	if ((GetDynastyID("") == -1 or not IsDynastySim("")) and GetInsideBuildingID("") == -1) then
		if Time >= 9 then
			if Rand(100) < 30 then
				if GetNearestSettlement("", "City") then
					if CityGetNearestBuilding("City", "", -1, GL_BUILDING_TYPE_WORKER_HOUSING, -1, -1, FILTER_IGNORE, "WorkerHut") then
						if GetDistance("", "WorkerHut") < 15000 and not SimIsWorkingTime("") then
							MsgDebugMeasure("Unimportant going home and wait")
							f_MoveTo("", "WorkerHut", GL_MOVESPEED_RUN)
							MsgDebugMeasure("Unimportant wait at home")
							if not SimIsWorkingTime("") then
								Sleep(20)
							end
							
							if not SimIsWorkingTime("") then
								Sleep(20)
							end
							
							if not SimIsWorkingTime("") then
								Sleep(20)
							end
							
							if not SimIsWorkingTime("") then
								Sleep(Rand(60))
							end
							
							return
						else
							Sleep(5+Rand(6))
						end
					end
				end
			end
		end
	end
	
	-- No activity means stay at home and do nothing
	
	if not ActiveMovement then
		if GetHomeBuilding("", "HomeBuilding") then
			local Distance = GetDistance("", "HomeBuilding")
			if Distance > 600 and Distance < 3000 then
				idlelib_GoHome()
				Sleep(20)
				return
			else
				Sleep(5)
				idlelib_DoNothing()
				return
			end
		else
			Sleep((Rand(10)+10))
			return
		end
	end
	
	-- different behavior for children
	
	if SimGetAge("") < 16 then
		if SimGetAge("") < 5 then
			SimSetBehavior("", "Childness")
		elseif SimGetAge("") < 9 then
			SimSetBehavior("", "Schooldays")
		else
			if SimGetBehavior("") ~= "University" then
				SimSetBehavior("", "Apprenticeship")
			end
		end
		Sleep(5)
		return
	end
	
	-- check inquisition
	
	if GetSettlement("","MyCity") then
		if HasProperty("MyCity","InquisitionOnTheRun") then
			if (GetImpactValue("","WasInChurch")~=1) then
				local MyReligion = SimGetReligion("")
				local InquisitionReligion = GetProperty("MyCity","InquisitionOnTheRun")
				if InquisitionReligion ~= MyReligion then
					idlelib_ChangeReligion(InquisitionReligion)
				end
			end
		end
	end
	
-- *******************************************
--
-- Random illness for non-player sims
--
-- *******************************************
	
	if not DynastyIsPlayer("") then
		if GetImpactValue("", "Resist") == 0 then
			if Time > 6 and Time < 20 then -- to stop sickness spam during nighttime
				-- Make some guys sick
				GetSettlement("","City")
				local CityLevel = CityGetLevel("City")
				local SicknessChance = Rand(220)
				local Season = GetSeason()
				if season == EN_SEASON_AUTUMN or EN_SEASON_WINTER then
					SicknessChance = Rand(110)
				end
				
				if CityLevel >= 4 then
					if SicknessChance < 3 then
						diseases_Cold("",true,false)
					elseif SicknessChance < 5 then
						diseases_Sprain("",true,false)
					elseif SicknessChance < 7 then
						diseases_Influenza("",true,false)
					elseif SicknessChance == 7 then
						if Rand(3) == 0 then
							diseases_Fracture("",true,false)
						end
					elseif SicknessChance == 8 then
						if Rand(4) == 0 then
							diseases_Caries("",true,false)
						end
					elseif SicknessChance == 9 then
						if Rand(6) == 0 then
							diseases_Pox("",true,false)
						end
					end
				elseif CityLevel > 2 then
					if SicknessChance < 5 then
						diseases_Cold("",true,false)
					elseif SicknessChance < 8 then
						diseases_Sprain("",true,false)
					elseif SicknessChance < 10 then
						diseases_Influenza("",true,false)
					end
				else
					if SicknessChance < 10 then
						diseases_Cold("",true,false)
					elseif SicknessChance < 15 then
						diseases_Sprain("",true,false)
					end
				end
			end
		end
	end
	
	if (GetImpactValue("","Sickness")==0) then
		MoveSetActivity("","")
	end

	if ((GetImpactValue("","Sickness")>0) or (GetHPRelative("") < 0.98)) then
		if gameplayformulas_CheckMoneyForTreatment("")==1 and Time >7 and Time <20 then
			idlelib_VisitDoc()
		else
			idlelib_Illness()
			return
		end
	end
	
-- [[NEEDS]]

-- *******************************************
--
-- satisfy need sleep
--
-- *******************************************

	if GetHomeBuilding("","HomeBuilding") then
		if BuildingHasIndoor("HomeBuilding") and SimIsCourting("")==false then

			local offset = Rand(3)
			local	StartSleep = 0+offset
			local EndSleep = 5+offset
		
			if Time > StartSleep and Time < EndSleep then
				idlelib_Sleep(StartSleep, EndSleep)
				return
			end
		end
	end
	
-- *******************************************
--
-- Check  the weather before activities start
--
-- *******************************************

	if not idlelib_CheckWeather() then
		if not SimIsCourting("") and GetHomeBuilding("", "HomeBuilding") then
			if Rand(3) > 0 then
				-- Bad weather? stay at home!
				idlelib_GoHome()
				Sleep(Rand(15)+30)
				return
			end
		end
	end
	
-- *******************************************
--
-- satisfy need eat
--
-- *******************************************

	if SimGetNeed("",1)>=1 then
		if Time >= 6 and Time <= 18 then
			local Switch = Rand(6)
			if Switch == 0 then
				idlelib_BuySomethingAtTheMarket(1) -- 1 means something to eat.
				MoveSetActivity("","")
				CarryObject("","",false)
				Sleep(2)
				return
			elseif Switch == 1 or Switch == 2  then 
				idlelib_GoToTavern(1) -- 1 means eating
				Sleep(2)
				return
			else
				idlelib_CheckInsideStore(1) -- 1 means bakery
				Sleep(2)
				return
			end
		else
			if Rand(3) ==0 then
				idlelib_BuySomethingAtTheMarket(1) -- 1 means something to eat
				MoveSetActivity("","")
				CarryObject("","",false)
				Sleep(2)
				return
			end
		end
	end
	

-- *******************************************
--
-- satisfy need religion
--
-- *******************************************

	if SimGetNeed("",4)>=1 and (GetImpactValue("","WasInChurch")~=1) then
		if (8 <= Time and Time <= 12) or (17 <= Time and Time <= 22) then
			if Rand(100)>=70 then
				idlelib_Graveyard()
				return
			else
				if SimGetChurch("", "church") then
					if BuildingGetOwner("church","churchowner") then
						MeasureRun("", "church", "AttendMass")
						return
					end
				end
			end
		else
			if Rand(5) == 0 then
				idlelib_BuyReligion()
				return
			end
		end
	-- if you are a true believer your need will raise even faster
	elseif SimGetNeed("",4)<1 then
		if SimGetFaith("")>80 then
			SatisfyNeed("",4,(-0.08))
		elseif SimGetFaith("")>50 then
			SatisfyNeed("",4,(-0.04))
		end
	end

-- *******************************************
--
-- satisfy need financial
--
-- *******************************************

	if Time >=8 and Time <=20 then
		if SimGetNeed("",9)>=1 and not HasProperty("","CreditBank") then
			if Rand(4) == 0 then
				idlelib_BuySomethingAtTheMarket(9)
				return
			else
				idlelib_TakeACredit()
				return
			end
		elseif SimGetNeed("",9)<1 then
			-- Financial Need increase is bugged, so we need to tune it here
			SatisfyNeed("",9,(-0.085))
		end
	end	
	
-- *******************************************
--
-- satisfy need pleasure
--
-- *******************************************	

	if SimGetNeed("",2)>=1 then
		if SimGetAge("")>17 then -- no dirty pleasures for young adults ...
			if (Time >9 or Time <2) then
				local Switch = Rand(4)
				if Switch == 0 then
					idlelib_GoToDivehouse()
					return
				elseif Switch == 1 then
					idlelib_GoToTavern(2)
					return
				elseif Switch == 2 then
					idlelib_SitDown()
					return
				else
					if SimGetGender("")==GL_GENDER_MALE then -- gender specific pleasures ...
						idlelib_UseCocotte()
						return
					else
						idlelib_KissMeHonza()
						return
					end
				end
			end
		else -- Pleasures for young adults
			idlelib_SitDown()
		end
	end

-- *******************************************
--
-- satisfy need konsum
--
-- *******************************************

	if SimGetNeed("",7)>=1 then
		if Time >= 6 and Time <= 18 then
			if Rand(5) == 0 then
				idlelib_BuySomethingAtTheMarket(2) -- 2 means normal goods
				MoveSetActivity("","")
				CarryObject("","",false)
				return
			else
				idlelib_CheckInsideStore(2) -- 2 means normal goods
				return
			end
		else
			idlelib_BuySomethingAtTheMarket(2) -- 2 means normal goods.
			MoveSetActivity("","")
			CarryObject("","",false)
			return
		end
	end

-- *******************************************
--
-- satisfy need drinking
--
-- *******************************************

	if SimGetNeed("",8)>=1 then
		if SimGetAge("")>17 then -- No drinking if you are too young.
			if (Time >9 or Time <2) then
				if SimGetClass("") == 4 then -- Rogues always go to the divehouse
					idlelib_GoToDivehouse()
					return
				else
					if Rand(3) == 0 then -- other classes have 33% to visit the divehouse
						idlelib_GoToDivehouse()
						return
					else
						idlelib_GoToTavern(8)
						return
					end
				end
			end
		else
			SatisfyNeed("",8,1) -- satisfy the need if you are too young.
		end
	end		
	
-- *******************************************
--
-- satisfy need talk
--
-- *******************************************
	if SimGetNeed("",3)>=1 and GetDynastyID("")>0 and not GetInsideBuilding("","Inside") then
		local TalkPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==1500)AND NOT(Object.GetStateImpact(no_idle))AND(Object.IsDynastySim())AND(Object.CanBeInterrupted(StartDialog))AND NOT(Object.HasImpact(Hidden))AND NOT(Object.GetInsideBuilding()))","TalkPartner", -1)
		if TalkPartners>0 then
			MeasureRun("", "TalkPartner"..Rand(TalkPartners), "StartDialog" )
			return
		end
	end	

-- *******************************************
--
-- satisfy need curiosity
--
-- *******************************************

	if SimGetNeed("",5)>=1 and (Time >5 and Time <21) then
		local Switch = Rand(6)
		if Switch == 0 or Switch == 1 then
			idlelib_GoToRandomPosition()
			return
		elseif Switch == 2 then
			idlelib_GetCorn()
			return
		elseif Switch == 3 then
			idlelib_GoTownhall()
			return
		elseif Switch == 4 then
			idlelib_CollectWater()
			return
		else
			if Rand(50) == 0 then
				if GetHPRelative("")>0.5 then
					local FightPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==2000)AND NOT(Object.HasDynasty())AND NOT(Object.GetState(unconscious))AND NOT(Object.GetState(dead))AND(Object.CompareHP()>30))","FightPartner", -1)
					if FightPartners>0 then
						idlelib_ForceAFight("FightPartner")
						return
					end
				end
			end
		end
	end
	
--******************************************	
		
		
	--Repair Homebuilding if damaged and if not dynsim
	if GetDynastyID("") <= 0 then
		if GetHomeBuilding("","HomeBuilding") then
			local CurrentHP = GetHPRelative("HomeBuilding")
			if CurrentHP <= 0.9 then
				if Rand(100) > 50 then
					idlelib_RepairHome("HomeBuilding")
				end
			end
		end
	end
		
	-- all needs low?
	if GetDynastyID("")<=0 or DynastyIsShadow("") then
		if SimGetNeed("",1) <1 and SimGetNeed("",2)<1 and SimGetNeed("",3)<1 and SimGetNeed("",4)<1 and SimGetNeed("",5)<1 and SimGetNeed("",6)<1 and SimGetNeed("",7)<1 and SimGetNeed("",8)<1 and SimGetNeed("",9)<1 then
			local RandomNeed = 1+Rand(9)
			SatisfyNeed("",RandomNeed,(-0.2))
			
			if Rand(2) == 0 then
				idlelib_GoToRandomPosition()
			else
				idlelib_DoNothing()
			end
		end
	end

	Sleep(5+Rand(10))
	
end

function Worker(ActiveMovement)
	
	if HasProperty("", "StartWorkingTime") then
		RemoveProperty("", "StartWorkingTime")
		if SimGetWorkingPlace("", "WorkingPlace") then
			if DynastyIsShadow("") and not ActiveMovement then
				SimBeamMeUp("","WorkingPlace",false)
			else
				f_MoveTo("", "WorkingPlace", GL_MOVESPEED_RUN)
				if not GetState("", STATE_WORKING) then
					SetState("", STATE_WORKING, true)
				end
			end
			local SicknessChance = Rand(100)
			if SicknessChance == 1 then
				diseases_Sprain("",true,false)
			elseif SicknessChance == 2 then
				diseases_Cold("",true,false)
			end

			if ((GetImpactValue("","Sickness")>0) or (GetHP("") < GetMaxHP("")/4)) then
				if gameplayformulas_CheckMoneyForTreatment("")==1 then
					idlelib_VisitDoc()
				end
			end

		end
	end
	
	-- idle workers do something?
	local AtPlace	= SimGetAssignedAreaID("") == SimGetWorkingPlaceID("")
	SimGetWorkingPlace("", "WorkingPlace")
	local IsManageEmployee = GetProperty("", "TWP_ManageEmployee") or 0
	if AtPlace or BuildingGetAISetting("WorkingPlace", "Enable") > 0 or IsManageEmployee > 0 then
		if SimGetProfession("") == GL_PROFESSION_THIEF then
			--LogMessage("::TOM::ThiefIdle::"..GetName("").." Going into idle work state.")
			aitwp_ThiefIdle("WorkingPlace")
			return
		elseif SimGetProfession("") == GL_PROFESSION_ROBBER then
			idlelib_RobberIdle("WorkingPlace")
			return
		elseif SimGetProfession("") == GL_PROFESSION_COCOTTE then
			aitwp_CocotteIdle("")
			return
		elseif SimGetProfession("") == GL_PROFESSION_MYRMIDON then
			aitwp_MyrmidonIdle("")
			return
		elseif SimGetProfession("") == 74 then
			idlelib_LeibwacheIdle("WorkingPlace")
			return
		elseif SimGetProfession("") == 17 then
			idlelib_LeibwacheIdle("WorkingPlace")
			return
		end
	end
	Sleep(120)
end


function DynastyIdle()
	--LogMessage("AITWP::DynIdle::"..GetName("").." Starting DynastyIdle")
	if GetImpactValue("", "banned") > 0 then
		MeasureRun("", nil, "DynastyBanned")
		return
	end 
	
	if SimGetBehavior("")=="CheckPresession" or SimGetBehavior("")=="CheckPretrial" then
		-- TODO also check Presession?
		--LogMessage("AITWP::DynIdle::"..GetName("").." Is in CheckPresession or CheckPretrial. stop idle measure.")
		return
	end
	
	-- no idle measures just before trial
	if GetImpactValue("", "TrialTimer") >= 1 and ImpactGetMaxTimeleft("", "TrialTimer") <= 3 then
		--LogMessage("AITWP::DynIdle::"..GetName("").." waiting for trial")
		return
	end
	-- no idle measures just before duel
	if GetImpactValue("", "DuelTimer") >= 1 and ImpactGetMaxTimeleft("", "DuelTimer") <= 3 then
		--LogMessage("AITWP::DynIdle::"..GetName("").." Waiting for Duel")
		return
	end
	-- no idle measures just before office session
	if GetImpactValue("", "OfficeTimer") >= 1 and ImpactGetMaxTimeleft("", "OfficeTimer") <= 3 then
		--LogMessage("AITWP::DynIdle::"..GetName("").." Waiting for office session")
		return
	end

	-- priority check: health
	std_idle_CheckHealth()

	local Value = Rand(80)
	if Value < 5 then -- move about
		idlelib_GoToRandomPosition()
	elseif Value < 10 then -- sit down
		idlelib_SitDown()
	elseif Value < 20 then -- go shopping
		if DynastyIsShadow("") then
			idlelib_CheckInsideStore(Rand(2)+1)
		else
			idlelib_BuySomethingAtTheMarket(Rand(2)+1)
		end
	elseif Value < 25 then -- get drunk
		if Rand(2) == 0 then
			idlelib_BeADrunkChamp()
		else
			idlelib_BeADiceChamp()
		end
	elseif Value < 30 then
		idlelib_UseCocotte()
	elseif Value < 40 then
		local need = 2
		if Rand(4) > 0 then
			need = 8
		end
		if SimGetClass("") == 4 then
			idlelib_GoToDivehouse()
		else
			if Rand(3) == 1 then
				idlelib_GoToDivehouse()
			else
				idlelib_GoToTavern(need)
			end
		end
	elseif Value < 45 then
		idlelib_CollectWater()
	elseif Value < 55 then
		std_idle_UseRandomArtefact("")
	elseif Value < 70 and not SimGetSpouse("") and GetDynasty("", "MyDyn") and DynastyIsAI("MyDyn") then
		-- find lover, court and marry (disabled for family of players)
		aitwp_CourtLover("")
	else
		idlelib_DoNothing()
	end
	Sleep(5)
end

function CheckHealth()
	-- sickness, go to doctor
	if GetImpactValue("","Sickness") > 0 
			and Rand(10) < 5 
			and GetRepeatTimerLeft("", GetMeasureRepeatName2("AttendDoctor")) <= 0 then
		MeasureRun("", nil, "AttendDoctor")
		-- I could also just go home and sleep...
	end
	
	-- poisoned, try to use antidote
	if GetState("", STATE_POISONED) 
			and Rand(10) < 5
			and GetRepeatTimerLeft("", GetMeasureRepeatName2("UseAntidote")) <= 0 
			and ai_CanBuyItem("", "Antidote") > 0 then
		MeasureRun("", nil, "UseAntidote")
	end
	
	-- Check HP damage
	if GetHPRelative("") < 0.85 and Rand(10) < 5 then
		-- either doctor or lingerplace or nothing
		if GetMoney("") > 2500 
				and GetRepeatTimerLeft("", GetMeasureRepeatName2("AttendDoctor")) <= 0 then
			MeasureRun("", nil, "AttendDoctor")
		else
			MeasureRun("", "LingerPlace", "Linger")
		end
	end
end

function UseRandomArtefact(SimAlias)
	local Item = "WalkingStick"
	local Money = GetMoney(SimAlias)
	
	if Money < 2000 then
		return
	end
	
	if GetRepeatTimerLeft(SimAlias, GetMeasureRepeatName2("Use"..Item)) > 0 then
		return
	end
	
	if GetImpactValue(SimAlias, "walkingstick") > 0 or GetImpactValue(SimAlias, "Sugar") > 0 then
		return
	end

	local Price = ai_CanBuyItem(SimAlias, Item)
	
	if Price < 0 then
		return
	end
	
	-- use item
	MeasureRun(SimAlias, nil, "UseWalkingStick")
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopAction("brawl","")
	if AliasExists("SitPos") then
		f_EndUseLocator("","SitPos",GL_STANCE_STAND)
	end
	if GetState("",STATE_SLEEPING) then
		SetState("",STATE_SLEEPING,false)
	end
	StopAnimation("")
	MoveSetStance("",GL_STANCE_STAND)
	if not (GetImpactValue("","Sickness")>0) then
		MoveSetActivity("","")
	end
	CarryObject("","",true)
	CarryObject("","",false)
	if HasProperty("","WaitingForTreatment") then
		RemoveProperty("","WaitingForTreatment")
	end
	if AliasExists("SleepPosition") then
		f_EndUseLocatorNoWait("", "SleepPosition", GL_STANCE_STAND)
		RemoveAlias("SleepPosition")
	end
	if AliasExists("ChairPos") then
		f_EndUseLocatorNoWait("", "ChairPos", GL_STANCE_STAND)
		RemoveAlias("ChairPos")
	end
	if HasProperty("","KissMeHoney") then
		RemoveProperty("","KissMeHoney")
	end
end

