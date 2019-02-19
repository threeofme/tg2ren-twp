function Weight()

	if GetMeasureRepeat("SIM", "UseAntidote") > 0 then
		return 0
	end
	
	if GetState("SIM", STATE_POISONED) then
		if ai_CanBuyItem("SIM", "Antidote") < 0 then
			return 0
		end
		
		if GetMoney("SIM") < 1000 then
			return 0
		end
		
		local Difficulty = ScenarioGetDifficulty()
		if Difficulty < 2 then
			return 0
		else
			return 100
		end
	end
	
	return 0
end


function Execute()
	MeasureRun("SIM", nil, "UseAntidote")
end

