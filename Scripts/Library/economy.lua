-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

PREFIX_SALESCOUNTER = "Salescounter_"
PREFIX_SALESCOUNTER_MAX = "SalescounterMax_"

---- returns count and the list of items (by itemId) that can be sold at this workshop. See BuildingToItems.dbt
function GetItemsForSale(BldAlias)
	local BldId = BuildingGetProto(BldAlias)
	local ItemsString
	if GL_BUILDING_TYPE_WAREHOUSE == BuildingGetType(BldAlias) then
		-- Warehouse may offer anything, check current offer 
		ItemsString = GetProperty(BldAlias, "SalesCounterItems")
	else
		-- production buildings may only offer their own products
		ItemsString = GetDatabaseValue("BuildingToItems", BldId, "produceditems")
	end
	if ItemsString == nil then
		return 0, {}
	end
	local Items = {}
	local Count = 0
	for Id in string.gfind(ItemsString, "%d+") do
		Count = Count + 1
		Items[Count] = ItemGetID(Id)
	end
	return Count, Items
end

-- Count and Items should be taken from above function GetItemsForSale
function UpdateSalescounter(BldAlias, Count, Items)
	if not Items then
		Count, Items = GetItemsForSale(BldAlias)
	end

	local Id, CurrentAmount, Max, Inv, Diff, Transfered
	for i=1, Count do
		Id = ItemGetID(Items[i])
		Max = GetProperty(BldAlias, PREFIX_SALESCOUNTER_MAX..Id)
		if Max == nil then
			Max = 0
		end		
		CurrentAmount = GetProperty(BldAlias, PREFIX_SALESCOUNTER..Id)
		if CurrentAmount == nil then
			CurrentAmount = 0
		end
		Diff = Max - CurrentAmount
		if Diff > 0 then
			-- transfer to sales counter
			Transfered = RemoveItems(BldAlias, Id, Diff)
			SetProperty(BldAlias, PREFIX_SALESCOUNTER..Id, CurrentAmount + Transfered)
		elseif Diff < 0 and CanAddItems(BldAlias, Id, math.abs(Diff)) then
			-- transfer from counter to production
			AddItems(BldAlias, Id, math.abs(Diff))
			SetProperty(BldAlias, PREFIX_SALESCOUNTER..Id, Max)
		end
	end
end

--- Sales ranking is based on availability, charisma and craftmanship
-- It's currently not based on pricing since that depends on Bargaining
function CalculateSalesRanking(BldAlias, Count, Items)
	-- only applicable for owned shops 
	if not BuildingGetOwner(BldAlias, "Boss") then
		return 0
	end
	
	if not Items then
		Count, Items = economy_GetItemsForSale(BldAlias)
	end
	-- no pricing for now. If it existed, it would be around {75, 100, 125}
	-- local Pricing = GetProperty(BldAlias, "SalescounterPrice")

	local Ranking = 0
	-- availablity of goods is based on a default of six slots
	local AvailableGoods = 0
	local Tmp
	for i=1, Count do
		Tmp = GetProperty(BldAlias, PREFIX_SALESCOUNTER..Items[i])
		if Tmp ~= nil and Tmp > 0 then
			AvailableGoods = AvailableGoods + 1
		end
	end
	-- 5 points for each available item
	AvailableGoods = math.min(8, AvailableGoods)
	local RankingGoods = AvailableGoods * 4		
	
	-- use craftmanship or secret knowledge, depending on class 
	local Crafty
	if SimGetClass("Boss") == GL_CLASS_SCHOLAR then
		Crafty = GetSkillValue("Boss", SECRET_KNOWLEDGE)
	else
		Crafty = GetSkillValue("Boss", CRAFTSMANSHIP)
	end 
	local RankingCrafty = (math.min(12, Crafty) * 4) 
	
	local Charisma = GetSkillValue("Boss", CHARISMA)
	local RankingCharisma = (math.min(12, Charisma) * 4) 
	
	local Ranking = RankingGoods + RankingCrafty + RankingCharisma

	local Attractivity = GetImpactValue(BldAlias,"Attractivity")
	if Attractivity then
		Ranking = Ranking + Ranking * Attractivity
	end
	SetProperty(BldAlias, "SalescounterRanking", Ranking)
	return Ranking, RankingGoods, RankingCrafty, RankingCharisma, Attractivity
end

function GetRandomBuildingByRanking(CityAlias, ResultAlias, Ranking, Type)
	Ranking = Ranking or 0
	Type = Type or -1
	local Count = CityGetBuildings(CityAlias, GL_BUILDING_CLASS_WORKSHOP, Type, -1, -1, FILTER_HAS_DYNASTY, "Result")
	
	-- calculated weighted choice
	local Ranking
	local RankingSum = 0
	for i = 0, Count-1 do
		if AliasExists("Result"..i) then
			Ranking = GetProperty("Result"..i, "SalescounterRanking")
			if Ranking then
				RankingSum = RankingSum + Ranking 
			end
		end
	end

	local Choice = Rand(RankingSum) + 1
	for i = 0, Count-1 do
		if AliasExists("Result"..i) then
			Ranking = GetProperty("Result"..i, "SalescounterRanking")
			if Ranking then
				Choice = Choice - Ranking 
			end
			if Choice <= 0 then
				CopyAlias("Result"..i, ResultAlias)
				return true
			end
		end
	end
	return false
end

FILTER_BY_ITEM = "__F((Object.GetObjectsByRadius(Building)==%d)AND(Object.IsClass(2))AND(Object.Property.Salescounter_%d >= %d))"
function GetRandomBuildingByOfferedItem(ForAlias, ResultAlias, ItemId, Amount)
	Amount = Amount or 0
	local Radius = 15000
	local FilterByItem = string.format(FILTER_BY_ITEM, Radius, ItemId, Amount)
	local Count = Find(ForAlias, FilterByItem, "Result", 10)
	if Count > 0 then
		local x = Rand(Count)
		CopyAlias("Result"..x, ResultAlias)
		return GetProperty("Result"..x, PREFIX_SALESCOUNTER..ItemId)
	end
	return 0
end

--- Buy some random items from the workshop
-- returns ItemId, ItemCount, TotalPrice
-- TotalPrice will be below the given Budget
-- Count and Items are optional. Provide them if you've already got them
function BuyRandomItems(BldAlias, BuyerAlias, Budget, Max, Count, Items, IgnoreMoney)
	-- initialize optional Count, Items
	if not Count or not Items then
		Count, Items = economy_GetItemsForSale(BldAlias)
	end
	IgnoreMoney = IgnoreMoney or (not IsDynastySim(BuyerAlias))
	
	local ItemId, Available, ItemPrice, ItemCount
	for i=1, Count do
		ItemId = Items[Rand(Count) + 1]
		Available = GetProperty(BldAlias, PREFIX_SALESCOUNTER..ItemId)
		if Available and Available > 0 then
			local MaxCount = math.min(Max, economy_ProtectSaleItems(BldAlias, ItemId, Available))
			if MaxCount > 0 then
				ItemPrice = economy_GetPrice(BldAlias, ItemId, BuyerAlias)
				ItemCount = math.min(Rand(MaxCount)+1, math.floor(Budget / ItemPrice))
				if ItemCount > 0 then
					SetProperty(BldAlias, PREFIX_SALESCOUNTER..ItemId, Available - ItemCount)
					local TotalPrice = ItemCount * ItemPrice 
					CreditMoney(BldAlias, TotalPrice, "WaresSold")
					ShowOverheadSymbol(BldAlias, false, false, 0, "@L%1t",TotalPrice)
					economy_UpdateBalance(BldAlias, "Salescounter", TotalPrice, ItemId)
					if not IgnoreMoney then
						SpendMoney(BuyerAlias, TotalPrice, "WaresBought")
					end
					return ItemId, ItemCount, TotalPrice
				end
			end
		end
	end
	return nil, 0, 0
end

--- Protects some items from outsales that are required for a building to function (Hospital)
PROTECTED_SALE_ITEMS = ".201.202.203.204."
function ProtectSaleItems(BldAlias, ItemId, Available)
	if BuildingGetType(BldAlias) == GL_BUILDING_TYPE_HOSPITAL then
		if string.find(PROTECTED_SALE_ITEMS, "."..ItemId..".", 1, true) then
			-- don't sell more than half the maximum stock
			local MaxStock = GetProperty(BldAlias, PREFIX_SALESCOUNTER_MAX..ItemId) or 0
			local Diff = Available - MaxStock/2 -- Item count above half stock
			return math.max(0, Diff) -- return 0 if negative Diff
		end
	end
	-- no restriction, return all available items
	return Available
end

--- Buy some items from this workshop
-- Userful for inter-workshop trade
-- returns ItemCount, TotalPrice
function BuyItems(BldAlias, BuyerAlias, ItemId, DesiredAmount)
	local Available = GetProperty(BldAlias, PREFIX_SALESCOUNTER..ItemId)
	if Available and Available > 0 then
		local ItemPrice = economy_GetPrice(BldAlias, ItemId, BuyerAlias)
		local ItemCount = math.min(Available, DesiredAmount)
		SetProperty(BldAlias, PREFIX_SALESCOUNTER..ItemId, Available - ItemCount)
		local TotalPrice = ItemCount * ItemPrice
		CreditMoney(BldAlias, TotalPrice, "WaresSold")
		ShowOverheadSymbol(BldAlias, false, false, 0, "@L%1t",TotalPrice)
		economy_UpdateBalance(BldAlias, "Salescounter", TotalPrice, ItemId)
		SpendMoney(BuyerAlias, TotalPrice, "WaresBought")
		return ItemCount, TotalPrice
	end
	return 0, 0
end

--- calculates current price for offered item
-- Price is based on current market price and depends on Bargaining of Owner and Buyer 
function GetPrice(BldAlias, ItemId, Buyer)
	if not GetSettlement(BldAlias, "MyCity") then
		return -1
	end
	if not BuildingGetOwner(BldAlias, "BldOwner") then
		return -1
	end

	-- get market price
	CityGetLocalMarket("MyCity","MyMarket")
	local BasePrice = ItemGetPriceSell(ItemId, "MyMarket")
	
	-- get difference in bargaining between Owner and Buyer
	local BargOwner = GetSkillValue("BldOwner", BARGAINING)
	local TheBargain
	if Buyer and AliasExists(Buyer) then
		local BargBuyer = GetSkillValue(Buyer, BARGAINING)
		TheBargain = (BargOwner - BargBuyer) * 0.02
	else
		TheBargain = BargOwner * 0.02
	end
	
	-- this will result in a range of about 70..110% of the market price
	return (BasePrice * 0.9) + (BasePrice * TheBargain) 
end

function UpdateBalance(BldAlias, BalanceSuffix, TotalPrice, ItemId, Amount)
	local Current = GetProperty(BldAlias, "Balance"..BalanceSuffix) or 0
	SetProperty(BldAlias, "Balance"..BalanceSuffix, Current + TotalPrice)
	-- logging
	--MsgBoxNoWait(BldAlias, BldAlias, "Balance updated", "The balance for "..BalanceSuffix.." was updated, difference is "..TotalPrice)
	
	-- TODO update balance for each item the workshop sells
	-- these specific balances could then be shown after clicking an item in sales counter management
end


--- "Enable", 
-- "BuySell", 
-- "BuySell_Selection", 
-- "BuySell_Radius", 
-- "BuySell_Stock", 
-- "BuySell_PriceLevel", 
-- "BuySell_SellStock", 
-- "BuySell_Carts", 
-- "Workers", 
-- "Workers_Quality", 
-- "Workers_Favor", 
-- "Budget", 
-- "Budget_Repair", 
-- "Budget_Upgrades"
function LogAISettings(BldAlias)
	LogMessage("::TOM:: Logging AI Settings")
	local SettingTable = { "Enable", "Produce", "Produce_Selection", "Produce_Stock", "BuySell", "BuySell_Radius", "BuySell_PriceLevel", "BuySell_SellStock", "BuySell_Carts", "Workers", "Workers_Quality", "Workers_Favor", "Budget", "Budget_Repair", "Budget_Upgrades" }
	local Setting
	for i = 1, 15 do
		Setting = SettingTable[i]
		LogMessage(Setting.." = "..BuildingGetAISetting(BldAlias, Setting))
	end
end

--- Salescounter for AI will default to 
function InitializeDefaultSalescounter(BldAlias, Count, Items)
	if not GetSettlement(BldAlias, "MyCity") then
		return -1
	end
	if not BuildingGetOwner(BldAlias, "BldOwner") then
		return -1
	end

	-- get market
	CityGetLocalMarket("MyCity","MyMarket")

	-- initialize optional Count, Items
	if not (Count and Items) then
		Count, Items = economy_GetItemsForSale(BldAlias)
	end

	local Budget = BuildingGetLevel(BldAlias) * 1000
	local ItemId, MarketPrice, Max
	for i=1, Count do
		ItemId = ItemGetID(Items[i])
		MarketPrice = ItemGetPriceSell(ItemId, "MyMarket")
		if ItemId and ItemId > 0 and MarketPrice and MarketPrice > 0 then
			Max = math.floor(Budget / MarketPrice)
			SetProperty(BldAlias, PREFIX_SALESCOUNTER_MAX..ItemId, Max)
		end 
	end
end

function CalculateWages(BldAlias)
	-- wages
	local numFound = 0
	local Alias
	local count = BuildingGetWorkerCount(BldAlias)

	for number=0, count-1 do
		Alias = "Worker"..numFound
		if BuildingGetWorker(BldAlias, number, Alias) then
			numFound = numFound + 1
		end
	end
	local Wages = 0
	if numFound > 0 then
		for i=0, numFound-1 do
			Alias = "Worker"..i
			Wages = Wages + SimGetWage(Alias, BldAlias)
		end
	end
	return Wages
end

function ChooseItemFromCounter(BldAlias, Count, Items)
	LogMessage("TOM::economy::ChooseItemFromCounter starting")
	-- initialize optional Count, Items
	if not Count or not Items then
		Count, Items = economy_GetItemsForSale(BldAlias)
	end
	
	local Buttons = ""
	local CurrentAmount, MaxAmount, Id, ItemTexture, ItemLabel, Subtext
	for i=1, Count do
		Id = ItemGetID(Items[i])
		-- Appending the itemID finding the items again and even enables filters on the property
		CurrentAmount = GetProperty(BldAlias, PREFIX_SALESCOUNTER..Id) or 0
		MaxAmount = GetProperty(BldAlias, PREFIX_SALESCOUNTER_MAX..Id) or 0
		ItemTexture = "Hud/Items/Item_"..ItemGetName(Items[i])..".tga"
		-- result, Tooltip, label, icon
		ItemLabel = ItemGetLabel(Items[i], CurrentAmount == 1)
		Subtext = CurrentAmount .. "/" .. MaxAmount
		Buttons = Buttons.."@B[" .. Id .. "," .. Subtext .. "," .. ItemLabel .. "," .. ItemTexture .."]"
	end
	-- add extra button if warehouse and Count < 16
	--hud/buttons/btn_220_Train.tga
	if GL_BUILDING_TYPE_WAREHOUSE == BuildingGetType(BldAlias) and Count < 16 then
		Buttons = Buttons.."@B[" .. -1 .. ",,,hud/buttons/btn_220_Train.tga]"
	end
	local ChosenItemId = InitData(
		"@P"..Buttons, -- PanelParam
		0, -- AIFunc
		"@L_MEASURE_SALESCOUNTER_HEAD_+0",-- HeaderLabel
		"Body"-- BodyLabel (obsolete)
		)-- optional variable list
	
	if ChosenItemId == "C" then
		return nil, 0
	end
	local Amount = GetProperty(BldAlias, PREFIX_SALESCOUNTER..ChosenItemId) or 0
	return ChosenItemId, Amount
end

---
-- returns ItemId, AvailableAmount
function ChooseItemFromInventory(BldAlias, PlayerAlias)
	LogMessage("TOM::economy::ChooseItemFromInventory starting")
	-- not my own building and not market, use sales counter
	if GetDynastyID(PlayerAlias) ~= GetDynastyID(BldAlias) and BuildingGetClass(BldAlias) ~= GL_BUILDING_CLASS_MARKET then
		return economy_ChooseItemFromCounter(BldAlias)
	end
	
	local zSlots = InventoryGetSlotCount(BldAlias,INVENTORY_STD)
	-- market with too many slots, use Market function with pre-selected category
	if BuildingGetClass(BldAlias) == GL_BUILDING_CLASS_MARKET and zSlots > 20 then 
		return economy_ChooseItemFromMarket(BldAlias, PlayerAlias)
	end
	
	local itemInfo = {}	
	local schalter = ""
	local ItemLabel, ItemTexture, itemNam, itemMen, itemID, itemSchalt
	local itemTypeCount = 1

	-- initialize item information for every slot
	for slotNr = 0,zSlots-1 do
		itemID, itemMen = InventoryGetSlotInfo(BldAlias,slotNr,INVENTORY_STD)
		if itemMen and itemMen >= 0 and not economy_ContainsItemType(itemInfo, itemTypeCount, itemID) then
			ItemTexture = "Hud/Items/Item_"..ItemGetName(itemID)..".tga"
			-- result, Tooltip, label, icon
			ItemLabel = ItemGetLabel(itemID, itemMen == 1)
			schalter = schalter.."@B[" .. itemID .. "," .. itemMen .. "," .. ItemLabel .. "," .. ItemTexture .."]"

			itemInfo[itemTypeCount] = itemID
			itemTypeCount = itemTypeCount + 1
		end
	end
	
	local ItemId = InitData(
		"@P"..schalter, -- PanelParam
		0, -- AIFunc
		"@L_AUTOROUTE_TYPESELECT_HEAD_+0",-- HeaderLabel
		"Body"-- BodyLabel (obsolete)
		)-- optional variable list
	
	if ItemId and ItemId ~= "C" then
		return ItemId, GetItemCount(BldAlias, ItemId)
	end
	return nil, 0
end

---
-- returns ItemId, AvailableAmount
function ChooseItemFromMarket(BldAlias, PlayerAlias)
	local katWahl
	local itemInfo = {}	
	local schalter = ""
	local itemNam, itemKat, itemMen, itemID, itemSchalt
	local zSlots = InventoryGetSlotCount(BldAlias,INVENTORY_STD)

	repeat 	
		local itemTypeCount = 1
		katWahl = economy_SelectCategoryFromMarket(BldAlias, PlayerAlias)
		if katWahl == 0 then
			return nil, 0
		end
		-- bugfix: when repeating, reinitialize item list
		itemInfo = {}	
		schalter = ""
		-- initialize item information for every slot
		for slotNr = 0,zSlots-1 do
			itemID, itemMen = InventoryGetSlotInfo(BldAlias,slotNr,INVENTORY_STD)
			if itemMen and itemMen >= 0 then
				if(not economy_ContainsItemType(itemInfo, itemTypeCount, itemID)) then
					itemKat = ItemGetCategory(itemID)
					if itemKat == katWahl then
						itemNam = ItemGetLabel(itemID,true)
						itemSchalt = "@B["..itemID..",@L"..itemNam..",]"
						itemInfo[itemTypeCount] = itemID
						schalter = schalter..itemSchalt
						itemTypeCount = itemTypeCount + 1
					end
				end
			end
		end
		
		local ItemId = MsgBox(PlayerAlias,BldAlias,"@P"..schalter,"@L_AUTOROUTE_TYPESELECT_HEAD_+0","@L_AUTOROUTE_TYPESELECT_BODY_+0", GetID(BldAlias))
		if ItemId and ItemId ~= "C" then
			return ItemId, GetItemCount(BldAlias, ItemId)
		end
	until (ItemId and ItemId ~= "C")
end

---- itemInfo is an array wth IDs
function ContainsItemType(itemInfo, length, itemID)
	for i = 1, length - 1 do
		if itemInfo[i] == itemID then
			return true
		end
	end
	return false
end

function SelectCategoryFromMarket(BldAlias, PlayerAlias)
	local katSchalter = ""
	katSchalter = katSchalter.."@B[1,@L_BUILDING_Market_Ressource_NAME_+0,]"
	katSchalter = katSchalter.."@B[2,@L_BUILDING_Market_Food_NAME_+0,]"
	katSchalter = katSchalter.."@B[3,@L_BUILDING_Market_Smithy_NAME_+0,]"
	katSchalter = katSchalter.."@B[4,@L_BUILDING_Market_Textile_NAME_+0,]"
	katSchalter = katSchalter.."@B[5,@L_BUILDING_Market_Alchemist_NAME_+0,]"
	katSchalter = katSchalter.."@B[6,@L_BUILDING_Market_NewMarket_NAME_+0,]"
	katSchalter = katSchalter.."@B[C,@LBack_+0,]"
	local katWahl = MsgBox(PlayerAlias,BldAlias,"@P"..katSchalter,"@L_AUTOROUTE_CATEGORY_HEAD_+0","")
	if katWahl ~= "C" then
		return katWahl
	end
	return 0
end

function BuyDrinkOrFood(Tavern, SimAlias, Budget, MaxItems)
	-- ItemIDs for: Grainpap, SmallBeer, Stew , WheatBeer, SalmonFilet, RoastBeef, Wine
	local Items = {30, 31, 32, 34, 35, 37, 38}
	local Count = 7
	return economy_BuyRandomItems(Tavern, SimAlias, Budget, MaxItems, Count, Items)
end
