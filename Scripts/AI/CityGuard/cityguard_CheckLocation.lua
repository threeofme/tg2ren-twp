function Weight()

	if not GetSettlement("SIM", "Settlement") then
		return 0
	end
	
	local Time = math.mod(GetGametime(),24)
	if Time > 20 or Time < 4 then
		if Rand(3) > 0 then
			return 0
		end
	end
	
	-- 2 = EN_OFFICETYPE_SHERIFF
	if GetOfficeTypeHolder("Settlement", 2, "Office") then
		if DynastyIsPlayer("Office") then
			return 0
		end
	end
	return 100
end

function Execute()
	MeasureRun("SIM", nil, "CheckLocation")
end

