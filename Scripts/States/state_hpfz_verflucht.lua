function Init()
end

function Run()

	local Slots, Number, ItemId, ItemCount, Abzug, Menge

	if GetImpactValue("",388)==1 then
		local dur = ImpactGetMaxTimeleft("",388)
		BuildingGetOwner("","BOwner")
		SetData("Duration",dur)
		SetData("Schaden",0)
	
		-- visual
		GetPosition("","HausFliegen")
		GfxAttachObject("fliegen", "particles/flies.nif")
		GfxSetPositionTo("fliegen", "HausFliegen")
		GfxMoveToPosition("fliegen",0,20,0,0.1,false)
		GfxStartParticle("fliegenfliegen", "particles/flies.nif", "HausFliegen", 2)

		while GetImpactValue("",388)>0 do
			Slots = InventoryGetSlotCount("",INVENTORY_STD)
			Number = Rand(Slots)
			ItemId, ItemCount = InventoryGetSlotInfo("", Number, INVENTORY_STD)

			if ItemCount>0 then
				Menge = Rand(ItemCount)
				RemoveItems("",ItemId,Menge,INVENTORY_STD)
				SetData("Schaden",(GetData("Schaden")+Menge))
				MsgNewsNoWait("","","","intrigue",-1,"@L_HPFZ_VERFLUCHEN_EFFECTMSG_HEAD_+0",
					"@L_HPFZ_VERFLUCHEN_EFFECTMSG_BODY",GetID("BOwner"),GetID(""),Menge,ItemId)
			end
			Sleep(30)
		end
        end
        SetState("",STATE_HPFZ_VERFLUCHT,false)
        GfxDetachObject("fliegen")
        return
 
end

function CleanUp()
	if GetData("Schaden")>0 then
	local duration = GetData("Duration")
		MsgNewsNoWait("All","","","intrigue",-1,"@L_HPFZ_VERFLUCHEN_ENDMSG_HEAD_+0",
					"@L_HPFZ_VERFLUCHEN_ENDMSG_BODY",GetID("BOwner"),GetID(""),duration,Menge)
	end		
end
