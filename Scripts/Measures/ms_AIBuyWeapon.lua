-------------------------------------------------------------------------------
----
----	OVERVIEW "AIBuyWeapon.lua"
----
----	with this measure the AI buys a weapon and uses it
----
-------------------------------------------------------------------------------
function Run()
	
	local ItemName
	
	if HasProperty("", "AIBuyWeapon") then
		ItemName = GetProperty("", "AIBuyWeapon")
	else
		StopMeasure()
	end
	
	if GetItemCount("", ItemName, INVENTORY_STD)==0 and GetItemCount("", ItemName, INVENTORY_EQUIPMENT)==0 then
		if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
			StopMeasure()
		end
	end
	
	-- Animation
	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(0.5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time-2)
	MsgSay("","@L_BUYWEAPON_COMMENT")
	Sleep (0.5)
	
	if GetItemCount("", ItemName, INVENTORY_STD)>0 then
	
		-- Equip the Item if Slot is empty
		if GetRemainingInventorySpace("", ItemName, INVENTORY_EQUIPMENT)>0 then		
			RemoveItems("", ItemName, 1, INVENTORY_STD)
			AddItems("", ItemName, 1, INVENTORY_EQUIPMENT)
	
		else
			-- Check what item blocks the space
			local ItemCase1 = GetItemCount("","Dagger", INVENTORY_EQUIPMENT)
			local ItemCase2 = GetItemCount("","Shortsword", INVENTORY_EQUIPMENT)
			local ItemCase3 = GetItemCount("","Mace", INVENTORY_EQUIPMENT)
			local ItemCase4 = GetItemCount("","Longsword", INVENTORY_EQUIPMENT)
			local ItemCase5 = GetItemCount("","Axe", INVENTORY_EQUIPMENT)
	
			if ItemCase1>0 then
				-- Check if new item is better or not
				-- Every case is better than Dagger
				if ItemName ~= "Dagger" then
					RemoveItems("", "Dagger",1, INVENTORY_EQUIPMENT)
					RemoveItems("", ItemName, 1, INVENTORY_STD)
					-- Equip new item
					AddItems("",ItemName,1,INVENTORY_EQUIPMENT)
				end
			elseif ItemCase2 >0 then
				if ItemName ~= "Dagger" and ItemName ~= "Shortsword" then
					RemoveItems("", "Shortsword",1, INVENTORY_EQUIPMENT)
					RemoveItems("", ItemName, 1, INVENTORY_STD)
					AddItems("", ItemName, 1, INVENTORY_EQUIPMENT)
				end
			elseif ItemCase3 >0 then
				if ItemName ~= "Dagger" and ItemName ~= "Shortsword" and ItemName ~= "Mace" then
					RemoveItems("", "Mace", 1, INVENTORY_EQUIPMENT)
					RemoveItems("", ItemName, 1, INVENTORY_STD)
					AddItems("", ItemName, 1 , INVENTORY_EQUIPMENT)
				end
			elseif ItemCase4 >0 then
				if ItemName == "Axe" then
					RemoveItems("", "Longsword",1, INVENTORY_EQUIPMENT)
					RemoveItems("", ItemName, 1, INVENTORY_STD)
					AddItems("", ItemName, 1, INVENTORY_EQUIPMENT)
				end
			elseif ItemCase5 >0 then
				-- You already have an Axe, no need to change.
				RemoveItems("", ItemName, 1, INVENTORY_STD)
				StopMeasure()
			end
		end
	end
end

function CleanUp()
	if HasProperty("", "AIBuyWeapon") then
		RemoveProperty("", "AIBuyWeapon")
	end
end
