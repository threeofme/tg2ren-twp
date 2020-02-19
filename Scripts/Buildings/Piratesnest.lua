
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
	
	-- Heal default-workers & remove items
	
	for workerindex = 0 , BuildingGetWorkerCount("") -1 do
		if BuildingGetWorker("", workerindex, "Worker"..workerindex) then
		
			-- remove armor
			if GetItemCount("Worker"..workerindex, "LeatherArmor", INVENTORY_EQUIPMENT)>0 then
				RemoveItems("Worker"..workerindex, "LeatherArmor", 1, INVENTORY_EQUIPMENT)
			elseif GetItemCount("Worker"..workerindex, "Chainmail", INVENTORY_EQUIPMENT)>0 then
				RemoveItems("Worker"..workerindex, "Chainmail", 1, INVENTORY_EQUIPMENT)
			elseif GetItemCount("Worker"..workerindex, "Platemail", INVENTORY_EQUIPMENT)>0 then
				RemoveItems("Worker"..workerindex, "Platemail", 1, INVENTORY_EQUIPMENT)
			end
			
			-- remove weapon
			if GetItemCount("Worker"..workerindex, "Mace", INVENTORY_EQUIPMENT)>0 then
				RemoveItems("Worker"..workerindex, "Mace", 1, INVENTORY_EQUIPMENT)
			elseif GetItemCount("Worker"..workerindex,"Shortsword", INVENTORY_EQUIPMENT)>0 then
				RemoveItems("Worker"..workerindex, "Shortsword", 1, INVENTORY_EQUIPMENT)
			elseif GetItemCount("Worker"..workerindex,"Longsword", INVENTORY_EQUIPMENT)>0 then
				RemoveItems("Worker"..workerindex, "Longsword", 1, INVENTORY_EQUIPMENT)
			elseif GetItemCount("Worker"..workerindex,"Axe", INVENTORY_EQUIPMENT)>0 then
				RemoveItems("Worker"..workerindex, "Axe", 1, INVENTORY_EQUIPMENT)
			end
		
			AddItems("Worker"..workerindex, "Dagger", 1, INVENTORY_EQUIPMENT)
		
			if GetImpactValue("Worker"..workerindex, "Sickness")>0 then
				diseases_Sprain("Worker"..workerindex,false)
				diseases_Cold("Worker"..workerindex,false)
				diseases_Influenza("Worker"..workerindex,false)
				diseases_BurnWound("Worker"..workerindex,false)
				diseases_Pox("Worker"..workerindex,false)
				diseases_Pneumonia("Worker"..workerindex,false)
				diseases_Blackdeath("Worker"..workerindex,false)
				diseases_Fracture("Worker"..workerindex,false)
				diseases_Caries("Worker"..workerindex,false)
				MoveSetActivity("","")
			end
		end
	end
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
	local Found = false
	for i=0,BuildingGetCartCount("")-1 do
		if BuildingGetCart("",i,"Cart") then
			if CartGetType("Cart")==EN_CT_CORSAIR then
				Found = true
				break
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
		
		if DynastyIsAI("") then
			if Rand(100)<6 then
				if BuildingGetWaterPos("", true, "PosWater") then
					ScenarioCreateCart(EN_CT_CORSAIR, "", "PosWater", "pirateship")
					Found = true
				end
			end
		end
	end
end

--
-- Run is called directly after the building is complete initialized.
-- this is a scheduled call, so you can loop an sleep
--
function Run()
	BuildingGetWaterPos("", true, "PosWater")
	if not ScenarioCreateCart(EN_CT_CORSAIR, "", "PosWater", "pirateship") then
		return false
	end
	if (GetOutdoorMovePosition("pirateship", "", "GoodPos")) then
		SimBeamMeUp("pirateship", "GoodPos")
	end	
end
