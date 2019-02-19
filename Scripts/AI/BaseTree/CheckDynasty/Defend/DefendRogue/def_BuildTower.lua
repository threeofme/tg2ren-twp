function Weight()
	
	if not GetHomeBuilding("SIM","Home") then
		return 0
	end
	
	if not ReadyToRepeat("Home", "AI_TOWER") then
		return 0
	end
	
	local TowerLevel = 1
	
	if ScenarioGetDifficulty()<2 then -- no towers on easy settings
		return 0
	elseif ScenarioGetDifficulty()==2 then
		if DynastyGetBuildingCount("SIM",7,GL_BUILDING_TYPE_TOWER)>0 then -- only 1 towers on medium setting
			return 0
		end
	else
		if DynastyGetBuildingCount("SIM",7,GL_BUILDING_TYPE_TOWER)>2 then -- max 3 towers on hardest settings
			return 0
		end
	end
	
	if GetMoney("SIM")<4000 then
		return 0
	end
	
	if not DynastyGetRandomBuilding("SIM", 2, -1, "ProtectMe") then
		return 0
	end

	if not BuildingGetCity("ProtectMe", "ProCity") then
		return 0
	end
	
	if not CityGetRandomBuilding("ProCity",3,23,-1,-1,FILTER_IGNORE,"Townhall") then
		return 0
	end
	
	-- only buy towers if you are far away from the townhall
	if GetDistance("ProtectMe", "Townhall") < 8000 then
		return 0
	end
	
	if GetNobilityTitle("SIM")<5 or GetMoney("SIM") < 5000 then
		TowerLevel = 1
		SetData("Price", 5000)
	elseif GetNobilityTitle("SIM")<8 and GetMoney("SIM") > 7500 then
		TowerLevel = 2
		SetData("Price", 7500)
	elseif GetNobilityTitle("SIM")>=8 and GetMoney("SIM") > 10000 then
		TowerLevel = 3
		SetData("Price", 10000)
		if BuildingGetType("ProtectMe")==GL_BUILDING_TYPE_FARM or BuildingGetType("ProtectMe")==GL_BUILDING_TYPE_MILL or BuildingGetType("ProtectMe")==GL_BUILDING_TYPE_FRUITFARM then
			TowerLevel = 2 -- no cannon towers for farmers and mills
			SetData("Price", 7500)
		end
	end
	
	if BuildingGetType("ProtectMe")==GL_BUILDING_TYPE_MINE then
		TowerLevel = 3
		SetData("Price", 2500)
	end
	
	local	Proto = ScenarioFindBuildingProto(7, GL_BUILDING_TYPE_TOWER, TowerLevel, -1)
	if Proto==-1 then
		return 0
	end
	
	if not BuildingGetOwner("ProtectMe", "BuildOwner") then
		return 0
	end
	
	SetData("TowerProto", Proto)
	
	if BuildingGetType("ProtectMe")==GL_BUILDING_TYPE_MINE then
		return 100
	else
		if GetRound()>2 then
			return 20
		else
			SetRepeatTimer("Home", "AI_TOWER", 12)
			return 0
		end
	end
end

function Execute()
	SetRepeatTimer("Home", "AI_TOWER", 72)
	local Proto = GetData("TowerProto")
	local Price = 5000
	if HasData("Price") and GetData("Price") >= 2500 then
		Price = GetData("Price")
	end
	if SpendMoney("Home", Price, "misc") then
		if not CityBuildNewBuilding("ProCity", Proto, "BuildOwner", "Tower", "ProtectMe") then
			CreditMoney("Home", Price, "misc")
			return
		end
	end
end
