function Weight()	
	local time = math.mod(GetGametime(),24)
	
	if time < 18 then
		return 0
	end
	
	if SimGetAge("SIM") < 18 then
		return 0
	end
	
	return 10
end

function Execute()
	if ai_GoInsideBuilding("SIM", "SIM", -1, GL_BUILDING_TYPE_TAVERN) then
		MeasureRun("SIM", nil, "RPGSitAround", false)
	end
end

