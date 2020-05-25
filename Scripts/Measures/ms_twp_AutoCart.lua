-- Entry to enable use by players, MeasureToObjects.dbt:
-- 3099   13085   0   0   1509   3   ""   ()   ""   0   0   |

function Init()
end

function Run()
	-- find home 
	if not GetHomeBuilding("","MyHome") then
		return
	end
	if not GetSettlement("MyHome", "MyCity") then
		return
	end
	if not GetOutdoorMovePosition("", "MyHome", "HomePos") then
		return
	end
	-- 1. Go home.
	if not IsInLoadingRange() and not f_MoveTo("","HomePos", GL_MOVESPEED_RUN) then
		-- cannot get gome, something went wrong
		StopMeasure() 
	end
	local CartSlots, CartSlotSize = cart_GetCartSlotInfo("")
	
	while true do 
		-- 2. Get all Items on sale
		local Count, Items = economy_GetItemsForSale("MyHome")
		
		-- necessary in combination with AI management: unload at home
		for i = 1, CartSlots do
			local ItemId, ItemCount = InventoryGetSlotInfo("", CartSlots-i)
			if ItemId and ItemCount > 0 then
				if CanAddItems("MyHome", ItemId, ItemCount, INVENTORY_STD) then				
					Transfer("","MarketBld",INVENTORY_STD,"",INVENTORY_STD, ItemId, ItemCount)
				end
			end
		end
		
		-- 3. Calculate expected profit for each item
		CityGetLocalMarket("MyCity","MyMarket")
		local Profits = {} -- table of ItemId -> Profit
		local ProfitCount = 0
		for i = 1, Count do
			-- TODO optimize this, so that we don't iterate over the whole inventory for each item
			local Amount = bld_GetItemCount("MyHome", Items[i])
			local Profit = Amount *	ItemGetPriceSell(Items[i], "MyMarket") 
			if Amount > 0 and Profit > 500 then
				ProfitCount = ProfitCount + 1
				Profits[ProfitCount] = {Items[i], Profit}
			end
		end
 
		-- TODO rather move content of if clause to another method
		if ProfitCount > 0 then
			-- 4. sort by expected profit, highest first
			Profits = helpfuncs_QuickSort(Profits, 1, ProfitCount, ms_twp_autocart_SortProfits)
			
			-- 5. load the cart, slot by slot
			local CurrentItem = 1
			for i = 1, CartSlots do
				local ItemId = Profits[CurrentItem][1]
				local Error, ItemTransfered = Transfer("","",INVENTORY_STD,"MyHome",INVENTORY_STD, ItemId, CartSlotSize)
				-- 6. make sure list is repeated if slots are still available
				CurrentItem = math.mod(CurrentItem, ProfitCount) + 1 
			end 
			
			-- 7. go to the market
			-- get market building
			if CityGetRandomBuilding("MyCity", -1, GL_BUILDING_TYPE_MARKET, -1, -1, FILTER_IGNORE, "MarketBld") then
				f_MoveTo("","MarketBld", GL_MOVESPEED_RUN)
			end
			Sleep(1)
			cart_UnloadAll("", "MarketBld")
		end
		Sleep(2)
		-- return home if necessary
		if not IsInLoadingRange() and not f_MoveTo("","HomePos", GL_MOVESPEED_RUN) then
			-- cannot get gome, something went wrong
			StopMeasure() 
		end
		Sleep(180)
	end
end

function SortProfits(a,b) 
	return a[2] > b[2] 
end

function CleanUp()
end