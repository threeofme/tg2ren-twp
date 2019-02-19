function Weight()
	local Count = ScenarioGetObjects("cl_Settlement", 99, "Cities")
	if Count<1 then
		return 0
	end
	
	local	Value = Rand(Count)
	
	if not CityGetRandomBuilding("Cities"..Value, 0, GL_BUILDING_TYPE_HARBOR, -1, -1, FILTER_IGNORE, "Harbor") then
		return 0
	end
	
	--return 30
	return 0
end

function Execute()
	MeasureRun("SHIP", "Harbor", "Walk")
end
