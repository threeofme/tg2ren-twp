function Run()
	
	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_HOSPITAL, "WorkBuilding") then
		StopMeasure() 
		return
	end
	
	local Producer = BuildingGetProducerCount("WorkBuilding", PT_MEASURE, "Quacksalver")
	
	if IsStateDriven() then
		if Producer >1 then
			StopMeasure()
			return
		end
	end
	
	if not GetSettlement("WorkBuilding", "City") then
		return
	end
	
	if not BuildingGetOwner("WorkBuilding","MyBoss") then
		return
	end
	
	if GetInsideBuilding("","InsideBuilding") then
		f_ExitCurrentBuilding("")
	end

	local result = 0
	
	if IsStateDriven() then
		if DynastyIsPlayer("MyBoss") then
			if BuildingGetAISetting("WorkBuilding", "Produce_Selection")>0 then
				-- For the AI
				result = 1+Rand(5)
			end
		end
	end
	
	if not AliasExists("Destination") then
		-- Get the Destination
		result = MsgBox("MyBoss","","@P"..
			"@B[1,@L_PIRATE_LABOROFLOVE_DESTINATION_+0,]"..
			"@B[2,@L_PIRATE_LABOROFLOVE_DESTINATION_+1,]"..
			"@B[3,@L_PIRATE_LABOROFLOVE_DESTINATION_+2,]"..
			"@B[4,@L_PIRATE_LABOROFLOVE_DESTINATION_+3,]"..
			"@B[5,@L_PIRATE_LABOROFLOVE_DESTINATION_+4,]",
			"@L_PIRATE_LABOROFLOVE_DESTINATION_HEAD_+0",
			"@L_PIRATE_LABOROFLOVE_DESTINATION_BODY_+0")
	end
		
	local ErrorLabel
	
	if result == 0 then
		local WorkResult = GetProperty("","WorkResult")
		if WorkResult == 1 then
			result = 1
		elseif WorkResult == 2 then
			result = 2
		elseif WorkResult == 3 then
			result = 3
		elseif WorkResult == 4 then
			result = 4
		elseif WorkResult == 5 then
			result = 5
		end
	end
		
	if result == 1 then
		-- Go to the market (or black board)	
		local Market = 1+Rand(5)
		if CityGetRandomBuilding("City", 5,14,Market,-1, FILTER_IGNORE, "MarketPos") then
			CopyAlias("MarketPos", "Destination")
		else
			CityGetRandomBuilding("City", 3, 41, 0,-1, FILTER_IGNORE, "BlackBoardPos")
			CopyAlias("BlackBoardPos","Destination")
		end
		
		-- Save the result for next day
		SetProperty("","WorkResult",1)
	elseif result == 2 then
		-- Go to the Townhall
		CityGetNearestBuilding("City","",3,23,-1,-1, FILTER_IGNORE, "CityHallPos")
		CopyAlias("CityHallPos", "Destination")
		
		-- Save the result for next day
		SetProperty("","WorkResult",2)
	elseif result == 3 then
		-- Go to a tavern
		if CityGetNearestBuilding("City","",2,4,-1,-1, FILTER_HAS_DYNASTY, "TavernPos") then
			CopyAlias("TavernPos", "Destination")
		else
			ErrorLabel = "@L_PIRATE_LABOROFLOVE_ERROR_TAVERN_+0"
			MsgQuick("","@L_PIRATE_LABOROFLOVE_ERROR_+0",GetID(""),ErrorLabel)
			StopMeasure()
		end
			
		-- Save the result for next day
		SetProperty("","WorkResult",3)
	elseif result == 4 then
		-- Go to a church
		local Church = 19 + Rand(2)
		if CityGetNearestBuilding("City","",2,Church,-1,-1, FILTER_HAS_DYNASTY, "ChurchPos") then
			CopyAlias("ChurchPos", "Destination")
		else
			ErrorLabel = "@L_PIRATE_LABOROFLOVE_ERROR_CHURCH_+0"
			MsgQuick("","@L_PIRATE_LABOROFLOVE_ERROR_+0",GetID(""),ErrorLabel)
			StopMeasure()
		end
		-- Save the result for next day
		SetProperty("","WorkResult",4)
	elseif result == 5 then
		-- Stay at your workbuilding
		CopyAlias("Workbuilding", "Destination")
		-- Save the result for next day
		SetProperty("","WorkResult",5)
	end
	
	MeasureSetStopMode(STOP_NOMOVE)
	
	-- start the labor
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)
	
	while true do
		if not ms_quacksalver_GetPlacebo() then
			StopMeasure()
		end

		local startloc = Rand(300)+50
		if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,startloc) then
			return
		end
		
		if IsStateDriven() then
			-- Timeout
			if math.mod(GetGametime(),24) <7 then
				StopMeasure()
				break
			end
		end

		CommitAction("quacksalver", "", "")
		while GetItemCount("", "MiracleCure")>0 do
		
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_jolly",0.6)
			else
				PlaySound3DVariation("","CharacterFX/female_jolly",0.6)
			end
			PlayAnimation("","preach")
			PlayAnimation("","pray_standing")
			Sleep(2)
		end
		StopAction("quacksalver", "")
	end

	StopMeasure()
end

function GetPlacebo()

	local Count = GetItemCount("", "Lavender", INVENTORY_STD) 
		
	-- lavender is deleted from the inventory of the doctor and added to the inventory of the hospital
	
	if Count > 0 then
		if CanAddItems("WorkBuilding", "Lavender", Count, INVENTORY_STD) then
			RemoveItems("", "Lavender", Count)
			AddItems("WorkBuilding", "Lavender", Count)
		end
	end
		

	if GetItemCount("", "MiracleCure")>0 then
		return true
	end
	
	CopyAlias("WorkBuilding","Hospital")
	
	if GetInsideBuildingID("") ~= GetID("Hospital") then
		if not f_MoveTo("", "Hospital", GL_MOVESPEED_RUN) then
			return false
		end
	end
	
	local	Done
	local	Result
	
	Result, Done = Transfer("", "", INVENTORY_STD, "Hospital", INVENTORY_STD, "MiracleCure", 99)
	if Done > 0 then
		return true
	end
	
	local ItemId = ItemGetID("MiracleCure")
	local CuresInCounter = GetProperty("Hospital","Salescounter_"..ItemId) or 0
	local InvSpace = GetRemainingInventorySpace("","MiracleCure",INVENTORY_STD)
	if CuresInCounter > 0 then
		local TransferItems = math.min(InvSpace, CuresInCounter)
		AddItems("","MiracleCure",TransferItems)
		SetProperty("Hospital","Salescounter_"..ItemId,(CuresInCounter-TransferItems))
		return true
	end
		
	return false
end

function CleanUp()
	StopAnimation("")
	StopAction("quacksalver", "")
end


