function Weight()

	if ScenarioGetTimePlayed() < 6 then
		return 0
	end
	
	if SimGetAge("SIM") < 16 then
		return 0
	end

	if not ReadyToRepeat("SIM", "AI_Attack") then
		return 0
	end
	
	if not f_SimIsValid("SIM") then
		return 0
	end
	
	-- only important shadows should attack (performance)
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
	
	return 100
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	local Timer = 5.5 - Difficulty
	SetRepeatTimer("SIM", "AI_Attack", Timer)	
end
