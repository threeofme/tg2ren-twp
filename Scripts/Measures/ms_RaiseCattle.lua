function Init()
	if IsGUIDriven() then
		SetProperty("", "RaiseCattleID", (GetID("Destination")))
	end
end

function Run()
	
	if not SimGetWorkingPlace("", "Farm") then
		local NextBuilding = ai_GetNearestDynastyBuilding("", GL_BUILDING_CLASS_WORKSHOP, GL_BUILDING_TYPE_FARM)
		if not NextBuilding then
			StopMeasure()
		else
			CopyAlias(NextBuilding, "Farm")
		end
	end
	
	if not AliasExists("Farm") then
		StopMeasure()
	end
	
	-- Spawn the animals
	local Lifestock = "__F((Object.GetObjectsByRadius(Sim)==800)AND(Object.GetProfession()==58)OR(Object.GetProfession()==55)OR(Object.GetProfession()==57))" -- animal professions
	local Animals = Find("Destination", Lifestock,"PflegeViehs", 6)
	if Animals < 1 then
		for i=1, 3 do
			local hoftier, hoftierID
			GetPosition("Destination","HueterPos")
			local x,y,z = PositionGetVector("HueterPos")
			x = x + ((Rand(200)*2)-200)
			z = z + ((Rand(200)*2)-200)
			PositionModify("HueterPos",x,y,z)
			SetPosition("HueterPos",x,y,z)

			if i == 1 then
				hoftierID = 923
				hoftier = "Pig"
			elseif i == 2 then
				hoftierID = 920
				hoftier = "Sheep"
			elseif i == 3 then
				hoftierID = 922
				hoftier = "Cattle"
			end
				
			SimCreate(hoftierID,"","HueterPos","Tier"..i)
			SimSetFirstname("Tier"..i, "@L_UPGRADE_"..hoftier.."_NAME_+0")
			SimSetLastname("Tier"..i, "@L_EMPTY_NAME_+0")

			AddImpact("Tier"..i, 390, 1, -1) -- Huete Tier
			SetState("Tier"..i, STATE_ANIMAL, true)
		end
	end
	
	if not HasProperty("", "RaiseCattleID") then
		return
	end
	
	local DidGather = false
	
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)
	
	while true do
	
		if IsGUIDriven() then
			CopyAlias("Destination", "Source")
		else
			GetAliasByID(GetProperty("", "RaiseCattleID"), "Source")
		end
		
		if not AliasExists("Source") then
			break
		end
		
		local Label	= ItemGetLabel(3, true)
		
		local SimSpace = GetRemainingInventorySpace("", 3, INVENTORY_STD)
		local BuildingSpace = GetRemainingInventorySpace("Farm", 3, INVENTORY_STD)
		local ProdCount = ItemGetProductionAmount(3)
		local Time = 2
		
		if CanAddItems("", 3, ProdCount, INVENTORY_STD) then
		
			while CanAddItems("", 3, ProdCount, INVENTORY_STD) do
			
				if not gather_GotoResource("", "Source", Label) then
					break
				end
				
				SetData("Endtime", (GetGametime()+Time))
			
				-- starting animation
				SetContext("", "sow")
				CarryObject("", "Handheld_Device/ANIM_Seed.nif", true)
				PlayAnimation("", "sow_field_in")
				
				if DidGather == false then
					DidGather = true
				end
				
				while true do
					LoopAnimation("", "sow_field_loop", 2)
					Sleep(0.5)
					LoopAnimation("", "sow_field_loop", 2)
					Sleep(0.5)
					LoopAnimation("", "sow_field_loop", 2)
					PlayAnimation("", "sow_field_out")
					CarryObject("", "", true)
					Sleep(0.75)
					
					if GetGametime()>GetData("Endtime") then
						break
					end
					Sleep(Rand(10))
				end
				
				AddItems("", 3, ProdCount, INVENTORY_STD)
			end
		end
		
		if DidGather == true then
			PlayAnimationNoWait("","fetch_store_obj_R")
			Sleep(1)
			PlayAnimation("", "knee_work_out")
			PlayAnimationNoWait("", "fetch_store_obj_R")
			Sleep(0.75)
			CarryObject("", "", false)
			MoveSetActivity("", "carry")
			Sleep(1)
			CarryObject("", "Handheld_Device/ANIM_haunch.nif", false)
			Sleep(0.5)
			
			f_MoveTo("", "Farm", GL_MOVESPEED_WALK)
		end
		
		Sleep(2)
		if GetItemCount("", 3, INVENTORY_STD)>0 then 
			if not ms_raisecattle_ReturnItems("", "Farm") then
				MsgQuick("","@L_GENERAL_MEASURES_SENDCART_MSG_+0")
				Sleep(10)
			end
		end
		
		-- stop the measure here after gathering for AI to select new production
		if BuildingGetAISetting("", "Produce_Selection") > 0 then
			RemoveProperty("", "RaiseCattleID")
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
	CarryObject("","",false)
	MoveSetActivity("","")
	
	if AliasExists("Farm") and DynastyIsAI("") then
		local ItemId, Found
		local Count = InventoryGetSlotCount("", INVENTORY_STD)
		for i=0,Count-1 do
			ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
			if ItemId and ItemId>0 and Found>0 then
			
				if CanAddItems("Farm", ItemId, Found, INVENTORY_STD) then
					RemoveItems("", ItemId, Found)
					AddItems("Farm", ItemId, Found)
				end
			end
		end
	end
end

