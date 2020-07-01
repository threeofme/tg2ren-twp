
function GameStart()

	if not GetSettlement("", "City") then
		return 0
	end
	
	if CityIsKontor("City") then
		return 0
	end
	
	local Level = CityGetLevel("City")
	-- Generate starting market
	
	-- Food and Drinks (2)
		-- Mill
	marketpinghour_CheckItem(Level, "WheatFlour", 10)
	marketpinghour_CheckItem(Level, "Oil", 2)
	marketpinghour_CheckItem(Level, "Saft", 2)
		-- Church
	marketpinghour_CheckItem(Level, "Housel", 2)
		-- Alchimist
	marketpinghour_CheckItem(Level, "HerbTea", 1)
		-- Farmer
	marketpinghour_CheckItem(Level, "Milch", 2)
		-- Baker
	marketpinghour_CheckItem(Level, "Cookie", 1)
	marketpinghour_CheckItem(Level, "Wheatbread", 1)
	marketpinghour_CheckItem(Level, "BreadRoll", 2)
	marketpinghour_CheckItem(Level, "Cake", 1)
	marketpinghour_CheckItem(Level, "CreamPie", 0.5)
	marketpinghour_CheckItem(Level, "Candy", 0.5)
	marketpinghour_CheckItem(Level, "Pastry", 0.5)
		-- Tavern
	marketpinghour_CheckItem(Level, "GrainPap", 1)
	marketpinghour_CheckItem(Level, "SmallBeer", 1)
	marketpinghour_CheckItem(Level, "Stew", 2)
	marketpinghour_CheckItem(Level, "Weingeist", 10)
	marketpinghour_CheckItem(Level, "WheatBeer", 1)
	marketpinghour_CheckItem(Level, "SalmonFilet", 1)
	marketpinghour_CheckItem(Level, "Mead", 0.5)
	marketpinghour_CheckItem(Level, "RoastBeef", 0.5)
	marketpinghour_CheckItem(Level, "Wein", 0.5)
	marketpinghour_CheckItem(Level, "BoozyBreathBeer", 0.5)
		-- Fisher
	marketpinghour_CheckItem(Level, "FriedHerring", 2)
	marketpinghour_CheckItem(Level, "FishSoup", 1)
	marketpinghour_CheckItem(Level, "SmokedSalmon", 1)
	marketpinghour_CheckItem(Level, "Shellsoup", 0.5)

	-- Handcraft (3)
		-- Joiner
	marketpinghour_CheckItem(Level, "Torch", 2)
	marketpinghour_CheckItem(Level, "Schnitzi", 1)
	marketpinghour_CheckItem(Level, "WalkingStick", 0.5)
	marketpinghour_CheckItem(Level, "BuildMaterial", 1)
	marketpinghour_CheckItem(Level, "Holzpferd", 0.5)
	marketpinghour_CheckItem(Level, "Kamm", 0.5)
	marketpinghour_CheckItem(Level, "CrossOfProtection", 0.5)
	marketpinghour_CheckItem(Level, "RubinStaff", 0.5)
		-- Tailor
	marketpinghour_CheckItem(Level, "Blanket", 1)
	marketpinghour_CheckItem(Level, "FarmersClothes", 1)
	marketpinghour_CheckItem(Level, "MoneyBag", 0.5)
	marketpinghour_CheckItem(Level, "CitizensClothes", 1)
	marketpinghour_CheckItem(Level, "LeatherGloves", 1)
	marketpinghour_CheckItem(Level, "CamouflageCloak", 0.5)
	marketpinghour_CheckItem(Level, "NoblesClothes", 1)
	marketpinghour_CheckItem(Level, "GlovesOfDexterity", 0.5)
	marketpinghour_CheckItem(Level, "LeatherArmor", 1)
		-- Stonemason
	marketpinghour_CheckItem(Level, "vase", 0.5)
	marketpinghour_CheckItem(Level, "Stonerotary", 0.5)
	marketpinghour_CheckItem(Level, "Blissstone", 0.5)
	marketpinghour_CheckItem(Level, "Gravestone", 0.5)
	marketpinghour_CheckItem(Level, "statue", 0.5)
	marketpinghour_CheckItem(Level, "Gargoyle", 0.5)
		-- Fisher
	marketpinghour_CheckItem(Level, "Shellchain", 0.5)
	marketpinghour_CheckItem(Level, "PearlChain", 0.5)
		-- Juggler
	marketpinghour_CheckItem(Level, "Amulet", 2)
	marketpinghour_CheckItem(Level, "Spindel", 0.25)
	marketpinghour_CheckItem(Level, "Pendel", 0.25)
	marketpinghour_CheckItem(Level, "Voodo", 0.25)
		-- Necro
	marketpinghour_CheckItem(Level, "Schadelkerze", 0.5)
	marketpinghour_CheckItem(Level, "Knochenarmreif", 0.5)
	marketpinghour_CheckItem(Level, "Boneflute", 0.5)
	marketpinghour_CheckItem(Level, "Robe", 0.5)
	marketpinghour_CheckItem(Level, "FalseRelict", 0.5)
	
	-- Documents (4)
		-- Church
	marketpinghour_CheckItem(Level, "Kerzen", 2)
	marketpinghour_CheckItem(Level, "Poem", 1)
	marketpinghour_CheckItem(Level, "Chaplet", 0.5)
	marketpinghour_CheckItem(Level, "AboutTalents1", 0.5)
	marketpinghour_CheckItem(Level, "ThesisPaper", 0.5)
	marketpinghour_CheckItem(Level, "AboutTalents2", 0.5)
	marketpinghour_CheckItem(Level, "Hasstirade", 0.25)
	marketpinghour_CheckItem(Level, "Bible", 0.5)
	marketpinghour_CheckItem(Level, "LetterOfIndulgence", 0.5)
	marketpinghour_CheckItem(Level, "LetterFromRome", 0.25)
		-- Bank
	marketpinghour_CheckItem(Level, "Siegelring", 0.5)
	marketpinghour_CheckItem(Level, "Schuldenbrief", 0.5)
	marketpinghour_CheckItem(Level, "Optieisen", 1)
	marketpinghour_CheckItem(Level, "Urkunde", 0.5)
	marketpinghour_CheckItem(Level, "Optisilber", 1)
	marketpinghour_CheckItem(Level, "Handwerksurkunde", 0.5)
	marketpinghour_CheckItem(Level, "Optigold", 0.5)
	marketpinghour_CheckItem(Level, "Pfandbrief", 0.5)
	marketpinghour_CheckItem(Level, "Empfehlung", 0.25)
		-- Necro
	marketpinghour_CheckItem(Level, "HexerdokumentI", 0.25)
	marketpinghour_CheckItem(Level, "HexerdokumentII", 0.25)
		-- Juggler
	marketpinghour_CheckItem(Level, "TarotCards", 0.25)
	
	-- Fragrance & Herb (5)
	
		-- Joiner
	marketpinghour_CheckItem(Level, "CartBooster", 2)	
		-- Alchimist
	marketpinghour_CheckItem(Level, "Phiole", 0.5)
	marketpinghour_CheckItem(Level, "FlowerOfDiscord", 0.25)
	marketpinghour_CheckItem(Level, "Perfume", 1)
	marketpinghour_CheckItem(Level, "FragranceOfHoliness", 1, 0.5)
	marketpinghour_CheckItem(Level, "DrFaustusElixir", 1, 0.5)
	marketpinghour_CheckItem(Level, "ToadExcrements", 1, 0.5)
	marketpinghour_CheckItem(Level, "ToadSlime", 1, 0.5)
	marketpinghour_CheckItem(Level, "WeaponPoison", 1, 0.5)
	marketpinghour_CheckItem(Level, "ParalysisPoison", 1, 0.5)
	marketpinghour_CheckItem(Level, "BlackWidowPoison", 1, 0.5)
		-- Tavern
	marketpinghour_CheckItem(Level, "GhostlyFog", 1, 0.5)
		-- Hospital
	marketpinghour_CheckItem(Level, "Salve", 2)	
	marketpinghour_CheckItem(Level, "Soap", 2)
	marketpinghour_CheckItem(Level, "Antidote", 2)
	marketpinghour_CheckItem(Level, "Mixture", 0.5)
		-- Necro
	marketpinghour_CheckItem(Level, "Pddv", 0.25)
	
	-- Ironstuff (6)
		-- Smithy
	marketpinghour_CheckItem(Level, "Nails", 3)
	marketpinghour_CheckItem(Level, "Tool", 1)
	marketpinghour_CheckItem(Level, "Dagger", 2)
	marketpinghour_CheckItem(Level, "SilverRing", 1)
	marketpinghour_CheckItem(Level, "IronBrachelet", 2)
	marketpinghour_CheckItem(Level, "GoldChain", 0.5)
	marketpinghour_CheckItem(Level, "BeltOfMetaphysic", 0.5)
	marketpinghour_CheckItem(Level, "GemRing", 0.5)
	marketpinghour_CheckItem(Level, "Diamond", 0.5)
	marketpinghour_CheckItem(Level, "Shortsword", 2)
	marketpinghour_CheckItem(Level, "IronCap", 1)
	marketpinghour_CheckItem(Level, "Chainmail", 0.5)
	marketpinghour_CheckItem(Level, "Longsword", 1)
	marketpinghour_CheckItem(Level, "FullHelmet", 1)
	marketpinghour_CheckItem(Level, "Platemail", 0.5)
		-- Joiner
	marketpinghour_CheckItem(Level, "Mace", 2)
	marketpinghour_CheckItem(Level, "BoobyTrap", 3)
	marketpinghour_CheckItem(Level, "Axe", 0.5)
		--Pirate
	marketpinghour_CheckItem(Level, "Matchlock", 0.5)
	marketpinghour_CheckItem(Level, "Snaplock", 0.5)
	marketpinghour_CheckItem(Level, "Wheellock", 0.5)
	
	-- Ressources (1)
		-- Farmer
	marketpinghour_CheckItem(Level, "Wheat", 12)
	marketpinghour_CheckItem(Level, "Flachs", 10)
	marketpinghour_CheckItem(Level, "Wool", 12)
	marketpinghour_CheckItem(Level, "Fat", 10)
	marketpinghour_CheckItem(Level, "Leather", 10)
	marketpinghour_CheckItem(Level, "Beef", 10)
		-- Fisher
	marketpinghour_CheckItem(Level, "Herring", 12)
	marketpinghour_CheckItem(Level, "Salmon", 12)
		-- Orchardist
	marketpinghour_CheckItem(Level, "Fruit", 10)
	marketpinghour_CheckItem(Level, "Honey", 10)
		-- Woodcutter
	marketpinghour_CheckItem(Level, "Pinewood", 12)
	marketpinghour_CheckItem(Level, "Oakwood", 10)
	marketpinghour_CheckItem(Level, "Charcoal", 10)
	marketpinghour_CheckItem(Level, "Fungi", 10)
	marketpinghour_CheckItem(Level, "Pech", 10)
		-- Mine
	marketpinghour_CheckItem(Level, "Iron", 12)
	marketpinghour_CheckItem(Level, "Silver", 10)
	marketpinghour_CheckItem(Level, "Gold", 10)
	marketpinghour_CheckItem(Level, "Gemstone", 10)
		-- Stonemason
	marketpinghour_CheckItem(Level, "Grindingbrick", 3)
		-- Mill
	marketpinghour_CheckItem(Level, "Dye", 10)
	marketpinghour_RemoveStart()
	
end

function PingHour()
	-- Spawn Ressources every hour if they are very low
	
	if not GetSettlement("", "City") then
		return 0
	end
	
	if CityIsKontor("City") then
		return 0
	end
	
	local Level = CityGetLevel("City")
	-- disable resource spawning on harder difficulties
	local Difficulty = ScenarioGetDifficulty() -- easy 0, 1, 2, 3, 4 hard
	local AddMissing = Difficulty < 3 or GetRound() < 12 - (4 * (4 - Difficulty))
	-- TODO re-enable resource spawning in early game
	AddMissing = false
	
		-- Farmer
	marketpinghour_CheckItem(Level, "Wheat", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Flachs", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Wool", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Fat", 5, AddMissing)
	marketpinghour_CheckItem(Level, "Leather", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Beef", 2, AddMissing)
	marketpinghour_CheckItem(Level, "Milch", 2, AddMissing)
		-- Orchardist
	marketpinghour_CheckItem(Level, "Fruit", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Honey", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Fungi", 4, AddMissing)
		-- Woodcutter
	marketpinghour_CheckItem(Level, "Pinewood", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Oakwood", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Charcoal", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Pech", 5, AddMissing)
		-- Mine
	marketpinghour_CheckItem(Level, "Iron", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Silver", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Gold", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Gemstone", 2, AddMissing)
		-- Stonemason
	marketpinghour_CheckItem(Level, "Grindingbrick", 2, AddMissing)
		-- Mill
	marketpinghour_CheckItem(Level, "WheatFlour", 4, AddMissing)
	marketpinghour_CheckItem(Level, "Oil", 2, AddMissing)
		-- Smithy
	marketpinghour_CheckItem(Level, "Nails", 2, AddMissing)
		-- Alchemist
	marketpinghour_CheckItem(Level, "Dye", 3, AddMissing)
	marketpinghour_CheckItem(Level, "Weingeist", 3, AddMissing)
	
	GetScenario("World")
	if HasProperty("World","seamap") then
			-- Fisher
		marketpinghour_CheckItem(Level, "Herring", 4, AddMissing)
		marketpinghour_CheckItem(Level, "Salmon", 4, AddMissing)
	else
			-- Fisher
		marketpinghour_CheckItem(Level, "Herring", 4, true)
		marketpinghour_CheckItem(Level, "Salmon", 6, true)
	end

	marketpinghour_RemoveItemMarket()
	
	if Rand(100) < 5 and not GetState("", STATE_KONTOR_EVENT) then
		SetState("", STATE_KONTOR_EVENT, true)
	end	
end


function CheckItem(CityLevel, Item, MinCount, AddMissing)
	
	local Wanted = math.floor((MinCount*CityLevel))
	local Count = GetItemCount("", Item, INVENTORY_STD)
	local AddCount = 0
	
	if AddMissing and Count < Wanted then
		AddCount = Wanted-Count
		if ItemGetCategory(Item)==1 then
			AddCount = AddCount - Rand(12)
		end
		
		if AddCount <1 then 
			AddCount = 1
		end
		
		AddItems("", Item, AddCount, INVENTORY_STD)
	end
	
	Count = GetItemCount("", Item, INVENTORY_STD)
	
	if Count > 1000 then
	local new = 100+Rand(Wanted)
		RemoveItems("", Item, Count, INVENTORY_STD)
		RemoveEmptySlots("", INVENTORY_STD)
		AddItems("", Item, new, INVENTORY_STD)
	end
end

function RemoveStart()
	-- Some items are too powerful for gamestart so we remove them (but keep the slot for info)
	if not GetSettlement("", "City") then
		return 0
	end
	
	if CityIsKontor("City") then
		return 0
	end
	local Name
	local Count
	local item = {	"Matchlock","Snaplock","Wheellock", "Diamond", "BlackWidowPoison", "ToadSlime", "ToadExcrements",
				"Mixture", "HexerdokumentI", "HexerdokumentII", "Pddv", "Empfehlung", "Hasstirade", "LetterFromRome",
				"Axe", "Platemail"
				}
	for i=1, 16 do
		Name = item[i]
		if (Name ~= nil) then
			Count = GetItemCount("", Name, INVENTORY_STD)
			RemoveItems("", Name, Count, INVENTORY_STD)
		end
	end
end

function RemoveItemMarket()
	-- Delete items from market slowly if noone ever buys them
	if not GetSettlement("", "City") then
		return 0
	end
	
	if CityIsKontor("City") then
		return 0
	end

	local chance, Name, Baseprice, Sellprice, Count
	local Reducevalue
	local item = {
		"Cookie", "Wheatbread", "Cake", 
		"BreadRoll", "CreamPie", "Candy", "Pastry", "GrainPap", 
		"SmallBeer", "Stew", "SalmonFilet", "WheatBeer", "Mead", 
		"RoastBeef", "Wein", "BoozyBreathBeer", "GhostlyFog", "FriedHerring",
		"FishSoup", "SmokedSalmon",  "Shellchain", "Shellsoup", "Pearlchain",
		"Saft", "Tool", "Dagger", "SilverRing", "IronBrachelet",
		"GoldChain", "BeltOfMetaphysic", "GemRing", "Diamond", "Shortsword",
		"IronCap","Chainmail", "Longsword", "FullHelmet", "Platemail",
		"Torch", "Schnitzi", "WalkingStick", "BuildMaterial", "Holzpferd",
		"Mace", "CartBooster", "Kamm", "CrossOfProtection", "RubinStaff", 
		"Axe", "Blanket", "FarmersClothes", "MoneyBag", "CitizensClothes",
		"LeatherGloves", "CamouflageCloak", "NoblesClothes",  "GlovesOfDexterity", "LeatherArmor",
		"vase", "Stonerotary", "Blissstone", "Gravestone", "statue",
		"Gargoyle", "HerbTea", "Phiole", "FlowerOfDiscord", "Perfume", 
		"BoobyTrap", "FragranceOfHoliness", "DrFaustusElixir", "WeaponPoison",
		"ToadExcrements", "ParalysisPoison", "Toadslime", "BlackWidowPoison", "Housel", 
		"Kerzen", "Poem", "ThesisPaper", "AboutTalents2", "Hasstirade",
		"Bible", "Chaplet", "AboutTalents1", "LetterOfIndulgence", "LetterFromRome", 
		"Soap", "Salve", "Antidote", "Mixture", "Siegelring",
		"Schuldenbrief", "Optieisen", "Urkunde", "Optisilber", "Pfandbrief",
		"Optigold",  "Empfehlung",  "Handwerksurkunde",
		"Schadelkerze", "Knochenarmreif", "BoneFlute", "HexerdokumentI", "Robe",
		"FalseRelict", "HexerdokumentII", "Pddv", "Amulet", "Spindel",
		"Pendel", "Voodo", "TarotCards", "Round", "Matchlock",
		"Wheellock",  "Snaplock", "Amber", "Porcelain", "Spicery",
		"Silk", "OrientalCarpet", "OrientalStatues", "OrientalTobacco", "Sugar"
		}
 
	for i=0, 127 do
	Name = item[i]
	
		if (Name ~= nil) then
			Count = GetItemCount("", Name, INVENTORY_STD)
			if Count >500 then
				RemoveItems("", Name, Count, INVENTORY_STD)
				RemoveEmptySlots("", INVENTORY_STD)
				AddItems("", Name, 5, INVENTORY_STD)
			end
			
			Baseprice = ItemGetBasePrice(Name)
			Sellprice = ItemGetPriceSell(Name, "") 
			Reducevalue = Rand(3) -- sell 0 to 2
			
			if Sellprice < Baseprice then
				Transfer(nil, nil, INVENTORY_STD, "", INVENTORY_STD, Name, Reducevalue)
			end 

		end
	end
end

function CleanUp()
end