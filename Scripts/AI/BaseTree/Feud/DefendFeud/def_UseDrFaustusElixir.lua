function Weight()

	local	Item = "DrFaustusElixir"
	local Money = GetMoney("SIM")*0.20 
	local Difficulty = ScenarioGetDifficulty()
	
	if ItemGetBasePrice(Item) > Money then
		return 0
	end
	
	if Difficulty <3 then
		return 0
	end
	
	if DynastyIsShadow("SIM") then
		return 0
	end
	
	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("Use"..Item)) > 0 then
		return 0
	end
	
	if GetItemCount("", Item,INVENTORY_STD)>0 then
		return 100
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price<0 then
		return 0
	end

	return 10
end

function Execute()
	MeasureRun("SIM", nil, "UseDrFaustusElixir")
end
