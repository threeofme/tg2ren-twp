function Weight()
	local Count = CityGetBuildingCount("HomeCity", -1, GL_BUILDING_TYPE_STONEMASON)
	local CityLevel = CityGetLevel("HomeCity")
	return (CityLevel - 1) - Count
end

function Execute()
	ai_BuildNewWorkshop("SIM", GL_BUILDING_TYPE_STONEMASON)
end