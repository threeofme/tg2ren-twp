function Run()

	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_PIRAT, "WorkBuilding") then
		StopMeasure() 
		return
	end 

	if not GetSettlement("WorkBuilding", "City") then
		return
	end
	
	if not BuildingGetOwner("WorkBuilding","MyBoss") then
		return
	end
	
	local result = 0
	
	if IsStateDriven() then
		if DynastyIsPlayer("MyBoss") then
			if BuildingGetAISetting("WorkBuilding", "Produce_Selection")>0 then
				-- For the AI
				result = 1+Rand(4)
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
		if not result or result == "C" then
			StopMeasure()
		end
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
	
	if GetInsideBuilding("","InsideBuilding") then
		f_ExitCurrentBuilding("")
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
	SetProperty("","CocotteHasClient",0)
	SetProperty("","CocotteProvidesLove",1)
	
	-- start the labor
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)

	while true do
		
		-- only move if destination is far enough
		if GetDistance("","Destination")>450 then
			-- Startlocation
			local startloc = Rand(300)+50
			if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,startloc) then
				return
			end
		end
		
		-- Timeout
		if not SimIsWorkingTime("") then
			StopMeasure()
			break
		end
				
		-- some animation stuff
		local SimFilter = "__F( (Object.GetObjectsByRadius(Sim)==500)AND(Object.HasDifferentSex())AND(Object.GetState(idle))AND NOT(Object.GetState(townnpc))AND(Object.MinAge(16))AND(Object.CanBeInterrupted(UseLaborOfLove))AND NOT(Object.HasImpact(FullOfLove)))"
		local NumSims = Find("",SimFilter,"Sims",-1)
		-- Found someone?
		if NumSims > 0 then
			local DestAlias = "Sims"..Rand(NumSims-1)
			AlignTo("",DestAlias)
			Sleep(1)
			local AnimTime = PlayAnimationNoWait("","point_at")
			MsgSayNoWait("","@L_PIRATE_LABOROFLOVE_PROPOSE")
			Sleep(AnimTime)
			-- Try to attract him. Bonus for high charisma.
			if Rand(101)>(50-GetSkillValue("",CHARISMA)) then
				MeasureRun(DestAlias,"","UseLaborOfLove")
			else
				AddImpact(DestAlias,"FullOfLove",1,4)
			end
		else
			-- Nobody found, find a new place
			if not GetSettlement("", "City") then
				return
			end
			-- Find a place with people
			if GetSettlement("", "City") and f_CityFindCrowdedPlace("City", "", "Destination") > 0 then
				-- Check if place is too far away from starting position. If that is the case, return to starting position
				if AliasExists("MarketPos") then
					if (GetDistance("MarketPos", "Destination") >= 1500) then
						CopyAlias("MarketPos", "Destination")
					end
				elseif AliasExists("CityHallPos") then
					if (GetDistance("CityHallPos", "Destination") >= 1500) then
						CopyAlias("CityHallPos", "Destination")
					end
				elseif AliasExists("TavernPos") then
					if (GetDistance("TavernPos", "Destination") >= 1500) then
						CopyAlias("TavernPos", "Destination")
					end
				elseif AliasExists("ChurchPos") then
					if (GetDistance("ChurchPos", "Destination") >= 1500) then
						CopyAlias("ChurchPos", "Destination")
					end
				else
					CopyAlias("Workbuilding", "Destination")
				end
			end
		end
		Sleep(3)
	end
	
	StopMeasure()
end

function CleanUp()
	StopAnimation("")
	RemoveProperty("","CocotteProvidesLove")
end


