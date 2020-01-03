function Weight()
	--LogMessage("::TOM::Thief::"..GetName("SIM").." Weight for Pickpocket")
	if not SimGetWorkingPlace("SIM", "WorkBuilding") then
		return 0
	end

	if GetHPRelative("SIM") < 0.7 then
		return 0
	end
	
	local Time = math.mod(GetGametime(), 24)
	if 5 <= Time and Time <= 21 then
		return 50
	end
	
	return 10
end

function Execute()
	roguelib_Pickpocket("SIM", "WorkBuilding")
end


