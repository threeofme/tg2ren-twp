function Weight()
	
	if SimGetAge("SIM") < 16 then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "AI_CheckOutfit") then
		return 0
	end

	if not SimGetWorkingPlace("SIM", "Place") then
		return 0
	end

	if GetMoney("Place") < 5000 then
		return 0
	end

	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_CheckOutfit", 6)
	MeasureRun("SIM","Place","CheckOutfit")
end

