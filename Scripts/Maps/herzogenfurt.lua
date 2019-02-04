-- the "Prepare" function is called directly after the map is loaded from the .wld-file
function Prepare()

	ScenarioSetOutdoorScrollBoundaries(-35304, 30222, -29932, -35420, 32877, -22479, 35022, 39999)
	ScenarioSetNameLanguage("german")

	local worldname = "Herzogenfurt"
	local mapid = gameplayformulas_GetDatabaseIdByName("maps", worldname)
	GetScenario("World")
	SetProperty("World", "mapid", mapid)
	SetProperty("World", "seamap", 1)

	--if not IsMultiplayerGame() then
		local Options = FindNode("\\Settings\\Options")
		local YearsPerRound = Options:GetValueInt("YearsPerRound")
		if YearsPerRound then
			ScenarioSetYearsPerRound(YearsPerRound)
		end
	--end
	
	SetProperty("World", "ambient", 0)
	if not IsMultiplayerGame() then
		local Options = FindNode("\\Settings\\Options")
		local Ambient = Options:GetValueInt("Ambient")
		if Ambient==0 then
			SetProperty("World", "ambient", 1)
		end
	end

	SetProperty("World", "messages", 0)
	if not IsMultiplayerGame() then
		local Options = FindNode("\\Settings\\Options")
		local Messages = Options:GetValueInt("Messages")
		if Messages==0 then
			SetProperty("World", "messages", 1)
		end
	end

	local Options = FindNode("\\Settings\\Options")
	local FrequencyOfficeSessions = Options:GetValueInt("FrequencyOfficeSessions")
	SetProperty("World", "fos", FrequencyOfficeSessions)

end


-- the "Start" function is called after everything has been initializied on the map (players/ai/...)
function Start()
	local Difficulty = ScenarioGetDifficulty()
	local Count = ScenarioGetObjects("cl_Dynasty", 99, "Dyn")
	local Alias
	local DynNum = 0
	local Dynasty1
	local Dynasty2
	local Dynasty3
	local Dynasty4
	local Proto
	
	for l=0,Count-1 do
		if GetID("Dyn"..l)>0 and DynastyIsPlayer("Dyn"..l) or DynastyIsAI("Dyn"..l) and not DynastyIsShadow("Dyn"..l) then
			Alias = "Dyn"..l
			DynastyGetMember(Alias, 0, "Sim")

			DynNum = DynNum + 1

			if Dynasty1 then
				if Dynasty2 then
					if Dynasty3 then
						Dynasty4 = Alias
					else
						Dynasty3 = Alias
					end
				else
					Dynasty2 = Alias
				end
			else
				Dynasty1 = Alias
			end

			if Difficulty == 0 then
				CreditMoney(Alias, 20000, "StartupMoney")
				SetNobilityTitle("Sim", 6, true)
				IncrementXP("Sim", 3000)
				Proto = ScenarioFindBuildingProto(0, GL_BUILDING_TYPE_RESIDENCE, 5, 0)
				GetHomeBuilding("Sim", "Home")
				BuildingInternalLevelUp("Home", Proto)
			elseif Difficulty == 1 then
				CreditMoney(Alias, 15000, "StartupMoney")
				SetNobilityTitle("Sim", 5, true)
				IncrementXP("Sim", 2000)
				Proto = ScenarioFindBuildingProto(0, GL_BUILDING_TYPE_RESIDENCE, 4, 0)
				GetHomeBuilding("Sim", "Home")
				BuildingInternalLevelUp("Home", Proto)
			elseif Difficulty == 2 then
				CreditMoney(Alias, 10000, "StartupMoney")
				SetNobilityTitle("Sim", 4, true)
				IncrementXP("Sim", 1000)
				Proto = ScenarioFindBuildingProto(0, GL_BUILDING_TYPE_RESIDENCE, 3, 0)
				GetHomeBuilding("Sim", "Home")
				BuildingInternalLevelUp("Home", Proto)
			elseif Difficulty == 3 then
				CreditMoney(Alias, 5000, "StartupMoney")
				SetNobilityTitle("Sim", 3, true)
				IncrementXP("Sim", 500)
				Proto = ScenarioFindBuildingProto(0, GL_BUILDING_TYPE_RESIDENCE, 2, 0)
				GetHomeBuilding("Sim", "Home")
				BuildingInternalLevelUp("Home", Proto)
			end
		end
	end	
	
	if DynNum==2 then
		-- diplomacy state and favor -> Dynasty1 to Dynasty2
			DynastySetDiplomacyState(Dynasty1,Dynasty2,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty1,Dynasty2,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty1,Dynasty2,0)
		
		-- diplomacy state and favor -> Dynasty2 to Dynasty1
			DynastySetDiplomacyState(Dynasty2,Dynasty1,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty2,Dynasty1,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty2,Dynasty1,0)
	else
		-- diplomacy state and favor -> Dynasty1 to Dynasty2
			DynastySetDiplomacyState(Dynasty1,Dynasty2,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty1,Dynasty2,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty1,Dynasty2,0)

		-- diplomacy state and favor -> Dynasty1 to Dynasty3
			DynastySetDiplomacyState(Dynasty1,Dynasty3,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty1,Dynasty3,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty1,Dynasty3,0)

		-- diplomacy state and favor -> Dynasty1 to Dynasty4
			DynastySetDiplomacyState(Dynasty1,Dynasty4,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty1,Dynasty4,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty1,Dynasty4,0)

		
		-- diplomacy state and favor -> Dynasty2 to Dynasty1
			DynastySetDiplomacyState(Dynasty2,Dynasty1,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty2,Dynasty1,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty2,Dynasty1,0)

		-- diplomacy state and favor -> Dynasty2 to Dynasty3
			DynastySetDiplomacyState(Dynasty2,Dynasty3,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty2,Dynasty3,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty2,Dynasty3,0)

		-- diplomacy state and favor -> Dynasty2 to Dynasty4
			DynastySetDiplomacyState(Dynasty2,Dynasty4,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty2,Dynasty4,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty2,Dynasty4,0)


		-- diplomacy state and favor -> Dynasty3 to Dynasty1
			DynastySetDiplomacyState(Dynasty3,Dynasty1,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty3,Dynasty1,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty3,Dynasty1,0)

		-- diplomacy state and favor -> Dynasty3 to Dynasty2
			DynastySetDiplomacyState(Dynasty3,Dynasty2,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty3,Dynasty2,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty3,Dynasty2,0)

		-- diplomacy state and favor -> Dynasty3 to Dynasty4
			DynastySetDiplomacyState(Dynasty3,Dynasty4,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty3,Dynasty4,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty3,Dynasty4,0)


		-- diplomacy state and favor -> Dynasty4 to Dynasty1
			DynastySetDiplomacyState(Dynasty4,Dynasty1,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty4,Dynasty1,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty4,Dynasty1,0)

		-- diplomacy state and favor -> Dynasty4 to Dynasty2
			DynastySetDiplomacyState(Dynasty4,Dynasty2,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty4,Dynasty2,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty4,Dynasty2,0)

		-- diplomacy state and favor -> Dynasty4 to Dynasty3
			DynastySetDiplomacyState(Dynasty4,Dynasty3,DIP_FOE)
			DynastySetMaxDiplomacyState(Dynasty4,Dynasty3,DIP_FOE,-1,-1)
			SetFavorToDynasty(Dynasty4,Dynasty3,0)

	end

end

