function Weight()
	
	if not ReadyToRepeat("dynasty", "AI_LearnAtHome") then
		return 0
	end

	if not GetHomeBuilding("SIM", "home") then
		return 0
	end
	
	if BuildingGetType("home")~=GL_BUILDING_TYPE_RESIDENCE then
		return 0
	end
	
	if GetInsideBuildingID("SIM") == -1 then
		if GetDistance("SIM", "home") > 10000 then
			return 0
		end
	end
	
	return 15
end

function Execute()
	SetRepeatTimer("dynasty", "AI_LearnAtHome", 1)	
	if f_MoveTo("SIM", "home", GL_MOVESPEED_RUN) then
		SetRepeatTimer("dynasty", "AI_LearnAtHome", 8)	
		MeasureRun("SIM", nil, "Train")
		return
	end
end
