function Weight()
	local	Item = "Perfume"
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end
	
	if DynastyIsShadow("SIM") then
		if SimGetOfficeLevel("SIM")<1 then
			return 0
		end
	end
	
	if GetItemCount("", Item,INVENTORY_STD)>0 then
		return 100
	end

	local Price = ai_CanBuyItem("SIM", Item)
	if Price<0 then
		return 0
	end
	
	if SimGetOfficeLevel("SIM")>0 then
		return 50
	end

	return 10
end

function Execute()
	MeasureRun("SIM", nil, "UsePerfume")
end
