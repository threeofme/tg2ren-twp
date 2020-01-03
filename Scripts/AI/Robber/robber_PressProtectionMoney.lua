function Weight()
	if IsDynastySim("SIM") then
		return 0
	end
	
	if not GetSettlement("SIM", "PPM_CITY") then
		return 0
	end
	
	if not ReadyToRepeat("SIM", GetMeasureRepeatName2("PressProtectionMoney")) then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM","PresserHome") then
		return 0
	end
	
	if not ReadyToRepeat("PresserHome", "AI_PRESS") then
		return 0
	end
	
	
	local Count = CityGetBuildings("PPM_CITY", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_ISNOT_BUYABLE, "PPM_BUILD")
	if Count < 1 then
		return 0
	end
	
	local Alias
	local	Value
	local	BestValue = 0
	local	BestAlias
	
	for l=0,Count-1 do
		Alias	= "PPM_BUILD"..l
		if DynastyGetDiplomacyState(Alias, "SIM") <= DIP_NEUTRAL then
			Value = chr_GetBootyCount(Alias)
			if Value > BestValue then
				BestValue = Value
				BestAlias = Alias
			end
		end
	end
	
	if not BestAlias then
		return 0
	end
	
	if not ReadyToRepeat(BestAlias, "AI_PRESSED") then
		return 0
	end
	
	if GetImpactValue(BestAlias, "buildingburgledtoday")>0 then
		return 0
	end
	
	if HasProperty(BestAlias, "RobberProtected") then
		return 0
	end
	
	CopyAlias(BestAlias, "PPM_DEST")

	return 100
end

function Execute()
	SetRepeatTimer("PresserHome", "AI_PRESS", 2)
	SetRepeatTimer("PPM_DEST","AI_PRESSED",8)
	MeasureRun("SIM","PPM_DEST","PressProtectionMoney")
end

