function Run()
	-- ms_092_SingForPeacefulness.lua active
	if (GetImpactValue("", "Peaceful") ~= 0) then
		StopMeasure("") 
		return
	end		
	if not AliasExists("Destination") then
		return
	end
	BlockChar("Destination")
	gameplayformulas_SimAttackWithRangeWeapon("", "Destination")
	-- in some cases there could be an error. therefore the check is implemented twice
	if not AliasExists("Destination") then
		return
	end
	local iBattleID = BattleJoin("","Destination", true)
end

