function Weight()

	if GetImpactValue("SIM", "DuelTimer") < 1 then
		return 0
	end
	
	-- it's too soon for an attack
	if ImpactGetMaxTimeleft("SIM", "DuelTimer") > 10 then
		return 0
	end
	
	if not HasProperty("SIM", "DuelOpponent") then
		return 0
	end
	
	local OpponentID = GetProperty("SIM", "DuelOpponent")
	GetAliasByID(OpponentID, "Victim")
	
	if not AliasExists("Victim") then
		return 0
	end
	
	if GetDistance("SIM", "Victim") > 8000 then
		return 0
	end
	
	if DynastyIsShadow("SIM") and DynastyIsShadow("Victim") then
		return 0
	end
	
	return 100
end

function Execute()
end