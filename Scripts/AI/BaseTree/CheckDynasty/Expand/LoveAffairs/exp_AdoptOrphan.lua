function Weight()
	
	local Count = SimGetChildCount("SIM")
	local MaxChilds = 1 + Rand(4)
	
	if DynastyIsShadow("SIM") then
		MaxChilds = 1
	end
	
	if SimGetSpouse("SIM", "Spouse") then
		if Count >= MaxChilds and SimGetChildCount("Spouse") >= MaxChilds then
			return 0
		end
	else
		return 0
	end
	
	if not FindNearestBuilding("SIM", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, false, "WeddingChapel") then
		return 0
	end
	
	if GetHomeBuilding("SIM", "Home") then
		if BuildingGetType("Home")==GL_BUILDING_TYPE_RESIDENCE then
			if SimGetAge("SIM") < 40 and SimGetAge("Spouse") < 40 then
				-- I have a residence home, so I can make my own children.
				return 0
			end
		end
	else
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "AI_AdoptOrphan") then
		return 0
	end
	
	local time = math.mod(GetGametime(),24)
	if time < 8 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("dynasty", "AI_AdoptOrphan", 24)
	MeasureRun("SIM", "WeddingChapel", "AdoptOrphan", false)
end
