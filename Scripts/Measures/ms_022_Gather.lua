function Run(ItemID)

	local CharName = GetID("")
	local labelname = ItemGetLabel(ItemID, false)
	
	local RemainingSpace 	= GetRemainingInventorySpace("WorkBuilding",ItemID)
	local RemainingSimSpace = GetRemainingInventorySpace("",ItemID)
	local Count = ItemGetProductionAmount(ItemID) 

	if RemainingSpace <= 0 and RemainingSimSpace < Count then
		-- no space left in the inventory of the building AND the sim 
		-- message missing

		MsgQuick("", "@L_GENERAL_INFORMATION_INVENTORY_INVENTORY_FULL_+3", GetID(""), GetID("WorkBuilding"), ItemGetLabel(ItemID, true))

		while true do
			Sleep(5)
			ms_022_gather_ReturnItems("","WorkBuilding")
			if GetItemCount("",ItemID) <= 0 then
				break				
			end
		end
	elseif RemainingSimSpace <= 0 then
		ms_022_gather_ReturnItems("","WorkBuilding")
		RemainingSimSpace = GetRemainingInventorySpace("",ItemID)
		if RemainingSimSpace <= 0 then
			-- no space left in the inventory of the gatherer and he could not transfer the items to his working building
			-- message missing

			MsgQuick("", "@L_GENERAL_INFORMATION_INVENTORY_INVENTORY_FULL_+0", GetID(""), ItemGetLabel(ItemID, true))
			
			while true do
				Sleep(5)
				ms_022_gather_ReturnItems("","WorkBuilding")
				if GetItemCount("",ItemID) <= 0 then
					break				
				end
			end
		end
	end

	if AliasExists("Destination") and IsType("Destination", "GuildResource") then
		CopyAlias("Destination","Herbs")
	else
		local Capacity = ResourceFind("WorkBuilding",ItemID,"Herbs", false)

		if Capacity==-1 then
			MsgQuick("", "@L_GENERAL_MEASURES_GATHER_RESOURCE_NOTHING_FOUND_HEAD", ItemGetLabel(ItemID, true))
			return false
		end 
		
		if Capacity==0 and not ResourceCanBeChanged("Herbs") then
			--MsgQuick("", "@L_GENERAL_MEASURES_GATHER_RESOURCE_EMPTY_ALL", ItemGetLabel(ItemID, true), GetID(""), ItemGetLabel(ItemID, true), ItemGetLabel(ItemID, true))
			--return false
		end 
	end

	if not AliasExists("Herbs") then
		MsgQuick("", "@L_GENERAL_MEASURES_GATHER_RESOURCE_NOTHING_FOUND_HEAD", ItemGetLabel(ItemID, true))
		return false
	end
	
	if ResourceGetItemId("Herbs") < 1 then
		MsgQuick("", "@L_GENERAL_MEASURES_GATHER_RESOURCE_NOTHING_FOUND_HEAD", ItemGetLabel(ItemID, true))
		Sleep(0.5)
		return false
	end

	if not gather_Run("", "Herbs", "auto") then
		return false
	end

	if AliasExists("WorkBuilding") then

		if f_MoveTo("", "WorkBuilding", GL_MOVESPEED_RUN) then
			local BuildingID = GetID("WorkBuilding")
			BuildingGetOwner("WorkBuilding","BuildingOwner")
		end
		
		if not ms_022_gather_ReturnItems("", "WorkBuilding") then
			return false
		end
	end
	
	return true
end

function ReturnItems(SimAlias, BuildingAlias)

	local ItemId
	local Found
	local RemainingSpace
	local Removed
	local TotalCount
	local MovedItems = 0
	local HasAnything = 0
	
	local Count = InventoryGetSlotCount(SimAlias, INVENTORY_STD)
	for i=0,Count-1 do
		ItemId, Found = InventoryGetSlotInfo(SimAlias, i, INVENTORY_STD)
		if ItemId and ItemId>0 and Found>0 then
			
			HasAnything = Found
			TotalCount	= GetItemCount(SimAlias, ItemId, INVENTORY_STD)
			RemainingSpace = GetRemainingInventorySpace(BuildingAlias,ItemId)
			Removed = RemoveItems(SimAlias, ItemId, RemainingSpace)
			if Removed>0 then
				AddItems(BuildingAlias, ItemId, Removed)
				MovedItems = MovedItems + Removed
			end
		end
	end

	MoveSetActivity(SimAlias, "")
	Sleep(2)
	CarryObject(SimAlias, "", false)
	
	if MovedItems>0 then
		return true
	else
		if HasAnything == 0 then
			return true
		else
			return false
		end
	end
end

function CleanUp()
	if AliasExists("WorkBuilding") and DynastyIsAI("") then
		local ItemId, Found
		local Count = InventoryGetSlotCount("", INVENTORY_STD)
		for i=0,Count-1 do
			ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
			if ItemId and ItemId>0 and Found>0 then
			
				if CanAddItems("WorkBuilding", ItemId, Found, INVENTORY_STD) then
					RemoveItems("", ItemId, Found)
					AddItems("WorkBuilding", ItemId, Found)
				end
			end
		end
	end
end
