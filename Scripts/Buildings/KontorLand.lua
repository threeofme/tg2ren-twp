function OnLevelUp()
end

function Setup()

	if worldambient_CheckAmbient()==true then
		if BuildingGetLevel("") == 2 then
			worldambient_CreateKontorSim("",2)
		elseif BuildingGetLevel("") == 3 then
			worldambient_CreateKontorSim("",3)
		elseif BuildingGetLevel("") == 4 then
			worldambient_CreateKontorSim("",1)
		end
	end
	
	if GetState("",STATE_TRADERCONTROL)==false then
		SetState("",STATE_TRADERCONTROL,true)
	end

	MeasureRun("", nil, "KontorMeasure")
end

function PingHour()
	if GetCurrentMeasureName("") ~= "KontorMeasure" then
		MeasureRun("", nil, "KontorMeasure")
	end
end
