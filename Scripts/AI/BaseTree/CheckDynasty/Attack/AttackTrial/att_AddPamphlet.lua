function Weight()
	
	if ScenarioGetDifficulty() < 2 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "AddPamphlet")>0 then
		return 0
	end
			
	return 100
end

function Execute()
	MeasureRun("SIM","VICTIM","AddPamphlet")
end

