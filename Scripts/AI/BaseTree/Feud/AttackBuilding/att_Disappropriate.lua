function Weight()
	if GetImpactValue("SIM", "Disappropriate") == 0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "Disappropriate") > 0 then
		return 0
	end
	
	if not DynastyGetRandomBuilding("Victim", GL_BUILDING_CLASS_WORKSHOP, -1, "VictimWorkshop") then
		return 0
	end
	
	if AliasExists("RivalBuild") then
		CopyAlias("RivalBuild", "VictimWorkshop")
	end
	
	if GetRound() < 3 then
		return 0
	end

	return 10
end

function Execute()
	MeasureRun("SIM", "VictimWorkshop", "Disappropriate")
end

