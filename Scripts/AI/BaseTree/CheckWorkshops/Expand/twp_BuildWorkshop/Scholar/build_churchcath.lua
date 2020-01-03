function Weight()
	if not SimGetReligion == RELIGION_CATHOLIC then
		return 0
	end
	local Count = CityGetBuildingCount("HomeCity", -1, GL_BUILDING_TYPE_CHURCH_CATH)
	local CityLevel = CityGetLevel("HomeCity")
	return math.max(0, ((CityLevel - 1) - Count))
end

function Execute()
	ai_BuildNewWorkshop("SIM", GL_BUILDING_TYPE_CHURCH_CATH)
end