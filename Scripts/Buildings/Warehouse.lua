--
-- CheckPosition is called everytime a new position is checked for a building of this kind
-- the only alias defined here is "Position", that represents the wanted position
-- return nil if the position ok else return the label of the error message
-- attention: this function call is unscheduled
--
function CheckPosition()

	--direct Line check 
	if (BuildingFindWaterPos("Position","PositionEntry","WaterPos")) then
		return nil
	end

	return nil
end

--
-- OnLevelUp is called everytime the building level was changed, even when the building is build the first time.
-- This function is called before Setup
-- attention: this function call is unscheduled
--
function OnLevelUp()

	GetPosition("", "Position")
	GetLocatorByName("", "Entry1", "PositionEntry")	
	if (BuildingFindWaterPos("Position","PositionEntry","PosWater")) then
		if (GetOutdoorMovePosition(NIL, "", "PosGround")) then
			BuildingSetWaterPos("", "PosWater", "PosGround")
			return true
		end
	end
	
	if ScenarioFindPosition("", 2250, EN_POSTYPE_WATER, 300, 750, EN_POSTYPE_GROUND, 100, "PosWater", "PosGround") then
		BuildingSetWaterPos("", "PosWater", "PosGround")
		return true
	end	
	
	-- no water found, this is a big problem
	bld_HandleOnLevelUp("")
	return false
end

--
-- Setup is called after the building is build. The function is called after OnLevelUp
-- attention: this function call is unscheduled
--
function Setup()
	if ScenarioFindPosition("", GL_WAREHOUSE_MAX_DISTANCE_HARBOR, EN_POSTYPE_WATER, 300, 750, EN_POSTYPE_GROUND, 100, "PosWater", "PosGround") then
		BuildingSetWaterPos("", "PosWater", "PosGround")
	end
	bld_HandleSetup("")
end

--
-- Run is called directly after the building is complete initialized.
-- this is a scheduled call, so you can loop an sleep
--
function Run()
end

--
-- PingHour is called every full hour (ingame)
-- attention: this function call is unscheduled
--
function PingHour()
	bld_HandlePingHour("")
end
