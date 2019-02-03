function Weight()
	if GetHPRelative("SIM") >= 0.9 then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM","Robbernest") then
		return 0
	end
	
	if not BuildingHasUpgrade("Robbernest","Campfire") then
		return 0
	end
	
end

function Execute()
	MeasureRun("SIM","Robbernest","GetCured")
end

