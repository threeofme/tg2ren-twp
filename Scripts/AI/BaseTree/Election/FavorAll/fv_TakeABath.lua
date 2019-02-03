function Weight()	
	
	if GetMoney("dynasty") < 2500 then
		return 0
	end
	
	if GetImpactValue("SIM", "perfume") > 0 then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "ai_Bath") then
		return 0
	end
	
	if not GetSettlement("SIM", "MyCity") then
		return 0
	end
	
	-- find a tavern
	
	if not DynastyGetRandomBuilding("SIM", -1, GL_BUILDING_TYPE_TAVERN, "Tavern") then
		if not CityGetNearestBuilding("MyCity", "SIM", -1, GL_BUILDING_TYPE_TAVERN, 2, -1, FILTER_HAS_DYNASTY, "Tavern") then
			if not CityGetNearestBuilding("MyCity", "SIM", -1, GL_BUILDING_TYPE_TAVERN, 3, -1, FILTER_HAS_DYNASTY, "Tavern") then
				return 0
			end
		end
	end
			
	if not AliasExists("Tavern") then
		return 0
	end
	
	return 10
end

function Execute()
	SetRepeatTimer("dynasty", "ai_Bath", 12)
	MeasureRun("SIM", "Tavern", "TakeABathAlone")
end

