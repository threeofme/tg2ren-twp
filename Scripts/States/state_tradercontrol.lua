---
--  Here is what the script does:
-- Spawn trading carts and start measure "ms_WorldTrader" on them.
-- Keep track of any robberies on the carts.
-- Notify players when too many robberies have occured.
-- Stop trading for a while if robberies don't stop.
-- NOTE the corresponding script for ships is "state_marinecontrol.lua"

function Init()

end


function Run()
	if not BuildingGetCity("","KontorSettlement") then
		return
	end
		
	local Count = ScenarioGetObjects("Settlement", 20, "City")
	local NearestDistance = 9999999
	local NearestCity, CityAlias
	for l=0,Count-1 do -- get nearest city
		CityAlias = "City"..l
		if not CityIsKontor(CityAlias ) then
			local Dist = CalcDistance("", CityAlias)
			if Dist < 0 then
				return
			end
			if Dist < NearestDistance then
				NearestDistance = Dist
				NearestCity = CityAlias
			end
		end
	end
	
	if not HasProperty("","Settlement") then
		SetProperty("","Settlement",NearestCity) -- needs to be testet on bigger map!
	end
	-- nasty way to do this
	if not HasProperty("","Cart0") then
		SetProperty("","Cart0",0)
	end
	
	if not HasProperty("","Cart1") then
		SetProperty("","Cart1",0)
	end
	
	if not HasProperty("","Cart2") then
		SetProperty("","Cart2",0)
	end
	
	if not HasProperty("","Cart3") then
		SetProperty("","Cart3",0)
	end

	if not HasProperty("","CartCount") then
		SetProperty("","CartCount",0)
	end
	
	if not HasProperty("","Plundered") then
		SetProperty("","Plundered",0)
	end
	
	if not HasProperty("","RobberMessageSaid") then
		SetProperty("","RobberMessageSaid", 0)
	end
	
	--if not HasProperty("", "KontorSettlement") then
	--	SetProperty("", "KontorSettlement", KontorSettlement)
	--end

	while true do
		local CurrentCarts = GetProperty("","CartCount")
		if state_tradercontrol_CanBuyNewCart() == true then
			state_tradercontrol_BuyNewCart()
		else
			for i=0,CurrentCarts-1 do
				--if BuildingGetCart("",i,"CurrentCart") then
				local Cart = GetProperty("","Cart"..i)
				state_tradercontrol_CheckCart(Cart)
				--end
			end
		end			
		
		local MainPlunderCount = GetProperty("","Plundered")
		if MainPlunderCount > 4 then -- Too many robberies occured, stop trade for some time
			local Time = Rand(24)+24
			AddImpact("","TradingRoutePlundered",1,Time) 
			MainPlunderCount = 0
			SetProperty("","Plundered", 0)
			SetProperty("","RobberMessageSaid", 0)			

			-- msg to all players;
			MsgNewsNoWait("All","","","economie",-1, 
				"@L_KONTOR_TOOMANYROBBERIES_HEAD_+0", 
				"@L_KONTOR_TOOMANYROBBERIES_BODY_+1", GetID("KontorSettlement")) 
			
		elseif MainPlunderCount > 2 and GetProperty("","RobberMessageSaid") ~= 1 then
			MsgNewsNoWait("All","","","economie",-1, 
				"@L_KONTOR_TOOMANYROBBERIES_HEAD_+0", 
				"@L_KONTOR_TOOMANYROBBERIES_BODY_+0", GetID("KontorSettlement")) 
			SetProperty("","RobberMessageSaid", 1)
		end
		
		
		local CurrentRound = GetRound()
		if not HasProperty("", "LastTimeRobbed") then
			SetProperty("", "LastTimeRobbed", CurrentRound)
		end
		
		local LastTimeRobbed = GetProperty("","LastTimeRobbed")
		if CurrentRound - LastTimeRobbed > 2 then
			SetProperty("","LastTimeRobbed", CurrentRound)	
			SetProperty("","Plundered", 0)
		end

		if MainPlunderCount == 0 then
			SetProperty("","LastTimeRobbed", CurrentRound)
		end
		
		Sleep(15)
	end
end

function CheckCart(CurrentCart)
	local PlunderCount -- update plundercount
	if HasProperty(CurrentCart,"BeeingPlundered") then
		PlunderCount = GetProperty(CurrentCart,"BeeingPlundered") 
	end
	local MainPlunderCount = GetProperty("","Plundered")
	if PlunderCount and PlunderCount > 0 then
		MainPlunderCount = MainPlunderCount + PlunderCount
		SetProperty(CurrentCart,"BeeingPlundered",0)
		SetProperty("","Plundered",MainPlunderCount)
	end
	
	local CartType = CartGetType(CurrentCart)
	
	if GetState(CurrentCart,STATE_BUILDING) then
		return
	end
	
	if GetState(CurrentCart,STATE_DRIVERATTACKED) then
		return	
	end
	
	if GetCurrentMeasureName(CurrentCart)=="WorldTrader" then
		return
	end
		
	MeasureRun(CurrentCart,nil,"WorldTrader",true)

	return
end

function BuyNewCart()
	local Settlement = GetProperty("","Settlement")
	local CityLevel = CityGetLevel(Settlement)
	local CurrentCarts = GetProperty("","CartCount") or 0
	local NewCartType = EN_CT_MIDDLE
	
	if CityLevel > 3 then
		NewCartType = EN_CT_OX
	end
	
	if CityLevel > 5 then
		NewCartType = EN_CT_HORSE
	end
	
	if GetPosition("", "GroundPos") then
		if ScenarioCreateCart(NewCartType, NIL, "GroundPos", "CartTrader") then
			--SetName("CartTrader", "Trader "..CurrentCarts)
			SetProperty("","CartCount",CurrentCarts+1)
			SetProperty("","Cart"..CurrentCarts,"CartTrader")
			if (GetOutdoorMovePosition("CartTrader", "", "GoodPos")) then
				SimBeamMeUp("CartTrader", "GoodPos", false) -- false added
			end
			SetEndlessMoney("CartTrader", true)
			MeasureRun("CartTrader", nil, "WorldTrader", true)
			SetProperty("CartTrader","BeeingPlundered",0)
			
			--SetProperty("CartTrader","HomeKontor",GetProperty("KontorSettlement"))
			--SetProperty("CartTrader","NearestCity",GetProperty("Settlement"))
		end
	end
end

function CanBuyNewCart()
	local Settlement = GetProperty("","Settlement")
	local CityLevel = CityGetLevel(Settlement)	

	local SettlementCount = ScenarioGetObjects("Settlement", 20, "City")
	local KontorCount = ScenarioGetBuildingCount(-1, 34, -1, -1, FILTER_IGNORE)
	
	local CartCount = CityLevel + (SettlementCount - KontorCount)
	
	if (GetProperty("","CartCount") >= CartCount) then
		return false
	end
	
	return true
end


