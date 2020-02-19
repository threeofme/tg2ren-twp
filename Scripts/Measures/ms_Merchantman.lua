function Run()
	-- LogMessage("::TOM::Merchantman:2 Measure ms_Merchantman started.")
	GetScenario("scenario")
	if not HasProperty("scenario", "static") then
		local	Type = -1
		
		if not GetHomeBuilding("", "Home") then
			Type = 0	-- Free trader
		elseif GetDynasty("", "Dynasty") then
			Type = 1	-- dynasty trader
		elseif HasProperty("","CityShip") then
			Type = 0	-- Free trader (Harbour/Kontor)
		end
		
		if Type==-1 then
			return
		end
		
		local	Success = false
		
		if Type==0 then
			Success = ms_merchantman_SetupFreeTrader()
		elseif Type==1 then
			Success= ms_merchantman_SetupDynastyShip()
		end
		
		while true do
			RemoveData("Source")
			RemoveData("Target")
			
			if ms_merchantman_CheckSell() then
				if not ms_merchantman_GotoTarget() then
					break
				end
				ms_merchantman_SellGoods()
			else
				if not ms_merchantman_GotoSource() then
					break
				end
			
				if ms_merchantman_BuyGoods() then
			
					if not ms_merchantman_GotoTarget() then
						break
					end
					ms_merchantman_SellGoods()
				end
			end
			Sleep(5)
		end
	end
end

function SetupFreeTrader()
	-- Input = Kontor
	-- Output = Harbors
	
	local Count = ScenarioGetObjects("Settlement", 10, "City")
	if Count==0 then
		return false
	end
	
	local SourceCount = 0
	local	TargetCount = 0
	
	for l=0,Count-1 do
		Alias = "City"..l
		if CityIsKontor(Alias) then
			if CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_KONTOR, -1, -1, FILTER_IGNORE, "Source"..SourceCount) then
				SetData("Source"..SourceCount..INVENTORY_SELL,1)
				SourceCount = SourceCount + 1
			end
		else
			if CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_HARBOR, -1, -1, FILTER_IGNORE, "Target"..TargetCount) then
				TargetCount = TargetCount + 1
			end
		end
	end
	
	if TargetCount==0 or SourceCount==0 then
		return false
	end
	
	SetData("SourceCount", SourceCount)
	SetData("TargetCount", TargetCount)

	SetData("Trade"..ITEM_TYPE_RESOURCE, 1)
	SetData("Trade"..ITEM_TYPE_GATHERING, 1)
	-- SetData("TradeAll", 1)
	
	-- ITEM_TYPE_RESOURCE = 1,
	-- ITEM_TYPE_INTERSTAGEPRODUCT = 2,
	-- ITEM_TYPE_NEED = 3,
	-- ITEM_TYPE_SUPPLY = 4,
	-- ITEM_TYPE_ARTIFACT = 5,
	-- ITEM_TYPE_ANIMAL = 6,
	-- ITEM_TYPE_PRODBYMEASURE = 7,		
	-- ITEM_TYPE_GATHERING= 8,	
	-- ITEM_TYPE_QUESTITEM = 9
end

function SetupDynastyShip()
	-- Input = own warehouse
	-- Output = Harbors+Kontors

	local	TargetCount = 0
	local Count = ScenarioGetObjects("Settlement", 10, "City")
	if Count==0 then
		return false
	end
	
	if not GetHomeBuilding("", "Source0") then
		return false
	end
	SetData("Source0"..INVENTORY_STD,1)
	SetData("Source0"..INVENTORY_SELL,1)
	
	for l=0,Count-1 do
		Alias = "City"..l
		TargetAlias = "Target"..TargetCount
		
		if not CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_HARBOR, -1, -1, FILTER_IGNORE, TargetAlias) then
			CityGetRandomBuilding(Alias, -1, GL_BUILDING_TYPE_KONTOR, -1, -1, FILTER_IGNORE, TargetAlias)
		end
		
		if AliasExists(TargetAlias) then
			TargetCount = TargetCount + 1
		end
	end

	if TargetCount==0 then
		return false
	end

	SetData("SourceCount", 1)
	SetData("TargetCount", TargetCount)
	SetData("TradeAll", 1)
end

function GotoSource()
	local SourceCount = GetData("SourceCount")
	if not SourceCount then
		return false
	end
	
	local	Source = "Source"..Rand(SourceCount)
	SetData("Source", Source)

	if not f_MoveTo("", Source, GL_MOVESPEED_RUN) then
		return false
	end

	return true
end

function BuyGoods()
	Sleep(1)
	
	local TargetCount = GetData("TargetCount")
	if not TargetCount then
		return false
	end
	
	local	Target
	local	BestProfit = 0
	
	for no=0,TargetCount-1 do
		Profit = ms_merchantman_DoBuyGoods("Target"..no, true)
		if Profit > BestProfit then
			Target = "Target"..no
			BestProfit = Profit
		end
	end
	
	if BestProfit<50 then
		return false
	end
	
	SetData("Target", Target)
	return (ms_merchantman_DoBuyGoods(Target, false)>0)
end
	
function DoBuyGoods(Target, CheckOnly)
	local	ItemId
	local	ItemCount
	local	Count
	local	PriceIn
	local	PriceOut
	local	Total = 0
	local	Done
	local Result
	local	Trade
	local StepSize = 3
	local TradeAll = ( GetData("TradeAll")==1 )
	local	PriceInNew
	local PriceOutNew
	local CountNew
	local	DiffIn
	local	DiffOut
	local	WinFaktor = 1.1
	
	local	Inventories = { INVENTORY_SELL, INVENTORY_STD }
	local	Inv = 1
	local	Slots
	local Source = GetData("Source")
	local InventoryType
	
	while Inventories[Inv] do
	
		InventoryType = Inventories[Inv]
		Inv = Inv + 1
	
		if GetData(Source..InventoryType) then
	
			Slots = InventoryGetSlotCount(Source, InventoryType)

			for Number = 0, Slots-1 do
				ItemId, ItemCount = InventoryGetSlotInfo(Source, Number, InventoryType)
				if ItemId and ItemCount and ItemCount>2 then
		
					Type = ItemGetType(ItemId)
					Trade = TradeAll or (GetData("Trade"..Type)==1)
			
					if Trade then
			
						-- calculate the amount to trade
				
						Count = 3
				
						PriceIn 	= GetAccessPriceTake(Source, "", ItemId, Count, InventoryType)
						if PriceIn == 0 then
							PriceIn = ItemGetBasePrice(ItemId)*Count
						end
						
						PriceOut 	= GetAccessPriceGive(Target, "", ItemId, Count, INVENTORY_STD)
				
						if PriceIn>0 and PriceOut>0 and PriceIn*WinFaktor < PriceOut then
				
							while true do
					
								CountNew 	= Count + StepSize
								if CountNew > ItemCount then
									CountNew = ItemCount
								end
								if CountNew == Count then
									break
								end

								PriceInNew	= GetAccessPriceTake(Source, "", ItemId, CountNew, InventoryType)
								if PriceInNew == 0 then
									PriceInNew = ItemGetBasePrice(ItemId)*CountNew
								end
								PriceOutNew	= GetAccessPriceGive(Target, "", ItemId, CountNew, INVENTORY_STD)
					
								DiffIn 	= (PriceInNew - PriceIn) / (CountNew - Count)
								DiffOut = (PriceOutNew - PriceOut)  / (CountNew - Count)
					
								if DiffIn*WinFaktor > DiffOut then
									break
								end
						
								Count 	= CountNew
								PriceIn 	= PriceInNew
								PriceOut 	= PriceOutNew

								if Count==30 or Count==60 or Count==90 then
									WinFaktor = WinFaktor + 0.1
								end
								Sleep(5)
							end
							
							if CheckOnly then
								Total = Total + (PriceOut - PriceIn)
							else
					
								Result, Done = Transfer("", "", INVENTORY_STD, Source, InventoryType, ItemId, Count)
								if Done<1 then
									break
								end
								Sleep(0.5 + Done/20)
								Total = Total + Done
							end
						end
					end
				end
			end
		end
	end
		
	return Total
end

function GotoTarget()
	local	Target = GetData("Target")
	if not f_MoveTo("", Target, GL_MOVESPEED_RUN) then
		return false
	end

	return true
end

function SellGoods()
	Sleep(1)

	local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local	ItemId
	local	ItemCount
	local	Target = GetData("Target")
	
	for Number = Slots-1, 0, -1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemCount then
			Transfer("", Target, INVENTORY_STD, "", INVENTORY_STD, ItemId, ItemCount)
		end
	end
	Sleep(1)
end

function CheckSell()
	local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local	ItemId
	local	ItemCount
	local	BestPrice = 0
	
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemCount and ItemCount>0 then
		
			local TargetCount = GetData("TargetCount")
			if not TargetCount then
				return false
			end
			
			for l=0,TargetCount-1 do
				PriceOut = GetAccessPriceGive("Target"..l, "", ItemId, ItemCount, INVENTORY_STD)
				if PriceOut>BestPrice then
					BestPrice = PriceOut
					SetData("Target", "Target"..l)
				end
			end
			
			if BestPrice>0 then
				return true
			end
		end
	end
end

function CleanUp()
end

