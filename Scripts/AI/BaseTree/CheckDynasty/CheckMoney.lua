function Weight()
	local Money = GetMoney("SIM")
	local Difficulty = ScenarioGetDifficulty()
	
	if Difficulty <3 then
		return 0
	end
	
	if not DynastyIsShadow("SIM") then
		return 0
	end
	
	if Money < 1000 then
		return 100
	else
		return 0
	end
	
end

function Execute()
	MeasureRun("SIM", nil, "Bricklebrit", false)
end
