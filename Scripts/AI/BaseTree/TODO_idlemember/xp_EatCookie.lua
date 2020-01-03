function Weight()
	
	local Item
	if SimGetRank("SIM")<4 then
		Item = "Cookie"
	else
		if Rand(3) == 0 then
			Item = "Cookie"
			SetData("Choice", 1)
		else
			Item = "CreamPie"
			SetData("Choice", 2)
		end
	end
	
	local Money = GetMoney("SIM") 
	
	if Money < 5000 then
		return 0
	end
	
	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("Eat"..Item)) > 0 then
		return 0
	end
	
	if GetImpactValue("SIM", "Sugar") > 0 then
		return 0
	end
	
	if GetImpactValue("SIM","walkingstick") > 0 then
		return 0
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price<0 then
		return 0
	end
	
	return 10
end

function Execute()

	if GetData("Choice") == 1 then
		MeasureRun("SIM", nil, "EatCookie")
	else
		MeasureRun("SIM", nil, "EatCreamPie")
	end
end
