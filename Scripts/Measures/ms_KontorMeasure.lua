function Run()

	GetSettlement("", "City")

	local Firsttime		= true
	local TimeToSleep = Gametime2Realtime(0.5)
	local Count
	local Item
	local Demand
	local Stock
	local LocalCityId = GetID("City")
	
	
	while true do
	
		if Rand(100)>=90 then
			Count = GetData("#KontorEventCount")
			if (not Count) or Count<1 then
				if not GetState("", STATE_KONTOR_EVENT) then
					SetState("", STATE_KONTOR_EVENT, true)
				end
			end
		end

		Sleep(TimeToSleep)
		
		local	Check = {}
		
		local EventItem = GetProperty("", "EventItem")
		local EvID  = -1
		if EventItem then
			EvID = ItemGetID(EventItem)
		end
		
		Count = ScenarioGetKontorGoodCount()
		local CityId
		for g=0, Count-1 do
			Item, Demand, CityId = ScenarioGetKontorGoodInfo(g)
			if Item ~= -1 and Item ~= EvID and Item ~= EventItem and CityId == LocalCityId then
				if Demand>0 then
					ms_kontormeasure_CheckItem(Item, Demand*2, Firsttime)
					Check[Item] = true
				end
			end
		end
		
		Count = InventoryGetSlotCount("", INVENTORY_STD)
		
		-- add some random item occasionally
		if Rand(10) < 1 and Count < 20 then
			local It = ms_kontormeasure_GetRandomItem()
			if It and GetItemCount("", It, INVENTORY_STD) < 1 then
				ms_kontormeasure_CheckItem(It, Rand(40) + 5, true)
				Check[It] = true
				Count = Count + 1
			end
		end
		
		Count = InventoryGetSlotCount("", INVENTORY_STD)
		for g=0,Count-1 do
		
			Item, Demand = InventoryGetSlotInfo("", g, INVENTORY_STD)
			if Item and Check[Item] ~= true and Item~=EvID then
				if Demand>0 then
					Transfer(nil, nil, INVENTORY_STD, "", INVENTORY_STD, Item, (1+Rand(3)))
				end
			end
		end
		
		RemoveEmptySlots("", INVENTORY_STD)
		Firsttime = false

	end
end

function CheckItem(Item, Wanted, FirstTime)
	if Wanted <= 0 then
		return
	end
	
	local Count = GetItemCount("", Item, INVENTORY_STD)
	if Count >= Wanted then
		return
	end
	
	local ItemType = ItemGetType(Item)
	local StartSpawn = Wanted
	
	-- Max start spawn by type
	if ItemType == 8 or ItemType == 2 or ItemType == 1 then
		if Wanted < 50 then
			StartSpawn = 50 + Rand(51)
		end
	elseif ItemType == 5 then
		if Wanted > 20 then
			StartSpawn = 5 + Rand(11)
		end
	elseif ItemType == 3 then
		if Wanted > 50 then
			StartSpawn = 50 - Rand(25)
		end
	end
	
	local	Var = 95 - (Wanted-Count)*0.5
	
	local Grow = (Wanted-Count) * 0.05
	if Grow < 2 then
		Grow = 2
	end
	
	if Grow > 5 then
		Grow = 10
	end
	
	
	if Count < Wanted then
		if not FirstTime then
			if Rand(101) > Var then
				AddItems("", Item, (Rand(Grow)+1), INVENTORY_STD)
			end
		else
			AddItems("", Item, (Rand(StartSpawn)+1), INVENTORY_STD)
		end
	end
	
	local	Base = ItemGetBasePrice(Item)
	if Base~=-1 then
	
		local PriceIn = Base * 0.25
		Count = GetItemCount("", Item, INVENTORY_STD)
	
		local	Quote		= 0.61 + 0.85*(1 - Count / Wanted)
		if Base >= 750 then
			Quote = 1.20 + 0.54*(1 - Count / Wanted)
		end
		local PriceOut = Base * Quote
	
		CitySetFixedPrice("", Item, PriceIn, PriceOut, -1)
	end	
end

function GetRandomItem() 
	local ItemList = {
	"Wheat"
, "Flachs"
, "Wool"
, "Fat"
, "Leather"
, "Milch"
, "Beef"
, "Cookie"
, "Wheatbread"
, "Cake"
, "BreadRoll"
, "CreamPie"
, "Candy"
, "Pastry"
, "GrainPap"
, "SmallBeer"
, "Stew"
, "Weingeist"
, "WheatBeer"
, "SalmonFilet"
, "Mead"
, "RoastBeef"
, "Wein"
, "BoozyBreathBeer"
, "GhostlyFog"
, "Herring"
, "Salmon"
, "FriedHerring"
, "FishSoup"
, "SmokedSalmon"
, "Shellchain"
, "Shellsoup"
, "Pearlchain"
, "Fruit"
, "Dagger"
, "Honey"
, "Longsword"
, "WheatFlour"
, "Oil"
, "Dye"
, "Saft"
, "Nails"
, "Tool"
, "SilverRing"
, "IronBrachelet"
, "GoldChain"
, "BeltOfMetaphysic"
, "GemRing"
, "Diamond"
, "Shortsword"
, "IronCap"
, "Chainmail"
, "FullHelmet"
, "Platemail"
, "Torch"
, "Schnitzi"
, "WalkingStick"
, "BuildMaterial"
, "Holzpferd"
, "Mace"
, "CartBooster"
, "Kamm"
, "CrossOfProtection"
, "RubinStaff"
, "Axe"
, "Blanket"
, "FarmersClothes"
, "MoneyBag"
, "CitizensClothes"
, "LeatherGloves"
, "CamouflageCloak"
, "NoblesClothes"
, "GlovesOfDexterity"
, "LeatherArmor"
, "Grindingbrick"
, "vase"
, "Stonerotary"
, "Blissstone"
, "Gravestone"
, "statue"
, "Gargoyle"
, "Pinewood"
, "Oakwood"
, "Charcoal"
, "Fungi"
, "Pech"
, "Iron"
, "Silver"
, "Gold"
, "HerbTea"
, "Phiole"
, "FlowerOfDiscord"
, "Perfume"
, "BoobyTrap"
, "FragranceOfHoliness"
, "DrFaustusElixir"
, "WeaponPoison"
, "ToadExcrements"
, "ParalysisPoison"
, "Toadslime"
, "BlackWidowPoison"
, "Housel"
, "Kerzen"
, "Poem"
, "ThesisPaper"
, "AboutTalents2"
, "Hasstirade"
, "Bible"
, "Chaplet"
, "AboutTalents1"
, "LetterOfIndulgence"
, "LetterFromRome"
, "Soap"
, "Salve"
, "Antidote"
, "Mixture"
, "Siegelring"
, "Schuldenbrief"
, "Optieisen"
, "Urkunde"
, "Optisilber"
, "Pfandbrief"
, "Optigold"
, "Empfehlung"
, "Handwerksurkunde"
, "Schadelkerze"
, "Knochenarmreif"
, "BoneFlute"
, "HexerdokumentI"
, "Robe"
, "FalseRelict"
, "HexerdokumentII"
, "Pddv"
, "Amulet"
, "Spindel"
, "Pendel"
, "Voodo"
, "TarotCards"
, "Round"
, "Matchlock"
, "Wheellock"
, "Snaplock"
	}
	local count = 142
	local random = Rand(count + 1)
	return ItemList[random]
end
