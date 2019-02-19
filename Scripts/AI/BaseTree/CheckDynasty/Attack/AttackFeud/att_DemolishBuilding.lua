function Weight()

	if GetImpactValue("SIM", "DemolishBuilding")==0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "DemolishBuilding")>0 then
		return 0
	end

	local i = 0
	local NumVictimBuildings = DynastyGetBuildingCount("Victim",-1,-1)
	for i=0,NumVictimBuildings do
		if not DynastyGetRandomBuilding("Victim",-1,-1,"db_House") then
			return 0
		end
		if GetHPRelative("db_House") < 0.3 then
			return 100
		end
	end
	return 0
	
end

function Execute()
	MeasureRun("SIM", "db_House", "DemolishBuilding")
end
