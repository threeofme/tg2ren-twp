function Weight()

	local Difficulty = ScenarioGetDifficulty()
	
	if Difficulty <2 then
		return 0
	end
	
	if not DynastyGetRandomBuilding("SIM", -1, 12, "Mine") then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "MineGuards")>0 then
		return 0
	end
	
	if not ReadyToRepeat("Mine", "AI_MineGuards") then
		return 0
	end
	
	if Rand(4) > 0 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("Mine", "AI_MineGuards", 24)	
	MeasureRun("SIM", nil, "MineGuards", false)
end

