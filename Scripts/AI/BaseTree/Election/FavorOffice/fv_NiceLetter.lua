function Weight()
	if not ReadyToRepeat("dynasty", "DIP_"..GetDynastyID("Target")) then
		return 0
	end
	
	if Rand(3) > 0 then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureCreate("measure")
	MeasureAddData("Measure", "Choice", 2, false)
	MeasureStart("Measure", "SIM", "Target", "AdministrateDiplomacy")
end