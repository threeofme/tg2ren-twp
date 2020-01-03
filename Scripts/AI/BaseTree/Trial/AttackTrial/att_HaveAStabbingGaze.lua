function Weight()

	if GetImpactValue("SIM", "UncannyGlare")==0 then
		return 0
	end
	
	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("UncannyGlare")) > 0 then
		return 0
	end

	return 1000
end

function Execute()
	MeasureRun("SIM", "Victim", "UncannyGlare", false)
end

