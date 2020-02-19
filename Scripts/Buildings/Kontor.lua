--
-- OnLevelUp is called everytime the building level was changed, even when the building is build the first time.
-- This function is called bevor Setup
-- attention: this function call is unscheduled
--


function OnLevelUp()

	local Water = 0
	SetProperty("","WaterKontor",0)
	GetPosition("", "Position")
	GetLocatorByName("", "Entry1", "PositionEntry")	
	if (BuildingFindWaterPos("Position","PositionEntry","PosWater")) then
		if (GetOutdoorMovePosition(nil, "", "PosGround")) then
			BuildingSetWaterPos("", "PosWater", "PosGround")
			SetProperty("","WaterKontor",1)
			Water = 1
			return true
		end
	end
	
	if Water == 1 and GetState("",STATE_MARINECONTROL)==false then
		SetState("",STATE_MARINECONTROL,true)
	elseif Water == 0 and GetState("",STATE_TRADERCONTROL)==false then
		SetState("",STATE_TRADERCONTROL,true)
	end
	
	if not ScenarioFindPosition("", 2250, EN_POSTYPE_WATER, 600, nil, nil, nil, "PosWater") then
		return false
	end
	BuildingSetWaterPos("", "PosWater")
end

--
-- Setup is called after the building is build. The function is called after OnLevelUp
-- attention: this function call is unscheduled
--
function Setup()
	SetProperty("","WaterKontor",0)
	GetPosition("", "Position")
	GetLocatorByName("", "Entry1", "PositionEntry")	
	if (BuildingFindWaterPos("Position","PositionEntry","PosWater")) then
		if (GetOutdoorMovePosition(nil, "", "PosGround")) then
			SetProperty("","WaterKontor",1)
		end
	end
	MeasureRun("", nil, "KontorMeasure")
end

--
-- PingHour is called every full hour (ingame)
-- attention: this function call is unscheduled
--
function PingHour()
	if GetCurrentMeasureName("") ~= "KontorMeasure" then
		MeasureRun("", nil, "KontorMeasure")
	end
end
