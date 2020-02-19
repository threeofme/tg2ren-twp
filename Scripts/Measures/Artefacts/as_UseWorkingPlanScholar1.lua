-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseWorkingPlanScholar1"
----
----	with this artifact, the player can increase the favour to other characters
----	in range
----
-------------------------------------------------------------------------------

function Run()

	if not GetInsideBuilding("", "Building") then
		StopMeasure()
	end

	local choice

	local Plan = "WorkingPlanScholar1"
	local PlanCount = 1
	local PlanLabel = ItemGetLabel(Plan, true)
	local Object = "Almanac"
	local ObjectCount = 1
	local ObjectLabel = ItemGetLabel(Object, true)

	local ItemName1 = "Pinewood"
	local ItemCount1 = 1
	local ItemLabel1
	local ItemName2 = "Oakwood"
	local ItemCount2 = 1
	local ItemLabel2
	local ItemName3 = "Leather"
	local ItemCount3 = 1
	local ItemLabel3

	if ItemCount1 > 1 then
		ItemLabel1 = ItemGetLabel(ItemName1, false)
	else
		ItemLabel1 = ItemGetLabel(ItemName1, true)
	end
	if ItemCount2 > 1 then
		ItemLabel2 = ItemGetLabel(ItemName2, false)
	else
		ItemLabel2 = ItemGetLabel(ItemName2, true)
	end
	if ItemCount3 > 1 then
		ItemLabel3 = ItemGetLabel(ItemName3, false)
	else
		ItemLabel3 = ItemGetLabel(ItemName3, true)
	end

	local ProduceTime = 240 - (GetSkillValue("",SECRET_KNOWLEDGE) * 18)
	local ItemInStock1 = false
	local ItemInStock2 = false
	local ItemInStock3 = false
	local ItemInStock1Label = "@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_STOCK_+1"
	local ItemInStock2Label = "@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_STOCK_+1"
	local ItemInStock3Label = "@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_STOCK_+1"

	if ( (GetItemCount("",ItemName1) > ItemCount1-1) or (GetItemCount("Building",ItemName1) > ItemCount1-1) ) then
		ItemInStock1 = true
		ItemInStock1Label = "@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_STOCK_+0"
	end
	if ( (GetItemCount("",ItemName2) > ItemCount2-1) or (GetItemCount("Building",ItemName2) > ItemCount2-1) ) then
		ItemInStock2 = true
		ItemInStock2Label = "@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_STOCK_+0"
	end
	if ( (GetItemCount("",ItemName3) > ItemCount3-1) or (GetItemCount("Building",ItemName3) > ItemCount3-1) ) then
		ItemInStock3 = true
		ItemInStock3Label = "@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_STOCK_+0"
	end

	if AiDriven then
		choice = 0
	else
		if (ItemInStock1 == true) and (ItemInStock2 == true) and (ItemInStock3 == true) then
			choice = MsgBox("", "", "@P@B[0,@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_OPT_+0]"..
								"@B[1,@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_OPT_+1]",
								"@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_HEAD_+0",
								"@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_TEXT_+1",
								PlanLabel, ObjectLabel, ItemCount1, ItemLabel1, ItemCount2, ItemLabel2, ItemCount3, ItemLabel3, ItemInStock1Label, ItemInStock2Label, ItemInStock3Label, GetID(""), ProduceTime)
		else
			MsgBox("", "", "",
								"@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_HEAD_+0",
								"@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_TEXT_+2",
								PlanLabel, ObjectLabel, ItemCount1, ItemLabel1, ItemCount2, ItemLabel2, ItemCount3, ItemLabel3, ItemInStock1Label, ItemInStock2Label, ItemInStock3Label, GetID(""), ProduceTime)
			StopMeasure()
		end

		if choice == 0 then
		
			if RemoveItems("",ItemName1,ItemCount1) == 0 then
				RemoveItems("Building",ItemName1,ItemCount1)
			end
			if RemoveItems("",ItemName2,ItemCount2) == 0 then
				RemoveItems("Building",ItemName2,ItemCount2)
			end
			if RemoveItems("",ItemName3,ItemCount3) == 0 then
				RemoveItems("Building",ItemName3,ItemCount3)
			end

			ForbidMeasure("", "ToggleInventory", EN_BOTH)
			SetState("",STATE_LOCKED,true)
			local percent = ProduceTime / 100
			LoopAnimation("","use_object_standing",-1)
			for i=1,100 do
				feedback_OverheadPercent("", i)
				Sleep(percent)
			end
			StopAnimation("")
			RemoveItems("",Plan,1)
			AddItems("",Object,1)
			IncrementXP("", 50)

			MsgBoxNoWait("", "",
								"@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_HEAD_+0",
								"@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_TEXT_+3",
								ObjectLabel, GetID(""))
		end
	end
end


function CleanUp()
	SetState("",STATE_LOCKED,false)
	AllowMeasure("", "ToggleInventory", EN_BOTH)
end
