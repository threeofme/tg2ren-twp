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
	if 5 <= Time and Time <= 21 then
		return 0
	end
		
	return 50
end

function Execute()
	roguelib_BurgleBuilding("SIM", "WorkBuilding")
end

