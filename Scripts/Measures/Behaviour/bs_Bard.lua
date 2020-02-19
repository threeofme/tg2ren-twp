function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end

	if not GetState("", STATE_IDLE) then
		return ""
	end
	
	if GetProperty("","NoBard") == 1 then
		return ""
	end	
	
	if GetState("", STATE_WORKING) then
		return ""
	end
	
	if not ReadyToRepeat("", "Listen2Bard") then
		return ""
	end

	return "Listen"
end

