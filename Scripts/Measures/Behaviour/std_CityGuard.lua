function Run()

	local Player = false
	if GetSettlement("","Settlement") then	
		if GetOfficeTypeHolder("Settlement", 2 ,"Office") then		-- 2 = sheriff
			Player = DynastyIsPlayer("Office")
		end
		
		if not Player then
			if Rand(100) < 15 then
				if CityGetNearestBuilding("Settlement", "", -1, GL_BUILDING_TYPE_WORKER_HOUSING, -1, -1, FILTER_IGNORE, "WorkerHut") then
					if GetDistance("", "WorkerHut") < 10000 then
						MsgDebugMeasure("CityGuard going home and wait")
						f_MoveTo("", "WorkerHut", GL_MOVESPEED_RUN)
						MsgDebugMeasure("CityGuard wait at home")
						Sleep(60)
						return
					end
				end
			end
			
			local Time = math.mod(GetGametime(),24)
			if Time > 20 or Time < 4 then
				if Rand(10) < 3 then
					idlelib_GoToTavern(8)
					return
				end
			end

			AIExecutePlan("", "CityGuard", "SIM", "", "dynasty", "ServantDynasty")
			return
		end
	else
		PlayAnimation("","cogitate")
	end
	
	Sleep(Rand(20)+12)
end
