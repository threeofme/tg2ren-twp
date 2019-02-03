function Weight()
	if DynastyGetBuildingCount("dynasty", -1, -1) < 1 then
		return 0
	end
	
	if not (DynastyGetRandomBuilding("dynasty", -1, -1, "PatrolPlace")) then
		return 0
	end
		
	return 100
end

function Execute()
	MeasureRun("SIM", "PatrolPlace", "PatrolTheTown")
end
