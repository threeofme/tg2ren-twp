function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	if GetState("",STATE_IMPRISONED) or GetState("",STATE_CAPTURED) then
		return ""
	end
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end
	
	

	local	Favor = GetFavorToSim("", "Actor")
	if  Favor < 40 then
		return "Deride"
	end

	SetData("NoAutoFollow", 1)
	return "Gauntlet"
end

