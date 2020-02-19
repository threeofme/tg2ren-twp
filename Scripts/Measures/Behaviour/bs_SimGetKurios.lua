function Run()
    if SimGetNeed("", 5)<=0.5 then
	    return ""
	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end

	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
	if SimGetProfession("")==42 then --juggler
		return ""
	end

	if SimGetClass("")==3 then
		return ""
	end

    if not ReadyToRepeat("","SimGetKurios") then
        return ""
    end


    if IsPartyMember("") then
        return ""
    end

	if not GetState("", STATE_IDLE) then
		return ""
	end	
	
    return "SimGetKurios"
end
