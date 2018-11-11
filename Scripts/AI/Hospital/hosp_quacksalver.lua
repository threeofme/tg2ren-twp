function Weight()

	if not ai_GetWorkBuilding("SIM", GL_BUILDING_TYPE_HOSPITAL, "Hospital") then
		return 0
	end
	
	if not BuildingHasUpgrade("Hospital","MiracleCure") then
		return 0
	end
	
	if SimGetAge("SIM")<16 then
		return 0
	end
	
	if IsDynastySim("SIM") then
		if SimGetClass("SIM")~=3 then
			return 0
		end
	end
	
	if DynastyIsAI("SIM") then
		if SimGetOfficeLevel("SIM")>=1 then
			return 0
		end
	end
	
	if not ReadyToRepeat("Hospital", "AI_QUACKSALVER") then
		return 0
	end
	
	if not ai_HasAccessToItem("SIM", "MiracleCure") then
		return 0
	end
	
	if BuildingGetProducerCount("Hospital", PT_MEASURE, "Quacksalver") > 0 then
		return 0
	end

	if GetItemCount("SIM", "MiracleCure")>=1 then -- sell the rest
		return 100
	elseif GetItemCount("Hospital", "MiracleCure", INVENTORY_STD) >= 10 then
		return 100
	end

	local ItemId = ItemGetID("MiracleCure")
	local CuresInSalescounter = GetProperty("Hospital", "Salescounter_"..ItemId) or 0
	if CuresInSalescounter >= 10 then
		return 100
	end

	return 0
end

function Execute()
	SetRepeatTimer("Hospital", "AI_QUACKSALVER", 4)
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("Quacksalver"))
end
