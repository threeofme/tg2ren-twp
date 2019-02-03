function Weight()
	
	if ScenarioGetTimePlayed() < 2 then
		return 0
	end
	
	if SimGetAge("SIM") < 16 then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "AI_Defend") then
		return 0
	end
	
	if not f_SimIsValid("SIM") then
		return 0
	end
	
	if GetDynastyID("SIM") == -1 then
		return 0
	end
	
	-- only important shadows should defend (performance)
	if DynastyIsShadow("SIM") then
		if DynastyGetBuildingCount2("SIM") > 0 then -- we own something
			return 100
		end
		
		if SimGetOfficeLevel("SIM") >= 0 or SimIsAppliedForOffice("SIM") then -- we are political
			return 100
		end
		
		if GetImpactValue("SIM", "DuelTimer") > 0 then -- we are about to duel someone
			return 100
		end
		
		if GetImpactValue("SIM", "TrialTimer") > 0 then -- we are about to go to trial
			return 100
		end
		
		return 0 -- we are unimportant
	end
	
	return 100 -- coloured dynasty always defend
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	local Timer = 4.5 - Difficulty
	SetRepeatTimer("SIM", "AI_Defend", Timer)	
end

