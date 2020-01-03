function Weight()
	
	if SimGetClass("SIM") == 4 then
		return 0
	end
	
	local Item = "Tool"
	local Money = GetMoney("SIM")
	
	if Money < 5000 then
		return 0
	end
	
	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("Use"..Item)) > 0 then
		return 0
	end
	
	if GetImpactValue("SIM", "Tool") > 0 then
		return 0
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price < 0 then
		return 0
	end
	
	return 5
end

function Execute()
	MeasureRun("SIM", nil, "UseTool")
end
