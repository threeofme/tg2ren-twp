function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
--	if not GetState("", STATE_IDLE) then
--		return ""
--	end

	if GetState("",STATE_GUARDING) then
		return ""
	end
	
	if GetState("",STATE_CHILD) then
		return ""
	end
	
	if GetState("",STATE_CRUSADE) then
		return ""
	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end
	
	if GetState("",STATE_DYING) then
		return ""
	end

	if not ReadyToRepeat("", "Listen2Preacher") then
		return ""
	end

	return "ListenFlamingSpeech"
end

