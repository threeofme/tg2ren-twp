function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	if not SimGetWorkingPlace("","Workbuilding") then
		if IsPartyMember("") then
			-- use nearest building as home for party members
			local NextBuilding = ai_GetNearestDynastyBuilding("", GL_BUILDING_CLASS_WORKSHOP, GL_BUILDING_TYPE_THIEF)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"Workbuilding")
		else
			StopMeasure()
		end
	end
	-- move to building entrance
	GetOutdoorMovePosition("", "Destination", "DoorPos")
	f_MoveTo("", "DoorPos", GL_MOVESPEED_RUN,1200)

	MeasureSetNotRestartable()
	SetState("", STATE_HIDDEN, false)
	
	-- this is a more stealthy action
	PlayAnimation("","watch_for_guard")
	CommitAction("stealfromcounter","","Destination", "Destination")
	
	-- move to door
	f_MoveTo("","DoorPos",GL_MOVESPEED_RUN) 
	
	if GetImpactValue("Destination","buildingburgledtoday")==0 then
		if GetLocatorByName("Destination","bomb1","ParticleSpawnPos") then
			StartSingleShotParticle("particles/plunder.nif","ParticleSpawnPos",8,5)
		end
		if GetLocatorByName("Destination","bomb2","ParticleSpawnPos2") then
			StartSingleShotParticle("particles/plunder.nif","ParticleSpawnPos2",7,5)
		end
		feedback_MessageMilitary("Destination","@L_BATTLE_061_PLUNDERBUILDING_MSG_VICTIM_START_HEAD_+0",
						"@L_BATTLE_061_PLUNDERBUILDING_MSG_VICTIM_START_BODY_+0",GetID(""),GetID("Destination"))
	end
	PlaySound3DVariation("Destination","measures/plunderbuilding",1)
	
	-- steal random items from sales counter.
	local ItemId, ItemCount, Money = ms_twp_stealfromcounter_StealRandomItems("Destination", "")
	if (Money > 0) then
		AddImpact("Destination","buildingburgledtoday",1,12)
		local Time = MoveSetActivity("","carry")
		Sleep(2)
		CarryObject("","Handheld_Device/ANIM_Bag.nif",false)
		PlaySound3DVariation("","measures/plunderbuilding",1)
		Sleep(Time-2)
		MsgQuick("","@L_BATTLE_061_PLUNDERBUILDING_MSG_ACTOR_END_BODY_+0",GetID("Destination"))
		chr_GainXP("",GetData("BaseXP"))		
		--for the mission
		mission_ScoreCrime("",Money)
		
	else
		MsgQuick("","@L_BATTLE_061_PLUNDERBUILDING_FAILURES_+1")
	end
	f_ExitCurrentBuilding("")
	StopAction("stealfromcounter","")
	GetFleePosition("", "Destination", 1500, "Away")
	f_MoveTo("", "Away", GL_MOVESPEED_RUN)
	f_MoveTo("","Workbuilding",GL_MOVESPEED_RUN)
	local ItemId
	local Found
	local RemainingSpace
	local Removed
	
	-- put items into workshop inventory
	local Count = InventoryGetSlotCount("", INVENTORY_STD)
	for i=0,Count-1 do
		ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
		if ItemId and ItemId>0 and Found>0 then
			RemainingSpace	= GetRemainingInventorySpace("Workbuilding",ItemId)
			Removed		= RemoveItems("", ItemId, RemainingSpace)
			if Removed>0 then
				AddItems("Workbuilding", ItemId, Removed, INVENTORY_STD)
			end
			
		end
	end

end


function StealRandomItems(BldAlias, ThiefAlias)
	-- initialize Count, Items of available items in counter
	local Count, Items = economy_GetItemsForSale(BldAlias)
	local ItemId, Available, ItemPrice, ItemCount
	for i=1, Count do
		ItemId = Items[Rand(Count) + 1]
		Available = GetProperty(BldAlias, PREFIX_SALESCOUNTER..ItemId)
		if Available and Available > 0 then
			ItemPrice = economy_GetPrice(BldAlias, ItemId, ThiefAlias)
			ItemCount = GetRemainingInventorySpace(ThiefAlias, ItemId)
			ItemCount = math.min(Available, ItemCount)
			if ItemCount > 0 then
				SetProperty(BldAlias, PREFIX_SALESCOUNTER..ItemId, Available - ItemCount)
				AddItems(ThiefAlias, ItemId, ItemCount)
				local TotalPrice = ItemCount * ItemPrice 
				return ItemId, ItemCount, TotalPrice
			end
		end
	end
	return nil, 0, 0
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("Destination") then
		if HasProperty("Destination", "CanEnter_"..GetID("")) then
			RemoveProperty("Destination", "CanEnter_"..GetID(""))
		end
	end
	if GetInsideBuilding("","CurrentBuilding") then
		if (GetID("CurrentBuilding") == GetID("Destination")) then
			if GetOutdoorMovePosition("", "Destination", "DoorPos") then
				SimBeamMeUp("", "DoorPos", false) -- false added
			end
		end
	end
		
	StopAction("stealfromcounter","")
	MoveSetActivity("","")
	CarryObject("","",false)
end
