--[[ 
Vanilla:

* Measure data is structured as follows (Vanilla):
	* InfoAblauf:		Total number of actions, say 'n'
	* Ort1 ... Ortn: Station (location) of that action
	* Was1 ... Wasn: Action at that station, i.e. load or unload
	* Wovon1 ... Wovonn: Item type to transfer
	* Wieviel1 ... Wievieln: Amount of items to transfer

* For the time of initialization, there is additional data for the cart:
	* KarrenSlots: Count of available slots (1--3)
	* SlotPlatz: Space in each slot (20/40)
	* PlatzMax: Resulting total space on the cart
	* Slot1 ... Slotn: Current item type in a cart slot
	* MengeSlot1 ... MengeSlotn: Amount of items in given slot 
	
TradingMod:

* Measure data will be restructured to differ between stations and actions
	* StationCount: Total number of stations, each selected by the *Next building* command.
	* Station1 ... Stationn: List of stations to stop at (for total n stations)
	* Station1Actions: Total number of actions at given station (here first station)
	* S1Action1 ... Sation1Am: First Action at this station
	* S1Type1 ... Sation1Tm: Item type of first action
	* S1Count1 ... Sation1Cm: Count of items at this station

* Initialization data (see above) will be kept for now.

--]]

function Init()
	GetHomeBuilding("", "homeBuilding")
	economy_UpdateBalance("homeBuilding", "Autoroute", 0)

	local ort = ""
	MsgBox("", "Owner", "", "@L_AUTOROUTE_HELP_HEAD_+0", "@L_AUTOROUTE_HELP_BODY_+0")

	local StationCount = 0 -- increment on "Next Building"
	local Stations = {} -- each entry is: {station, actioncount, {actions}, important}
	local ActionCount = 0 -- increment on each valid action, reset on "Next Building"
	local Actions = {}
	local Important = true
	
	local SaleThreshold = 0
	local Interval = 0 -- 0, 1, 6, 12
	local IntervalLabel = "_AUTOROUTE_INITIATE_INTERVAL_+0"
	
	-- current cart data
	SetData("CurrentItemsCount", 0) -- keeps track of different item types on the cart
	local CurrentItems = {}
	-- CurrentItems[1] = {itemType, amount} 
	 
	local vorgang
	repeat -- building overview, building select and send out
		local optionen = { -- TODO list current buildings as buttons or submenu
											"@B[1,@L_AUTOROUTE_INITIATE_OPTION_+2,]", -- Nächstes Gebäude
											"",--"@B[2,@L_AUTOROUTE_INITIATE_OPTION_+9,]", -- Aktuelle Route anzeigen
											"@B[5,@L_AUTOROUTE_INITIATE_OPTION_+5,]", -- Verkaufsniveau
											"@B[6,@L_AUTOROUTE_INITIATE_OPTION_+6,]", -- Intervall
											"@B[3,@L_AUTOROUTE_INITIATE_OPTION_+3,]", -- Aussenden
											"@B[C,@LAbort_+0,]" -- Abbrechen
											}
		local optionen2
		if ort ~= "" then
			optionen2 = optionen[1]..optionen[3]..optionen[4]..optionen[5]..optionen[6]
		else
			optionen2 = optionen[1]..optionen[3]..optionen[4]..optionen[6]
		end
		vorgang = MsgBox("","Owner","@P"..optionen2,"@L_AUTOROUTE_INITIATE_HEAD_+0","_AUTOROUTE_INITIATE_BODY_+0", SaleThreshold, IntervalLabel)	 -- Vorgang wählen
		if vorgang == 1 then -- next building
			StationCount = StationCount + 1 
			ort = ms_hpfz_autoroute_Wegpunkte(StationCount) -- returns ("WegPunkt"..o, true)
			ActionCount, Actions, Important = ms_hpfz_autoroute_ActionSelect(ort, CurrentItems)
			Stations[StationCount] = {ort, ActionCount, Actions, Important}
		elseif vorgang == 2 then
			ms_hpfz_autoroute_ShowRoute(StationCount, Stations) 
		elseif vorgang == 5 then
			local ret = MsgBox("", "Owner", 
				"@P@B[0,@L_AUTOROUTE_SALETHRESHOLD_+0,]"..
				"@B[70,@L_AUTOROUTE_SALETHRESHOLD_+1,]"..
				"@B[80,@L_AUTOROUTE_SALETHRESHOLD_+1,]"..
				"@B[90,@L_AUTOROUTE_SALETHRESHOLD_+1,]"..
				"@B[100,@L_AUTOROUTE_SALETHRESHOLD_+2,]"..
				"@B[110,@L_AUTOROUTE_SALETHRESHOLD_+3,]"..
				"@B[120,@L_AUTOROUTE_SALETHRESHOLD_+4,]"..
				"@B[130,@L_AUTOROUTE_SALETHRESHOLD_+4,]"..
				"@B[140,@L_AUTOROUTE_SALETHRESHOLD_+4,]"..
				"@B[150,@L_AUTOROUTE_SALETHRESHOLD_+4,]",
				"@L_AUTOROUTE_SALETHRESHOLD_HEAD_+0",
				"@L_AUTOROUTE_SALETHRESHOLD_BODY_+0",
				SaleThreshold)
			if ret ~= "C" then
				SaleThreshold = ret
			end 
		elseif vorgang == 6 then
			local ret = MsgBox("","Owner","@P@B[0,@L_AUTOROUTE_INITIATE_INTERVAL_+0,]".."@B[1,@L_AUTOROUTE_INITIATE_INTERVAL_+1,]".."@B[6,@L_AUTOROUTE_INITIATE_INTERVAL_+2,]".."@B[12,@L_AUTOROUTE_INITIATE_INTERVAL_+3,]","@L_AUTOROUTE_INTERVAL_HEAD_+0","@L_AUTOROUTE_INTERVAL_BODY_+0")
			if ret == 0 or ret == 1 then
				IntervalLabel = "_AUTOROUTE_INITIATE_INTERVAL_+"..ret
				Interval = ret
			elseif ret == 6 then
				IntervalLabel = "_AUTOROUTE_INITIATE_INTERVAL_+2"
				Interval = ret
			elseif ret == 12 then
				IntervalLabel = "_AUTOROUTE_INITIATE_INTERVAL_+3"
				Interval = ret
			end				
		elseif vorgang == "C" then -- cancel
			StopMeasure()
		end
	until vorgang == 3
	ms_hpfz_autoroute_SetRouteData(StationCount, Stations)
	-- how often shall the cart do the route? 8 hours, 4 hours, constantly
	SetData("Interval",Interval)
	SetData("SaleThreshold",SaleThreshold)
end

function ActionSelect(ort, CurrentItems)
	local ActionCount = 0
	local Actions = {}
	local wichtig = true
	
	local vorgang, was, wovon, wieviel
	local optionen = {"@B[1,@L_AUTOROUTE_ACTIONSELECT_OPTION_+1,]", -- Einladen
										"@B[2,@L_AUTOROUTE_ACTIONSELECT_OPTION_+2,]", -- Ausladen
										"@B[3,@L_AUTOROUTE_ACTIONSELECT_OPTION_+3,]",--Lager auffüllen
										"@B[81,@L_AUTOROUTE_ACTIONSELECT_OPTION_+4,]",-- Wegpunkt als wichtig markieren
										"@B[82,@L_AUTOROUTE_ACTIONSELECT_OPTION_+5,]", -- Wegpunkt als nicht wichtig markieren
										"@B[C,@L_AUTOROUTE_ACTIONSELECT_OPTION_+0,]"}-- Zurück

	repeat 
		local optionen2 = ""
		local imp = ""
		optionen2 = optionen2..optionen[1]--Einladen
		optionen2 = optionen2..optionen[2]--Ausladen
		if GetDynastyID("") == GetDynastyID(ort) then
			optionen2 = optionen2..optionen[3]--Lager auffüllen
		end
		if not wichtig then
			optionen2 = optionen2..optionen[4] -- als wichtig markieren
			imp = "_AUTOROUTE_ACTIONSELECT_BODY_+2"
		else
			optionen2 = optionen2..optionen[5] -- als nicht wichtig markieren
			imp = "_AUTOROUTE_ACTIONSELECT_BODY_+1"
		end
		optionen2 = optionen2..optionen[6]--Zurück
		vorgang = MsgBox("","Owner","@P"..optionen2,"@L_AUTOROUTE_ACTIONSELECT_HEAD_+0","@L_AUTOROUTE_ACTIONSELECT_BODY_+0", GetID(ort), imp)	-- Vorgang wählen

		if vorgang == "C" then
			-- Zurück zur Gebäudeauswahl
			return ActionCount, Actions, wichtig
			
		elseif vorgang == 1 then -- Einladen
			was = 1
			wovon, wieviel = cart_ChooseItemsToLoad("", ort)
			if wovon ~= 0 and wieviel ~= 0 then
				ms_hpfz_autoroute_KarrenLager(true, wovon, wieviel, CurrentItems)
			end
			
		elseif vorgang == 2 then -- Ausladen
			was = 2
			wovon, wieviel = ms_hpfz_autoroute_InitUnload(ort, false, CurrentItems)
			if wovon ~= 0 then
				ms_hpfz_autoroute_KarrenLager(false, wovon, wieviel, CurrentItems)
			end

		elseif vorgang == 3 then -- Lager auffüllen
			was = 3
			wovon, wieviel = ms_hpfz_autoroute_InitUnload(ort, true, CurrentItems)
			-- kein Ändern des Karrenlagers, da ggf. gar keine Waren abgeladen werden
		
		elseif vorgang == 81 then
			wichtig = true
		elseif vorgang == 82 then
			wichtig = false
		end
		if vorgang < 10 and wovon ~= 0 then
			ActionCount = ActionCount + 1
			Actions[ActionCount] = {was, wovon, wieviel}
		end
	until vorgang == 5
	return ActionCount, Actions, wichtig
end

-- zeigt einen Dialog mit einem Button pro Station und einem Zurück-Button 
function ShowRoute(StationCount, Stations)
	-- show message with route
	local buttons = "@P" 
	for i=1, StationCount do
		local ort = Stations[i][1]
		buttons = buttons.."@B["..i..","..ort..",]"
	end
	buttons = buttons.."@B[8888,@LBack_+0,]"
	local vorgang = MsgBox("","Owner",buttons,"@L_AUTOROUTE_INITIATE_HEAD_+0","")	-- Vorgang wählen
	-- TODO process vorgang
	return
end




function InitUnload(station, isRestock, CurrentItems)
	local CurrentItemsCount = GetData("CurrentItemsCount")

	local backC = 1
	local drinWahl, drinMeng
	repeat
	
		local drinNam, drinID, drinMenge, drinMengeX, ItemTexture
		local karStuf = ""
		
		for k = 1, CurrentItemsCount do
			drinID = CurrentItems[k][1]
			drinMenge = CurrentItems[k][2]
			if drinID and drinID ~= 0 and drinMenge > 0 then
				drinNam = ItemGetLabel(drinID, false)
				ItemTexture = "Hud/Items/Item_"..ItemGetName(drinID)..".tga"
				karStuf = karStuf.."@B[" .. drinID .. "," .. drinMenge .. "," .. drinNam .. "," .. ItemTexture .."]"
			end
		end
		
--		local bodytext = "@L_AUTOROUTE_TYPESELECT_BODY_+1"
--		if isRestock then
--			bodytext = "@L_AUTOROUTE_TYPESELECT_BODY_+2"
--		end	
--		drinWahl = MsgBox("","Owner","@P"..karStuf,"@L_AUTOROUTE_TYPESELECT_HEAD_+0", bodytext, GetID(station))
		drinWahl = InitData(
			"@P"..karStuf, -- PanelParam
			0, -- AIFunc
			"@L_AUTOROUTE_TYPESELECT_HEAD_+0",-- HeaderLabel
			"Body"-- BodyLabel (obsolete)
			)-- optional variable list
		
		if drinWahl == "C" then
			return 0,0
		end	
		
		local mengStuf = ""
		local menge = {}
		local maxM = 0
		if isRestock then
			if BuildingGetType(station) == 38 then -- warehouse
				menge = {100, 200, 300, 400, 500}
				maxM = 5
			else
				menge = {10, 20, 40, 60, 80, 100}
				maxM = 6
			end
		else 
			for k=1, CurrentItemsCount do
				if drinWahl == CurrentItems[k][1] then
					drinMengeX = CurrentItems[k][2]
				end
			end
			
			local AmountOptions = {0, 5, 10, 20, 30, 40}
			local AmountOptionCount = 6
			for i=1, AmountOptionCount do
				if drinMengeX >= AmountOptions[i] then
					maxM = maxM + 1
					menge[maxM] = AmountOptions[i]
				end
			end
		end
		for p=1, maxM do
			mengStuf = mengStuf.."@B["..menge[p]..","..menge[p]..",]"
		end
		mengStuf = mengStuf.."@B[C,@LBack_+0,]"

		if isRestock then
			bodytext = "@L_AUTOROUTE_COUNTSELECT_BODY_+2"
		else
			bodytext = "@L_AUTOROUTE_COUNTSELECT_BODY_+1"
		end	
		drinMeng = MsgBox("","Owner","@P"..mengStuf,"@L_AUTOROUTE_COUNTSELECT_HEAD_+0",bodytext,GetID(station), ItemGetLabel(drinWahl,false))
		
		if drinMeng == "C" then
			backC = 0
		else
			backC = 1
		end

	until backC == 1
	
	return drinWahl, drinMeng

end

function KarrenLager(isLoad, itemType, amount, CurrentItems)
	local CurrentItemsCount = GetData("CurrentItemsCount")
	
	if isLoad == true then
		local Exists = false
		for k=1, CurrentItemsCount do
			if CurrentItems[k][1] == itemType then
				CurrentItems[k][2] = CurrentItems[k][2] + amount
				Exists = true 
			end
		end
		if not Exists then
			CurrentItemsCount = CurrentItemsCount + 1
			CurrentItems[CurrentItemsCount] = {itemType, amount}
		end
	elseif isLoad == false then
		for k=1, CurrentItemsCount do
			if CurrentItems[k][1] == itemType then
				local fuell = CurrentItems[k][2]
				fuell = amount
				CurrentItems[k][2] = fuell
				break
			end
		end
	end
	SetData("CurrentItemsCount", CurrentItemsCount)	
end

function Wegpunkte(o)
	-- filter for waypoint selection
	InitAlias("WegPunkt"..o,MEASUREINIT_SELECTION,
		"__F((Object.BelongsToMe()) OR (Object.IsClass(2)) OR (Object.IsClass(5)) AND (Object.Type == Building))",
		"@L_AUTOROUTE_NEXT_BUILDING_+0",0)
	return "WegPunkt"..o
end

function Run()
	--workaround for spinning carts...
	SetProperty("","AutoRoute",1)
	GetHomeBuilding("", "homeBuilding")
	
	local StationCount = 0
	local Stations = {}
	StationCount, Stations = ms_hpfz_autoroute_GetRouteData()
	local Threshold = GetData("SaleThreshold")
	local WarningCount = 12 -- display warning after 12 hours of waiting at the same station
	local NumberOfTries = 0
	
	while true do
		local Station
		for s = 1, StationCount do
			Station = Stations[s][1]
			
			-- move to given station. check owner (relevant for buying/selling)
			f_MoveTo("",Station, GL_MOVESPEED_RUN)
			Sleep(1)
			local SrcID = GetDynastyID("")
			local DestID = -1
			if AliasExists(Station) then
				DestID = GetDynastyID(Station)
			end

			--- If station is important each action will have to state that it is done:
			-- Load: Required amount of items are present on cart.
			-- Unload: Cart contains no more than the specified amount. 
			-- Restock: Cart has no more items of this type. 
			local isDone, restockEmpty
			local Action, Type, Count
			NumberOfTries = 0
			repeat
				isDone = true -- any action that isn't done will set this to false
				restockEmpty = false -- overrides false isDone for restock action 
				for i = 1, Stations[s][2] do
					local AC = Stations[s][3][i]
					Action = AC[1]
					Type = AC[2]
					Count = AC[3]
					
					if Action == 1 then 
						------ Einladen oder Karren auffüllen ----
						local requiredItems = Count - GetItemCount("", Type, INVENTORY_STD)
				 		local itemCount = math.min(requiredItems, GetItemCount(Station, Type, INVENTORY_STD))
			 			ms_hpfz_autoroute_LoadCart(SrcID, DestID, Station, Type, itemCount)
				 		if GetItemCount("", Type, INVENTORY_STD) < Count then
				 			isDone = false
				 		end
					elseif Action == 2 then
					------ Ausladen ----
						isDone = isDone and ms_hpfz_autoroute_Unload(Station, Type, Count, Threshold)
					elseif Action == 3 then
					------ Lager auffüllen ----
						local requiredItems = Count - GetItemCount(Station, Type, INVENTORY_STD)
						if requiredItems > 0 and SrcID == DestID then
							local itemCount = math.min(requiredItems, GetItemCount("", Type, INVENTORY_STD))
							Transfer("",Station,INVENTORY_STD,"",INVENTORY_STD,Type,itemCount)
						end
						if GetItemCount("", Type, INVENTORY_STD) <= 0 then
							restockEmpty = true
						else
							isDone = false
						end
					end -- endif; switch case over action
				end -- for each action of the station

				if (not Stations[s][4]) or isDone or restockEmpty then
					-- repeat until this condition
				else
					-- station is important but didn't get done
					WarningCount, isDone, NumberOfTries = ms_hpfz_autoroute_CheckWarning(NumberOfTries, WarningCount, Station)
					if isDone then
						break
					else
						Sleep(30)
					end
				end
				Sleep(1)
			-- repeat actions if important until done or a restock item runs out 
			until (not Stations[s][4]) or isDone or restockEmpty
		end -- for each station
		Sleep(2)
		local warteZeit = GetData("Interval")
		if warteZeit == 1 then -- execute route only once
			break
		end
		Sleep(warteZeit*60) -- wait
	end -- run until cancelled (while true)
	StopMeasure()
end

function CleanUp()
	--workaround for spinning carts...
	RemoveProperty("","AutoRoute")
	----------------------------------
end

function LoadCart(SrcID, DestID, station, type, itemCount)
	local BargainMoney = 0
	local EstimatedMoney = 0
	local prevCount = GetItemCount("", type, INVENTORY_STD)
	Transfer("","",INVENTORY_STD,station,INVENTORY_STD,type, itemCount)
	local actualCount = GetItemCount("", type, INVENTORY_STD) - prevCount
	if SrcID ~= DestID and actualCount > 0 then
		GetDynasty("","bsitzer") -- Dynastie des Karrens
		-- add bargaining bonus
		if GetHomeBuilding("","Buisness") then
			if BuildingGetOwner("Buisness","MyBoss") then
				if GetSettlement(station, "MyCity") then
					CityGetLocalMarket("MyCity","MyMarket")
					EstimatedMoney = ItemGetPriceBuy(type,"MyMarket")*actualCount
					BargainMoney = math.floor(EstimatedMoney*((GetSkillValue("MyBoss",BARGAINING)*2)/100))
				end
			end
		end
	end
	economy_UpdateBalance("homeBuilding", "Autoroute", 0 - math.abs(EstimatedMoney))
	if BargainMoney > 0 then
		Sleep(0.5)
		f_CreditMoney("homeBuilding",BargainMoney,"WaresSold")
		ShowOverheadSymbol("", false, false, 0, "@L(+ %1t)",BargainMoney)
	end
end

function SetRouteData(StationCount, Stations)
	SetData("StationCount", StationCount)
	for s = 1, StationCount do
		SetData("Station"..s, Stations[s][1]) 
		SetData("Station"..s.."Actions", Stations[s][2])
		if Stations[s][2] >= 1 then
			for a = 1, Stations[s][2] do
				local Action = Stations[s][3][a]
				SetData("S"..s.."Action"..a, Action[1]) -- Aktion: 1=Einladen, 2=Ausladen, 3=Auffüllen
				SetData("S"..s.."Type"..a, Action[2])
				SetData("S"..s.."Count"..a, Action[3])
			end 
		end
		if Stations[s][4] then
			SetData("Station"..s.."Important", 1)
		else
			SetData("Station"..s.."Important", 0)
		end
	end
end

function GetRouteData()
	local StationCount = GetData("StationCount")
	local Stations = {}
	for s = 1, StationCount do
		Stations[s] = {}
		Stations[s][1] = GetData("Station"..s) 
		Stations[s][2] = GetData("Station"..s.."Actions")
		if Stations[s][2] >= 1 then
			Stations[s][3] = {}
			for a = 1, Stations[s][2] do
				local Action = {
					GetData("S"..s.."Action"..a),
					GetData("S"..s.."Type"..a),
					GetData("S"..s.."Count"..a)
					}
				Stations[s][3][a] = Action
			end 
		end
		local important = GetData("Station"..s.."Important")
		if important == 1 then
			Stations[s][4] = true
		else
			Stations[s][4] = false
		end
	end
	return StationCount, Stations
end

function Unload(Station, Type, Count, Threshold)
	local itemCount = GetItemCount("", Type, INVENTORY_STD) - Count
	local BargainMoney = 0
	local EstimatedMoney = 0
	if(BuildingGetClass(Station) == GL_BUILDING_CLASS_MARKET) then
		if GetHomeBuilding("","Buisness") then
			if BuildingGetOwner("Buisness","MyBoss") then
				if GetSettlement(Station, "MyCity") then
					CityGetLocalMarket("MyCity","MyMarket")
					-- check threshold
					if Threshold > 0 then
						local Ratio = ItemGetPriceSell(Type, "MyMarket")*100/ItemGetBasePrice(Type)
						if Ratio < Threshold then
							return false
						end
					end
					-- check threshold
					EstimatedMoney = ItemGetPriceSell(Type,"MyMarket")*itemCount
					BargainMoney = math.floor(EstimatedMoney*((GetSkillValue("MyBoss",BARGAINING)*2)/100))
				end
			end
		end
	end
	Transfer("",Station,INVENTORY_STD,"",INVENTORY_STD,Type,itemCount)
	economy_UpdateBalance("homeBuilding", "Autoroute", math.abs(EstimatedMoney))
	if BargainMoney > 0 then
		Sleep(0.5)
		f_CreditMoney("homeBuilding",BargainMoney,"WaresSold")
		ShowOverheadSymbol("", false, false, 0, "@L(+ %1t)",BargainMoney)
	end
	if GetItemCount("", Type, INVENTORY_STD) > Count then
		return false
	end
	return true
end

function CheckWarning(NumberOfTries, WarningCount, Station)
	if (WarningCount > 0) and (NumberOfTries >= WarningCount*2) then
		local ret = MsgNews("", "", 
			"@P@B[C,@L_AUTOROUTE_WARNING_OPTION_+0,]".."@B[1,@L_AUTOROUTE_WARNING_OPTION_+1,]".."@B[2,@L_AUTOROUTE_WARNING_OPTION_+2,]".."@B[3,@L_AUTOROUTE_WARNING_OPTION_+3,]", 
			0,
			"production", 
			1, 
			"@L_AUTOROUTE_WARNING_HEAD_+0", 
			"@L_AUTOROUTE_WARNING_BODY_+0", 
			WarningCount, GetID(Station))
		if ret == 1 then
			-- send the cart on
			return WarningCount, true, 0
		elseif ret == 2 then
			-- increase time until warning for the route
			return (WarningCount + 12), false, 0
		elseif ret == 3 then
			-- never warn again about this route
			return 0, false, 0
		else 
			-- keep waiting, reset counter (default)
			return WarningCount, false, 0
		end
	end
	return WarningCount, false, (NumberOfTries + 1)
end