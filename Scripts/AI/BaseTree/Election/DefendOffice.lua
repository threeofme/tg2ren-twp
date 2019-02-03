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
	
	if GetImpactValue("SIM", "OfficeTimer") < 2 then
		return 0
	end
	
	if ImpactGetMaxTimeleft("SIM", "OfficeTimer") > 12 then
		return 0
	end
	
	return 15
end

function Execute()
	SetRepeatTimer("SIM", "AI_DefendOffice", 0.75)	
end