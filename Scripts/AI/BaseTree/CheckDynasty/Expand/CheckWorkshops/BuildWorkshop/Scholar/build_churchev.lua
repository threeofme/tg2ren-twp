function Weight()
	if not SimGetReligion == RELIGION_EVANGELIC then
		return 0
	end
	local Count = CityGetBuildingCount("HomeCity", -1, GL_BUILDING_TYPE_CHURCH_EV)
	local CityLevel = CityGetLevel("HomeCity")
	return (CityLevel - 1) - Count
end

function Execute()
	ai_BuildNewWorkshop("SIM", GL_BUILDING_TYPE_CHURCH_EV)
end