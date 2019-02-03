function Weight()
	local	Item = "Mixture"
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end
	
	if GetItemCount("", Item, INVENTORY_STD)>0 then
		return 100
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price < 0 then
		return 0
	end
	
	if GetMoney("SIM") < 5000 then
		return 0
	end
	
	if GetInsideBuilding("Victim","Inside") then
		return 0
	end

	return 5
end

function Execute()
	MeasureRun("SIM", "Victim", "UseMixture", false)
end
