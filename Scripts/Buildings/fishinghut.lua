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

	-- deeper pos check
	if not ScenarioFindPosition("Position", 2000, EN_POSTYPE_WATER, 300, 750, EN_POSTYPE_GROUND, 100, "PosWater", "PosGround") then
		-- no water found, this is a big problem
		return "@L_GENERAL_BUILDING_NEED_WATER"
	end
	return nil
end

function OnLevelUp()
	
	if BuildingGetAISetting("", "Produce_Selection") > 0 then
		bld_SetupAI("")
		bld_SpawnMaterial("")
	end
	
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

function Setup()
end

function SellFish(BldAlias, CartAlias)
	if not GetSettlement(BldAlias, "MyCity") then
		return
	end
	
	CityGetLocalMarket("MyCity", "MyMarket")
	if not AliasExists("MyMarket") then
		return
	end
	
	if not AliasExists(CartAlias) then
		return
	end
	
	local AddSalmon = 0
	local AddHerring = 0
	
	if GetItemCount(BldAlias, "Salmon") >= 28 then
		local RemainingSalmon = GetRemainingInventorySpace(CartAlias, "Salmon", INVENTORY_STD)
		if RemainingSalmon >= 20 then
			AddSalmon = 20
		end
	end
	
	if GetItemCount(BldAlias, "Herring") >= 28 then
		local RemainingHerring = GetRemainingInventorySpace(CartAlias, "Herring", INVENTORY_STD)
		if RemainingHerring >= 20 then
			AddHerring = 20
		end
	end
	
	local Market = Rand(5)+1
	if not CityGetRandomBuilding("MyCity", 5, 14, Market ,-1, FILTER_IGNORE, "MarketPos") then
		CityGetRandomBuilding("MyCity", 5, 14, -1, -1, FILTER_IGNORE, "MarketPos")
	end
	
	if AddSalmon + AddHerring > 0 then
		MeasureRun(CartAlias, "MarketPos", "SendCartAndUnload", true)
	end
	
	if AddSalmon > 0 then 
		CreateScriptcall("TransferSalmon", 0.15, "Buildings/fishinghut.lua", "TransferSalmon", BldAlias, CartAlias)
	end
	
	if AddHerring > 0 then
		CreateScriptcall("TransferHerring", 0.15, "Buildings/fishinghut.lua", "TransferHerring", BldAlias, CartAlias)
	end
end

function TransferSalmon()
	RemoveItems("", "Salmon", 20)
	AddItems("Destination", "Salmon", 20)
end

function TransferHerring()
	RemoveItems("", "Herring", 20)
	AddItems("Destination", "Herring", 20)
end

function PingHour()
	
	if BuildingGetOwner("","MyBoss") then
		if GetHomeBuilding("MyBoss", "MyHome") then
			-- Improve Production
			if BuildingGetAISetting("", "Produce_Selection")>0 then
				bld_SetupAI("")
				bld_SpawnMaterial("")

				if DynastyIsAI("MyHome") then
					bld_CheckRivals("")
					bld_ForceLevelUp("")
				end
				
				-- spawn boat and cart if needed
				local FoundBoat = false
				local FoundCart = false
				for i=0,BuildingGetCartCount("")-1 do
					if BuildingGetCart("",i,"Cart") then
						local CartType = CartGetType("Cart")
						if CartType == EN_CT_FISHERBOOT then
							FoundBoat = true
						elseif CartType == EN_CT_MIDDLE or CartType == EN_CT_OX or CartType == EN_CT_HORSE then
							-- sell fish if needed
							if not GetState("Cart", STATE_CHECKFORSPINNINGS) then -- is not moving
								if CanAddItems("Cart", "Salmon", 20, INVENTORY_STD) then
									if GetDistance("", "Cart") < 1000 then
										fishinghut_SellFish("", "Cart")
									end
								end
							end
							FoundCart = true
						end
					end
				end
				if not FoundBoat then
					if BuildingGetWaterPos("", true, "PosWater") then
						ScenarioCreateCart(EN_CT_FISHERBOOT, "", "PosWater", "fishingboat")
					end
				end
				if not FoundCart then
					GetOutdoorMovePosition(nil,"","Pos")
					if BuildingGetLevel("") < 2 then
						ScenarioCreateCart(EN_CT_MIDDLE, "", "Pos", "Cart")
					else
						ScenarioCreateCart(EN_CT_HORSE, "", "Pos", "Cart")
					end
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
	if BuildingGetWaterPos("", true, "PosWater") then
		local Found = false
		for i=0,BuildingGetCartCount("")-1 do
			if BuildingGetCart("",i,"Cart") then
				if CartGetType("Cart")==EN_CT_FISHERBOOT then
					Found = true
					break
				end
			end
		end
		if not Found then
			if BuildingGetWaterPos("", true, "PosWater") then
				ScenarioCreateCart(EN_CT_FISHERBOOT, "", "PosWater", "fishingboat")
			end
		end
	
		if (GetOutdoorMovePosition("fishingboat", "", "GoodPos")) then
			SimBeamMeUp("fishingboat", "GoodPos")
		end	
	end
end
