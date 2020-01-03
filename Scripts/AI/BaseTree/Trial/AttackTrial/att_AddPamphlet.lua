function Weight()
	
	if ScenarioGetDifficulty() < 2 then
		return 0
	end
	
	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("AddPamphlet")) > 0 then
		return 0
	end
			
	return 100
end

function Execute()
	MeasureRun("SIM","VICTIM","AddPamphlet")
end

