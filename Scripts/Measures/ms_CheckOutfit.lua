function Run()

	local ItemId

	if not SimGetWorkingPlace("", "Place") then
		return
	end
		
	ItemId = ms_checkoutfit_CheckEquip("", "Place", -1, -1)
	if ItemId and ItemId > 0 then
		ms_checkoutfit_Equip("", "Place", "Place", ItemId)
		return
	end

	if not GetNearestSettlement("", "City") then
		return
	end

	if not CityGetLocalMarket("City", "Market") then
		return
	end
	
	if SimGetProfession("")==GL_PROFESSION_CITYGUARD or  SimGetProfession("")==GL_PROFESSION_ELITEGUARD then
		GetSettlement("Place", "WorkCity")
		ItemId = ms_checkoutfit_CheckEquip("", "Market", -1, CityGetLevel("WorkCity"))
	else
		local Budget = GetData("Budget")
		if not Budet then
			Budget = 350
		end
		ItemId = ms_checkoutfit_CheckEquip("", "Market", Budget, -1)
	end
	
	if ItemId and ItemId > 0 then
	
		if not CityGetRandomBuilding("City", GL_BUILDING_CLASS_MARKET, -1, ItemGetCategory(ItemId), -1, FILTER_IGNORE, "Tent") then
			CityGetRandomBuilding("City", GL_BUILDING_CLASS_MARKET, -1, -1, -1, FILTER_IGNORE, "Tent")
		end
	
		if not AliasExists("Tent") then
			return false
		end	
		
		ms_checkoutfit_Equip("", "Market", "Tent", ItemId)
		return
	end
	
end

function CheckEquip(SimAlias, SourceAlias, Budget, CityLevel)

	local Count = InventoryGetSlotCount(SourceAlias, INVENTORY_STD)
	
	local	ItemId
	local	Found
	local	Slot
	local	Items = {}
	local	ItemsCount = 0
	local	NewPrice
	local InUse
	local	InUsePrice
	local	PriceSell = 0
	local	Level
	local	Oldlevel
	
	for i=0,Count-1 do
		ItemId, Found = InventoryGetSlotInfo(SourceAlias, i, INVENTORY_STD)
		
		if ItemId and Found>0 then
			Slot = ItemGetSlot(ItemId)
			if Slot>0 then
			
				InUse = InventoryGetSlotInfo("", Slot-1, INVENTORY_EQUIPMENT)
				
				if InUse ~= ItemId then
		
					InUsePrice 	= 0
					PriceSell 	= 0
					
					if not InUse then
						InUse = -1
					end
					
					if InUse>0 then
						InUsePrice 	= ItemGetBasePrice(InUse)
						PriceSell 	= ItemGetPriceSell(InUse, SourceAlias)
					end
					NewPrice 	= ItemGetBasePrice(ItemId)
					
					if InUsePrice < NewPrice then

						if Budget>0 then
						
							local	PriceBuy 	= ItemGetPriceBuy(ItemId, SourceAlias)
							if (PriceBuy - PriceSell) < Budget then
						
								local	Var = (PriceBuy / NewPrice - 1) * 100
								if Rand(100) > Var then
									Items[ItemsCount] = ItemId
									ItemsCount = ItemsCount + 1
								end
							end
						elseif CityLevel>0 then
							Level = ItemGetSubstLevel(ItemId)
							if Level <= CityLevel then
								local	Oldlevel = ItemGetSubstLevel(InUse)
								if Level > Oldlevel then
									Items[ItemsCount] = ItemId
									ItemsCount = ItemsCount + 1
								end
							end
						else
							Items[ItemsCount] = ItemId
							ItemsCount = ItemsCount + 1
						end
					end
				end
			end
		end
	end
	
	if ItemsCount >0 then
		ItemId = Items[Rand(ItemsCount)]
		return ItemId
	end
	return -1
end

function Equip(SimAlias, SourceAlias, MoveToAlias, ItemId)

	if not ItemId or ItemId==-1 then
		return false
	end
	
	if not f_MoveTo(SimAlias, MoveToAlias, GL_MOVESPEED_RUN) then
		return false
	end
	
	local Slot = ItemGetSlot(ItemId)
	if not Slot or Slot==-1 then
		return false
	end
	
	if GetItemCount(SourceAlias, ItemId) < 1 then
		return false
	end
	
	local InUse = InventoryGetSlotInfo("", Slot-1, INVENTORY_EQUIPMENT)
	if InUse and InUse>0 then
		-- das alte item verkaufen
		Transfer("", SourceAlias, INVENTORY_STANDARD, "", INVENTORY_EQUIPMENT, InUse, 1)
	end
	Transfer("", "", INVENTORY_EQUIPMENT, SourceAlias, INVENTORY_STANDARD, ItemId, 1)
	
end
