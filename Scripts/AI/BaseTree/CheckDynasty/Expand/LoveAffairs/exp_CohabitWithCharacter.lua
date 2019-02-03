function Weight()
	if SimGetGender("SIM")==GL_GENDER_MALE then
		return 0
	end
	
	if SimGetAge("SIM") < 16 or SimGetAge("SIM") > 40 then
		return 0
	end

	if not SimGetSpouse("SIM", "Spouse") or SimGetAge("Spouse") > 40 then
		return 0
	end

	if not ReadyToRepeat("dynasty", "AI_CohabitWithCharacter") then
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

	local Count = SimGetChildCount("SIM")
	local MaxChilds = 1 + Rand(4)
	
	if DynastyIsShadow("SIM") then
		MaxChilds = 1
	end
	
	if SimGetChildCount("SIM") < MaxChilds then
		if Rand(4) > 0 then
			return 100
		end
	end

	return 0
end

function Execute()
	if not AliasExists("Spouse") then
		if not SimGetSpouse("SIM", "Spouse") then
			return
		end
	end
	
	SetRepeatTimer("dynasty", "AI_CohabitWithCharacter", 24)
	MeasureRun("SIM", "Spouse", "CohabitWithCharacter")
end
