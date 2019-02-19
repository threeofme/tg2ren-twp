function Weight()
	if IsDynastySim("SIM") then
		return 0
	end
	
	if not GetSettlement("SIM", "PPM_CITY") then
		return 0
	end
	
	if not ReadyToRepeat("SIM", GetMeasureRepeatName2("OfferBuildingProtection")) then
		return 0
	end
	
	local Count
	if Rand(2) == 0 then
	    Count = CityGetBuildings("PPM_CITY", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_ISNOT_BUYABLE, "PPM_BUILD")
	else
	    Count = CityGetBuildings("PPM_CITY", 1, -1, -1, -1, FILTER_ISNOT_BUYABLE, "PPM_BUILD")
	end
	
	if Count < 1 then
		return 0
	end
	
	local Alias
	local	Value
	local	BestValue = 0
	local	BestAlias
	
	for l=0,Count-1 do
		Alias	= "PPM_BUILD"..l
		if DynastyGetDiplomacyState(Alias, "SIM") >= DIP_NEUTRAL then
	    if GetDynastyID("SIM") ~= GetDynastyID("PPM_BUILD"..l) then
		    Value = chr_GetBootyCount(Alias)
		    if Value > BestValue then
			    BestValue = Value
			    BestAlias = Alias
		    end
			end
		end
	end
	
	if not BestAlias then
		return 0
	end
	
	CopyAlias(BestAlias, "PPM_DEST")
	return 100
end

function Execute()
	SetProperty("SIM", "SpecialMeasureDestination", GetID("PPM_DEST"))
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("OfferBuildingProtection"))
end

