function Weight()

	if GetMoney("SIM") < 5000 then
		return 0
	end
	
	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("BribeCharacter")) > 0 then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "AI_Bribe"..GetID("Target")) then
		return 0
	end
	if not ReadyToRepeat("Target", "AI_Bribe_Target") then
		return 0
	end
	
	return 100
end


function Execute()
	SetRepeatTimer("SIM", "AI_Bribe"..GetID("Target"), 12)
	SetRepeatTimer("Target", "AI_Bribe_Target", 12)
	MeasureRun("SIM", "Target", "BribeCharacter", false)
end

