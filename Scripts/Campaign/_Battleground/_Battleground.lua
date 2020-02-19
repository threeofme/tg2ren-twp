function GetWorld()
	local WorldName
	WorldName = GetSettingString("ENDLESS", "World", "")
	return WorldName
end

function Prepare()
	SetTime(EN_SEASON_SPRING,1404, 7, 0)
	return true
end

function CreatePlayerDynasty()

	local CityName
	CityName = GetSettingString("ENDLESS", "City", "")

	local	ok = false
	local	CityAlias

	if CityName and CityName ~= "" then
		CityAlias = "city0"
		if ScenarioGetObjectByName("Settlement", CityName, CityAlias) then
			if CityGetRandomBuilding(CityAlias, GL_BUILDING_CLASS_LIVINGROOM, GL_BUILDING_TYPE_RESIDENCE, -1, -1, FILTER_IS_BUYABLE, "home") then
				ok = true
			end
		end
	end
	
	if not ok then
		
		if ScenarioGetObjects("Settlement", 10, "city")==0 then
			return "error - no settlement found on this map"
		end
	
		local	Number
		for Number = 0, 10 do
			CityAlias = "city"..Number
			if CityGetRandomBuilding(CityAlias, GL_BUILDING_CLASS_LIVINGROOM, GL_BUILDING_TYPE_RESIDENCE, -1, -1, FILTER_IS_BUYABLE, "home") then
				ok = true
				break
			end
		end
	end
	
	if not ok then
		return "unable to create player character"
	end
	
	if not PlayerCreate("home", "boss") then
		return "unable to create player character"
	end

	if not DynastyCreate(CityAlias, "boss", "home", 1, true, "PlayerDynasty") then
		return "cannot create the dynasty 'fugger'"
	end

	local Rotation = GetRotation("boss", "home")
	CameraTerrainSetPos("boss", 1500, Rotation)
	
	local Workshop
	Number = 1
	while true do
	
		Workshop = GetSettingString("ENDLESS", "Workshop"..Number, "")
		if Workshop=="" then
			break
		end
		
		local WorkshopType
		WorkshopType = Name2BuildingType(Workshop)
		
		if WorkshopType~=-1 then
			if CityGetRandomBuilding(CityAlias, GL_BUILDING_CLASS_WORKSHOP, WorkshopType, -1, -1, FILTER_IS_BUYABLE, "Workshop") then
				BuildingBuy("Workshop", "boss", BM_STARTUP)
			else
				local Proto = ScenarioFindBuildingProto(GL_BUILDING_CLASS_WORKSHOP, WorkshopType, 1, -1)
				if Proto and Proto~=-1 then
					if CityBuildNewBuilding(CityAlias, Proto, nil, "Workshop") then
						BuildingBuy("Workshop", "boss", BM_STARTUP)
					end
				end
			end
		end
		Number = Number + 1
	end
	
	local Total = GetSettingNumber("ENDLESS", "WorkingHuts", 0)
	if Total and Total>=Number then
		while Total >= Number do
			if CityGetRandomBuilding(CityAlias, GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_IS_BUYABLE, "Workshop") then
				BuildingBuy("Workshop", "boss", BM_STARTUP)
			end
			Number = Number + 1
		end
	end
	
	if Number == 1 then
		CreditMoney("PlayerDynasty", 5000, "GameStart")
	else
		CreditMoney("PlayerDynasty", 1000*(Number-1), "GameStart")
	end	
	
	--dyn2
	if not CityGetRandomBuilding(CityAlias, GL_BUILDING_CLASS_LIVINGROOM, GL_BUILDING_TYPE_RESIDENCE, -1, -1, FILTER_IS_BUYABLE, "home") then
		HomeAlias = "WorkingHut"
	else
		HomeAlias = "home"
	end

	local Class
	Class = 1 + math.mod(Number, 5)	-- force class between 1 and 5

	if not BossCreate(HomeAlias, GL_GENDER_MALE, Class, -1, "boss") then
		return "unable to create boss of the dynasty"
	end

	if not DynastyCreate( CityAlias, "boss", HomeAlias, -1, false, "ComputerDynasty1") then
		return "cannot create the dynasty"
	end
	
	--dyn3
	if not CityGetRandomBuilding(CityAlias, GL_BUILDING_CLASS_LIVINGROOM, GL_BUILDING_TYPE_RESIDENCE, -1, -1, FILTER_IS_BUYABLE, "home") then
		HomeAlias = "WorkingHut"
	else
		HomeAlias = "home"
	end

	local Class
	Class = 1 + math.mod(Number, 5)	-- force class between 1 and 5

	if not BossCreate(HomeAlias, GL_GENDER_MALE, Class, -1, "boss") then
		return "unable to create boss of the dynasty"
	end

	if not DynastyCreate(CityAlias, "boss", HomeAlias, -1, false, "ComputerDynasty2") then
		return "cannot create the dynasty"
	end
	
	--dyn4
	if not CityGetRandomBuilding(CityAlias, GL_BUILDING_CLASS_LIVINGROOM, GL_BUILDING_TYPE_RESIDENCE, -1, -1, FILTER_IS_BUYABLE, "home") then
		HomeAlias = "WorkingHut"
	else
		HomeAlias = "home"
	end

	local Class
	Class = 1 + math.mod(Number, 5)	-- force class between 1 and 5

	if not BossCreate(HomeAlias, GL_GENDER_MALE, Class, -1, "boss") then
		return "unable to create boss of the dynasty"
	end

	if not DynastyCreate(CityAlias, "boss", HomeAlias, -1, false, "ComputerDynasty3") then
		return "cannot create the dynasty"
	end
	
	DynastySetDiplomacyState("PlayerDynasty", "ComputerDynasty1", 1)	
	DynastySetDiplomacyState("PlayerDynasty", "ComputerDynasty2", 0)
	-- add the new property
	f_DynastyAddEnemy("PlayerDynasty","ComputerDynasty2")
	f_DynastyAddEnemy("ComputerDynasty2","PlayerDynasty")
	DynastySetDiplomacyState("PlayerDynasty", "ComputerDynasty3", 3)

	DynastySetDiplomacyState("ComputerDynasty2", "ComputerDynasty1", 3)
	DynastySetDiplomacyState("ComputerDynasty2", "ComputerDynasty3", 3)

	DynastySetDiplomacyState("ComputerDynasty3", "ComputerDynasty1", 0)
end

function Start()
end

