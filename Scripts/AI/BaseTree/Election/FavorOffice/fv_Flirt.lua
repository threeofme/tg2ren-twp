function Weight()
	
	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("Flirt")) > 0 then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "ai_Compliment"..GetID("Target")) then
		return 0
	end
	
	if SimGetGender("Target") == SimGetGender("SIM") then
		return 0
	end
	
	if GetSkillValue("SIM", RHETORIC) < 3 then
		return 0
	end

	return 100
end

function Execute()
	SetRepeatTimer("SIM", "ai_Compliment"..GetID("Target"), 4)
	MeasureRun("SIM", "Target", "Flirt", true)
end
