function Weight()
	if GetImpactValue("SIM", "TrialTimer") < 1 then
		return 0
	end
	
	-- it's too soon for an attack
	if ImpactGetMaxTimeleft("SIM", "TrialTimer") > 10 then
		return 0
	end
	
	if not HasProperty("SIM", "TrialOpponent") then
		return 0
	end
	
	if not HasProperty("SIM", "TrialJudge") then
		return 0
	end
	
	local OpponentID = GetProperty("SIM", "TrialOpponent")
	if not GetAliasByID(OpponentID, "TrialOpponent") then
		return 0
	end
	
	local JudgeID = GetProperty("SIM", "TrialJudge")
	if not GetAliasByID(JudgeID, "TrialJudge") then
		return 0
	end
	
	if GetFavorToSim("SIM", "TrialJudge") <= 25 then -- we hate the judge
		-- select a random target
		if Rand(4) == 0 then -- attack judge
			CopyAlias("TrialJudge", "Victim")
		else -- attack opponent
			CopyAlias("TrialOpponent", "Victim")
		end
	else
		CopyAlias("TrialOpponent", "Victim")
	end
	
	if not AliasExists("Victim") then
		return 0
	end
	
	if GetDynasty("Victim", "VictimDyn") then
		local BestState = ai_DynastyGetBestDiplomacyState("dynasty", "VictimDyn")
		if BestState == "NAP" or BestState == "ALLIANCE" then -- actualy we want to be friends
			return 0
		end
	end
	
	-- check for diplomacy state to be sure
	if DynastyGetDiplomacyState("Victim", "SIM") >= DIP_NAP then
		return 0
	end
	
	if GetDistance("SIM", "Victim") > 10000 then
		return 0
	end
	
	if DynastyIsShadow("SIM") and DynastyIsShadow("Victim") then
		return 0
	end
	
	if DynastyIsShadow("SIM") then
		-- reduces aggressiveness of shadow dynasties
		return 5
	end
	
	return 100
end

function Execute()
end