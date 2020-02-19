--
-- OnLevelUp is called everytime the building level was changed, even when the building is build the first time.
-- This function is called bevor Setup
-- attention: this function call is unscheduled
--
function OnLevelUp()

	if GetState("",STATE_MARINECONTROL)==false then
		SetState("",STATE_MARINECONTROL,true)
	end

	GetPosition("", "Position")
	GetLocatorByName("", "Entry1", "PositionEntry")	
	if (BuildingFindWaterPos("Position","PositionEntry","PosWater")) then
		if (GetOutdoorMovePosition(nil, "", "PosGround")) then
			BuildingSetWaterPos("", "PosWater", "PosGround")
			return true
		end
	end

	if not ScenarioFindPosition("", 2500, EN_POSTYPE_WATER, 800, nil, nil, nil, "PosWater") then
		return false
	end
	BuildingSetWaterPos("", "PosWater")
end

function Run()
end


function Setup()
end


function PingHour()
  local CurrentTime = math.mod(GetGametime(),24)

  if CurrentTime == 7 or CurrentTime == 19 then
		worldambient_CreateSailor("",3)
	end
end
