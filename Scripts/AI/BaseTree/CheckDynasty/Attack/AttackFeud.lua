function Weight()
	
	local Difficulty = ScenarioGetDifficulty()
	
	if Difficulty < 3 then
		if GetRound() < (4 - Difficulty) then
			return 0
		end
	end
	
	-- only important shadows attack enemies
	if DynastyIsShadow("SIM") then
		if SimGetOfficeLevel("SIM")<0 then
			if DynastyGetBuildingCount2("SIM") == 0 then
				return 0
			end
		end
	end
	
	if not ReadyToRepeat("SIM", "AI_AttackFeud") then
		return 0
	end
	
	local EnemyCount = f_DynastyGetNumOfEnemies("SIM")
	if EnemyCount < 1 then
		return 0
	end
	
	-- select a random enemy dynasty
	local DynNum = Rand(EnemyCount)
	-- Get the ID
	local TargetID = 0
		
	if HasProperty("dynasty", "Enemy_"..DynNum) then
		TargetID = GetProperty("dynasty", "Enemy_"..DynNum)
	else
		return 0
	end
		
	-- Get the Alias
	if not GetAliasByID(TargetID, "VictimDynasty") then
		return 0
	end
		
	-- Get a Victim
	if not DynastyGetMemberRandom("VictimDynasty", "Victim") then
		return 0
	end
	
	if not AliasExists("Victim") then
		return 0
	end
	
	-- don't attack shadow enemies
	if DynastyIsShadow("Victim") then
		return 0
	end
	
	-- check for diplomacy state to be sure
	if DynastyGetDiplomacyState("Victim", "SIM") >= DIP_NAP then
		return 0
	end
	
	-- don't attack characters who are inside a building
	if GetInsideBuilding("Victim","Inside") then
		return 0
	end
	
	if GetDistance("SIM", "Victim") > 10000 then
		return 0
	end
	
	if DynastyIsShadow("SIM") and DynastyIsShadow("Victim") then
		return 0
	end
	
	return 90
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	local Timer = 13 - Difficulty*3
	SetRepeatTimer("SIM", "AI_AttackFeud", Timer)	
end