function Weight()
	
	if not GetSettlement("SIM", "City") then
		return 0
	end
	
	if CityFindCrowdedPlace("City", "SIM", "jugglerPlay")==0 then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM","MyWork") then
		return 0
	end
	
	if BuildingGetProducerCount("MyWork", PT_MEASURE, "JugglerBeg") > 0 then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", Rand(3)+3)
	MeasureStart("Measure", "SIM", "jugglerPlay", "JugglerBeg")
end

