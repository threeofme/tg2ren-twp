function Weight()

	if not ReadyToRepeat("SIM", "AI_DefendDuel") then
		return 0
	end

	if GetImpactValue("SIM", "DuelTimer") < 1 then
		return 0
	end
	
	-- it's too soon for an attack
	if ImpactGetMaxTimeleft("SIM", "DuelTimer") > 12 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_DefendDuel", 2)
end