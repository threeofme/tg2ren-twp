function Weight()
	
	-- only important shadows attack enemies
	if DynastyIsShadow("SIM") then
		if SimGetOfficeLevel("SIM")<0 then
			if DynastyGetBuildingCount2("SIM") == 0 then
				return 0
			end
		end
	end
	
	if not ReadyToRepeat("SIM", "AI_AttackRogue") then
		return 0
	end
	
--	if DynastyIsShadow("SIM") and DynastyIsShadow("Victim") then
--		return 0
--	end
	
	-- TODO
	return 0
end

function Execute()
	SetRepeatTimer("SIM", "AI_AttackRogue", 8)
end