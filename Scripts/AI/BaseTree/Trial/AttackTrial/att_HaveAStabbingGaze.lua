function Weight()

	if GetImpactValue("SIM", "UncannyGlare")==0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "UncannyGlare")>0 then
		return 0
	end

	return 1000
end

function Execute()
	MeasureRun("SIM", "Victim", "UncannyGlare", false)
end

