function Weight()
	if not GetHomeBuilding("SIM", "home") then
		return 0
	end
	
	if not BuildingGetCity("home", "city") then
		return 0
	end
	
	local simclass = SimGetClass("SIM")
	local simrel = SimGetReligion("SIM")
	
	local n = CityGetBuildingCountForCharacter("city", simclass, simrel, FILTER_IS_BUYABLE)
	local m = CityGetBuildingCountForCharacter("city", simclass, simrel, FILTER_NO_DYNASTY)
  
	return (n * 10) + (m * 10) 
end

function Execute()
	ai_BuyRandomWorkshop("SIM")
end