function Weight()

	local Item = "WalkingStick"
	local Money = GetMoney("SIM")
	
	if Money < 4000 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "Use"..Item) > 0 then
		return 0
	end
	
	if GetImpactValue("SIM", "walkingstick") > 0 or GetImpactValue("SIM", "Sugar") > 0 then
		return 0
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price < 0 then
		return 0
	end
	
	return 10
end

function Execute()
	MeasureRun("SIM", nil, "UseWalkingStick")
end
