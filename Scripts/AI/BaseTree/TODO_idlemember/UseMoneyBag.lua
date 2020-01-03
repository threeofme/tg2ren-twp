-- TODO move to dynastyidle 

function Weight()
	if dyn_GetIdleMember("dynasty", "SIM") == -1 then
		return 0
	end

	local Item = "MoneyBag"
	local Money = GetMoney("SIM")
	
	if Money < 4000 then
		return 0
	end
	
	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("Use"..Item)) > 0 then
		return 0
	end
	
	if GetImpactValue("SIM", "MoneyBag") > 0 then
		return 0
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price < 0 then
		return 0
	end
	
	return 10
end

function Execute()
	MeasureRun("SIM", nil, "UseMoneyBag")
end
