function Weight()
	if not AliasExists("SIM") then
		return 0
	end

	if SimGetChildCount("SIM") >= 2 then
		-- I've got enough children to survive
		return 0
	end

	if not FindNearestBuilding("SIM", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, false, "WeddingChapel") then
		return 0
	end
	
	if not GetHomeBuilding("SIM", "Home") then
		return 0
	end

	if BuildingGetType("Home")==GL_BUILDING_TYPE_RESIDENCE then
		if SimGetAge("SIM") < 40 and SimGetAge("Spouse") < 40 then
			-- I have a residence home, so I can make my own children.
			return 0
		end
	end
	
	local time = math.mod(GetGametime(),24)
	if time < 8 then
		return 0
	end
	
	return 5
end

function Execute()
	MeasureRun("SIM", "WeddingChapel", "AdoptOrphan", false)
end
