function Run()
	if Rand(100) < 5 then
		if GetNearestSettlement("", "City") then
			if CityGetNearestBuilding("City", "", -1, GL_BUILDING_TYPE_WORKER_HOUSING, -1, -1, FILTER_IGNORE, "WorkerHut") then
				if GetDistance("", "WorkerHut") < 6000 then
					MsgDebugMeasure("EliteGuard going home and wait")
					f_MoveTo("", "WorkerHut", GL_MOVESPEED_RUN)
					MsgDebugMeasure("EliteGuard wait at home")
					Sleep(60)
					return
				end
			end
		end
	end
	
	AIExecutePlan("", "EliteGuard", "SIM", "", "dynasty", "dynasty")
end
