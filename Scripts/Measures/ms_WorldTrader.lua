---
-- Findings about this script:
-- The trader will only buy at counting houses.
-- The trader will only sell at markets. 
-- The choice of items they will transport is quite limited and includes only resources.
-- I guess the script was supposed to ensure availability of base resources in all towns. That didn't quite work though in my experience.
-- DONE:
-- Make the traders browse the town shops for offers in sales counter.
-- TODO:
-- Split into carts and ships to increase readability. Extract functions where necessary.
-- Rethink the syntax of used properties as they seem somewhat crude. ("Source"..Type..Index..? = 1?)
-- Enable the traders on maps without counting houses.
-- Enable trade between towns.
-- Possibly increase the number of traders. 



function Run()	
	GetScenario("scenario")
	local Type
	if not HasProperty("scenario", "static") then
		local CartType = CartGetType("")
	
		if CartType == EN_CT_MERCHANTMAN_BIG or CartType == EN_CT_MERCHANTMAN_SMALL then
			Type = 0 -- Free tradership
		else
			Type = 1 -- Free trader cart
		end
		SetData("TraderType", Type)	
		
		if not ms_worldtrader_SetupFreeTrader() then
			return
		end
		
		while true do
			RemoveData("Source")
			
			-- source is always a counting house
			ms_worldtrader_GotoSource()
			-- TODO sell anything left in Inventory
			-- target is selected and will always be a settlement
			--LogMessage("::TOM::Worldtrader::Run Setting the target")
			ms_worldtrader_SetTarget()
			-- this will buy some items at counting house to trade with target
			--LogMessage("::TOM::Worldtrader::Run Buying items at counting house.")
			ms_worldtrader_BuyThreeMostNeededGoods()
			
			-- move to settlement
			--LogMessage("::TOM::Worldtrader::GoToSource Returning to settlement.")
			ms_worldtrader_GotoTarget()
			-- sell items
			--LogMessage("::TOM::Worldtrader::GoToSource Selling goods.")
			ms_worldtrader_SellGoods()
			
			-- look for some random shops and buy something
			--LogMessage("::TOM::Worldtrader::Run Let's do some local shopping.")
			if Type == 1 then
				local Slots = 2
				if CartType == EN_CT_HORSE or CartType == EN_CT_OX then
					Slots = 3
				end
				for WorkshopClass = 1, Slots do
					ms_worldtrader_BuyRandomGoods(WorkshopClass)
				end
			end
		end
	end
end

function SetupFreeTrader()
	local Type = GetData("TraderType")
	local Count = ScenarioGetObjects("Settlement", 20, "City")
	if Count==0 then
		return false
	end
	
	local LandSourceCount = 0
	local WaterSourceCount = 0
	local LandTargetCount = 0
	local WaterTargetCount = 0
	
	local Alias
	for l=0,Count-1 do
		Alias = "City"..l
		if CityIsKontor(Alias) then
			if CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_KONTOR, -1, -1, FILTER_IGNORE, "Source1"..LandSourceCount) and not BuildingGetWaterPos("Source1"..LandSourceCount, true, "WaterPos") then
				SetData("Source1"..LandSourceCount..INVENTORY_SELL,1)
				LandSourceCount = LandSourceCount + 1
			elseif CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_KONTOR, -1, -1, FILTER_IGNORE, "Source0"..WaterSourceCount) and BuildingGetWaterPos("Source0"..WaterSourceCount, true, "WaterPos") then
				SetData("Source0"..WaterSourceCount..INVENTORY_SELL,1)
				WaterSourceCount = WaterSourceCount + 1
			end
		else
			if CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_MARKET, -1, -1, FILTER_IGNORE, "Target1"..LandTargetCount) then
				LandTargetCount = LandTargetCount + 1
			end
			if CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_HARBOR, -1, -1, FILTER_IGNORE, "Target0"..WaterTargetCount) then
				WaterTargetCount = WaterTargetCount + 1
			end
		end
	end
	
	if Type == 1 and (LandTargetCount==0 or LandSourceCount==0) then
		return false
	end
	
	if Type == 0 and (WaterTargetCount==0 or WaterSourceCount==0) then
		return false
	end
	
	if Type == 0 then
		SetData("SourceCount", WaterSourceCount)
		SetData("TargetCount", WaterTargetCount)
	else
		SetData("SourceCount", LandSourceCount)
		SetData("TargetCount", LandTargetCount)	
	end
	
	return true
end

function SetTarget()
	local Type = GetData("TraderType")
	local TargetCount = GetData("TargetCount")
	local CurrentTarget = GetData("Target")
	local NewTarget = "Target"..Type..Rand(TargetCount)
	
	while CurrentTarget == NewTarget and TargetCount > 1 do
		NewTarget = "Target"..Type..Rand(TargetCount)
		Sleep(1)
	end
	
	SetData("Target", NewTarget)
end

function GotoTarget()
	local Target = GetData("Target")
	local AltTarget = GetData("Source")
	
	while not (GetImpactValue(AltTarget, "TradingRoutePlundered") == 0) do
		Sleep(10)
	end

	
	if not f_MoveTo("", Target, GL_MOVESPEED_RUN) then
		return false
	end

	return true
end

function GotoSource()
	-- get random kontor and go back
	-- target: the city the cart comes from
	local Type = GetData("TraderType")
	local SourceCount = GetData("SourceCount")
	if not SourceCount then
		return false
	end
	
	local Source = "Source"..Type..Rand(SourceCount)
	local AltTarget = GetData("Target")

	SetData("Source", Source)

	if not f_MoveTo("", Source, GL_MOVESPEED_RUN) then
		return false
	end
	
	-- remove current items
	for Slot = 0, 2 do
		--LogMessage("::TOM::Worldtrader::GoToSource Selling goods.")
		local ItemId, ItemCount = InventoryGetSlotInfo("", Slot)
		if ItemId and ItemId > 0 and ItemCount > 0 then
			RemoveItems("", ItemId, ItemCount)		
		end
	end

	return true
end

function BuyThreeMostNeededGoods()
	local Target = GetData("Target")
	local Level = CityGetLevel(Target)
	-- TODO check selection
	local Resources = {
		"Charcoal", 
		"Wool", 
		"Herring", 
		"Salmon", 
		"Iron", 
		"Silver", 
		"Gold",
		"Salt",
		"WheatFlour",
		"Oakwood", 
		"Pinewood", 
		"Leather", 
		"Honey", 
		"Fruit",
		"Fungi",
		"Pech"
		}

	local ResourceCount = 16
	local MostNeededItems = {1,0,0}
	local MostNeededValues = {0, 0, 0}
	local Buystring = ""
	local BoughtSomething = false
	
	-- randomize the start so all resources get bought
	local Start = Rand(ResourceCount)+1
	
	MostNeededValues[1] = ms_worldtrader_CheckItem(Level, "Pinewood", 1, 5)
	local End = ResourceCount+Start
	for i=Start,End do
		local Index = math.mod(i,ResourceCount)+1
		local ItemValue = ms_worldtrader_CheckItem(Level, Resources[Index], 1, 5)
		if ItemValue > MostNeededValues[1] then 
			MostNeededItems[3] = MostNeededItems[2]
			MostNeededItems[2] = MostNeededItems[1]
			MostNeededItems[1] = Index
			MostNeededValues[3] = MostNeededValues[2]
			MostNeededValues[2] = MostNeededValues[1]
			MostNeededValues[1] = ItemValue
			BoughtSomething = true
		elseif ItemValue > MostNeededValues[2] then
			MostNeededItems[3] = MostNeededItems[2]
			MostNeededItems[2] = Index
			MostNeededValues[3] = MostNeededValues[2]
			MostNeededValues[2] = ItemValue
		elseif ItemValue > MostNeededValues[3] then
			MostNeededItems[3] = Index
			MostNeededValues[3] = ItemValue
		end
	end
	
	for j=1,3 do
		if MostNeededItems[j] ~= 0 then
		
			local index = MostNeededItems[j]
			AddItems("", Resources[index] , MostNeededValues[j], INVENTORY_STD)
		end
	end
	return BoughtSomething
end

function CheckItem(CityLevel, Item, MinCount, MaxCount)
	local Wanted = (MaxCount*CityLevel)
	
	local Count = GetItemCount(GetData("Target"), Item, INVENTORY_STD)
	if Count < Wanted then
		return (Wanted - Count)
	end
	
	return 0
end

function SellGoods()
	Sleep(1)

	local Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local ItemId
	local ItemCount
	local Target = GetData("Target")
	
	for Number = Slots-1, 0, -1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemCount then
			--Transfer("", Target, INVENTORY_STD, "", INVENTORY_STD, ItemId, ItemCount)
			AddItems(Target, ItemId, (2*ItemCount), INVENTORY_STD)
			RemoveItems("", ItemId, ItemCount, INVENTORY_STD)
			local ItemName = GetDatabaseValue("Items", ItemId, "name")
		end
	end
	Sleep(1)
end

--CLASS_TO_BUILDINGTYPE = {
--	{}, -- Patron 
--	{}, -- Artisan
--	{}  -- Scholar
--}
function BuyRandomGoods(WorkshopClass)
	--LogMessage("::TOM::Worldtrader::BuyRandomGoods Starting...")
	local Target = GetData("Target")
	
	if not GetSettlement(Target, "City") then
		--LogMessage("::TOM::Worldtrader::BuyRandomGoods Target does not belong to a settlement: "..Target)
		return
	end
	--LogMessage("::TOM::Worldtrader::BuyRandomGoods Looking for a workshop.")
	-- only visit shops with good ranking
	economy_GetRandomBuildingByRanking("City", "RandomWorkshop", 50)
	if not AliasExists("RandomWorkshop") then
		return
	end
	f_MoveTo("", "RandomWorkshop", GL_MOVESPEED_RUN)
	
	-- only fill one slot
	local MaxItems
	if CartGetType("") == EN_CT_OX then
		MaxItems = 40
	else
		MaxItems = 20
	end 
	local Budget = CityGetLevel("City") * (500 + Rand(1000))
	--LogMessage("::TOM::Worldtrader::BuyRandomGoods I'll buy items up to my budget of "..Budget)
	local ItemId, ItemCount, TotalPrice = economy_BuyRandomItems("RandomWorkshop", "", Budget, MaxItems)
	if ItemId and ItemId > 0 then
		--LogMessage("::TOM::Worldtrader::BuyRandomGoods I bought these items: "..ItemCount.." of "..ItemGetName(ItemId))
		AddItems("", ItemId, ItemCount)
		if ItemCount >= 10 or TotalPrice >= 500 then
			-- display message for good sales
			MsgNewsNoWait("RandomWorkshop", --target 
				"RandomWorkshop", -- jump to 
				"", -- panel (buttons)
				"building", -- message class
				-1, -- no timeout
				"@L_TOM_WORLDTRADER_HEAD_+0", 
				"@L_TOM_WORLDTRADER_BODY_+0",
				--20206    "_TOM_WORLDTRADER_BODY_+0"   "Ein Händler hat soeben %1GG besucht und die beachtliche Menge von %2i %3l aus Eurem Verkaufslager gekauft!$N$N Ihr habt durch diesen Verkauf %4t erhalten!"   |
				GetID("RandomWorkshop"), ItemCount, ItemGetLabel(ItemId, (ItemCount == 1)), TotalPrice
				) -- variable list
		end
	end	
end

function CleanUp()
end

