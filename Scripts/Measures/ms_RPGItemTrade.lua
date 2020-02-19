function Run()
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local	Number 
	local	ItemId
	local	ItemCount
	local	NumItems = 0
	local	ItemName = {}
	local	ItemLabel = {}
	local	ItemTexture
	local 	btn = ""
	local	added = {}
	--count all items, remove duplicates
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemId>0 and ItemCount then		
			if not added[ItemId] then
				
				added[ItemId] = true
			
				--create labels for replacements
				ItemName[NumItems] = ItemId 
				ItemTextureName = ItemGetName(ItemId)
				ItemTexture = "Hud/Items/Item_"..ItemTextureName..".tga"
				btn = btn.."@B[BTN"..NumItems..",,%"..1+NumItems.."l,"..ItemTexture.."]"
				ItemLabel[NumItems] = ""..ItemGetLabel(ItemName[NumItems],true)
				NumItems = NumItems + 1
			end	
		end
	end
	SetData("NumItems",NumItems)
	
	local Result
	
	if Slots > 0 and NumItems > 0 then
		Result = InitData("@P"..btn,
				ms_rpgitemtrade_AIDecide,  --AIFunc
				"@L_MESSAGES_RPGItemTrade_TEXT_+0",
				"",
				ItemLabel[0],ItemLabel[1],
				ItemLabel[2],ItemLabel[3],
				ItemLabel[4],ItemLabel[5])
		
	else
		MsgQuick("","@L_REPLACEMENTS_FAILURE_MSG_NOITEM_+0")
		StopMeasure()
	end
	
	if Result == "C" then
		StopMeasure()
	end
	
	--check the item
	local ItemIndex
	if Result == "BTN0" then
		ItemIndex = 0
	elseif Result == "BTN1" then
		ItemIndex = 1
	elseif Result == "BTN2" then
		ItemIndex = 2
	elseif Result == "BTN3" then
		ItemIndex = 3
	elseif Result == "BTN4" then
		ItemIndex = 4
	elseif Result == "BTN5" then
		ItemIndex = 5
	end
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", 1000, 64, nil) then
		StopMeasure()
	end
	
	local DestResult = MsgNews("Destination","Destination","@P"..
				"@B[A,@LJa_+0]"..
				"@B[C,@LNein_+0]",
				ms_rpgitemtrade_AIDecide,  --AIFunc
				"default",0.5,
				"@L_MESSAGES_RPGItemTrade_HEAD_+0",
				"@L_MESSAGES_RPGItemTrade_BODY_+0",
				GetID(""),ItemGetLabel(ItemName[ItemIndex]))
				
	if DestResult == "C" then
		MsgQuick("","@L_MESSAGES_RPGItemTrade_FAILURES_+1",GetID("Destination"))
		StopMeasure()
	end
	
	local time1
	local time2
	time1 = PlayAnimationNoWait("Owner", "use_object_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(1)
	time2 = PlayAnimationNoWait("Destination","fetch_store_obj_R")
	Sleep(1)
	StopAnimation("")
	PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(1)
	
	
	if AddItems("Destination",ItemName[ItemIndex],1,INVENTORY_STD)==0 then
		MsgQuick("","@L_MESSAGES_RPGItemTrade_FAILURES_+0",GetID("Destination"))
	elseif RemoveItems("",ItemName[ItemIndex],1,INVENTORY_STD)==0 then
		RemoveItems("Destination",ItemName[ItemIndex],1,INVENTORY_STD)
		StopMeasure()
	end
	
	StopMeasure()

end

function AIDecide()
	--NumItems = GetData("NumItems")
	if GetFavorToSim("Destination","Owner") < 40 then
		return "C"
	else
		return "A"
	end
end

function CleanUp()
	StopAnimation("")
	if AliasExists("Destination") then
		StopAnimation("Destination")
	end
end

