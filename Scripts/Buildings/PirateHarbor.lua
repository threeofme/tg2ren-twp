
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

	-- deeper pos check
	if not ScenarioFindPosition("Position", 2000, EN_POSTYPE_WATER, 300, 750, EN_POSTYPE_GROUND, 100, "PosWater", "PosGround") then
		-- no water found, this is a big problem
		return "@L_GENERAL_BUILDING_NEED_WATER"
	end
	return nil
end

function Setup()
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
	return false
end

function PingHour()

	-- Check every worker (only once) for illness and equipment 
	if not HasProperty("", "CheckDefaultWorkers") then
		bld_ResetWorkers("")
		SetProperty("", "CheckDefaultWorkers", 1)
	end
	
	local Found = false
	for i=0,BuildingGetCartCount("")-1 do
		if BuildingGetCart("",i,"Cart") then
			if CartGetType("Cart")==EN_CT_CORSAIR then
				Found = true
			end
		end
	end
	if Found then
		if not HasProperty("", "pirateship") then
			SetProperty("", "pirateship", 1)
		end
	else
		if HasProperty("", "pirateship") then
			RemoveProperty("","pirateship")
		end	
	end
	
	-- Only for AI
	
	if BuildingGetOwner("", "MyBoss") then
		if GetHomeBuilding("MyBoss", "MyHome") then
			if DynastyIsAI("MyHome") then
				bld_CheckRivals("")
			end
		end
	end
end
