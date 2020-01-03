function Weight()
	
	if IsDynastySim("SIM") then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM","MyBank") then
		return 0
	end
	
	if not BuildingGetOwner("MyBank","MyBoss") then
		return 0
	end
	
	if GetMoney("MyBoss") <= 1000 then
		return 0
	end

	if GetInsideBuildingID("SIM") ~= GetID("MyBank") then
		return 0
	end
	
	if not ReadyToRepeat("MyBank", "AI_CREDIT") then
		return 0
	end
	
	return 100	
end

function Execute()
	SetRepeatTimer("MyBank", "AI_CREDIT", 4)
	MeasureRun("MyBank","MyBank","OrderCredit", true)
end
