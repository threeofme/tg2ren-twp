function Weight()
	if not ReadyToRepeat("dynasty", "DIP_"..GetDynastyID("Target")) then
		return 0
	end
	
	if Rand(5) > 0 then
		return 0
	end
	
	if GetMoney("Target") < 5000 then 
		return 0
	end
	
	return 100
end

function Execute()
	MeasureCreate("measure")
	MeasureAddData("Measure", "Choice", 5, false)
	MeasureStart("Measure", "SIM", "Target", "AdministrateDiplomacy")
end