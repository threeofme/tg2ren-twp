function Run()

    if SimGetNeed("", 7)<0.5 then
	    return ""
	end

	if not GetState("", STATE_IDLE) then
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
	
	return "SimHandel"
end

