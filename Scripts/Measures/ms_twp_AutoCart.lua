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
	if not IsInLoadingRange("", "MyHome") and not f_MoveTo("","HomePos", GL_MOVESPEED_RUN) then
		-- cannot get gome, something went wrong
		StopMeasure() 
	end
	local CartSlots, CartSlotSize = cart_GetCartSlotInfo("")
	
	-- necessary in combination with AI management: unload at home and fill with dummy items
	for i = 1, CartSlots do
		local ItemId, ItemCount = InventoryGetSlotInfo("", CartSlots-i)
		if ItemId and ItemCount > 0 then
			if CanAddItems("MyHome", ItemId, ItemCount, INVENTORY_STD) then				
				Transfer("","MyHome",INVENTORY_STD,"",INVENTORY_STD, ItemId, ItemCount)
			else
				Transfer("","MyHome",INVENTORY_SELL,"",INVENTORY_STD, ItemId, ItemCount)
			end
		end 
	end
	AddItems("", "DummyItem", CartSlots*CartSlotSize, INVENTORY_STD) 
		
	while true do 
		
		-- 3. Calculate expected profit for each item
		CityGetLocalMarket("MyCity","MyMarket")
		local ProfitCount, Profits = ms_twp_autocart_CalcProfits("MyMarket", "MyHome")
		local CityAlias = "MyCity"
		if ProfitCount <= 0 then
			ProfitCount, Profits, CityAlias = ms_twp_autocart_CalcProfitsOutside("MyHome")
		end 
		
		if ProfitCount > 0 then
			-- 5. load the cart, slot by slot
			local CurrentItem = 1
			for i = 1, CartSlots do
				RemoveItems("", "DummyItem", CartSlotSize, INVENTORY_STD)
				local ItemId = Profits[CurrentItem][1]
				local Error, ItemTransfered = Transfer("","",INVENTORY_STD,"MyHome",INVENTORY_STD, ItemId, CartSlotSize)
				-- 6. make sure list is repeated if slots are still available
				CurrentItem = math.mod(CurrentItem, ProfitCount) + 1 
			end 
			
			-- 7. go to the market
			-- get market building
			if CityGetRandomBuilding(CityAlias, -1, GL_BUILDING_TYPE_MARKET, -1, -1, FILTER_IGNORE, "MarketBld") then
				f_MoveTo("","MarketBld", GL_MOVESPEED_RUN)
			end
			Sleep(1)
			RemoveItems("", "DummyItem", CartSlots*CartSlotSize, INVENTORY_STD)
			cart_UnloadAll("", "MarketBld", true)
			AddItems("", "DummyItem", CartSlots*CartSlotSize, INVENTORY_STD)			
			Sleep(2)
			-- return home if necessary
			if not IsInLoadingRange("", "MyHome") and not f_MoveTo("","HomePos", GL_MOVESPEED_RUN) then
				-- cannot get gome, something went wrong
				--StopMeasure() 
			end
		end
		Sleep(180) 
	end
end

function CalcProfits(MarketAlias, HomeAlias)
	local Profits = {} -- table of ItemId -> Profit
	local ProfitCount = 0

	local Count, Items = economy_GetItemsForSale(HomeAlias)
	for i = 1, Count do
		-- TODO optimize this, so that we don't iterate over the whole inventory for each item
		local Amount = bld_GetItemCount(HomeAlias, Items[i])
		local Profit = Amount *	ItemGetPriceSell(Items[i], MarketAlias) 
		if Amount > 0 and Profit > 500 then
			ProfitCount = ProfitCount + 1
			Profits[ProfitCount] = {Items[i], Profit}
		end
	end
 
 	if ProfitCount == 0 then
 		return 0, {}
 	end
 	
	-- 4. sort by expected profit, highest first
	Profits = helpfuncs_QuickSort(Profits, 1, ProfitCount, ms_twp_autocart_SortProfits)
	return ProfitCount, Profits 
end


--- returns ProfitCount, Profits, CityAlias
function CalcProfitsOutside(HomeAlias)
	local Count = ScenarioGetObjects("Settlement", 20, "City")
	
	local ProfitCount, Profits, CityAlias
	for l=0,Count-1 do
		CityAlias = "City"..l
		if CityIsKontor(CityAlias) then
			if CityGetRandomBuilding(CityAlias, -1, GL_BUILDING_TYPE_KONTOR, -1, -1, FILTER_IGNORE, "SomeMarketBld") and not BuildingGetWaterPos("SomeMarketBld", true, "WaterPos") then
				CityGetLocalMarket(CityAlias, "Market"..l)
				ProfitCount, Profits = ms_twp_autocart_CalcProfits("Market"..l, HomeAlias)
				if ProfitCount > 0 then 
					return ProfitCount, Profits, CityAlias
				end
			end
		else -- regular settlement
			CityGetLocalMarket(CityAlias, "Market"..l)
			ProfitCount, Profits = ms_twp_autocart_CalcProfits("Market"..l, HomeAlias)
			if ProfitCount > 0 then 
				return ProfitCount, Profits, CityAlias
			end
		end
	end
	
	return 0, {}, "MyCity"
end

function SortProfits(a,b) 
	return a[2] > b[2] 
end

function CleanUp()
	local CartSlots, CartSlotSize = cart_GetCartSlotInfo("")
	RemoveItems("", "DummyItem", CartSlots*CartSlotSize, INVENTORY_STD)
	if DynastyIsAI("") then
		CreateScriptcall("RestartAutoCartMeasure", 0.25, "Measures/ms_twp_AutoCart.lua", "RestartMeasure", "")
	end 
end

function RestartMeasure(CartAlias)
	MeasureRun(CartAlias, CartAlias, "AutoCart", true)
end