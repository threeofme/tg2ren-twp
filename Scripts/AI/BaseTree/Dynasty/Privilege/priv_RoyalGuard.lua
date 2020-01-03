function Weight()
	if GetImpactValue("SIM", "RoyalGuard")==0 then
		return 0
	end
	
	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("RoyalGuard")) > 0 then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureRun("SIM", nil, "RoyalGuard")
end

