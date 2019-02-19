function Weight()
	if IsDynastySim("SIM") then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM", "WFB_Place") then
		return 0
	end

	local Count = GetOutdoorLocator("ambush", -1, "Ambush")
	if (Count==0) or (Count==nil) then
		return 0
	end
	
	local	Alias
	local	Dist = -1
	local Location = nil
	local BestDist = 99999
	
	for l=0,Count-1 do
		Alias = "Ambush"..l
		Dist = GetDistance("WFB_Place", Alias)
		
		if not Location or Dist < BestDist then
			Location = Alias
			BestDist = Dist
		end
	end
	
	if not Location then
		return 0
	end
	
	CopyAlias(Location , "WFB_DEST")
	return 100
end

function Execute()
	SquadCreate("SIM", "SquadDanegeld", "WFB_DEST", "SquadDanegeldMember", "SquadDanegeldMember")
end

