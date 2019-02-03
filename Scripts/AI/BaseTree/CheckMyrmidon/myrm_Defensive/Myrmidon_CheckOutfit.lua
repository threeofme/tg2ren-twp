function Weight()
	if not ReadyToRepeat("SIM", "_AI_CheckOutfit") then
		return 0
	end
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "_AI_CheckOutfit", 12)
	MeasureRun("SIM", nil, "CheckOutfit")
end

