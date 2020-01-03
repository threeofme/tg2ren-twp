function Weight()

	if not ai_GetWorkBuilding("SIM", GL_BUILDING_TYPE_PIRAT, "Divehouse") then
		return 0
	end
	
	if not ReadyToRepeat("Divehouse", "ai_DiveGetBeer") then
		return 0
	end
	
	if GetMoney("Divehouse") < 1000 then
		return 0
	end

	if GetItemCount("Divehouse", "SmallBeer", INVENTORY_STD) >= 10 and GetItemCount("Divehouse", "WheatBeer") >= 10 then
		return 0
	end

	BuildingGetCity("Divehouse","checkTown")
	CityGetLocalMarket("checkTown","Market")
	
	if not AliasExists("Market") then
		return 0
	end
	
	if GetItemCount("Market", "SmallBeer", INVENTORY_STD) < 10 or GetItemCount("Market", "WheatBeer", INVENTORY_STD) < 10 then
	        return 0
	end
	
	return 100
end

function Execute()

	SetRepeatTimer("Divehouse", "ai_DiveGetBeer", 6)

	if not AliasExists("Market") then
		BuildingGetCity("Divehouse","checkTown")
		CityGetLocalMarket("checkTown","Market")
	end
	
	local NeedSmallBeer = 20 - GetItemCount("Divehouse", "SmallBeer", INVENTORY_STD)
	local NeedWheatBeer = 20 - GetItemCount("Divehouse", "WheatBeer", INVENTORY_STD)
	local Price
	
	-- buy SmallBeer
	if NeedSmallBeer > 0 then
		if GetItemCount("Market", "SmallBeer", INVENTORY_STD)>= NeedSmallBeer then
			Price = ItemGetPriceSell("SmallBeer", "Market") * NeedSmallBeer
			if GetMoney("Divehouse") > Price then
				if f_SpendMoney("Divehouse", Price, "misc") then
						Transfer(nil, nil, INVENTORY_STD, "Market", INVENTORY_STD, "SmallBeer", NeedSmallBeer)
						AddItems("Divehouse", "SmallBeer", NeedSmallBeer, INVENTORY_STD)
				end
			end
		end
	end
	
	-- buy WheatBeer
	if NeedWheatBeer > 0 then
		if GetItemCount("Market", "WheatBeer", INVENTORY_STD)>= NeedWheatBeer then
			Price = ItemGetPriceSell("WheatBeer", "Market") * NeedWheatBeer
			if GetMoney("Divehouse") > Price then
				if f_SpendMoney("Divehouse", Price, "misc") then
					Transfer(nil, nil, INVENTORY_STD, "Market", INVENTORY_STD, "WheatBeer", NeedWheatBeer)
					AddItems("Divehouse", "WheatBeer", NeedWheatBeer, INVENTORY_STD)
				end
			end
		end
	end
end

