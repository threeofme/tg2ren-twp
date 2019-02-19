function Weight()
	
	if not ReadyToRepeat("SIM", "AI_DefendBlackdeath") then
		return 0
	end
	
	local Infected = 0
	
	if not GetSettlement("SIM","City") then
		return 0
	end
	
	if HasProperty("City","BlackdeathInfected") then
		Infected = GetProperty("City","BlackdeathInfected")
	end
	
	if Infected == 0 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_DefendBlackdeath", 12)	
end