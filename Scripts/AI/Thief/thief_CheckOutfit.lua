function Weight()
	-- Disabled for now. Thieves don't really need outfit.
	return 0
end

function Execute()
	SetRepeatTimer("SIM", "AI_CheckOutfit", 6)
	MeasureRun("SIM","Place","CheckOutfit")
end

