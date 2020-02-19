function Run()
	if not GetState("", STATE_IDLE) then
		return ""
	end
	
	if SimGetProfession("")==GL_PROFESSION_MYRMIDON then
		return ""
	end

	if not ReadyToRepeat("", "Listen2Quacksalver") then
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
	
	if GetState("",STATE_GUARDING) then
		return ""
	end

	if IsDynastySim("") then
		return ""
	end

	return "ListenQuacksalver"
end

