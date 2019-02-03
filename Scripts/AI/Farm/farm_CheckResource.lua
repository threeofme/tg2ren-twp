function Weight()

	if SimGetWorkingPlace("SIM", "WorkBuilding") then
		-- alles ok
	elseif IsPartyMember("SIM") then
			local NextBuilding = ai_GetNearestDynastyBuilding("SIM",2,GL_BUILDING_TYPE_FARM)
			if not NextBuilding then
				return 0
			end
			CopyAlias(NextBuilding,"WorkBuilding")
	else
	    return 0
	end
	
	if not ReadyToRepeat("WorkBuilding", "AI_CR") then
		return 0
	end
	
	local	CheckResources = { "Wheat", "Flachs", "Vieh" }
	local	Resource
	local	ItemID
	local	Check = 1
	local Distance
	local Proto
	local Capacity
	
	if not BuildingGetOwner("WorkBuilding", "BuildOwner") then
		return 0
	end
	
	if not BuildingGetCity("WorkBuilding", "BuildCity") then
		return 0
	end
	
	SetData("daTown","BuildCity")
	
	SetRepeatTimer("WorkBuilding", "AI_CR", 0.25)
		
	while CheckResources[Check] do

		Resource	= CheckResources[Check]
		ItemID		= ItemGetID(Resource)
		Proto			= FindResourceProto(ItemID)
		SetData("Proto", Proto)
		
		if ReadyToRepeat("WorkBuilding", "AI_CR_"..ItemID) then

			SetRepeatTimer("WorkBuilding", "AI_CR_"..ItemID, 2)
		
			if AliasExists("ResourceAlias") then
				RemoveAlias("ResourceAlias")
			end
				
			Capacity = ResourceFind("WorkBuilding",Resource,"ResourceAlias", true)
			
			if AliasExists("ResourceAlias") then
				-- resource found
				-- check for owner
				if BuildingGetOwner("ResourceAlias","ResourceOwner") then
					if GetDynastyID("")==GetDynastyID("ResourceOwner") then
						if ResourceGetItemId("ResourceAlias")<1 then
							if Proto == 618 then
								SetData("ToDo", "RaiseCattle")
							else
								SetData("ToDo", "SowField")
							end
							SetData("ItemID", ItemID)
							SetRepeatTimer("WorkBuilding", "AI_CR_"..ItemID, 3)
							return 100
						else
							return
						end
					end
				end

				Distance = GetDistance("ResourceAlias", "WorkBuilding")
				if Distance<4000 and GetCurrentMeasureID("ResourceAlias")<1 then
					
					if not BuildingGetOwner("ResourceAlias","ResourceOwner") or GetState("ResourcaAlias", STATE_SELLFLAG) then
					--if GetState("ResourceAlias",STATE_SELLFLAG) == true or  GetImpactValue("ResourceAlias", 296) > 0 then
						SetData("ToDo", "Buy")
						SetData("ItemID", ItemID)
						return 100
					end
						
					if ResourceGetItemId("ResourceAlias")<1 then
						if Proto == 618 then
							SetData("ToDo", "RaiseCattle")
						else
							SetData("ToDo", "SowField")
						end
						SetData("ItemID", ItemID)
						SetRepeatTimer("WorkBuilding", "AI_CR_"..ItemID, 3)
						return 100
					end
				else
					if Proto>0 then
						RemoveAlias("ResourceAlias")
						SetData("ToDo", "BuildNew")
						SetData("ItemID", ItemID)
						SetRepeatTimer("WorkBuilding", "AI_CR_"..ItemID, 3)
						return 100
					end	
				end
			else
				if Proto>0 then
					RemoveAlias("ResourceAlias")
					SetData("ToDo", "BuildNew")
					SetData("ItemID", ItemID)
					SetRepeatTimer("WorkBuilding", "AI_CR_"..ItemID, 3)
					return 100
				end
			end
		end
		Check = Check + 1
	end
	return 0
end

function Execute()

	local Proto
	local MinDistance
	local Done
	local checkTown = GetData("daTown")
	local ItemID = GetData("ItemID")

	local	ToDo = GetData("ToDo")
	
	if ToDo == "BuildNew" then

		Proto = GetData("Proto")
		if not CityBuildNewBuilding(checkTown, Proto, "BuildOwner", "ResourceAlias", "WorkBuilding") then
			if not AliasExists("ResourceAlias") then
				return
			end
			if not BuildingBuy("ResourceAlias", "BuildOwner", BM_STARTUP) then
				return
			end
		else
			local x = 1
		end
        if Proto == 618 then
		    ToDo = "RaiseCattle"
		else
		    ToDo = "SowField"
		end
	elseif ToDo == "Buy" then

		Proto	= GetData("Proto")
		Done 	= false
		MinDistance = GetDistance("ResourceAlias", "WorkBuilding")
		
		if MinDistance>0 then
			if not BuildingBuy("ResourceAlias", "BuildOwner", BM_STARTUP) then
				Done = false
			else
				Done = true
			end
		end
		
		if not Done then
			if not CityBuildNewBuilding(checkTown, Proto, "BuildOwner", "ResourceAlias", "WorkBuilding") then
				return
			end
		end
		
		if Proto == 618 then
			ToDo = "RaiseCattle"
		else
			ToDo = "SowField"
		end
	end
	
	if ToDo == "SowField" then
		MeasureCreate("Measure")
		local	Entry = ResourceGetEntry("ResourceAlias", ItemID)
		local MeasureName = ResourceGetMeasureID("ResourceAlias", ItemID)
		if not MeasureName then
			MeasureName = "SowField"
		end
		MeasureAddData("Measure", "Selection", Entry)
		MeasureStart("Measure", "SIM", "ResourceAlias", MeasureName)
		return
	elseif ToDo == "RaiseCattle" then
		if HasProperty("ResourceAlias","ToBeSowed") then
			return
		else
			SetProperty("ResourceAlias","ToBeSowed",1)
		end
		MeasureCreate("Measure")
		local Entry = ResourceGetEntry("ResourceAlias", ItemID)
		local MeasureName = ResourceGetMeasureID("ResourceAlias", ItemID)
		if not MeasureName then
			MeasureName = "RaiseCattle"
		end
		MeasureAddData("Measure", "Selection", Entry)
		MeasureStart("Measure", "SIM", "ResourceAlias", MeasureName)
		return
	end
	
end

