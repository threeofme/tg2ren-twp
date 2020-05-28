function Weight()
	if not ReadyToRepeat("dynasty", "AI_HomeLevelUp") then
		return 0
	end
	
	DynastyGetMemberRandom("dynasty", "DynMember")

	if not GetHomeBuilding("DynMember", "home") then
		return 0
	end
	
	if BuildingGetType("home")~=GL_BUILDING_TYPE_RESIDENCE then
		return 0
	end
	
	if GetState("home", STATE_BUILDING) or GetState("home", STATE_LEVELINGUP) then
		return 0
	end
	
	local HomeLevel = BuildingGetLevel("home")
	local UpgradeCost = 0
	local MoneyReserve = 5000 -- how much money should the AI at least keep after the upgrade?
	local NeedTitle = 0
	
	if HomeLevel == 5 then
		return 0
	elseif HomeLevel == 4 then
		UpgradeCost = 20000
		NeedTitle = 8
	elseif HomeLevel == 3 then
		UpgradeCost = 15000
		NeedTitle = 7
	elseif HomeLevel == 2 then
		UpgradeCost = 10000
		NeedTitle = 5
	else
		UpgradeCost = 5000
		NeedTitle = 4
	end
	
	SetData("Cost", UpgradeCost)
	SetData("Level", HomeLevel)
	
	local Title = GetNobilityTitle("DynMember")
	local Money = GetMoney("DynMember")
	
	if Money < (UpgradeCost + MoneyReserve) or Title < NeedTitle then
		return 0
	end
	
	return 100
end

function Execute()
	if not AliasExists("home") then
		GetHomeBuilding("DynMember", "home")
	end
	
	local Difficulty = ScenarioGetDifficulty()
	local Timer = 96 - Difficulty*12
	SetRepeatTimer("dynasty", "AI_HomeLevelUp", Timer)	
	
	local BuildLevel = GetData("Level")
	local Proto = ScenarioFindBuildingProto(1, 2, BuildLevel+1,-1)
	local Price = GetData("Cost")
	
	if f_SpendMoney("dynasty", Price, "BuildingLevelup", false) then
		SetProperty("home", "LevelUpProto", Proto)
		SetState("home", STATE_LEVELINGUP, true)
	end
end
