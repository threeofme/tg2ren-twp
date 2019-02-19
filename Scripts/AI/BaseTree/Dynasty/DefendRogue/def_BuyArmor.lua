function Weight()
	
	if Rand(3) == 0 then
		return 0
	end
	
	local Difficulty = ScenarioGetDifficulty()
	local Item
	
	if Difficulty < 2 then
		return 0
	
	elseif Difficulty <= 3 then
		if DynastyIsShadow("SIM") then
			if SimGetOfficeLevel("SIM")<1 then
				return 0
			end
		end
		
		if SimGetRank("SIM")<3 then
			return 0
		elseif SimGetRank("SIM")==3 then
			Item = "LeatherArmor"
		elseif SimGetRank("SIM")==4 then 
			Item = "Chainmail"
		elseif SimGetRank("SIM")==5 then
			Item = "Platemail"
		end
		
		if GetItemCount("SIM", Item, INVENTORY_STD)>0 or GetItemCount("SIM", Item, INVENTORY_EQUIPMENT)>0 then
			return 0
		end
		
		if GetItemCount("SIM", "Platemail", INVENTORY_STD)>0 or GetItemCount("SIM", "Platemail", INVENTORY_EQUIPMENT)>0 then
			return 0
		end
		
	else
		if SimGetRank("SIM")<3 then
			return 0
		elseif SimGetRank("SIM")==3 then
			Item = "LeatherArmor"
		elseif SimGetRank("SIM")==4 then 
			Item = "Chainmail"
		elseif SimGetRank("SIM")==5 then
			Item = "Platemail"
		end
		
		if GetItemCount("SIM", Item, INVENTORY_STD)>0 or GetItemCount("SIM", Item, INVENTORY_EQUIPMENT)>0 then
			return 0
		end
		
		if GetItemCount("SIM", "Platemail", INVENTORY_STD)>0 or GetItemCount("SIM", "Platemail", INVENTORY_EQUIPMENT)>0 then
			return 0
		end
	end
	
	local Price = ai_CanBuyItem("SIM", Item)
	local money = GetMoney("SIM") / 4
	
	if Price<0 then
		return 0
	elseif Price>money then
		return 0
	end

	SetProperty("SIM","AIBuyArmor",Item)	
	return 100
end

function Execute()
	MeasureRun("SIM", nil, "AIBuyArmor")
end
