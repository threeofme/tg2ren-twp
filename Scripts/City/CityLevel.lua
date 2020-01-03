-- this function is called at the beginning of the game and returns the level the settlement

Include("Campaign/DefaultCampaign.lua")

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

function GetMinLevel()
	local Level = 2
	if CityGetRandomBuilding("",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_TOWNHALL,-1,-1,FILTER_IGNORE,"Townhall") then
		if HasProperty("Townhall", "Level") then
			Level = GetProperty("Townhall", "Level")
		end
	end
	return Level 
end

function CalcStartupLevel()

	if CityIsKontor("") then
		return 1
	end
	
	local Count = CityGetCitizenCount("")
--	Count = Count + 50 -- initbuffer

	local Level = citylevel_GetMinLevel()
	while Level < GL_MAX_CITY_LEVEL and citylevel_GetValue(Level) < Count do
		Level = Level + 1
	end

	if worldambient_CheckAmbient()==true then
		worldambient_CreateCityAnimals("",true)
		--worldambient_CreateCityBettler("",Level)
		if not AliasExists("#Eseltreiber") or not AliasExists("#Packo") then
			worldambient_CreateTeamDonkey("")
		end
		
		if WorldAnimals == 0 then
			WorldAnimals = 1
			worldambient_CreateWorldAnimals()
		end
	end

	-- init buyable buildings
	local buyablehouses = CityGetBuildingCount("",1,2,-1,-1,FILTER_IS_BUYABLE)
	CityGetBuildings("",1,2,-1,-1,FILTER_IS_BUYABLE,"FreeHouse")
	for i=0, buyablehouses-1 do
		if BuildingGetBuyPrice("FreeHouse"..i) then
			SetState("FreeHouse"..i, STATE_SELLFLAG, true)
		end
	end
	
	local buyableworkshops = CityGetBuildingCount("",2,-1,-1,-1,FILTER_IS_BUYABLE)
	CityGetBuildings("",2,-1,-1,-1,FILTER_IS_BUYABLE,"FreeWorkshop")
	for k=0, buyableworkshops-1 do
		if BuildingGetBuyPrice("FreeWorkshop"..k) then
			SetState("FreeWorkshop"..k, STATE_SELLFLAG, true)
		end
	end

	return Level
end

-- this function is called every ingame hour and checks, if the city is able to grow or shrink
function CalcNewLevel()

	if CityIsKontor("") then
		return 1
	end

	local Level = CityGetLevel("")
	local CurrentCitizens = CityGetCitizenCount("")
	local MinCitizens = citylevel_GetValue(Level)
	local CurrentYear = GetYear()
	if not HasData("#LastUpdateYear") then
		SetData("#LastUpdateYear", CurrentYear) -- no updates in first round
	end
	
	CityGetRandomBuilding("",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_TOWNHALL,-1,-1,FILTER_IGNORE,"Townhall")
	
	local LastUpdateYear = GetData("#LastUpdateYear")
	if AliasExists("Townhall") then
		if not HasProperty("Townhall","CityLevelUpAhead") and CurrentYear <= LastUpdateYear then
			SetProperty("","LevelUpCity",0)
			return Level
		end
	
--	if a cutscene is running in the townhall do not upgrade the city
--	!!! otherwise the townhall could be blocked with a never ending cutscene !!!
	
		if (BuildingGetCutscene("Townhall", "cutscene") == false) then
			if CurrentCitizens >= MinCitizens then -- enough people for levelup
				if HasProperty("","LevelUpPaid") and GetProperty("","LevelUpPaid")==1 and HasProperty("","LevelUpCity") and GetProperty("","LevelUpCity")==1 then
					SetProperty("","LevelUpCity",0)
					SetData("#LastUpdateYear", CurrentYear)
					return (Level + 1)
				else
					SetProperty("","LevelUpCity",1)
					return Level
				end
			end
		end
	end

	SetProperty("","LevelUpCity",0)
	return Level

end

function SetNewLevel(OldLevel, NewLevel)

	-- output a message
	if NewLevel>0 and NewLevel<=GL_MAX_CITY_LEVEL and ScenarioGetTimePlayed()>0.1 then
		-- only output messages, when the game is running, not at gamestart
--		GetLocalPlayerDynasty("Player")
		local Attribute = "@L_GENERAL_INFORMATION_CITY_LEVEL_MSG_PLUS_ATTRIBUTE_+"..(OldLevel-1)
		GetScenario("scenario")
		local mapid = GetProperty("scenario", "mapid")
		local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+1"
		MsgNewsNoWait("All", "", nil, "default", -1, 
			"@L_GENERAL_INFORMATION_CITY_LEVEL_MSG_PLUS_HEAD_+0",
			"@L_GENERAL_INFORMATION_CITY_LEVEL_MSG_PLUS_BODY_+0", CityLevel2Label(OldLevel), GetID(""), Attribute, CityLevel2Label(NewLevel), lordlabel )

		if HasProperty("","LevelUpPaid") and GetProperty("","LevelUpPaid")==1 then
			SetProperty("","LevelUpPaid",0)
		end
	end

	if worldambient_CheckAmbient()==true then
		worldambient_CreateCityAnimals("",false)
		worldambient_CreateCityBettler("",1)
	end
	
	-- fix for vacant judge position after first level up
	if NewLevel == 3 then
		CityGetOffice("", 2, 1, "treasurer")
		CityGetOffice("", 2, 2, "judge")
		if AliasExists("treasurer") and OfficeGetHolder("treasurer", "treasurerSim") and not OfficeGetHolder("judge", "judgeSim") then
			SimSetOffice("treasurerSim", "judge")
		end
	end
	
	if NewLevel==6 then
		citylevel_CheckForKing()
	end
end

function CheckForKing()

	if not CityGetOffice("", 7, 0, "OFFICE") then
		return
	end
	
	if OfficeGetHolder("OFFICE", "OfficeHolder") then
		return
	end
	
	local DynCount 	= ScenarioGetObjects("Dynasty", 999, "DynList")
	
	local	Points
	local	Candidate = nil
	local	BestPoints = 0
	local	DynAlias
	local fame = 0
	
	for dyn=0,DynCount-1 do
		DynAlias = "DynList"..dyn
		if DynastyGetBuilding2(DynAlias, 0, "DynHome") then
			if GetSettlementID("DynHome")==GetID("") then
				if DynastyIsShadow(DynAlias) then
					if GetProperty(DynAlias,"ImperialFame") then
						fame = GetProperty(DynAlias,"ImperialFame")
					end
					Points = (GetNobilityTitle(DynAlias) * 20000) + (fame * 2000) + GetMoney(DynAlias)
					if not Candidate or Points>BestPoints then
						Candidate = "DynList"..dyn
						BestPoints  = Points
					end
				end
			end
		end
	end
	
	if not Candidate then
		if defaultcampaign_CreateShadowDynasty(-1, "", "KingDynasty") then
			Candidate = "KingDynasty"
		end
	end
	
	if not Candidate then
		return
	end

	if not DynastyGetMemberRandom(Candidate, "Boss") then
		return
	end
	
	if GetNobilityTitle("Boss")<8 then
		SetNobilityTitle("Boss", 8)
	end
	
	SimSetOffice("Boss", "OFFICE")
end

