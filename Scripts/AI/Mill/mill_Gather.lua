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
	if math.mod(GetGametime(), 24) >= 17 then
		return 0
	end
	
	local Producer = BuildingGetProducerCount("WorkBuilding", PT_MEASURE, "Gather")
	local MaxProducer = BuildingGetWorkerCount("WorkBuilding") - 2 -- keep up to 2 guys for measures and production
	if MaxProducer < 1 then 
		MaxProducer = 2
	end
	
	if Producer >= MaxProducer then
		return 0
	end
	
	-- Decide what to gather
	
	local LavenderCount = GetItemCount("WorkBuilding", "Lavender", INVENTORY_STD)
	local BlackberryCount = GetItemCount("WorkBuilding", "Blackberry", INVENTORY_STD)
	local MoonflowerCount = GetItemCount("WorkBuilding", "Moonflower", INVENTORY_STD)
	
	if Producer == 0 then
		-- first gatherer prefers lavender
		if LavenderCount == 0 then 
			SetData("GatherGoal","Lavender")
			return 100
		elseif BlackberryCount == 0 then
			SetData("GatherGoal","Blackberry")
			return 100
		elseif MoonflowerCount == 0 then
			SetData("GatherGoal", "Moonflower")
			return 100
		end
	elseif Producer == 1 then
		-- second gatherer prefers blackberries
		if BlackberryCount == 0 then 
			SetData("GatherGoal","Blackberry")
			return 100
		elseif LavenderCount == 0 then
			SetData("GatherGoal","Lavender")
			return 100
		elseif MoonflowerCount == 0 then
			SetData("GatherGoal", "Moonflower")
			return 100
		end
	else
		-- third gatherer prefers lavender
		if LavenderCount == 0 then 
			SetData("GatherGoal","Lavender")
			return 100
		elseif BlackberryCount == 0 then
			SetData("GatherGoal","Blackberry")
			return 100
		elseif MoonflowerCount == 0 then
			SetData("GatherGoal", "Moonflower")
			return 100
		end
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