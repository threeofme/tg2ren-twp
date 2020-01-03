function Weight()

	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("RemovePamphlet")) > 0 then
		return 0
	end

	if not GetSettlement("SIM","BlackBoardCity") then
		return 0
	end
	
	if not CityGetRandomBuilding("BlackBoardCity",-1,41,-1,-1,FILTER_IGNORE,"BlackBoard") then
		return 0
	end
	
	for i=0,3 do
		if HasProperty("BlackBoard","Pamphlet_"..i) then
			local PamphletID = GetProperty("BlackBoard","Pamphlet_"..i)
			if GetAliasByID(PamphletID,"PamphletVictim") then
				if (GetDynastyID("PamphletVictim") == GetDynastyID("SIM")) then
					return 100
				end
			end
		end
	end

	return 0
end

function Execute()
	MeasureCreate("Measure")
	MeasureStart("Measure", "SIM", "SIM", "RemovePamphlet")
end

