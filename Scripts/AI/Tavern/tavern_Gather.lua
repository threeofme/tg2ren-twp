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
	if math.mod(GetGametime(), 24) >= 21.5 then
		return 0
	end
	
	if BuildingGetLevel("WorkBuilding") < 3 then
		return 0
	end
	
	local Producer = BuildingGetProducerCount("WorkBuilding", PT_MEASURE, "Gather")
	local MaxProducer = 1
	
	if Producer >= MaxProducer then
		return 0
	end
	
	-- Decide what to gather
	
	local FungiCount = GetItemCount("WorkBuilding", "Fungi", INVENTORY_STD)
	local SwamprootCount = GetItemCount("WorkBuilding", "Swamproot", INVENTORY_STD)
	
	if Producer == 0 then
		-- first gatherer prefers swamproot
		if SwamprootCount == 0 then 
			SetData("GatherGoal","Swamproot")
			return 100
		elseif FungiCount == 0 then
			SetData("GatherGoal","Fungi")
			return 100
		end
	elseif Producer == 1 then
		-- second gatherer prefers Fungi
		if FungiCount == 0 then
			SetData("GatherGoal","Fungi")
			return 100
		elseif SwamprootCount == 0 then
			SetData("GatherGoal","Swamproot")
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