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
	
	return 30
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	local Timer = 13 - Difficulty*3
	SetRepeatTimer("SIM", "AI_AttackFeud", Timer)	
end