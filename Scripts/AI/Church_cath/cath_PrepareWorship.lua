function Weight()
	if GetMeasureRepeat("SIM", "PrepareWorship") > 0 then
		return 0
	end
	
	if IsDynastySim("SIM") then
		if SimGetClass("SIM")~=3 then
			return 0
		end
	end
	
	if SimGetAge("SIM")<16 then
		return 0
	end
	
	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_CHURCH_CATH, "Church") then
		return 0
	end
	
	if BuildingGetProducerCount("Church", PT_MEASURE, "PrepareWorship") > 0 then
		return 0
	end

	local Time = math.mod(GetGametime(), 24)
	if (Time >= 8 and Time <= 12) or (Time >= 18 and Time <= 22) then
		local WaitingFilter = "__F((Object.GetObjectsByRadius(Sim) == 2000))"
		local NumWaitSims = Find("Church", WaitingFilter, "WaitSim", -1)
		local Found = 0
		
		for i=0, NumWaitSims do
			if AliasExists("WaitSim"..i) then
				if GetCurrentMeasureName("WaitSim"..i) == "AttendMass" then
					Found = 1
					break
				end
			end
		end
		
		if Found > 0 then
			return 100
		end
	end
	
	return 0
end

function Execute()
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("PrepareWorship"))
end

