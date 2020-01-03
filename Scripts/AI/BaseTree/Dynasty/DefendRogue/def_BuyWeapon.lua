function Weight()
	if not AliasExists("SIM") then
		return 0
	end
		
	local Difficulty = ScenarioGetDifficulty()
	local Item
	
	if Difficulty == 0 then
		return 0

	elseif Difficulty == 1 then	
		if DynastyIsShadow("SIM") then
			return 0
		end
		
		Item = "Dagger"
		
		if GetItemCount("SIM", "Dagger", INVENTORY_STD)>0 or GetItemCount("SIM", "Dagger", INVENTORY_EQUIPMENT)>0 then
			return 0
		end
		
	elseif Difficulty == 2 then
		if DynastyIsShadow("SIM") then
			return 0
		end
		
		if SimGetRank("SIM")<2 then
			Item = "Dagger"
		elseif SimGetRank("SIM")==2 then
			Item = "Shortsword"
		else 
			Item = "Mace"
		end
		
		if GetItemCount("SIM", Item, INVENTORY_STD)>0 or GetItemCount("SIM", Item, INVENTORY_EQUIPMENT)>0 then
			return 0
		end
		
		if GetItemCount("SIM", "Mace", INVENTORY_STD)>0 or GetItemCount("SIM", "Mace", INVENTORY_EQUIPMENT)>0 then
			return 0
		end	
		
	elseif Difficulty == 3 then		
		if DynastyIsShadow("SIM") then
			if SimGetOfficeLevel("SIM")<1 then
				return 0
			end
		end
		
		if SimGetRank("SIM")<2 then
			Item = "Dagger"
		elseif SimGetRank("SIM")==2 then
			Item = "Shortsword"
		elseif SimGetRank("SIM")==3 then
			Item = "Mace" 
		elseif SimGetRank("SIM")==4 then
			Item = "Longsword"
		elseif SimGetRank("SIM")==5 then
			Item = "Axe"
		end
		
		if GetItemCount("SIM", Item, INVENTORY_STD)>0 or GetItemCount("SIM", Item, INVENTORY_EQUIPMENT)>0 then
			return 0
		end
		
		if GetItemCount("SIM", "Axe", INVENTORY_STD)>0 or GetItemCount("SIM", "Axe", INVENTORY_EQUIPMENT)>0 then
			return 0
		end	

	else
		if SimGetRank("SIM")<2 then
			Item = "Dagger"
		elseif SimGetRank("SIM")==2 then
			Item = "Shortsword"
		elseif SimGetRank("SIM")==3 then
			Item = "Mace" 
		elseif SimGetRank("SIM")==4 then
			Item = "Longsword"
		elseif SimGetRank("SIM")==5 then
			Item = "Axe"
		end
		
		if GetItemCount("SIM", Item, INVENTORY_STD)>0 or GetItemCount("SIM", Item, INVENTORY_EQUIPMENT)>0 then
			return 0
		end
			
		if GetItemCount("SIM", "Axe", INVENTORY_STD)>0 or GetItemCount("SIM", "Axe", INVENTORY_EQUIPMENT)>0 then
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
	
	SetProperty("SIM","AIBuyWeapon",Item)
	return 100
end

function Execute()
	MeasureRun("SIM", nil, "AIBuyWeapon")
end
