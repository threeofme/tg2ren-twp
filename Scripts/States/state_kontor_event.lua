function Run()

	local Count = GetData("#KontorEventCount")
	if not Count then
		Count = 0
	end
	SetData("#KontorEventCount", Count+1)

	local	Selection = Rand(10)
	SetData("Selection", Selection)
	
	if Selection > 2 then
		state_kontor_event_NeedItems()
	else 
		state_kontor_event_OfferItems()
	end

end

function CleanUp()

	local Count = GetData("#KontorEventCount")
	if Count and Count>0 then
		SetData("#KontorEventCount", Count-1)
	end

	local Selection = GetData("Selection")
	if Selection==0 then
		state_kontor_event_NeedItemsCleanUp()
	elseif Selection==1 then
		state_kontor_event_OfferItemsCleanUp()
	end

	-- remove the hud countdown
	local ID = "Event"..GetID("")
	HudRemoveCountdown(ID,false)
end




-- *******************************************
--
-- Event: Kontor needs items
-- 
-- *******************************************

function NeedItems()

	local Needed = 5
	
	-- use an random event. Chance different for each event
	local Type = Rand(6)
	
	local	Item = state_kontor_event_NeedItemsFindItem(Type)
	if not Item then
		return
	end
	
	local BasePrice = ItemGetBasePrice(Item)
	if BasePrice<1 then
		return
	end
	
	-- set initial items to zero
	if GetItemCount("", Item, INVENTORY_STD) > 0 then
		RemoveItems("", Item, GetItemCount("", Item, INVENTORY_STD), INVENTORY_STD)
	end
	
	Needed = Rand(20)*Needed + 15 + Needed
	SetData("Item", Item)
	SetProperty("", "EventItem", Item)
	
	local CurrentTime = GetGametime()
	local Gametime	= Rand(13) + 16
	local DestTime  = CurrentTime + Gametime
	local	ToDo	= Gametime2Realtime(Gametime)
	local ItemLabel	= ItemGetLabel(Item, false)
	local	Count
	local	Success 	= false
	local ID = "Event"..GetID("")

	-- message to insert here: start of the event
	GetSettlement("", "City")

	MsgNewsNoWait("All","","@C[@L_KONTOR_MISSIONS_NEED_ITEMS_COOLDOWN_+0,%5i,%6l]","economie",-1,
			       "@L_KONTOR_MISSIONS_NEED_ITEMS_HEAD_+"..Type,
			       "@L_KONTOR_MISSIONS_NEED_ITEMS_TEXT_+"..Type,
			       GetID("City"), Needed, ItemLabel, Gametime, DestTime,ID)

	CitySetFixedPrice("", Item, BasePrice*2.5, BasePrice*3.25, Gametime)

	while ToDo>0 do

		Count = GetItemCount("", Item, INVENTORY_STD)
		if Count >= Needed then
			Success = true
			-- reset prices
			CitySetFixedPrice("", Item, -1, -1, -1)
			break
		end
		
		if Count==0 then
			AddItems("", Item, 1, INVENTORY_STD)
		end
		
		-- fix for restoring event prices after save/load
		if ItemGetPriceSell(Item, "") < BasePrice*2.4 then
			CitySetFixedPrice("", Item, BasePrice*2.5, BasePrice*3.25, DestTime - GetGametime())
		end
		
		ToDo = ToDo - 4
		Sleep(4)
	end

	-- message to insert here: end of the event
	if Success then
		feedback_MessageEconomie("All", "@L_KONTOR_MISSIONS_NEED_ITEMS_SUCCESS_HEAD_+0",
						"@L_KONTOR_MISSIONS_NEED_ITEMS_SUCCESS_TEXT_+0",
						GetID("City"), Needed, ItemLabel)
	else
		feedback_MessageEconomie("All", "@L_KONTOR_MISSIONS_NEED_ITEMS_FAILED_HEAD_+0",
						"@L_KONTOR_MISSIONS_NEED_ITEMS_FAILED_TEXT_+0",
						GetID("City"), Needed, ItemLabel)
	end
end

function NeedItemsFindItem(event)

	local	Items = {}
	-- Waren
	if event == 0 then
		Items = { 
			"Blanket", "HerbTea", "Poem", "Torch", "Holzpferd", 
			"WalkingStick", "Schnitzi", "MoneyBag", "LeatherGloves", 
			"vase", "Chaplet", "Kerzen", "Urkunde", "Siegelring"
			}
	-- Gebäudebau
	elseif event == 1 then
		Items = { 
			"Pinewood", "Charcoal", "Oakwood", "Tool", "Pech",
			"Granite", "Dye", "BuildMaterial"
			}
	-- Nahrungsmittel
	elseif event == 2 then
		Items = { 
		  "Beef", "Honey", "FishSoup", 
			"Cookie", "FriedHerring", "BreadRoll",
			"GrainPap", "Wheatbread", "Shellsoup", "Wurst", 
			"Cheese", "Salat", "Fungi", "Fruit"
			}
	-- Kriegsmaterial
	elseif event == 3 then
		Items = { 
			"IronCap", "IronBrachelet", 
			"LeatherArmor", "Grindingbrick", "FullHelmet", 
			"Dagger", "Mace", "Shortsword"
			}
	-- Fest-Waren
	elseif event == 4 then
		Items = { 
			"Perfume", "SmallBeer", "WheatBeer", "Wein", "Mead", "CreamPie", 
			"Cake", "CitizensClothes", "NoblesClothes", "Shellchain", "PearlChain",
			"SilverRing", "SalmonFilet", "SmokedSalmon", "RoastBeef", "Phiole", "Pastry"
			}
	else
	-- Rohstoffe
		Items = { 
			"Iron", "Silver", "Gold", "Wheat", "Flachs",
			"Wool", "Milch", "Leather",
			"Herring", "Salmon", "Fat"
			}
	end

	local	Count = 1
	while Items[Count] do
		Count = Count + 1
	end

	local	Sel	= Rand(Count-1)+1
	return Items[Sel]
end

function NeedItemsCleanUp()
	local Item = GetData("Item")
	if Item then
		local Count = GetItemCount("", Item, INVENTORY_STD)
		RemoveItems("", Item, Count, INVENTORY_STD)
		CitySetFixedPrice("", Item, -1, -1, -1)
	end
end



-- *******************************************
--
-- Event: Kontor offers resources/gathers
-- 
-- *******************************************

function OfferItems()
	GetSettlement("", "City")
	-- use an random event
	local random
	if CityIsKontor("City") then
		random = Rand(4)
	else
		-- only offer resources in cities
		random = 3
	end

	local	Item = state_kontor_event_OfferItemsFindItem(random)
	if not Item then
		return
	end
	
	local BasePrice = ItemGetBasePrice(Item)
	if BasePrice<1 then
		return
	end
	
	local Offering = 0
	
	if random == 0 then -- Waren
		Offering = Rand(10)*5 + 10
	elseif random == 1 then --Kriegsmaterial
		Offering = 20 + Rand(11)*3
	elseif random == 2 then --Lebensmittel
		Offering = 30 + Rand(15)*5
	elseif random == 3 then -- Rohstoffe
		Offering = 100 + Rand(21)*10
	end
	
	if Item == "Gemstone" then
		Offering = 20 + Rand(8)*5
	elseif Item == "Pastry" then
		Offering = 10 + Rand(11)*2
	end
	
	SetData("Item", Item)
	SetProperty("", "EventItem", Item)
	
	local CurrentTime = GetGametime()
	local Gametime	= Rand(7)+6
	local DestTime     = CurrentTime + Gametime
	local	ToDo			= Gametime2Realtime(Gametime)
	local ItemLabel	= ItemGetLabel(Item, false)
	local	Count
	local	Success 	= false
	local ID = "Event"..GetID("")
	
	-- first remove all items of this type	
	Count = GetItemCount("", Item, INVENTORY_STD)
	RemoveItems("", Item, Count, INVENTORY_STD)
	
	AddItems("", Item, Offering, INVENTORY_STD)
	CitySetFixedPrice("", Item, BasePrice*0.2, BasePrice*0.65, Gametime)
	
	MsgNewsNoWait("All","","@C[@L_KONTOR_MISSIONS_OFFER_ITEMS_COOLDOWN_+0,%5i,%6l]","economie",-1,
			       "@L_KONTOR_MISSIONS_OFFER_ITEMS_HEAD_+"..random,
			       "@L_KONTOR_MISSIONS_OFFER_ITEMS_TEXT_+"..random,
			       GetID("City"), Offering, ItemLabel, Gametime,DestTime,ID)
	
	while ToDo>0 and not Success do
		Sleep(4)
		Count = GetItemCount("", Item, INVENTORY_STD)
		if Count < 1 then
			Success = true
			CitySetFixedPrice("", Item, -1, -1, -1)
		elseif ItemGetPriceBuy(Item, "") > BasePrice then
			-- fix for restoring event prices after save/load
			CitySetFixedPrice("", Item, BasePrice*0.2, BasePrice*0.65, DestTime - GetGametime())
		end
		
		ToDo = ToDo - 4
	end

	-- message to insert here: end of the event
	if Success then
		feedback_MessageEconomie("All", "@L_KONTOR_MISSIONS_OFFER_ITEMS_SUCCESS_HEAD_+0",
						"@L_KONTOR_MISSIONS_OFFER_ITEMS_SUCCESS_TEXT_+0",
						GetID("City"), ItemLabel)
	else
		feedback_MessageEconomie("All", "@L_KONTOR_MISSIONS_OFFER_ITEMS_FAILED_HEAD_+0",
						"@L_KONTOR_MISSIONS_OFFER_ITEMS_FAILED_TEXT_+0",
						GetID("City"), ItemLabel)
	end

end

function OfferItemsFindItem(event)

	local	Items = {}
	-- Waren
	if event == 0 then
		Items = { 
			"Poem", "ThesisPaper", 
			"AboutTalents1", "AboutTalents2", "Perfume", "Soap", "Candy",
			"optieisen", "optisilber", "optigold",
			"CartBooster", "Pfandbrief", "Bible",
			"MoneyBag", "WalkingStick", "Phiole"
			}
	-- Kriegsmaterial
	elseif event == 1 then
		Items = { 
			"IronBrachelet", "LeatherArmor", "Chainmail", "FullHelmet", 
			"Platemail", "Longsword", "Axe", "Shortsword"
			}
	-- Lebensmittel
	elseif event == 2 then
		Items = { 
			"Wheatbread", "FriedHerring", "BreadRoll", "Wein",
			"Shellsoup", "RoastBeef", "SalmonFilet", "Mead",
			"SmokedSalmon", "SmallBeer", "WheatBeer", "Cake",
			"Honey", "Fruit", "CreamPie", "Pastry"
			}
	else
	-- Rohstoffe
		Items = { 
			"Iron", "Silver", "Gold", "Salt", "Gemstone",
			"Pinewood", "Oakwood", "Leather", "Pech",
			"Wool", "Wheat", "Charcoal", "Fungi", "Flachs",
			"Herring", "Salmon", "Milch", "WheatFlour"
			}
	end

	local	Count = 1
	while Items[Count] do
		Count = Count + 1
	end

	local	Sel	= Rand(Count-1)+1
	return Items[Sel]
end

function OfferItemsCleanUp()
	local Item = GetData("Item")
	if Item then
		local Count = GetItemCount("", Item, INVENTORY_STD)
		RemoveItems("", Item, Count, INVENTORY_STD)
		CitySetFixedPrice("", Item, -1, -1, -1)
	end
end

