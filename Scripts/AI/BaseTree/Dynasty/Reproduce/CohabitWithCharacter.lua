function Weight()
	if not AliasExists("SIM") then
		return 0
	end

	if not GetHomeBuilding("SIM", "home") then
		return 0
	end
	
	if DynastyGetBuildingCount("SIM", 1, 2) < 1 then
		return 0
	end

	if GetStateImpact("Spouse", "no_control") then
		return 0
	end
	
	if not f_SimIsValid("Spouse") then
		return 0
	end
	
	if SimGetBehavior("Spouse")=="CheckPresession" or SimGetBehavior("Spouse")=="CheckTrial" then
		return 0
	end

	return 50
end

function Execute()
	if not AliasExists("Spouse") then
		if not SimGetSpouse("SIM", "Spouse") then
			return
		end
	end
	
	MeasureRun("SIM", "Spouse", "CohabitWithCharacter")
end
