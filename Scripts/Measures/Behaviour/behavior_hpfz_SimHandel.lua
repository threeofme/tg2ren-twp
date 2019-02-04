function Run()
	if (SimGetNeed("", 7) > 0.5) and (Rand(2) == 0) then

		GetFleePosition("Owner", "Actor", 130+Rand(50), "Away")
		f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
		AlignTo("Owner", "Actor")
		Sleep(1)

		if Rand(10) < 5 then
			if SimGetGender("Owner")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_cheer",1)
			else
				PlaySound3DVariation("","CharacterFX/female_cheer",1)
			end
			TimeLeft = PlayAnimation("Owner", "cheer_01")
		else
			TimeLeft = PlayAnimation("Owner", "cheer_02")
		end

		local ItemCat = behavior_hpfz_simhandel_KundeAuswahl()

		if ItemCat > 0 then
		--debug
		-- MsgSay("","@L  case Buy")
		-- Sleep(2)
			behavior_hpfz_simhandel_KundeReaktion(ItemCat)
		else
		--debug
		-- MsgSay("","@L  case Ignor")
		-- Sleep(2)
		end

		SatisfyNeed("Owner",7,0.25) -- konsum need lowers
		SatisfyNeed("Owner",9,-0.25) -- financial need raises
	end

end

--Sell
function KundeAuswahl()
	local lagInhalt = { nil }
	local einkauf = nil

	local itemX, mengeX, slotX, feil, gPreis, summe
	local r = 0
	local MinFactor = 0

	slotX = InventoryGetSlotCount("Actor",INVENTORY_STD)
	for s = 0, slotX-1 do
		itemX, mengeX = InventoryGetSlotInfo("Actor",s,INVENTORY_STD)
		if itemX and mengeX > 0 then

			if (ItemGetCategory(itemX)==0) then--or (ItemGetCategory(itemX)==6) then
				MinFactor = MinFactor + 1
			end
			r = r + 1
			lagInhalt[r] = itemX
		end
	end

	if MinFactor ~= 0 then
		slotX = slotX - MinFactor
	end

	if slotX > 0 and r > 0 then--added r to prevent null item
		if (r == 1) then
			einkauf =  1
		else
			einkauf = ( Rand(r) + 1 )
		end

		-- if lagInhalt[einkauf] == nil then
			-- MsgSayNoWait("Actor", "@L trying to buy XNIL! Slots:" .. r .. " buyingslot:" .. einkauf)
			-- Sleep(2)
		-- else
			-- MsgSayNoWait("Actor", "@L trying to buy that:" .. ItemGetCategory(lagInhalt[einkauf]) .. " id:" .. lagInhalt[einkauf] .. " slots:" .. r .. " buyingslot:" ..einkauf)
			-- Sleep(2)
		-- end
		
		if ItemGetCategory(lagInhalt[einkauf])~=0 then--and ItemGetCategory(lagInhalt[einkauf])~=6 then

			feil = GetSkillValue("Actor", BARGAINING)*20 -- 10 Bargaining = 200% bonus on base price
			gPreis = ItemGetBasePrice(lagInhalt[einkauf])
			summe =math.floor((gPreis/100) * feil)
			summe = gPreis+Rand(summe)
			SimGetWorkingPlace("Actor", "Workingplace")
			if AliasExists("Workingplace") then
				f_CreditMoney("Workingplace",summe,"Offering")
				economy_UpdateBalance("Workingplace", summe, "Service")
			else
				f_CreditMoney("Actor",summe,"Offering")
			end
			IncrementXPQuiet("Actor",5)
			ShowOverheadSymbol("Actor",false,true,0,"%1t",summe)
			RemoveItems("Actor", lagInhalt[einkauf], 1)
		else
--MsgSayNoWait("","@L  Faill: high")
--Sleep(2)
		end
	else
		if HasProperty("Actor", "CartP") then
			local CartID = GetProperty("Actor","CartP")
			if not GetAliasByID(CartID, "CartPointer") then
				RemoveProperty("Actor", "CartP")
			end
		end
		
		if HasProperty("Actor", "CartP") then
			local CartID = GetProperty("Actor","CartP")
			if not GetAliasByID(CartID, "CartPointer") then
-- MsgSayNoWait("Actor", "@L Buyers Faill: lost alias")
-- Sleep(2)
			else
-- MsgSayNoWait("Actor", "@L Buyers Suc: GetData")
-- Sleep(2)
			end
		else
			local Karren = Find("Actor", "__F( (Object.GetObjectsByRadius(Cart)==800)AND(Object.BelongsToMe())AND(Object.CanBeControlled()) )", "ExtraLager", -1)
			local BigCartNumber = 0
			local BigCart = -1
			local LagerX = -1
			local Slots, LagerX, ItemID, ItemMenge

-- MsgSayNoWait("Actor", "@L Buyers: %1t is in here", Karren)
-- Sleep(2)

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
				if BigCartNumber < LagerX then
					BigCartNumber = LagerX
					BigCart = i
				end
			end
			CopyAlias("ExtraLager"..BigCart, "CartPointer")
		end

		if AliasExists("CartPointer") then
			local r = 0
			local itemX, mengeX, slotX, feil, gPreis, summe, bonus, replacev
			slotX = InventoryGetSlotCount("CartPointer",INVENTORY_STD)
			for s = 0, slotX-1 do
				itemX, mengeX = InventoryGetSlotInfo("CartPointer",s,INVENTORY_STD)
				if itemX and mengeX > 0 then
					r = r + 1
					lagInhalt[r] = itemX
				end
			end
			if (r  == 1) then
				einkauf  = 1
			else
				einkauf = ( Rand(r) + 1 )
			end

			-- MsgSayNoWait("Actor", "@L .")
			-- if lagInhalt[einkauf] == nil then
				-- MsgSayNoWait("Actor", "@L trying to buy NIL!")
			-- else
				-- MsgSayNoWait("Actor", "@L trying to buy that:" .. ItemGetCategory(lagInhalt[einkauf]) .. " id:" .. lagInhalt[einkauf])
				-- Sleep(2)
			-- end
			if ItemGetCategory(lagInhalt[einkauf])~=0 then--and ItemGetCategory(lagInhalt[einkauf])~=6 then
				feil = GetSkillValue("Actor", BARGAINING)*20 -- 10 Bargaining = 200% bonus on base price
				gPreis = ItemGetBasePrice(lagInhalt[einkauf])
				summe =math.floor((gPreis/100) * feil)
				summe = gPreis+Rand(summe)
				f_CreditMoney("Actor",summe,"Offering")
				IncrementXPQuiet("Actor",5)
				ShowOverheadSymbol("Actor",false,true,0,"%1t",summe)
				RemoveItems("CartPointer", lagInhalt[einkauf], 1)
			else
-- MsgSayNoWait("Actor", "@L can't buy that:" .. ItemGetCategory(lagInhalt[einkauf]) .. " id:" .. lagInhalt[einkauf])
-- Sleep(2)
			end
		else
-- MsgSayNoWait("Actor", "@L lost alias")
-- Sleep(2)
		end
	end

	local itcat = ItemGetCategory(lagInhalt[einkauf])
	return itcat
end


--action
function KundeReaktion(z)
	local simReagiert = Rand(3)
	local HandVerkauf = Rand(3)
	if simReagiert == 0 or simReagiert == 2 then
		if z == 1 then
			MoveSetActivity("Owner","carry")
			if HandVerkauf == 0 then
				CarryObject("Owner", "Handheld_Device/ANIM_Floursack.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+0")
			elseif HandVerkauf == 1 then
				CarryObject("Owner", "Handheld_Device/ANIM_Woodlog.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+1")
			else
				CarryObject("Owner", "Handheld_Device/ANIM_Metalbar.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+2")
			end
			Sleep(3)
		elseif z == 2 then
			MoveSetActivity("Owner","carry")
			if HandVerkauf == 0 then
				CarryObject("Owner", "Handheld_Device/ANIM_Barrel.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+3")
			elseif HandVerkauf == 1 then
				CarryObject("Owner", "Handheld_Device/ANIM_Breadbasket.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+4")
			else
				CarryObject("Owner", "Handheld_Device/ANIM_fish_L.nif", true)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+5")
			end
			Sleep(3)
		elseif z == 3 then
            local Aktion = PlayAnimationNoWait("Owner","use_object_standing")
			Sleep(1)
			if HandVerkauf == 0 then
				CarryObject("Owner", "Handheld_Device/Anim_Hammer.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+6")
			elseif HandVerkauf == 1 then
				CarryObject("Owner", "Handheld_Device/ANIM_gun.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+7")
			else
                CarryObject("Owner", "weapons/langsword_01.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+8")
			end
            Sleep(Aktion-1)
		elseif z == 4 then
			if HandVerkauf == 0 then
				MoveSetActivity("Owner","carry")
				CarryObject("Owner", "Handheld_Device/ANIM_bookpile.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+9")
				Sleep(3)
			elseif HandVerkauf == 1 then
				MoveSetActivity("Owner","carry")
				CarryObject("Owner", "Handheld_Device/ANIM_Cloth.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+10")
				 Sleep(3)
			 else
                local Aktion = PlayAnimationNoWait("Owner","use_object_standing")
				Sleep(1)
				CarryObject("Owner", "Handheld_Device/ANIM_Smallsack.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+11")
                Sleep(Aktion-1)
			end
		elseif z == 5 then
			if HandVerkauf == 0 then
				MoveSetActivity("Owner","carry")
				CarryObject("Owner", "Handheld_Device/ANIM_Bottlebox.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+12")
				Sleep(3)
			elseif HandVerkauf == 1 then
                local Aktion = PlayAnimationNoWait("Owner","use_object_standing")
				Sleep(1)
				CarryObject("Owner", "Handheld_Device/ANIM_Aesculap_Staff.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+13")
                Sleep(Aktion-1)
			else
                local Aktion = PlayAnimationNoWait("Owner","use_object_standing")
				Sleep(1)
				CarryObject("Owner", "Handheld_Device/ANIM_perfumebottle.nif", false)
				MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+14")
                Sleep(Aktion-1)
			end
		else
			PlayAnimationNoWait("Owner","use_object_standing")
			Sleep(1)
			CarryObject("Owner", "Handheld_Device/ANIM_Smallsack.nif", false)
			MsgSay("Owner","_HPFZ_HANDEL_ANTWORT_+3")
			Sleep(3)
		end
	end
    MoveSetActivity("")
	CarryObject("", "", false)
	CarryObject("", "", true)
	
end

function CleanUp()
	CarryObject("Owner", "", false)
    MoveSetActivity("Owner")
	CarryObject("", "", false)
	CarryObject("", "", true)
    MoveSetActivity("")
end
