function Weight()
	
	if not ReadyToRepeat("SIM", "AI_DefendOffice") then
		return 0
	end
	
	if SimGetOfficeLevel("SIM")<0 then
		return 0
	end
	
	if not SimIsAppliedForOffice("SIM") then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_DefendOffice", 0.75)	
end