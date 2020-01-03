function Weight()

	if not ReadyToRepeat("SIM", "AI_DefendTrial") then
		return 0
	end
	
	if GetImpactValue("SIM", "TrialTimer") < 1 then
		return 0
	end
	
	-- it's too soon for an attack
	if ImpactGetMaxTimeleft("SIM", "TrialTimer") > 10 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_DefendTrial", 0.5)
end