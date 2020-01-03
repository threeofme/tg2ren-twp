function Weight()
	if IsDynastySim("SIM") then
		return 0
	end
	
	if SimGetAge("SIM") < 16 then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM", "WorkBuilding") then
		return 0
	end
	
	-- no need to gather in the late hours before timeout
	if math.mod(GetGametime(), 24) >= 22.5 then
		return 0
	end
	
	local Producer = BuildingGetProducerCount("WorkBuilding", PT_MEASURE, "Gather")
	local MaxProducer = 2
	
	if Producer >= MaxProducer then
		return 0
	end
	
	-- Decide what to gather
	
	local HolyWaterCount = GetItemCount("WorkBuilding", "HolyWater", INVENTORY_STD)

	if HolyWaterCount <= 5 then 
		SetData("GatherGoal","HolyWater")
		return 100
	end

	return 0
end

function Execute()
	local Item
	local ItemID
	if HasData("GatherGoal") and AliasExists("SIM") and AliasExists("WorkBuilding") then
		Item = GetData("GatherGoal")
		ItemID = ItemGetID(Item)
		SetProperty("SIM", "GatherID", ItemID)
		MeasureRun("SIM", "WorkBuilding", "Gather", false)
	end
end