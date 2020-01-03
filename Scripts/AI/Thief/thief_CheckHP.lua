function Weight()
	--LogMessage("::TOM::Thief::"..GetName("SIM").." Weight for checkHP")
	
	if not SimGetWorkingPlace("SIM", "WorkBuilding") then
		return 0
	end
	
	if GetHPRelative("SIM") < 0.7 then
		return 100
	end
end


function Execute()
	roguelib_Heal("SIM", "WorkBuilding")
end

