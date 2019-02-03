function Weight()
	if not ReadyToRepeat("SIM", "AI_CheckOutfit") then
		return 0
	end	
	
	if math.mod(GetGametime(), 24) >= 6 then
		return 100
	else
		return 0
	end
end

function Execute()
	local Random = Rand(12)
	SetRepeatTimer("SIM", "AI_CheckOutfit", (18+Random))
	MeasureRun("SIM", nil, "CheckOutfit")
end

