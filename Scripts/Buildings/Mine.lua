function Run()
end

function OnLevelUp()
	bld_HandleOnLevelUp("")
end

function Setup()
	bld_HandleSetup("")
	-- create ambient animals
	if Rand(2)==0 then
		worldambient_CreateAnimal("Stag", "" , 2)
	else
		worldambient_CreateAnimal("Deer", "", 2)
	end
end

function SellOtherStuff(BldAlias)
	
	if not GetSettlement(BldAlias, "MyCity") then
		return
	end
	
	CityGetLocalMarket("MyCity", "MyMarket")
	if not AliasExists("MyMarket") then
		return
	end
	
	-- check all carts
	for i=0, BuildingGetCartCount(BldAlias)-1 do
		if BuildingGetCart(BldAlias, i, "Cart") then -- get the cart i
			if GetDistance(BldAlias, "Cart") < 1000 then
				if not GetState("Cart", STATE_CHECKFORSPINNINGS) then -- is not moving
					if CanAddItems("Cart", "Salmon", 30, INVENTORY_STD) then -- enough space
						CopyAlias("Cart", "MyCart")
						break
					end
				end
			end
		end
	end
	
	if not AliasExists("MyCart") then
		return
	end
	
	-- now check our inventory
	local Count = InventoryGetSlotCount(BldAlias, INVENTORY_STD)
	local ItemId
	local ItemCount
	local Item1 = 0
	local Amount1 = 0
	local Item2 = 0
	local Amount2 = 0
	
	for i=0, Count-1 do
		ItemId, ItemCount = InventoryGetSlotInfo(BldAlias, i, INVENTORY_STD)
		if ItemId and ItemCount > 0 then
			if ItemGetType(ItemId) == 3 or ItemGetType(ItemId) == 5 then
				if not BuildingCanProduce(BldAlias, ItemId) then 
					if Item1 == 0 then
						Item1 = ItemId
						Amount1 = ItemCount
						if Amount1 > 20 then
							Amount1 = 20
						end
					elseif Item2 == 0 then
						Item2 = ItemId
						Amount2 = ItemCount
						if Amount2 > 20 then
							Amount2 = 20
						end
					else
						break
					end
				end
			end
		end
	end
	
	local Market = Rand(5)+1
	if not CityGetRandomBuilding("MyCity", 5, 14, Market ,-1, FILTER_IGNORE, "MarketPos") then
		if not CityGetRandomBuilding("MyCity", 5, 14, -1, -1, FILTER_IGNORE, "MarketPos") then
			return
		end
	end
	
	if Item1 + Item2 > 0 then
		MeasureRun("MyCart", "MarketPos", "SendCartAndUnload", true)
	end
	
	if Item1 > 0 then 
		SetProperty("MyCart", "Amount", Amount1)
		CreateScriptcall("TransferItem1", 0.15, "Buildings/farm.lua", "TransferItem", BldAlias, "MyCart", Item1)
	end
	
	Sleep(0.25)
	
	if Item2 > 0 then
		SetProperty("MyCart", "Amount", Amount2)
		CreateScriptcall("TransferItem2", 0.15, "Buildings/farm.lua", "TransferItem", BldAlias, "MyCart", Item2)
	end
end

function PingHour()
	bld_HandlePingHour("")
	-- Improve AI management
	if BuildingGetAISetting("", "Produce_Selection") > 0 then
		mine_SellOtherStuff("")
	end
end
