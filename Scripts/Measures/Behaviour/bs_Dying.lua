function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	if GetState("",STATE_IMPRISONED) or GetState("",STATE_CAPTURED) then
		return ""
	end
	if GetCurrentMeasurePriority("")>=40 then
		return ""
	end
	local	Favor = GetFavorToSim("", "Actor")
	if  Favor < 20 then
		return "Deride"
	else
		return "Cry"
	end
	
end

