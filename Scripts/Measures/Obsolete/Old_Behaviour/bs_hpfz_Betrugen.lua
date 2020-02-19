function Run()
    if not GetState("",STATE_IDLE) then
        return ""
    end

    if not ReadyToRepeat("","Betrugen") then
        return ""
    end

    if GetImpactValue("","spying") == 1 then
        return ""
    end

	if SimGetProfession("")==41 then --bänker
		return ""
	end	

    if GetItemCount("Actor", "Urkunde")<1 then
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

    if GetImpactValue("","HaveBeenPickpocketed")>0 then
		return
	end	
	
    return "SimBetrugen"
end
