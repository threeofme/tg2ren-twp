function Run()

	if not GetState("", STATE_IDLE) then
		return ""
	end

	if not ReadyToRepeat("", "Ausschenken") then
		return ""
	end

	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
	if GetID("dynasty") == GetDynastyID("Actor") then
		return ""
	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end

    if IsPartyMember("") then
        return ""
    end

	local chraskill = GetSkillValue("Actor",3)
	local chance = Rand(8)	
	if chance > chraskill then	
	    return ""
	end
	
	return "SimAusschenken"
end

