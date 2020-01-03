function Weight()
	local CityLevel = CityGetLevel("HomeCity")
	local Count = CityGetBuildingCount("HomeCity", -1, GL_BUILDING_TYPE_TAILORING)
	return math.max(0, ((CityLevel - 1) - Count))
end

function Execute()
	ai_BuildNewWorkshop("SIM", GL_BUILDING_TYPE_TAILORING)
end