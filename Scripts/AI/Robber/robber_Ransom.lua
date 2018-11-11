function Weight()
	if IsDynastySim("SIM") then
		return 0
	end
	
	if SimGetAge("SIM")<16 then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM", "Thiefshut") then
		return 0
	end
	
	if not BuildingGetPrisoner("Thiefshut", "Victim") then
		return 0
	end
	
	if not ReadyToRepeat("SIM", GetMeasureRepeatName2("DemandRansom")) then
		return 0
	end
		
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "Victim", "Victim")
	MeasureStart("Measure", "SIM", nil, "DemandRansom")
end

