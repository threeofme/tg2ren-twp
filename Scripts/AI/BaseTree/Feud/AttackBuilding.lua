function Weight()
	
	local Difficulty = ScenarioGetDifficulty()
	
	if Difficulty < 2 then
		return 0
	end
	
	if Difficulty < 3 then
		if GetRound() < (4 - Difficulty) then
			return 0
		end
	end
	
	if not ReadyToRepeat("SIM", "AI_AttackRival") then
		return 0
	end
	
	if DynastyIsShadow("SIM") and DynastyIsShadow("Victim") then
		return 0
	end
	
	
	if not AliasExists("RivalBuild") then
		if not DynastyGetRandomBuilding("VictimDynasty", -1, -1, "RivalBuild") then
			return 0
		end
	end
	
	if BuildingGetClass("RivalBuild") == GL_BUILDING_CLASS_RESOURCE then
		return 0
	end
	
	if DynastyIsShadow("SIM") then
		-- reduces aggressiveness of shadow dynasties
		return 3
	end
	
	return 20
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	local Timer = 24 - Difficulty*4
	SetRepeatTimer("SIM", "AI_AttackRival", Timer)	
end