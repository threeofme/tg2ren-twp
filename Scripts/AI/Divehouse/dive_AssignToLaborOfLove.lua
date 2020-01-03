function Weight()

	if not GetSettlement("SIM", "City") then
		return 0
	end

	if IsDynastySim("SIM") then
		return 0
	end
	
	if not ai_GetWorkBuilding("SIM ", GL_BUILDING_TYPE_PIRAT, "MyWork") then
		return 0
	end

	if not HasProperty("MyWork", "ServiceActive") then
		return 0			
	end	

	if BuildingGetLevel("MyWork") > 1 then
		if not HasProperty("MyWork", "DanceShow") then
			return 33
		end	
	end

	return 100
end

function Execute()
	MeasureRun("SIM","MyWork","AssignToLaborOfLove",false)
end

