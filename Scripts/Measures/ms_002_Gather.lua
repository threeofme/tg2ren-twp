function Init()
	if IsGUIDriven() then
		if IsDynastySim("") then
			InitAlias("WorkBuilding",MEASUREINIT_SELECTION, "__F((Object.BelongsToMe())AND(Object.Type == Building))",
				"@L_MEASURE_002_GATHER_SELECT_WORKBUILDING_+0",0)
		end
		MsgMeasure("","")
		local ResID =  ResourceGetItemId("Destination")
		SetProperty("", "GatherID", ResID)
	end
end

function Run()
	
	if not HasProperty("", "GatherID") then
		StopMeasure()
	end
	
	local ItemID = GetProperty("", "GatherID")
	
	if not AliasExists("WorkBuilding") then
		if not SimGetWorkingPlace("", "WorkBuilding") then
			StopMeasure()
		end
	end
	
	local DidGather = false
	
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)
	
	while true do
	
		if IsGUIDriven() then
			CopyAlias("Destination", "Source")
		else
			ResourceFind("", ItemID, "Source", true)
		end
		
		if not AliasExists("Source") then
			break
		end

		local Label	= ItemGetLabel(ItemID, true)
		
		local SimSpace = GetRemainingInventorySpace("", ItemID, INVENTORY_STD)
		local BuildingSpace = GetRemainingInventorySpace("WorkBuilding", ItemID, INVENTORY_STD)
		local ProdCount = ItemGetProductionAmount(ItemID)
		if ProdCount < 5 and ItemID ~= 165 then
			ProdCount = 5
		end
		local Time = ItemGetProductionTime(ItemID)
		local Type = ResourceGetScriptFunc("Source")
	
		local Value = GetImpactValue("", 34)	-- 34 = GatherBonus
		if Value and Value>0 then
			Time = Time - Time * Value * 0.01
		end
	
		if GetSeason() == 3 then
			Time =  math.floor(Time + ((Time / 100) * 20)) -- im Winter 20% langsamer
		end
		
		if CanAddItems("", ItemID, ProdCount, INVENTORY_STD) then
		
			while CanAddItems("", ItemID, ProdCount, INVENTORY_STD) do
			
				if not gather_GotoResource("", "Source", Label) then
					break
				end
				
				SetData("Endtime",(GetGametime()+Time))
				-- starting animation
				if Type == "Herbs" then
					MsgMeasure("", "@L_GENERAL_MSGMEASURE_GATHER_+0", Label)
					CarryObject("","Handheld_Device/ANIM_Sickel.nif", false)
					PlayAnimation("","knee_work_in")
				elseif Type == "well" then
					MsgMeasure("", "@L_GENERAL_MSGMEASURE_GATHER_+0", Label)
					CarryObject("","Handheld_Device/ANIM_Bucket.nif", false)
					PlayAnimation("","fetch_water_in")
				elseif Type == "Fungi" then
					MsgMeasure("", "@L_GENERAL_MSGMEASURE_HARVEST_+0", Label)
					PlayAnimation("","knee_work_in")
				end
				if DidGather == false then
					DidGather = true
				end
				
				while true do
					if Type == "Herbs" then
						LoopAnimation("","knee_work_loop",4)
					elseif Type == "well" then
						LoopAnimation("", "fetch_water_loop", 4)
					elseif Type == "Fungi" then
						LoopAnimation("","knee_work_loop",4)
					end
					if GetGametime()>GetData("Endtime") then
						break
					end
				end
				
				AddItems("", ItemID, ProdCount, INVENTORY_STD)
			end
		end
		
		if DidGather == true then
			if Type == "Herbs" then
				PlayAnimation("","knee_work_out")
				CarryObject("","Handheld_Device/ANIM_Herbbox.nif", false)
				MoveSetActivity("","carry")
			elseif Type == "well" then
				CarryObject("","Handheld_Device/ANIM_Bucket_full.nif", false)
				PlayAnimation("","fetch_water_out")
				Sleep(2)
				CarryObject("","",true)
			elseif Type == "Fungi" then
				PlayAnimation("","knee_work_out")
				CarryObject("","Handheld_Device/ANIM_Fungibasket.nif", false)
				MoveSetActivity("","carry")
			end
			
			f_MoveTo("", "WorkBuilding", GL_MOVESPEED_WALK)
		end
		
		Sleep(2)
		if GetItemCount("", ItemID, INVENTORY_STD)>0 then 
			if not ms_002_gather_ReturnItems("", "WorkBuilding") then
				MsgQuick("","@L_GENERAL_MEASURES_SENDCART_MSG_+0")
				Sleep(10)
			end
		end
		
		-- stop the measure here after gathering for AI to select new production
		if BuildingGetAISetting("WorkBuilding", "Produce_Selection")>0 then
			RemoveProperty("", "GatherID")
			StopMeasure()
		end
	end
	StopMeasure()
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
	
	CarryObject("","",true)
	MoveSetActivity("","")
	
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

