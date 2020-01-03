function Weight()
	local Hour = math.mod(GetGametime(), 24)
	if Hour > 5 then
		if Hour < 22 then
			return 0
		end
	end

	if IsDynastySim("SIM") then
		return 0
	end
	
	if SimGetAge("SIM")<16 then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM","PlunderHome") then
		return 0
	end
	
	if not ReadyToRepeat("PlunderHome", "AI_PLUNDER") then
		return 0
	end
	
	for trys=0,9 do
		if robber_plunder_Check() then
			return 100
		end
	end
	return 0
end

function Check()
	
	if not GetSettlement("SIM","City") then
		return false
	end
	
	if not CityGetRandomBuilding("City", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_HAS_DYNASTY, "PLU_BUILD") then
		return false
	end
	
	if GetState("PLU_BUILD",STATE_BUILDING) then
		return false
	end
	
	if not BuildingGetOwner("PLU_BUILD", "VictimOwner") then
		return false
	end
	
	if GetDynastyID("SIM") == GetDynastyID("VictimOwner") or DynastyGetDiplomacyState("SIM", "VictimOwner") > DIP_NEUTRAL then
		return false
	end
	
	if GetImpactValue("PLU_BUILD","buildingburgledtoday")==1 then
		return false
	end

	return true
end

function Execute()
	SetRepeatTimer("PlunderHome", "AI_PLUNDER", 2)
	MeasureRun("SIM","PLU_BUILD","PlunderBuilding")
end

