
function Init()

end


function Run()
	local BuiltOnWater = GetProperty("","WaterKontor") -- determines if kontor is built near water or not

	if not BuildingGetCity("","Settlement") then
		return
	end
	if not HasProperty("","ShipCount") then
		SetProperty("","ShipCount",0)
	end
	if not HasProperty("","CartCount") then
		SetProperty("","CartCount",0)
	end
	if not HasProperty("","Plundered") then
		SetProperty("","Plundered",0)
	end

	while true do
		RemoveData("ForceWarShip")
		local CurrentShips = GetProperty("","ShipCount")
		local CurrentCarts = GetProperty("","CartCount")
		if state_marinecontrol_CanBuyNewShip() == true then
			state_marinecontrol_BuyNewShip()
		else
			for i=0,CurrentShips-1 do
				if BuildingGetCart("",i,"CurrentShip") then
					state_marinecontrol_CheckShip("CurrentShip")
				end
			end
		end	
		
		local MainPlunderCount = GetProperty("","Plundered")
		if MainPlunderCount > 20 then
			SetData("ForceWarShip",1)
			MainPlunderCount = 0
			state_marinecontrol_BuyNewShip()
		end
		
		Sleep(Rand(10)+10)
	end
end

function CheckShip(CurrentShip)
	local PlunderCount -- update plundercount
	if HasProperty(CurrentShip,"BeeingPlundered") then
		PlunderCount = GetProperty(CurrentShip,"BeeingPlundered")
	end
	local MainPlunderCount = GetProperty("","Plundered")
	if PlunderCount and PlunderCount > 0 then
		MainPlunderCount = MainPlunderCount + PlunderCount
		SetProperty(CurrentShip,"BeeingPlundered",0)
		SetProperty("","Plundered",MainPlunderCount)
	end
	
	local ShipType = CartGetType(CurrentShip)
	
	if GetState(CurrentShip,STATE_BUILDING) then
		return
	end
	
	if ShipType == EN_CT_WARSHIP then
		if GetCurrentMeasureName(CurrentShip)=="AttackEnemy" then
			return
		end
		
		if GetCurrentMeasureName(CurrentShip)=="EscortCharacterOrTransport" then
			return
		end
	end
	
	if GetCurrentMeasureName(CurrentShip)=="SailHomeAndRepair" then
		return
	end
	
	if GetCurrentMeasureName(CurrentShip)=="RepairCart" then
		return
	end

	if GetCurrentMeasureName(CurrentShip)=="PlunderShip" then
		return
	end
	
	if GetState(CurrentShip,STATE_FIGHTING) then
		return	
	end
	
	if GetHPRelative(CurrentShip) < 1 then
		MeasureRun(CurrentShip,nil,"SailHomeAndRepair",true)
		return
	end
	
	if GetCurrentMeasureName(CurrentShip)=="WorldTrader" then
		return
	end
	
	if ShipType == EN_CT_WARSHIP then
		local EnemyID = state_marinecontrol_GetEnemyPirateShip(CurrentShip)
		if EnemyID then
			if not GetAliasByID(EnemyID,"EnemyShip") then
				state_marinecontrol_EscortShip(CurrentShip)
				return
			end
		else
			state_marinecontrol_EscortShip(CurrentShip)
			return
		end
		MeasureRun(CurrentShip,"EnemyShip","AttackEnemy",true)
	else
		MeasureRun(CurrentShip,nil,"WorldTrader",true)
	end
	return
end

function GetEnemyPirateShip(CurrentShip)
	local ShipFilter = "__F((Object.GetObjectsByRadius(Ship)==20000))"
	local NumShips = Find(CurrentShip,ShipFilter,"MyTarget",-1)
	local TargetID = nil
	for i=0,NumShips-1 do
		local TargetShipType = CartGetType("MyTarget"..i)
		if TargetShipType == EN_CT_CORSAIR then
			if not GetState("MyTarget"..i,STATE_HIDDEN) then
				TargetID = GetID("MyTarget"..i)
				break
			end
		end
	end
	return TargetID
end

function EscortShip(Current)
	local CurrentShips = GetProperty("","ShipCount")
	local ShipType
	for i=0,CurrentShips-1 do
		if BuildingGetCart("",i,"CurrentShipToEscort") then
			ShipType = CartGetType("CurrentShipToEscort")
			if ShipType == EN_CT_MERCHANTMAN_SMALL or ShipType == EN_CT_MERCHANTMAN_BIG then
				CopyAlias("CurrentShipToEscort","ShipToEscort")
				break
			end
		end
	end
	if AliasExists("ShipToEscort") then
		MeasureRun(Current,"ShipToEscort","EscortCharacterOrTransport",true)
	end
	return
end

function BuyNewShip()
	local CityLevel = CityGetLevel("Settlement")
	local CurrentShips = GetProperty("","ShipCount")
	local NewShipType = EN_CT_MERCHANTMAN_SMALL
	local WarshipNeeded = false
	local TradeshipNeeded = true
	
	if CityLevel > 3 then
		NewShipType = EN_CT_MERCHANTMAN_BIG
	end
	
	for i=0,CurrentShips-1 do
		if BuildingGetCart("",i,"CurrentShip") then
			ShipType = CartGetType("CurrentShip")
			if ShipType == EN_CT_MERCHANTMAN_SMALL or ShipType == EN_CT_MERCHANTMAN_BIG then
				TradeshipNeeded = false
			end
			if HasProperty("CurrentShip","BeeingPlundered") then
				local PlunderCount = GetProperty("CurrentShip","BeeingPlundered")
				local MainPlunderCount = GetProperty("","Plundered")
				if PlunderCount > 0 then
					MainPlunderCount = MainPlunderCount + PlunderCount
					SetProperty("CurrentShip","BeeingPlundered",0)
					SetProperty("","Plundered",MainPlunderCount)
				end
				if MainPlunderCount > 5 then
					WarshipNeeded = true
				end
			end
		end
	end
	
	if HasData("ForceWarShip") then
		NewShipType = EN_CT_WARSHIP
		SetProperty("","Plundered",0)
	else
		if not TradeshipNeeded then
			if WarshipNeeded then
				NewShipType = EN_CT_WARSHIP
				SetProperty("","Plundered",0)
			end
		end
	end
		
	BuildingGetWaterPos("", true, "PosWater")
	if not BuildingBuyCart("",NewShipType,false,"Boat") then
		return false
	end
	SetProperty("","ShipCount",CurrentShips+1)
	SetProperty("Boat","CityShip",GetID("Settlement"))
	if NewShipType == EN_CT_WARSHIP then
		SetProperty("Boat","ShipMenCnt",100)
		AddImpact("Boat","ShipMenMod",0.5,-1)
		AddImpact("Boat","ShipCannonMod",0.5,-1)
		AddImpact("Boat","ShipHitpointMod",0.5,-1)
	end
	if (GetOutdoorMovePosition("Boat", "", "GoodPos")) then
		SimBeamMeUp("Boat", "GoodPos")
	end
	return
end

function CanBuyNewShip()
	local CityLevel = CityGetLevel("Settlement")
	local ShipCount = 0
	
	if CityLevel > 5 then
		ShipCount = 3
	elseif CityLevel > 3 then
		ShipCount = 2
	elseif CityLevel > 1 then
		ShipCount = 1
	end
	
	if (GetProperty("","ShipCount") >= ShipCount) then
		return false
	end
	
	return true
end


