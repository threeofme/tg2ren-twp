-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_ConfiscateGoods"
----
----	With this measure the player can confiscate goods at an enemy workshop
----  
----  1. Die Waren des selektierten Gebäudes werden konfisziert
----  2. Das Gebäude verliert alles was sich im Lager/Verkaufslager befindet
----  3. Der Heerführer erhält den Basispreis aller Waren als Geldwert
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	if  not AliasExists("Destination") then
		StopMeasure()
	end
	
	if not GetOutdoorMovePosition("","Destination","MovePos") then
		StopMeasure()
	end
	
	if not f_MoveTo("","MovePos") then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	
	AlignTo("","Destination")
	Sleep(1)
	PlayAnimation("","propel")
	
	local GoodMoney = chr_GetBootyCount("Destination", INVENTORY_STD)
	local Count, Items = economy_GetItemsForSale("Destination")
	local ItemCount, ItemPrice
	for i = 1, Count do
		ItemCount = GetProperty("Destination", "Salescounter_"..Items[i])
		ItemPrice = economy_GetPrice("Destination", Items[i])
		GoodMoney = GoodMoney + (ItemCount * ItemPrice)
		SetProperty("Destination", "Salescounter_"..Items[i], 0)
	end
	
	f_CreditMoney("", GoodMoney, "unknown")
	
	local ItemsInSTD = InventoryGetSlotCount("Destination", INVENTORY_STD)
	local ItemId, Found
	for i=0, ItemsInSTD-1 do
		ItemId, Found = InventoryGetSlotInfo("Destination", i, INVENTORY_STD)
		if ItemId and ItemId>0 and Found>0 then
			RemoveItems("Destination", ItemId, 999)
		end
	end
	
	MsgNewsNoWait("","Destination","","politics",-1,
				"@L_PRIVILEGES_CONFISCATEGOODS_MSG_ACTOR_HEAD_+0",
				"@L_PRIVILEGES_CONFISCATEGOODS_MSG_ACTOR_BODY_+0", GetID("Destination"),GoodMoney)
	MsgNewsNoWait("Destination","","","politics",-1,
				"@L_PRIVILEGES_CONFISCATEGOODS_MSG_VICTIM_HEAD_+0",
				"@L_PRIVILEGES_CONFISCATEGOODS_MSG_VICTIM_BODY_+0", GetID(""), GetID("Destination"))
	
	StopMeasure()
end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

