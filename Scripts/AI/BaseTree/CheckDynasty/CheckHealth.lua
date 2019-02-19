function Weight()

	local	Quote = GetHPRelative("SIM")
	-- Check illness
	if GetImpactValue("","Sickness")>0 then
		return 100
	end
	
	-- Check HP damage
	if Quote >= 0.95 then
		return 0
	end
	
	if not AliasExists("City") then
		if not GetSettlement("SIM", "City") then
			return 0
		end
	end
	
	if not CityGetNearestBuilding("City", "SIM", -1, GL_BUILDING_TYPE_LINGERPLACE, -1, -1, FILTER_IGNORE, "LingerPlace") then
		return 0
	end
	
	return 100
end


function Execute()
	if GetImpactValue("","Sickness")>0 then
		MeasureRun("SIM", nil, "AttendDoctor")
	else
		MeasureRun("SIM", "LingerPlace", "Linger")
	end
end

