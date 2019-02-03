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
	
	if not HasProperty("dynasty", "RivalID") then
		return 0
	end
	
	local RivalID = GetProperty("dynasty", "RivalID")
	local RivalBuilding = GetProperty("dynasty", "RivalBuilding")
	
	GetAliasByID(RivalID, "VictimDynasty")
	
	if not AliasExists("VictimDynasty") or DynastyGetDiplomacyState("VictimDynasty", "SIM") > DIP_NAP then
		RemoveProperty("dynasty", "RivalID")
		RemoveProperty("dynasty", "RivalBuilding")
		return 0
	end
	
	-- check for diplomacy state to be sure
	if DynastyGetDiplomacyState("VictimDynasty", "SIM") >= DIP_NAP then
		return 0
	end
	
	local DynastyCount = DynastyGetMemberCount("VictimDynasty")
	if not DynastyGetMember("VictimDynasty", Rand(DynastyCount), "Victim") then
		return 0
	end
	
	GetAliasByID(RivalBuilding, "RivalBuild")
	
	if not AliasExists("RivalBuild") then
		RemoveProperty("dynasty", "RivalID")
		RemoveProperty("dynasty", "RivalBuilding")
		return 0
	end
	
	if DynastyIsShadow("SIM") and DynastyIsShadow("Victim") then
		return 0
	end
	
	return 100
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	local Timer = 24 - Difficulty*4
	SetRepeatTimer("SIM", "AI_AttackRival", Timer)	
end