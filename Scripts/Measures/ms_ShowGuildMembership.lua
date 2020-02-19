function Run()

	-- GetSettlement("", "my_settlement")
	-- ScenarioSetImperialCapital("my_settlement")
	-- CityGetOffice("my_settlement",7,0,"King")
	-- SimSetOffice("","King")
	-- StopMeasure()

--	if IsMounted("") then
--		SetState("", STATE_RIDING, false)
--	else
--		SetState("", STATE_RIDING, true)
--	end
--	StopMeasure()

	local label
	local label2 = "@L_MEASURE_SHOWGUILDMEMBERSHIP_NULL_+0"
	local label3 = "@L_CHECKALDERMAN_ALDERMAN"
	local BuildingClass
	local member = false
	local noguildhouse = false

	if SimGetClass("")==1 then
		label = "_PATRON"
		BuildingClass = 1
	elseif SimGetClass("")==2 then
		label = "_ARTISAN"
		BuildingClass = 2
	elseif SimGetClass("")==3 then
		label = "_SCHOLAR"
		BuildingClass = 3
	elseif SimGetClass("")==4 then
		label = "_CHISELER"
		BuildingClass = 4
	else
		StopMeasure()
	end	

	GetSettlement("", "my_settlement")
	
	if (gameplayformulas_CheckPublicBuilding("my_settlement", GL_BUILDING_TYPE_BANK)[1]==0) then
		noguildhouse = true
	elseif CityGetRandomBuilding("my_settlement", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "guildhouse") then
		if chr_CheckGuildMaster("","guildhouse") then
			label = "@L_GUILDHOUSE_MASTERLIST"..label
			member = true
		else
			label = "@L_GUILDHOUSE_MEMBER"..label
			local Count = CityGetBuildings("my_settlement", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_IGNORE, "Buildings")
			local Alias
			for l=0,Count-1 do
				Alias = "Buildings"..l
				if BuildingGetOwner(Alias,"BuildingOwner") then
					if GetID("BuildingOwner") == GetID("") then
						member = true
						break
					end
				end
			end
		end
	else
		noguildhouse = true
	end

	if SimGetGender("")==GL_GENDER_MALE then
		label = label.."_MALE_+0"
		label3 = label3.."_MALE_+1"
	else
		label = label.."_FEMALE_+0"
		label3 = label3.."_FEMALE_+1"
	end

	famelevelsim = "@L_GUILDHOUSE_FAME_SIM_+"..chr_SimGetFameLevel("")
	fameleveldyn = "@L_GUILDHOUSE_FAME_DYNASTY_+"..chr_DynastyGetFameLevel("")

	GetScenario("scenario")
	local mapid = GetProperty("scenario", "mapid")
	local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+0"

	local impfamelevelsim = "@L_IMPERIAL_FAME_SIM_+"..chr_SimGetImperialFameLevel("")
	local impfameleveldyn = "@L_IMPERIAL_FAME_DYNASTY_+"..chr_DynastyGetImperialFameLevel("")

	if member==true then
		if chr_GetAlderman()==GetID("") and HasProperty("", "Alderman") then
			label2 = "@L_MEASURE_SHOWGUILDMEMBERSHIP_ALDERMAN_+0"
			MsgBoxNoWait("dynasty","",
				"@L_MEASURE_SHOWGUILDMEMBERSHIP_HEAD_+0",
				"@L_MEASURE_SHOWGUILDMEMBERSHIP_TEXT_+0",
				GetID(""),label,GetID("my_settlement"), famelevelsim, chr_SimGetFame(""), fameleveldyn, chr_DynastyGetFame(""), label2, 
					lordlabel, impfamelevelsim, chr_SimGetImperialFame(""), impfameleveldyn, chr_DynastyGetImperialFame(""), label3)
		else
			MsgBoxNoWait("dynasty","",
				"@L_MEASURE_SHOWGUILDMEMBERSHIP_HEAD_+0",
				"@L_MEASURE_SHOWGUILDMEMBERSHIP_TEXT_+0",
				GetID(""),label,GetID("my_settlement"), famelevelsim, chr_SimGetFame(""), fameleveldyn, chr_DynastyGetFame(""), label2, 
					lordlabel, impfamelevelsim, chr_SimGetImperialFame(""), impfameleveldyn, chr_DynastyGetImperialFame(""))
		end
	else
		if noguildhouse==true then
			if chr_GetAlderman()==GetID("") and HasProperty("", "Alderman") then
				MsgBoxNoWait("dynasty","",
					"@L_MEASURE_SHOWGUILDMEMBERSHIP_HEAD_+0",
					"@L_MEASURE_SHOWGUILDMEMBERSHIP_TEXT_+2",
					GetID(""), GetID("my_settlement"), famelevelsim, chr_SimGetFame(""), fameleveldyn, chr_DynastyGetFame(""), label3, 
						lordlabel, impfamelevelsim, chr_SimGetImperialFame(""), impfameleveldyn, chr_DynastyGetImperialFame(""))
			else
				MsgBoxNoWait("dynasty","",
					"@L_MEASURE_SHOWGUILDMEMBERSHIP_HEAD_+0",
					"@L_MEASURE_SHOWGUILDMEMBERSHIP_TEXT_+2",
					GetID(""), GetID("my_settlement"), famelevelsim, chr_SimGetFame(""), fameleveldyn, chr_DynastyGetFame(""), label2, 
						lordlabel, impfamelevelsim, chr_SimGetImperialFame(""), impfameleveldyn, chr_DynastyGetImperialFame(""))
			end				
		else
			if chr_GetAlderman()==GetID("") and HasProperty("", "Alderman") then
				MsgBoxNoWait("dynasty","",
					"@L_MEASURE_SHOWGUILDMEMBERSHIP_HEAD_+0",
					"@L_MEASURE_SHOWGUILDMEMBERSHIP_TEXT_+1",
					GetID(""), famelevelsim, chr_SimGetFame(""), fameleveldyn, chr_DynastyGetFame(""), label3,
						lordlabel, impfamelevelsim, chr_SimGetImperialFame(""), impfameleveldyn, chr_DynastyGetImperialFame(""))
			else
				MsgBoxNoWait("dynasty","",
					"@L_MEASURE_SHOWGUILDMEMBERSHIP_HEAD_+0",
					"@L_MEASURE_SHOWGUILDMEMBERSHIP_TEXT_+1",
					GetID(""), famelevelsim, chr_SimGetFame(""), fameleveldyn, chr_DynastyGetFame(""), label2,
						lordlabel, impfamelevelsim, chr_SimGetImperialFame(""), impfameleveldyn, chr_DynastyGetImperialFame(""))
			end
		end
	end	

end
