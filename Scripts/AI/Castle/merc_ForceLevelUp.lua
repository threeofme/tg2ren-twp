function Weight()

	if GetRound() <2 then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "ai_ForceLevelUp") then
		return 0
	end
	
	if IsDynastySim("SIM") then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM","MyWork") then
		return 0
	end

	if not BuildingGetOwner("MyWork","MyBoss") then
		return 0
	end
	
	if DynastyIsPlayer("MyBoss") then
		return 0
	end
	
	if GetState("MyWork", STATE_BUILDING) or GetState("MyWork", STATE_LEVELINGUP) then
		return 0
	end
	
	local BuildLevel = BuildingGetLevel("MyWork")
	
	if BuildLevel== 3 then
		return 0
	else
		SetData("BuildLevel", BuildLevel)
	end
	
	local BuildType = BuildingGetType("MyWork")
	SetData("BuildType", BuildType)
	
	local cost = 0
	local BossLevel = 0
	
	if BuildLevel == 2 then
		cost = 20000
		BossLevel = 5
	else
		cost = 10000
		BossLevel = 3
	end
	
	SetData("Cost", cost)
	
	if GetMoney("dynasty") < cost then
		SetRepeatTimer("dynasty", "ai_ForceLevelUp", 12)
		return 0
	end
	
	if SimGetLevel("MyBoss") < BossLevel then
		SetRepeatTimer("dynasty", "ai_ForceLevelUp", 12)
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("dynasty", "ai_ForceLevelUp", 48)
	local BuildType = GetData("BuildType")
	local BuildLevel = GetData("BuildLevel")
	local Proto = ScenarioFindBuildingProto(2, BuildType, BuildLevel+1, -1)
	local Price = GetData("Cost")
	
	if f_SpendMoney("dynasty", Price, "BuildingLevelup", false) then
		SetProperty("MyWork", "LevelUpProto", Proto)
		SetState("MyWork", STATE_LEVELINGUP, true)
	end
end