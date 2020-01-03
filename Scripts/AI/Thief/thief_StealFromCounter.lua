function Weight() 
	--LogMessage("::TOM::Thief::"..GetName("SIM").." Weight for burgle")
	if not SimGetWorkingPlace("SIM", "WorkBuilding") then
		return 0
	end
	
	if BuildingGetLevel("WorkBuilding") < 2 then	
		return false
	end

	if GetHPRelative("SIM") < 0.7 then
		return 0
	end
	
	local Time = math.mod(GetGametime(), 24)
	if 8 <= Time and Time <= 18 then
		return 20
	end
	
	return 0
end

function Execute()
	roguelib_StealFromCounter("SIM", "WorkBuilding")
end

