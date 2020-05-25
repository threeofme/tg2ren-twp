function Weight()
	if GetImpactValue("SIM", "Set_TurnoverTax") <= 0 then
		return 0 
	end
	if not ReadyToRepeat("SIM", "AI_PrivSetTurnoverTax") then
		return 0
	end
	
	if GetGametime() < 24 then
		return 0
	end
		
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_PrivSetTurnoverTax", 24)
	MeasureRun("SIM", 0, "Set_TurnoverTax")
end

