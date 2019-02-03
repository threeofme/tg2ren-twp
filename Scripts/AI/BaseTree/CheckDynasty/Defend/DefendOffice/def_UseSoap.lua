function Weight()
	local	Item = "Soap"
	local Money = GetMoney("SIM")*0.10 
	local Difficulty = ScenarioGetDifficulty()
	local Infected = 0
	
	if not GetSettlement("SIM","City") then
		return 0
	end
	
	if HasProperty("City","BlackdeathInfected") then
		Infected = GetProperty("City","BlackdeathInfected")
	end
	
	if ItemGetBasePrice(Item) > Money then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end
	
	if GetItemCount("", Item,INVENTORY_STD)>0 then
		return 100
	end
	
	if GetImpactValue("SIM","sickness")>0 then
		return 0
	end
	
	if GetImpactValue("SIM","Resist")>0 then
		return 0
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price<0 then
		return 0
	end
	
	if Difficulty > 2 then
		if Infected == 0 then
			return 5
		else
			return 100
		end
	else
		return 0
	end
end

function Execute()
	MeasureRun("SIM", nil, "UseSoap")
end
