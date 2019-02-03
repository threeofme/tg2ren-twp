function Run()
	if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
		return
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not GetSettlement("","city") then
		StopMeasure()
	end
	
	if not GetInsideBuilding("","Townhall") then
		StopMeasure()
	end
	
	GetSettlement("Townhall","city2")
	if not GetID("city")==GetID("city2") then
		StopMeasure()
	end

	local Level = CityGetLevel("city")
	local CityTreasure = GetMoney("city")
	local CityUpgradeCost = gameplayformulas_GetCityUpgradeCost(Level)
	local citylabel = CityLevel2Label(Level)
	local nomorelvlup = false
	local ImperialId = 0
	
	local CityCount = ScenarioGetObjects("Settlement", 12, "CityList")
	for i=0, CityCount -1 do
		if CityGetLevel("CityList"..i) == 6 then
			ImperialId = GetID("CityList"..i)
			break
		end
	end
	
	if Level == 6 then
		nomorelvlup = true
	elseif Level == 5 then
		-- secure that only one city can be the imperial capital in the scenario
		if ImperialId ~= 0 then
			nomorelvlup=true
		end
	end

	local CitizensForLevelUp = ms_levelupcity_GetValue(Level)
	local CurrentCitizens	= CityGetCitizenCount("city")

	if nomorelvlup == true then
		MsgBoxNoWait("", "Townhall",
					"@L_MEASURE_LEVELUPCITY_HEAD_+0",
					"@L_MEASURE_LEVELUPCITY_BODY_+5",GetID("city"), ImperialId)
		StopMeasure()
	end
				
	if HasProperty("city","LevelUpPaid") and GetProperty("city","LevelUpPaid")==1 then -- already paid, pls wait
		GetScenario("scenario")
		local mapid = GetProperty("scenario", "mapid")
		local scenarioname = GetDatabaseValue("maps", mapid, "lordship")
		local lordid = gameplayformulas_GetDatabaseIdByName("Lordship", scenarioname)
		local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+1"
		MsgBoxNoWait("", "Townhall",
					"@L_MEASURE_LEVELUPCITY_HEAD_+0",
					"@L_MEASURE_LEVELUPCITY_BODY_+4", GetID("city"),citylabel,lordlabel)
	
	elseif HasProperty("city","LevelUpCity") and GetProperty("city","LevelUpCity")==1 then -- you may levelup the city
		if CityTreasure < CityUpgradeCost then -- we need more money
			MsgBoxNoWait("", "Townhall",
						"@L_MEASURE_LEVELUPCITY_HEAD_+0",
						"@L_MEASURE_LEVELUPCITY_BODY_+0", GetID("city"), CityUpgradeCost, citylabel)
			StopMeasure()
		end
		
		local Result = MsgNews("",false,"@P"..
						"@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
						"@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
						ms_levelupcity_AIDecision,  --AIFunc
						"default", --MessageClass
						2, --TimeOut
						"@L_MEASURE_LEVELUPCITY_HEAD_+0",
						"@L_MEASURE_LEVELUPCITY_BODY_+1", GetID("city"), CityUpgradeCost, citylabel)

		if Result == 1 then -- do the levelup
			if Level==5 then
				if (ImperialId == nil or ImperialId < 1 ) then
					ScenarioSetImperialCapital("city")
					SetProperty("city","ImperialCapital",1)
					SetProperty("city","LevelUpPaid",1)
					f_SpendMoney("city", CityUpgradeCost, "LevelUpPaid")
					SetMeasureRepeat(TimeOut)
				end
			else
				SetProperty("city","LevelUpPaid",1)
				f_SpendMoney("city",CityUpgradeCost,"LevelUpPaid")
				SetMeasureRepeat(TimeOut)
			end
		else
			StopMeasure()
		end
	else -- we can't levelup the city because of missing property
		-- we haven't enough citizens
		if CurrentCitizens < CitizensForLevelUp then
			MsgBoxNoWait("", "Townhall",
				"@L_MEASURE_LEVELUPCITY_HEAD_+0",
				"@L_MEASURE_LEVELUPCITY_BODY_+2", GetID("city"), citylabel, CitizensForLevelUp, CurrentCitizens)
		else
			-- we have a cutscene
			MsgBoxNoWait("", "Townhall",
				"@L_MEASURE_LEVELUPCITY_HEAD_+0",
				"@L_MEASURE_LEVELUPCITY_BODY_+3", GetID("city"))
		end
	end
end

function GetValue(Level)
	if Level==2 then
		return 100
	elseif Level==3 then
		return 200
	elseif Level==4 then
		return 300
	elseif Level==5 then
		return 400
	elseif Level==6 then -- this never happens
		return 9999
	end
end

function AIDecision()
	return 1
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

