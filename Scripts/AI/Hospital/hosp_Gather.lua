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
	local MaxProducer = BuildingGetWorkerCount("WorkBuilding") - 2 -- keep up to 2 guys for measures and production
	if MaxProducer < 1 then 
		MaxProducer = 1
	end
	
	if Producer >= MaxProducer then
		return 0
	end
	
	-- Decide what to gather
	
	local LavenderCount = GetItemCount("WorkBuilding", "Lavender", INVENTORY_STD)
	local FungiCount = GetItemCount("WorkBuilding", "Fungi", INVENTORY_STD)
	if Producer == 0 then
		-- first gatherer prefers Lavender
		if LavenderCount < 10 then 
			SetData("GatherGoal","Lavender")
			return 100
		elseif FungiCount == 0 and BuildingGetLevel("WorkBuilding") > 1 then
			SetData("GatherGoal","Fungi")
			return 100
		end
	elseif Producer == 1 then
		-- second gatherer prefers Fungi
		if FungiCount == 0 and BuildingGetLevel("WorkBuilding") > 1 then
			SetData("GatherGoal","Fungi")
			return 100
		elseif LavenderCount < 10 then
			SetData("GatherGoal","Lavender")
			return 100
		end
	elseif Producer > 1 then 
		-- third gatherer prefers Lavender
		if LavenderCount < 10 then 
			SetData("GatherGoal","Lavender")
			return 100
		elseif FungiCount == 0 and BuildingGetLevel("WorkBuilding") > 1 then
			SetData("GatherGoal","Fungi")
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