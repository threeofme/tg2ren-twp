function Weight()

	if not SimGetWorkingPlace("SIM","Tavern") then
		return 0
	end

	if GetMeasureRepeat("Tavern", "ArrangeConcert") > 0 then
		return 0
	end
		
	return 0 --100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", 3)
	MeasureStart("Measure", "Tavern", "SIM", "ArrangeConcert")
end
