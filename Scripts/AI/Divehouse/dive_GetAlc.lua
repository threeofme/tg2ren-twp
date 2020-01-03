function Weight()

	if not ai_GetWorkBuilding("SIM", GL_BUILDING_TYPE_PIRAT, "Divehouse") then
		return 0
	end
	
	if not BuildingGetOwner("Divehouse", "DiveBoss") then
		return 0
	end
	
	if not ReadyToRepeat("Divehouse", GetMeasureRepeatName2("DiveGetAlc")) then
		return 0
	end

	if not BuildingHasUpgrade("Divehouse","PiratenGrog") then
		return 0
	end

	if GetMoney("Divehouse") < 1000 then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureRun("Divehouse", "Divehouse", "DiveGetAlc", true)
end

