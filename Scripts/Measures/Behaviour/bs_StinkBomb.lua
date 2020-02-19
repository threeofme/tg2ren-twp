function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
	if GetCurrentMeasureName("") == "UseStinkBomb" then
		return ""
	end
	
	if GetCurrentMeasurePriority("")>55 then
		return ""
	end
	
	SetData("Distance", 2000)
	return "Flee"
end
