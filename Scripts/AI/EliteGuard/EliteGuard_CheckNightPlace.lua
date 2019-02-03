function Weight()

	if not GetSettlement("SIM", "Settlement") then
		return 0
	end
	
	if Rand(10) == 0 then
		if not CityGetRandomBuilding("Settlement", 5, -1, -1, -1, FILTER_IGNORE, "NightPlace") then
			return 0
		end
	else
		if not CityGetRandomBuilding("Settlement", 3, -1, -1, -1, FILTER_IGNORE, "NightPlace") then
			return 0
		end
	end
	
	local Time = math.mod(GetGametime(),24)
	if Time < 6 or Time > 22 then
		return 100
	end
	
	return 0
end

function Execute()
	if Rand(3) == 0 then
		MeasureRun("SIM", "NightPlace", "CheckLocation", true)
	else
		if CityGetNearestBuilding("Settlement", "SIM", -1, GL_BUILDING_TYPE_WORKER_HOUSING, -1, -1, FILTER_IGNORE, "WorkerHut") then
			if GetDistance("SIM", "WorkerHut") < 12000 then
				MsgDebugMeasure("CityGuard going home and wait")
				f_MoveTo("SIM", "WorkerHut", GL_MOVESPEED_RUN)
				MsgDebugMeasure("CityGuard wait at home")
				Sleep(120)
				return
			end
		end
	end
end

