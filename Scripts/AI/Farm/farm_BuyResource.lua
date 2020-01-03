function Weight()
	
	local Found
	
	if DynastyIsPlayer("SIM") then
		return 0
	end
	
	GetDynasty("SIM","MyDyn")
	
	if DynastyGetBuildingCount("MyDyn",6,33)>3 then
		return 0
	end
	
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
	
	local FeedlotFilter = "__F((Object.GetObjectsByRadius(Building)==3000)AND(Object.IsType(33))AND(Object.IsBuyable())AND NOT(Object.BelongsToMe()))"
	Found = Find("WorkBuilding",FeedlotFilter,"ToBuy",-1)
	
	if Found>0 then
		return 100
	else
		return 0
	end
end

function Execute()
	BuildingBuy("ToBuy0", "SIM", BM_STARTUP)
end