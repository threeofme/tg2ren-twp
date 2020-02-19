function Init()
end

function Run()
	if not f_MoveTo("","Destination") then
		StopMeasure()
	end	
	
	local MyInv, CartInv, lagerSlot, prodSold, setupStall
	MeasureSetStopMode(STOP_NOMOVE)
	CommitAction("handeln", "", "")

	local ItID, ItMg, ItIDX, ItMgX, MyInv, CartInv, lagerSlot, Tmppointer
	
	prodSold = 1
	setupStall = 0
	
	while 1 do
		MyInv, CartInv, lagerSlot = ms_hpfz_handel_BestandCheck()
		Sleep(1)
		if MyInv == 0 and (CartInv == nil or CartInv == 0) or prodSold == 0 then
			if nottradeable~=0 then
				MsgQuick("",nottradeable)
			else
				MsgQuick("","_HPFZ_HANDEL_FEHLER_+0")
			end
			break
		end
		
		prodSold = 0--prevent selling items that no longer exist

		if MyInv > 0 then
			for s = 0, lagerSlot-1 do
				ItID, ItMg = InventoryGetSlotInfo("",s,INVENTORY_STD)
				
				if ItMg == nil then
					
				else
					if ItMg > 0 then
						prodSold = prodSold + 1

						if setupStall == 0 then
							setupStall = 1
							GetPosition("","MovePos")
							GfxAttachObject("tradetisch", "city/Stuff/tradetable.nif")
							GfxSetPositionTo("tradetisch", "MovePos")	
						end
						
						if ItemGetCategory(ItID) == 1 then
							ms_hpfz_handel_Ausrufer(1)
						elseif ItemGetCategory(ItID) == 2 then
							ms_hpfz_handel_Ausrufer(2)
						elseif ItemGetCategory(ItID) == 3 then
							ms_hpfz_handel_Ausrufer(3)
						elseif ItemGetCategory(ItID) == 4 then
							ms_hpfz_handel_Ausrufer(4)
						elseif ItemGetCategory(ItID) == 5 then
							ms_hpfz_handel_Ausrufer(5)
						elseif ItemGetCategory(ItID) == 6 then
							ms_hpfz_handel_Ausrufer(6)
						end

					end
				end
			end
		end

		
		if CartInv ~= nil and CartInv > 0 then
			if AliasExists("CartPointer") then
				RemoveAlias("CartPointer")
			end

			if HasProperty("","CartP") then
				Tmppointer = GetProperty("","CartP")
				if GetAliasByID(Tmppointer, "CartPointer") then
--MsgSayNoWait("", "@L Seller Suc: GetData ")
--Sleep(2)
				else
--MsgSayNoWait("", "@L Seller Faill: GetData ")
--Sleep(2)				
				end
			else
				Find("", "__F((Object.GetObjectsByRadius(Cart)==800)AND(Object.CanBeControlled())AND(Object.BelongsToMe()))", "ExtraLagerX", -1)
				CopyAlias("ExtraLagerX0", "CartPointer")
			end

			if AliasExists("","CartPointer") then
				lagerSlot = InventoryGetSlotCount("CartPointer",INVENTORY_STD)
				for s = 0, lagerSlot-1 do
					ItIDX, ItMgX = InventoryGetSlotInfo("CartPointer",s,INVENTORY_STD)
					
					
					if ItMgX == nil then
						
					else
						if ItMgX > 0 then
							prodSold = prodSold + 1
							--GfxAttachObject("verkaufsStand", "city/freierhandler.nif")
							if setupStall == 0 then
								setupStall = 1
								GetPosition("","MovePos")
								GfxAttachObject("tradetisch", "city/Stuff/tradetable.nif")
								GfxSetPositionTo("tradetisch", "MovePos")	
							end
							
							if ItemGetCategory(ItIDX) == 1 then
								ms_hpfz_handel_Ausrufer(1)
							elseif ItemGetCategory(ItIDX) == 2 then
								ms_hpfz_handel_Ausrufer(2)
							elseif ItemGetCategory(ItIDX) == 3 then
								ms_hpfz_handel_Ausrufer(3)
							elseif ItemGetCategory(ItIDX) == 4 then
								ms_hpfz_handel_Ausrufer(4)
							elseif ItemGetCategory(ItIDX) == 5 then
								ms_hpfz_handel_Ausrufer(5)
							elseif ItemGetCategory(ItIDX) == 6 then
								ms_hpfz_handel_Ausrufer(6)
							end
						end
					end
				end
			end
		end	
	end
	
	GfxDetachAllObjects()
	StopAction("handeln","")
	StopMeasure()
end

function BestandCheck()
	local Slots = InventoryGetSlotCount("",INVENTORY_STD)
	local r, ItemID, ItemMenge
	local Lager = 0
	local nottradeable = 0
	for r = 0, Slots-1 do
		ItemID, ItemMenge = InventoryGetSlotInfo("",r,INVENTORY_STD)
		if ItemID ~= nil and ItemMenge > 0 then
			Lager = Lager + 1
			if ItemGetCategory(ItemID)==0 then-- ItemGetCategory(ItemID)==6 then
				Lager = Lager - 1
			end
			nottradeable = "_HPFZ_HANDEL_FEHLER_+2"
		end
	end

	local Karren = Find("", "__F( (Object.GetObjectsByRadius(Cart)==800)AND(Object.BelongsToMe())AND(Object.CanBeControlled()) )", "ExtraLager", -1)
	local BigCartNumber = 0
	local BigCart = -1
	local BigLagerX = -1

--	MsgSayNoWait("", "@L Sellers: %1t is in here", Karren)
--	Sleep(2)

	for i=0,Karren -1 do
		LagerX = 0
		Slots = InventoryGetSlotCount("ExtraLager"..i,INVENTORY_STD)
		for r = 0, Slots-1 do
			ItemID, ItemMenge = InventoryGetSlotInfo("ExtraLager"..i,r,INVENTORY_STD)
			if ItemID ~= nil and ItemMenge > 0 then
				LagerX = LagerX + 1

				if ItemGetCategory(ItemID)==0 then--or ItemGetCategory(ItemID)==6 then
					LagerX = LagerX - 1
				end
			end 
		end

		if BigCartNumber < LagerX  then
			BigCartNumber = LagerX 
			BigCart = i
			BigLagerX = LagerX
		end
	end
	
	SetProperty("","CartP",GetID("ExtraLager"..BigCart))
	--
	-- MsgSayNoWait("", "@L Cart ID:"..GetID("ExtraLager"..BigCart).." / ["..BigLagerX.."]")
	-- Sleep(2)

	if BigLagerX ~= -1 then
		LagerX = BigLagerX
	end
	Sleep(1)

	return Lager, LagerX, Slots
end

function Ausrufer(z)
	local HandVerkauf = Rand(3)
	local Rufe = Rand(2)

	if SimGetGender("")==GL_GENDER_MALE then
		PlaySound3DVariation("","CharacterFX/male_jolly",1)
	else
		PlaySound3DVariation("","CharacterFX/female_jolly",1)
	end

	PlayAnimation("","preach")
	Sleep(1)
	if z==1 then
		MoveSetActivity("","carry")
		if HandVerkauf == 0 then
			CarryObject("", "Handheld_Device/ANIM_Floursack.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+0")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+1")
			end
		elseif HandVerkauf == 1 then
			CarryObject("", "Handheld_Device/ANIM_Woodlog.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+2")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+3")
			end
		else
			CarryObject("", "Handheld_Device/ANIM_Metalbar.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+4")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+5")
			end
		end
		Sleep(12)
	elseif z==2 then
		MoveSetActivity("","carry")
		if HandVerkauf == 0 then
			CarryObject("", "Handheld_Device/ANIM_Barrel.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+6")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+7")
			end
		elseif HandVerkauf == 1 then
			CarryObject("", "Handheld_Device/ANIM_Breadbasket.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+8")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+9")
			end
		else
			CarryObject("", "Handheld_Device/ANIM_fish_L.nif", true)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+10")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+11")
			end
		end
		Sleep(12)
	elseif z==3 then
		PlayAnimationNoWait("","use_object_standing")
		Sleep(1)
		if HandVerkauf == 0 then
			CarryObject("", "Handheld_Device/Anim_Hammer.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+12")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+13")
			end
		elseif HandVerkauf == 1 then
			CarryObject("", "Handheld_Device/ANIM_gun.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+14")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+15")
			end
		else
			CarryObject("", "weapons/langsword_01.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+16")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+17")
			end
		end
		Sleep(12)
	elseif z==4 then
		if HandVerkauf == 0 then
			MoveSetActivity("","carry")
			CarryObject("", "Handheld_Device/ANIM_bookpile.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+18")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+19")
			end
			Sleep(12)
		elseif HandVerkauf == 1 then
			MoveSetActivity("","carry")
			CarryObject("", "Handheld_Device/ANIM_Cloth.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+20")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+21")
			end
			Sleep(12)
		else
			PlayAnimationNoWait("","use_object_standing")
			Sleep(1)
			CarryObject("", "Handheld_Device/ANIM_Smallsack.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+22")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+23")
			end
			Sleep(12)
		end
	elseif z==5 then
		if HandVerkauf == 0 then
			MoveSetActivity("","carry")
			CarryObject("", "Handheld_Device/ANIM_Bottlebox.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+24")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+25")
			end
			Sleep(12)
		elseif HandVerkauf == 1 then
			PlayAnimationNoWait("","use_object_standing")
			Sleep(1)
			CarryObject("", "Handheld_Device/ANIM_Aesculap_Staff.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+26")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+27")
			end
			Sleep(12)
		else
			PlayAnimationNoWait("","use_object_standing")
			Sleep(1)
			CarryObject("", "Handheld_Device/ANIM_perfumebottle.nif", false)
			if Rufe==0 then
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+28")
			else
				MsgSay("","_HPFZ_HANDEL_SPRUCH_+29")
			end
			Sleep(12)
		end
	else
		if z>0 then
			PlayAnimationNoWait("","use_object_standing")
			
			Sleep(1)
			CarryObject("", "Handheld_Device/ANIM_Smallsack.nif", false)
			-- if Rufe==0 then
				-- MsgSay("","_HPFZ_HANDEL_SPRUCH_+16")
			-- else
				-- MsgSay("","_HPFZ_HANDEL_SPRUCH_+17")
			-- end

			Sleep(12)
		end
	end
	CarryObject("", "", false)
end

function CleanUp()
	StopAction("handeln", "")
	MoveSetActivity("")
	GfxDetachAllObjects()
	StopAnimation("")
	CarryObject("", "", false)
	if HasProperty("","CartP") then
		RemoveProperty("","CartP")
	end
end
