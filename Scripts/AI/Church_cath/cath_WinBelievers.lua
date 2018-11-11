function Weight()
	if GetMeasureRepeat("dynasty", "WinBelievers") > 0 then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "AI_WinBelievers") then
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
	
	if not ai_GetWorkBuilding("SIM", GL_BUILDING_TYPE_CHURCH_CATH, "Church") then
		return 0
	end
	
	if not BuildingHasUpgrade("Church", "Feretory") then
		return 0
	end
	
	if BuildingGetProducerCount("Church", PT_MEASURE, "WinBelievers") > 0 then
		return 0
	end
	
	local Hour = math.mod(GetGametime(), 24)
	local	Last = BuildingGetWorkingEnd("church") - 2
	if Hour > Last or Hour<10 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("dynasty", "AI_WinBelievers", 24)
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("WinBelievers"))
end

