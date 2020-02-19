-------------------------------------------------------------------------------
----
----	OVERVIEW "AIBuyArmor.lua"
----
----	with this measure the AI buys an armor and uses it
----
-------------------------------------------------------------------------------
function Run()
	
	local ItemName
	
	if HasProperty("", "AIBuyArmor") then
		ItemName = GetProperty("", "AIBuyArmor")
	else
		StopMeasure()
	end
	
	-- Buy the Item
	if GetItemCount("", ItemName, INVENTORY_STD)==0 and GetItemCount("", ItemName, INVENTORY_EQUIPMENT)==0 then
		if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
			return
		end
	end
	
	-- Animation
	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(0.5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time-2)
	MsgSay("","@L_BUYARMOR_COMMENT")
	Sleep (0.5)
	
	if GetItemCount("", ItemName)>0 then
	
		-- Equip the Item if Slot is empty
		if GetRemainingInventorySpace("", ItemName, INVENTORY_EQUIPMENT)>0 then
			RemoveItems("", ItemName, 1, INVENTORY_STD)
			AddItems("", ItemName, 1, INVENTORY_EQUIPMENT)
		
		else
			-- Check what item blocks the space
			local ItemCase1 = GetItemCount("","LeatherArmor", INVENTORY_EQUIPMENT)
			local ItemCase2 = GetItemCount("","Chainmail", INVENTORY_EQUIPMENT)
			local ItemCase3 = GetItemCount("","Platemail", INVENTORY_EQUIPMENT)
			
			if ItemCase1>0 then
				-- Check if new item is better or not
				-- Every case is better than Dagger
				if ItemName ~= "LeatherArmor" then
					RemoveItems("", "LeatherArmor", 1, INVENTORY_EQUIPMENT)
					RemoveItems("", ItemName, 1, INVENTORY_STD)
					-- Equip new item
					AddItems("",ItemName,1,INVENTORY_EQUIPMENT)
				end
			elseif ItemCase2 >0 then
				if ItemName == "Platemail" then
					RemoveItems("", "Chainmail",1, INVENTORY_EQUIPMENT)
					RemoveItems("", ItemName, 1, INVENTORY_STD)
					AddItems("",ItemName,1,INVENTORY_EQUIPMENT)
				end
			elseif ItemCase3 >0 then
				-- You already have a platemail, no need to change.
				RemoveItems("", ItemName, 1, INVENTORY_STD)
				StopMeasure()
			end
		end
	end
	StopMeasure()

end

function CleanUp()
	if HasProperty("", "AIBuyArmor") then
		RemoveProperty("", "AIBuyArmor")
	end
end
