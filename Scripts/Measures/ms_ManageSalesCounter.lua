function Run()
	CopyAlias("","Workshop")
	
	local Count, Items = economy_GetItemsForSale("Workshop")
	-- this call returns -1 for adding new items
	local SelectedItemId = economy_ChooseItemFromCounter("Workshop", Count, Items)
	if SelectedItemId == -1 then -- warehouse, add any available item from inventory
		SelectedItemId = ms_managesalescounter_AddItemFromInventory("Workshop")
	end
	if not SelectedItemId then
		return
	end
	ms_managesalescounter_ChooseItemAmount("Workshop", SelectedItemId, Count, Items)
	economy_UpdateSalescounter("Workshop", Count, Items)
	economy_CalculateSalesRanking("Workshop", Count, Items)
end


function ChooseItemAmount(BldAlias, ChosenItemId, Count, Items)
	local ButtonsForAmounts = ""
	local mengen = {0, 1, 3, 5, 10, 20, 40, 60, 80, 120}
	for i=1,10 do
		ButtonsForAmounts = ButtonsForAmounts.."@B["..mengen[i]..","..mengen[i]..",]"
	end
	 
	local CurrentMax = GetProperty(BldAlias, "SalescounterMax_"..ChosenItemId) or 0
	local AmountToStore = MsgBox("","",
			"@P"..ButtonsForAmounts.."@B[C,@LCancel_+0]", -- 
			"@L_MEASURE_SALESCOUNTER_HEAD_+0", -- Verkaufstheke verwalten
			"@L_MEASURE_SALESCOUNTER_ITEM_BODY_+0", -- Hier könnt Ihr festlegen, wieviel %1l in Eurer Verkaufstheke zum Verkauf angeboten werden soll. Diese Menge wird automatisch aus dem Produktionslager genommen.
			ItemGetLabel(ChosenItemId, false), CurrentMax)
	if AmountToStore ~= "C" then
		if AmountToStore > 0 then
			SetProperty(BldAlias, "SalescounterMax_"..ChosenItemId, AmountToStore)
			local NewList = ""
			local Exists
			for i = 1, Count do
				NewList = NewList..Items[i].." "
				if Items[i] == ChosenItemId then
					Exists = true
				end
			end
			if not Exists then
				-- add item to list in warehouse if necessary
				NewList = NewList..ChosenItemId
				LogMessage("TOM::SalesCounter::add Saving new item list: "..NewList)
				SetProperty(BldAlias, "SalesCounterItems", NewList)
			end
		else
			RemoveProperty(BldAlias, "SalescounterMax_"..ChosenItemId)
			-- remove the item from list in warehouse
			local NewList = ""
			for i = 1, Count do
				if Items[i] ~= ChosenItemId then
					NewList = NewList..Items[i].." "
				end
			end
			LogMessage("TOM::SalesCounter::remove Saving new item list: "..NewList)
			SetProperty(BldAlias, "SalesCounterItems", NewList)
		end
	end
end

function AddItemFromInventory(BldAlias)
	-- offer items from current inventory
	BuildingGetOwner(BldAlias, "BldOwner")
	return economy_ChooseItemFromInventory(BldAlias, "BldOwner")
end
