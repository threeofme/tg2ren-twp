function Run()
	if not ms_aidonothing_MoveToHome() then
		return
	end
	local		Time = Rand(20)+5
	Sleep(Time)
end

function MoveToHome()
	if not DynastyIsShadow("") then
		return true
	end
	
	if GetHomeBuilding("", "Home") then
		if GetInsideBuildingID("")==GetID("Home") then
			return true
		end
		return f_MoveTo("", "HomeBuilding", GL_MOVESPEED_WALK)
	end
	
	if GetInsideBuilding("", "InsideBuilding") then
		if BuildingGetClass("InsideBuilding")==GL_BUILDING_CLASS_LIVINGROOM then
			if GetDynastyID("InsideBuilding")<1 or GetDynastyID("InsideBuilding")==GetDynastyID("") then
				return true
			end
		end
	end
	
	-- search for a building to disappear
	
	if not GetSettlement("", "City") then
		return false
	end
	
	if not CityGetRandomBuilding("City", GL_BUILDING_TYPE_HOUSING, GL_BUILDING_TYPE_RESIDENCE, -1, -1, FILTER_IGNORE, "Home") then
		return false
	end
	
	return f_MoveTo("", "Home", GL_MOVESPEED_WALK)
end
