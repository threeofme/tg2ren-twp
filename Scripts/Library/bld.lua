-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

-- -----------------------
-- GetEmployeesInBuilding
-- -----------------------
function GetEmployeesInBuilding(BuildingAlias)

	local WorkerCount = BuildingGetWorkerCount(BuildingAlias)
	local Counter = WorkerCount
	
	while(Counter>0) do		
		BuildingGetWorker(BuildingAlias, Counter-1, "EmployeeNr"..Counter)
		Counter = Counter - 1
	end

	return WorkerCount
end

-- -----------------------
-- Stop former employees to work
-- -----------------------
function BuildingWorkersStopWorking(BuildingAlias)
	local Alias
	local workerCount = BuildingGetSimCount(BuildingAlias)
	GetSettlement(BuildingAlias, "City")
	
	if workerCount >0 then
		for i=0, workerCount-1 do
			if BuildingGetSim(BuildingAlias, i, "Worker"..i) then
				if GetHomeBuilding("Worker"..i, "WorkerHome") then
					if GetID("WorkerHome") == GetID(BuildingAlias) then
						-- assign a new home
						if CityGetNearestBuilding("City", "Worker"..i, 1, 1, -1, -1, FILTER_IGNORE, "Home") then
							SetHomeBuilding("Worker"..i, "Home")
						end
					end
				end
				-- stop the work
				if GetState("Worker"..i, STATE_WORKING) and SimGetClass("Worker"..i) ~= 4 then
					SimSetProduceItemID("Worker"..i, -1, -1)
					SimStopMeasure("Worker"..i)
				end
				-- exit
				if GetInsideBuildingID("Worker"..i) == GetID(BuildingAlias) then
					f_ExitCurrentBuilding("Worker"..i)
				end
			end
		end
	end
end

-- -----------------------
-- Pays out bank account and medicine chest when on sale/sold
-- -----------------------
function ClearBuildingStash(BldAlias, OwnerAlias)
	if BuildingGetType(BldAlias) == GL_BUILDING_TYPE_BANKHOUSE and HasProperty(BldAlias,"BankAccount") then
		local invest = GetProperty(BldAlias,"BankAccount")
		RemoveProperty(BldAlias,"BankAccount")
		if AliasExists(OwnerAlias) then
			f_CreditMoney(OwnerAlias,invest,"BuildingSold")
			-- notify former owner
			MsgNewsNoWait(OwnerAlias, BldAlias, "", "building", -1, 
				"@L_BUYBUILDING_CREDIT_HEAD_+0",
				"@L_BUYBUILDING_CREDIT_BODY_+0", 
				GetID(BldAlias), invest)
		end
	end
	local Count, Items = economy_GetItemsForSale(BldAlias)
	local Value = 0
	local ItemId, ItemCount, Price
	for i = 1, Count do
		ItemId = Items[i]
		ItemCount = GetProperty("Salescounter_"..ItemId) or 0
		Price = economy_GetPrice(BldAlias, ItemId)
		Value = Value + (ItemCount * Price)
		RemoveProperty("Salescounter_"..ItemId)
	end
	if Value > 0 and AliasExists(OwnerAlias) then
		f_CreditMoney(OwnerAlias, Value, "BuildingSold")
		MsgNewsNoWait(OwnerAlias, BldAlias, "", "building", -1, 
			"@L_BUYBUILDING_MEDICINE_HEAD_+0",
			"@L_BUYBUILDING_MEDICINE_BODY_+0", 
			GetID(BldAlias), Value)
	end	
end

-- ------------------
-- GetScaffoldOffsets
-- ------------------
function GetScaffoldOffsets(Proto)
	
	local OffsetX = 0
	local OffsetZ = 0

	if Proto == 100 then -- Barnyard (Hufe)
		OffsetX = -780
		OffsetZ = 240
	elseif Proto == 101 then -- Farm (Bauernhof)
		OffsetX = -850
		OffsetZ = 350
	elseif Proto == 102 then -- FarmEstate (Gutshof)
		OffsetX = -850
		OffsetZ = -150
	elseif Proto == 120 then -- BreadShop (Backstube)
		OffsetX = 100
		OffsetZ = -30
	elseif Proto == 121 then -- Bakery2 (B�ckerei)
		OffsetX = 50
		OffsetZ = -80
	elseif Proto == 122 then -- PastryShop (Konditorei)
		OffsetX = 55
		OffsetZ = -15
	elseif Proto == 130 then -- Taproom (Sch�nke)
		OffsetX = -10
		OffsetZ = -100
	elseif Proto == 131 then -- Inn (Taverne)
		OffsetX = 50
		OffsetZ = 0
	elseif Proto == 132 then -- Tavern (Gasthaus)
		OffsetX = 0
		OffsetZ = -180
	elseif Proto == 140 then -- Foundry (Giesserei)
		OffsetX = 50
		OffsetZ = 20
	elseif Proto == 141 then -- Smithy (Schmiede)
		OffsetX = 250
		OffsetZ = -110
	elseif Proto == 142 then -- Goldsmithy (Goldschmiede)
		OffsetX = 160
		OffsetZ = -105
	elseif Proto == 143 then -- CannonFoundry (Kanonengiesserei)
		OffsetX = 300
		OffsetZ = -140
	elseif Proto == 144 then -- Armourer (R�stungsschmiede)
		OffsetX = 60
		OffsetZ = -1750
	elseif Proto == 150 then -- Joinery (Tischlerei)
		OffsetX = 190
		OffsetZ = 560
	elseif Proto == 151 then -- Turnery (Drechslerei)
		OffsetX = 140
		OffsetZ = 150
	elseif Proto == 152 then -- Finejoinery (Kunsttischlerei)
		OffsetX = 20
		OffsetZ = -200
	elseif Proto == 160 then -- WeavingMill (Weberei)
		OffsetX = 0
		OffsetZ = -100
	elseif Proto == 161 then -- TailorShop (Schneiderei)
		OffsetX = -50
		OffsetZ = -25
	elseif Proto == 162 then -- Couturier (Schneiderei)
		OffsetX = -20
		OffsetZ = -60
	elseif Proto == 170 then -- Tinctury (Tinkturei)
		OffsetX = 15
		OffsetZ = -135
	elseif Proto == 171 then -- AlchemistParlour (Alchimistenstube)
		OffsetX = 70
		OffsetZ = -115
	elseif Proto == 172 then -- InventorWorkshop (Erfinderwerkstatt)
		OffsetX = 100
		OffsetZ = -100
	elseif Proto == 173 then -- GloomyParlour (Zauberstube)
		OffsetX = 140
		OffsetZ = -130
	elseif Proto == 174 then -- SorcererHouse (Magiergilde)
		OffsetX = 300
		OffsetZ = -1350
	elseif Proto == 190 then -- ev.Church (Kirche)
		OffsetX = -40
		OffsetZ = 90
	elseif Proto == 191 then -- ev.Minster (ev.Dom)
		OffsetX = 60
		OffsetZ = 30
	elseif Proto == 192 then -- ev.Cathedral (ev.Kathedrale)
		OffsetX = 220
		OffsetZ = -300
	elseif Proto == 193 then -- kath.Church (kath.Kirche)
		OffsetX = -50
		OffsetZ = 80
	elseif Proto == 194 then -- kath.Minster (kath.Dom)
		OffsetX = 80
		OffsetZ = -100
	elseif Proto == 195 then -- kath.Cathedral (kath.Kathedrale)
		OffsetX = 280
		OffsetZ = -400
	elseif Proto == 230 then -- robber low
		OffsetX = -450
		OffsetZ = -200
	elseif Proto == 231 then -- robber med
		OffsetX = -450
		OffsetZ = -200
	elseif Proto == 240 then -- SmugglerHole (Schmugglerloch)
		OffsetX = 15
		OffsetZ = -100
	elseif Proto == 241 then -- ThievesShelter (Diebesunterschlupf)
		OffsetX = 30
		OffsetZ = -180
	elseif Proto == 242 then -- ThievesGuild (Diebesgilde)
		OffsetX = 130
		OffsetZ = -370
	elseif Proto == 270 then -- rangerhut
		OffsetX = 220
		OffsetZ = -160
	elseif Proto == 300 then -- Pawnshop (Pfandhaus)
		OffsetX = 100
		OffsetZ = -115
	elseif Proto == 301 then -- BankingHouse (Bank)
		OffsetX = 100
		OffsetZ = -1400
	elseif Proto == 310 then -- ConventionHouse (Versammlungshaus)
		OffsetX = -320
		OffsetZ = 60
	elseif Proto == 311 then -- TownHall (Rathaus)
		OffsetX = 100
		OffsetZ = -1950
	elseif Proto == 312 then -- CouncilPalace (Ratspalast)
		OffsetX = 200
		OffsetZ = -2200
	elseif Proto == 330 then -- Dungeon (Schuldturm)
		OffsetX = -30
		OffsetZ = 200
	elseif Proto == 331 then -- Prison (Kerker)
		OffsetX = 80
		OffsetZ = 330
	elseif Proto == 340 then -- School (Schule)
		OffsetX = 10
		OffsetZ = -130
	elseif Proto == 341 then -- University (Universit�t)
		OffsetX = 200
		OffsetZ = -440
	elseif Proto == 200 then -- Watchtower1
		OffsetX = 180
		OffsetZ = -150
	elseif Proto == 201 then -- Watchtower2
		OffsetX = 180
		OffsetZ = -100
	elseif Proto == 202 then -- Watchtower3
		OffsetX = 180
		OffsetZ = -100
	elseif Proto == 365 then -- Warehouse (Warenhaus)
		OffsetX = 750
		OffsetZ = -1900
	elseif Proto == 370 then -- Fishinghut1
		OffsetX = 0
		OffsetZ = -1150
	elseif Proto == 371 then -- Fishinghut2
		OffsetX = 0
		OffsetZ = -1150
	elseif Proto == 372 then -- Fishinghut3
		OffsetX = -100
		OffsetZ = -900
	elseif Proto == 390 then -- Hospital1
		OffsetX = -180
		OffsetZ = -1050
	elseif Proto == 391 then -- Hospital2
		OffsetX = 50
		OffsetZ = -75
	elseif Proto == 392 then -- Hospital3
		OffsetX = 150
		OffsetZ = -200
	elseif Proto == 430 then -- WorkersHut1 (Arbeiterhaus)
		OffsetX = 0
		OffsetZ = -200
	elseif Proto == 431 then -- WorkersHut2 (Arbeiterhaus)
		OffsetX = 80
		OffsetZ = -200
	elseif Proto == 432 then -- WorkersHut3 (Arbeiterhaus)
		OffsetX = 40
		OffsetZ = -210
	elseif Proto == 440 then -- H�tte
		OffsetX = -45
		OffsetZ = -180
	elseif Proto == 441 then -- Haus
		OffsetX = -30
		OffsetZ = -160
	elseif Proto == 442 then -- Giebelhaus
		OffsetX = -50
		OffsetZ = -130
	elseif Proto == 443 then -- Patrizierhaus
		OffsetX = 20
		OffsetZ = -160
	elseif Proto == 444 then -- Herrenhaus
		OffsetX = 200
		OffsetZ = -300
	elseif Proto == 483 then -- Prison_lv3 (Gef�ngnis)
		OffsetX = 130
		OffsetZ = -330
	elseif Proto == 654 then -- Piratenest
		OffsetX = 750
		OffsetZ = -1900
	elseif Proto == 1001 then -- Piratenest
		OffsetX = 750
		OffsetZ = -1900
	elseif Proto == 1002 then -- Piratenest
		OffsetX = 750
		OffsetZ = -1900
	end
	
	return OffsetX, OffsetZ
end

function BauStuff(typeID, gebLVL, owner)
	local bNam,gLNam
	local nenr, gebId = 5, 1
	if typeID == 2 then
		bNam = "Residence"
	elseif typeID == 3 then
		bNam = "Farm"
	elseif typeID == 4 then
		bNam = "Tavern"
	elseif typeID == 6 then
		bNam = "Bakery"
	elseif typeID == 7 then
		bNam = "Blacksmith"
		if BuildingGetProto(owner) == 141 or BuildingGetProto(owner) == 142 then
			gebId = 5
		end
	elseif typeID == 8 then
		bNam = "Joinery"
	elseif typeID == 9 then
		bNam = "Couturier"
	elseif typeID == 11 then
		bNam = "Piratesnest"
	elseif typeID == 12 then
		bNam = "Mine"
	elseif typeID == 15 then
		bNam = "Robber"
	elseif typeID == 16 then
		bNam = "Alchemist"
		if BuildingGetProto(owner) == 173 or BuildingGetProto(owner) == 174 then
			gebId = 5
		end
	elseif typeID == 18 then
		bNam = "Rangerhut"
	elseif typeID == 19 or typeID == 20 then
		bNam = "Church"
		if BuildingGetProto(owner) == 191 or BuildingGetProto(owner) == 192 then
			gebId = 5
		end
	elseif typeID == 21 then
		bNam = "Mercenary"
	elseif typeID == 22 then
		bNam = "Thief"
	elseif typeID == 35 then
		bNam = "Fishinghut"
	elseif typeID == 36 then
	    bNam = "Divehouse"
	elseif typeID == 37 then
		bNam = "Hospital"
	elseif typeID == 38 then
		bNam = "Warehouse"
	elseif typeID == 43 then
		bNam = "Bank"
	elseif typeID == 98 then
		bNam = "Friedhof"
	elseif typeID == 102 then
		bNam = "Gaukler"
	elseif typeID == 104 then
		bNam = "Mill"
	elseif typeID == 108 then
		bNam = "Fruitfarm"
	elseif typeID == 110 then
		bNam = "Stonemason"
	else
		bNam = ""
	end	
	
	if gebLVL == 1 then
		gLNam = "low"
	elseif gebLVL == 2 then
		gLNam = "med"
	elseif gebLVL == 3 then
		gLNam = "high"
	elseif gebLVL == 4 then
		gLNam = "veryhigh"
	elseif gebLVL == 5 then
		gLNam = "max"
	end
	
	return bNam, gLNam, nenr, gebId
end	

function CalcTreatmentNeed(BldAlias, SimAlias)
	local MedicineNeed = 0
	local CheckNeed = 0
	for i=200, 205 do 
		if BuildingCanProduce(BldAlias, i) then
			local MedName = ItemGetName(i)
			CheckNeed = bld_GetNeedForMedicine(BldAlias, MedName)
			if CheckNeed > MedicineNeed then
				MedicineNeed = CheckNeed
			end
			
			if MedicineNeed == 100 then
				break
			end
		end
	end
	
	local AvailableBandages = GetItemCount(BldAlias, "Bandage")
	if HasProperty(BldAlias, "Bandages") then
		AvailableBandages = AvailableBandages + GetProperty(BldAlias, "Bandages")
	end
	
	-- we need more bandages right now!
	if AvailableBandages == 0 then
		return 0
	end
	
	local SickSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000) AND (Object.HasProperty(WaitingForTreatment)))"
	local NumSickSims = Find(SimAlias, SickSimFilter,"SickSim", -1)
	local Producer = BuildingGetProducerCount(BldAlias, PT_MEASURE, "MedicalTreatment")
	
	local HealerCount = 1
	if NumSickSims > 6 and MedicineNeed < 100 then
		HealerCount = 3
	elseif NumSickSims > 3 and MedicineNeed < 100 then
		HealerCount = 2
	elseif NumSickSims > 0 then
		HealerCount = 1
	end
	
	return HealerCount - Producer
end

-- -----------------------
-- CheckRivals (of given buildings and returns the ID of the rival dynasty)
-- -----------------------
function CheckRivals(BldAlias)
	
	if not ReadyToRepeat(BldAlias, "ai_CheckRivals") then
		return
	end
	
	if ScenarioGetTimePlayed() < 4 then
		return
	end
	
	local Difficulty = ScenarioGetDifficulty()
	
	if Difficulty < 2 then
		return
	end

	if not GetDynasty(BldAlias, "MyDynasty") then
		return
	end 
	
	if not BuildingGetOwner(BldAlias, "MyBoss") then
		return
	end
	
	if DynastyIsPlayer("MyBoss") then
		return
	end
	
	if not GetSettlement(BldAlias, "MyTown") then
		return
	end
	
	-- Only 1 rival a time
	if HasProperty("MyDynasty", "RivalID") then
		return
	end

	SetRepeatTimer(BldAlias, "ai_CheckRivals", 4)
	
	local BuildType = BuildingGetType(BldAlias)
	local BuildLevel = BuildingGetLevel(BldAlias)
	local BuildID = GetID(BldAlias)
	
	-- check for same buisness nearby
	local RivalFilter = "__F((Object.GetObjectsByRadius(Building) == 15000) AND (Object.IsType("..BuildType..")) AND (Object.GetLevel()<="..BuildLevel.."))"
	local NumRivals = Find(BldAlias, RivalFilter, "RivalBuilding", -1)
	local RivBld
	
	if NumRivals == 0 then
		return
	end
	
	if NumRivals > 0 then
		for i=0, NumRivals-1 do
			RivBld = "RivalBuilding"..i
			if GetDynastyID(RivBld) ~= GetDynastyID(BldAlias) then
				if GetSettlementID(RivBld) == GetSettlementID(BldAlias) then
					if not GetState(RivBld, STATE_BUILDING) then
						if BuildingGetOwner(RivBld, "RivalBoss") then
							-- rival needs to be a player
							if DynastyIsPlayer("RivalBoss") then
								-- check for diplomacy
								if DynastyGetDiplomacyState("MyBoss", "RivalBoss")<DIP_ALLIANCE then
									SetProperty("MyDynasty", "RivalID", GetDynastyID(RivBld)) -- save the enemy dynasty for AI Scripts
									SetProperty("MyDynasty", "RivalBuilding", GetID(RivBld)) -- save the rival building for AI Scripts
									MsgNewsNoWait("RivalBoss", BldAlias, "", "intrigue", -1,
												"@L_AI_NEWRIVALINTOWN_HEAD", "@L_AI_NEWRIVALINTOWN_BODY",GetID("MyBoss"),GetID(BldAlias),GetID(RivBld))
									ModifyFavorToDynasty("MyDynasty", "RivalBoss", -30)
									break
								end
							end
						end
					end
				end
			end
		end
	end
end

-- ----------------------------------------------
-- Remove highlevel weapons and armory & heal
-- ----------------------------------------------

function ResetWorkers(BldAlias)
	
	local NumWorkers = BuildingGetWorkerCount(BldAlias)
	
	for i=0 , NumWorkers -1 do
		if BuildingGetWorker(BldAlias, i, "Worker") then
			if not HasProperty("Worker", "ResetWorker") then
		
				-- remove armor
				if GetItemCount("Worker", "LeatherArmor", INVENTORY_EQUIPMENT) > 0 then
					RemoveItems("Worker", "LeatherArmor", 1, INVENTORY_EQUIPMENT)
				elseif GetItemCount("Worker", "Chainmail", INVENTORY_EQUIPMENT) > 0 then
					RemoveItems("Worker", "Chainmail", 1, INVENTORY_EQUIPMENT)
				elseif GetItemCount("Worker", "Platemail", INVENTORY_EQUIPMENT) > 0 then
					RemoveItems("Worker", "Platemail", 1, INVENTORY_EQUIPMENT)
				end
				
				-- remove weapon
				if GetItemCount("Worker", "Mace", INVENTORY_EQUIPMENT) > 0 then
					RemoveItems("Worker", "Mace", 1, INVENTORY_EQUIPMENT)
				elseif GetItemCount("Worker", "Shortsword", INVENTORY_EQUIPMENT) > 0 then
					RemoveItems("Worker", "Shortsword", 1, INVENTORY_EQUIPMENT)
				elseif GetItemCount("Worker", "Longsword", INVENTORY_EQUIPMENT) > 0 then
					RemoveItems("Worker", "Longsword", 1, INVENTORY_EQUIPMENT)
				elseif GetItemCount("Worker", "Axe", INVENTORY_EQUIPMENT) > 0 then
					RemoveItems("Worker", "Axe", 1, INVENTORY_EQUIPMENT)
				end
				
				-- add dagger if needed
				if SimGetClass("Worker") == GL_CLASS_FIGHTER then
					if GetItemCount("Worker", "Dagger", INVENTORY_EQUIPMENT) == 0 then
						AddItems("Worker", "Dagger", 1, INVENTORY_EQUIPMENT)
					end
				end
				
				-- heal
				if GetImpactValue("Worker", "Sickness") > 0 then
					diseases_Sprain("Worker", false)
					diseases_Cold("Worker", false)
					diseases_Influenza("Worker", false)
					diseases_BurnWound("Worker", false)
					diseases_Pox("Worker", false)
					diseases_Pneumonia("Worker", false)
					diseases_Blackdeath("Worker", false)
					diseases_Fracture("Worker", false)
					diseases_Caries("Worker", false)
					MoveSetActivity("","")
				end
				
				SetProperty("Worker", "ResetWorker", 1)
			end
		end
	end
end

-- ----------------------------------------------
-- Modify AI production priorities
-- ----------------------------------------------

function SetupAI(BldAlias)
	if not BuildingGetOwner(BldAlias, "MyBoss") then
		return
	end
	
	if not GetInventory(BldAlias, INVENTORY_STD, "Inv") then
		return
	end
	
	if not GetSettlement(BldAlias, "City") then
		GetNearestSettlement(Alias, "City")
	end
	
	CityGetLocalMarket("City","Market")
	if not AliasExists("Market") then
		return
	end
	
	local Items -- Arry, name of items. First items in this list have a lower value to produce than the last (So if you want to boost a items production priority, put it at the end of this list
	local ItemsNum -- total count of items to check
	local MarketStock = {} -- Array, If this is not -1, AI will prefer to produce items that have a lower amount on stock on the local market
	local LocalStock = {} -- Array, If this is not -1, AI will prefer to produce items that have a lower amount on stock on your workshops stock
	local CheckItem
	local CheckID
	local Value
	
	local BldType = BuildingGetType(BldAlias)
	
	if BldType == GL_BUILDING_TYPE_SMITHY then
		if BuildingGetLevel(BldAlias) == 1 then
			Items = 		{ "Nails", "Tool", "Dagger" }
			ItemsNum = 3
			MarketStock = 	{ 50, 40, 30 }
			LocalStock = 	{ 3, 3, 1 }
		else	
			-- check for sublevels
			if BuildingHasUpgrade(BldAlias, "engravingtoolset") then -- gold smith
				Items = {	"Nails", "Tool", "Dagger", "SilverRing", "IronBrachelet", 
						"GoldChain", "BeltOfMetaphysic", "GemRing", "Diamond"
					}
				ItemsNum = 9
				MarketStock = { 50, 40, 30, 30, 30, 15, 15, 15, 15 }
				LocalStock = { 3, 3, 1, -1, -1, -1, -1, -1, -1 }
			else
				Items = {	"Nails", "Tool", "Dagger", "Shortsword", "IronCap", 
						"Chainmail", "Steel", "Longsword", "FullHelmet", "Platemail"
					}
				ItemsNum = 10
				MarketStock = { 50, 40, 30, 30, 30, 15, -1, 20, 20, 15 }
				LocalStock = { 3, 3, 1, -1, -1, -1, 4, -1, -1, -1 }
			end
		end
		
	elseif BldType == GL_BUILDING_TYPE_ALCHEMIST then
		if BuildingGetLevel(BldAlias) == 1 then
			Items = { "Weingeist", "HerbTea", "Phiole"
					}
			ItemsNum = 3
			MarketStock = { 30, 20, 20 }
			LocalStock = { 5, 1, 3 }
		else	
			-- check for sublevels
			if BuildingHasUpgrade(BldAlias, "FlowerOfDiscord") then -- perfumery
				Items = {	"HerbTea", "Phiole", "Weingeist", "FlowerOfDiscord", "Perfume", "BoobyTrap", 
						"FragranceOfHoliness", "DrFaustusElixir"
					}
				ItemsNum = 8
				MarketStock = { 50, 35, 40, 20, 30, 20, 20, 15 }
				LocalStock = { 5, 5, 10, -1, -1, -1, -1, -1 }
			else
				Items = {	"HerbTea", "Phiole", "Weingeist", "WeaponPoison", "InvisiblePotion", "ToadExcrements", 
						"ParalysisPoison", "Toadslime", "BlackWidowPoison"
					}
				ItemsNum = 9
				MarketStock = { 50, 35, 40, 15, 30, 15, 15, 15, 10 }
				LocalStock = { 3, 1, 10, -1, -1, -1, -1, -1, -1 }
			end
		end
		
	elseif BldType == GL_BUILDING_TYPE_MINE then
		Items = {	"Gemstone", "Gold", "Salt", "Silver", "Iron"
					}
		ItemsNum = 5
		MarketStock = { 50, 50, 60, 70, 70 }
		LocalStock = { -1, -1, -1, -1, -1 }
		
	elseif BldType == GL_BUILDING_TYPE_TAILORING then
		Items = {	"Blanket", "FarmersClothes", "MoneyBag", "CitizensClothes", "LeatherGloves", 
				"CamouflageCloak", "NoblesClothes", "GlovesOfDexterity", "LeatherArmor", "Cloth"
					}
		ItemsNum = 10
		MarketStock = { 50, 50, 50, 50, 50, 20, 30, 20, 20, -1 }
		LocalStock = { 2, 2, 2, -1, -1, -1, -1, -1, -1, 4 }
		
	elseif BldType == GL_BUILDING_TYPE_BAKERY then
		Items = {	"Cookie", "Wheatbread", "Cake", "Pretzel", "BreadRoll", 
				"CreamPie", "Candy", "Pastry", "BreadDough", "CakeBatter"
					}
		ItemsNum = 10
		MarketStock = { 50, 50, 30, 40, 40, 40, 20, 25, -1, -1 }
		LocalStock = { 4, 3, -1, -1, -1, -1, -1, -1, 4, 4 }
	
	elseif BldType == GL_BUILDING_TYPE_FARM then
		Items = {	"Wurst", "Cheese", "Milch", "Beef", "Leather", 
				"Fat", "Wool", "Flachs", "Wheat"
					}
		ItemsNum = 9
		MarketStock = { 30, 30, 50, 50, 60, 60, 60, 70, 70 }
		LocalStock = { -1, -1, -1, -1, -1, -1, -1, -1, -1 }
	
	elseif BldType == GL_BUILDING_TYPE_TAVERN then
		Items = {	"GrainPap", "SmallBeer", "Stew", "WheatBeer", "SalmonFilet", 
				"Mead", "RoastBeef", "BoozyBreathBeer", "GhostlyFog", "Wein"
					}
		ItemsNum = 10
		MarketStock = { 40, 40, 40, 40, 40, 20, 30, 20, 15, 20 }
		LocalStock = { 4, 4, -1, 4, 4, -1, 4, -1, -1, 4 }
		
	elseif BldType == GL_BUILDING_TYPE_JOINERY then
		Items = {	"Torch", "Schnitzi", "WalkingStick", "BuildMaterial", "Holzpferd", 
				"Mace", "CartBooster", "Kamm", "CrossOfProtection", "RubinStaff",
				"Axe"
					}
		ItemsNum = 11
		MarketStock = { 40, 40, 40, 50, 40, 30, 20, 15, 20, 15, 15 }
		LocalStock = { 2, 2, 1, -1, -1, -1, -1, -1, -1, -1, -1 }
	
	elseif BldType == GL_BUILDING_TYPE_RANGERHUT then
		Items = {	"Pinewood", "Oakwood", "Charcoal", "Fungi", "Pech"
					}
		ItemsNum = 5
		MarketStock = { 60, 60, 60, 60, 60 }
		LocalStock = { -1, -1, -1, -1, -1 }
		
	elseif BldType == GL_BUILDING_TYPE_CHURCH_EV then
		Items = {	"Poem", "ThesisPaper", "AboutTalents2", "Hasstirade", "Bible", 
				"Kerzen", "Housel", "Ink"
					}
		ItemsNum = 8
		MarketStock = { 50, 30, 30, 15, 15, 50, 60, -1 }
		LocalStock = { 1, -1, -1, -1, -1, 5, 10, 2 }
		
	elseif BldType == GL_BUILDING_TYPE_CHURCH_CATH then
		Items = {	"Poem", "Chaplet", "AboutTalents1", "LetterOfIndulgence", "LetterFromRome", 
				"Kerzen", "Housel", "Ink"
					}
		ItemsNum = 8
		MarketStock = { 50, 30, 30, 20, 15, 50, 60, -1 }
		LocalStock = { 1, -1, -1, -1, -1, 5, 10, 2 }
		
	elseif BldType == GL_BUILDING_TYPE_HOSPITAL then
		Items = {	"Antidote", "Mixture" }
		ItemsNum = 2
		MarketStock = { 15, 5 }
		LocalStock = { -1, -1 }
		
		-- special case medicine
		local Medicine = { "Salve", "Bandage", "Medicine", "PainKiller", "Soap", "MiracleCure" }
		local ItemId 
		local Need
		
		for i=1, 6 do
			if BuildingHasUpgrade(BldAlias, Medicine[i]) then
				ItemId = ItemGetID(Medicine[i])
				Need = bld_GetNeedForMedicine(BldAlias, Medicine[i])
				if Medicine[i] == "Soap" or Medicine[i] == "MiracleCure" then
					Need = Need - 25
				end
				if Need >= 25 then
					SetProperty("Inv", "Need_"..ItemId, Need)
				else
					SetProperty("Inv", "Need_"..ItemId, Rand(3))
				end
			end
		end
	
	elseif BldType == GL_BUILDING_TYPE_FISHINGHUT then
		Items = {	"FriedHerring", "FishSoup", "SmokedSalmon", "Shellchain", "Shellsoup", 
				"Pearlchain", "Perle", "Shell"
					}
		ItemsNum = 8
		MarketStock = { 50, 40, 40, 30, 30, 15, -1, -1 }
		LocalStock = { -1, -1, -1, -1, -1, -1, 3, 3 }
		
	elseif BldType == GL_BUILDING_TYPE_NEKRO then
		Items = {	"Schadelkerze", "Knochenarmreif", "BoneFlute", "HexerdokumentI", "Robe", 
				"FalseRelict", "HexerdokumentII", "pddv", "Knochen", "Schadel",
				"Ektoplasma", "Leichenhemd"
					}
		ItemsNum = 12
		MarketStock = { 30, 30, 30, 15, 10, 10, 10, 10, -1, -1, -1, -1 }
		LocalStock = { 4, 4, -1, -1, -1, -1, -1, -1, 20, 20, 20, 20 }
		
	elseif BldType == GL_BUILDING_TYPE_MILL then
		Items = {	"Oil", "Dye", "WheatFlour"
					}
		ItemsNum = 3
		MarketStock = { 50, 60, 70 }
		LocalStock = { -1, -1, -1 }
		
	elseif BldType == GL_BUILDING_TYPE_BANKHOUSE then
		Items = {	"Siegelring", "Schuldenbrief", "Optieisen", "Urkunde", "Optisilber", 
				"Pfandbrief", "Optigold", "Empfehlung", "Handwerksurkunde", "Siegel"
					}
		ItemsNum = 10
		MarketStock = { 40, 40, 40, 30, 35, 15, 20, 10, 15, -1 }
		LocalStock = { -1, -1, -1, -1, -1, -1, -1, -1, -1, 2 }
		
	elseif BldType == GL_BUILDING_TYPE_STONEMASON then
		Items = {	"Grindingbrick", "vase", "Chisel", "Stonerotary", "Blissstone", 
				"Gravestone", "statue", "Gargoyle", "Clay", "Granite"
					}
		ItemsNum = 10
		MarketStock = { 50, 25, -1, 20, 15, 15, 10, 10, -1, -1 }
		LocalStock = { 5, 3, 3, -1, -1, -1, -1, -1, 2, 3 }
		
	elseif BldType == GL_BUILDING_TYPE_FRUITFARM then
		Items = {	"Salat", "Fruit", "Honey", "Saft", "Wein"
					}
		ItemsNum = 5
		MarketStock = { 30, 70, 60, 30, 20 }
		LocalStock = { -1, 10, 5, -1, -1 }
		
	elseif BldType == GL_BUILDING_TYPE_JUGGLER then
		Items = {	"Amulet", "Spindel", "Pendel", "Voodo", "TarotCards",
				"Willowrot"
					}
		ItemsNum = 6
		MarketStock = { 40, 30, 20, 20, 10, -1 }
		LocalStock = { -1, -1, -1, -1, -1, 5 }
	else
		return
	end
	
	local CheckStock
	local CheckMarket
	
	for i=1, ItemsNum do
		CheckItem = Items[i]
		CheckStock = LocalStock[i]
		CheckMarket = MarketStock[i]
		if CheckItem ~= nil then
			if BuildingCanProduce(BldAlias, CheckItem) then
				CheckID = ItemGetID(CheckItem)
				Value = 5+(i*5)
				if BldType == GL_BUILDING_TYPE_HOSPITAL then
					Value = 25
				end
				if CheckMarket ~= nil and CheckMarket ~= -1 then
					if GetItemCount("Market", CheckItem, INVENTORY_STD) <= CheckMarket and GetItemCount(BldAlias, CheckItem, INVENTORY_STD) <= CheckMarket then
						SetProperty("Inv", "Need_"..CheckID, Value)
					else
						SetProperty("Inv", "Need_"..CheckID, Rand(6))
					end
				end
				
				if CheckStock ~= nil and CheckStock ~= -1 then
					if GetItemCount(BldAlias, CheckItem, INVENTORY_STD) <= CheckStock then
						SetProperty("Inv", "Need_"..CheckID, Value*3)
					else
						SetProperty("Inv", "Need_"..CheckID, 0)
					end
				end
			end
		end
	end
end

-- ----------------------------------------------
-- Need for Medicine
-- ----------------------------------------------

function GetNeedForMedicine(HospAlias, ItemName)
	-- calculate available items
	local AvailableItems = GetItemCount(HospAlias, ItemName)
	if HasProperty(HospAlias, ItemName.."s") then
		AvailableItems = AvailableItems + GetProperty(HospAlias, ItemName.."s")
	end
	
	-- one item is missing
	if AvailableItems == 0 then
		return 100
	end

	-- Are we low on important stuff?
	if ItemName == "Bandage" then
		if AvailableItems < 5 then
			return 75
		elseif AvailableItems < 10 then
			return 50
		elseif AvailableItems < 25 then
			return 25
		else
			return 0
		end
	elseif ItemName == "Salve" then
		if AvailableItems < 5 then
			return 75
		elseif AvailableItems < 10 then
			return 50
		elseif AvailableItems < 15 then
			return 25
		else
			return 0
		end
	elseif ItemName == "Medicine" then
		if AvailableItems < 3 then
			return 75
		elseif AvailableItems < 6 then
			return 50
		elseif AvailableItems < 9 then
			return 25
		else
			return 0
		end
	elseif ItemName == "PainKiller" then
		if AvailableItems < 3 then
			return 75
		elseif AvailableItems < 6 then
			return 50
		elseif AvailableItems < 9 then
			return 25
		else
			return 0
		end
	elseif ItemName == "Soap" then
		if AvailableItems < 5 then
			return 75
		elseif AvailableItems < 10 then
			return 50
		elseif AvailableItems < 15 then
			return 25
		else
			return 0
		end
	elseif ItemName == "MiracleCure" then
		if AvailableItems < 5 then
			return 75
		elseif AvailableItems < 10 then
			return 50
		elseif AvailableItems < 15 then
			return 25
		else
			return 0
		end
	else
		return 0
	end
end

-- ----------------------------------------------
-- Help AI by spawning (buying) important ressources
-- ----------------------------------------------

function SpawnMaterial(BldAlias)
	
	if not BuildingGetOwner(BldAlias, "MyBoss") then
		return
	end
	
	if not GetSettlement(BldAlias, "City") then
		GetNearestSettlement(BldAlias, "City")
	end
	
	CityGetLocalMarket("City", "Market")
	if not AliasExists("Market") then
		return
	end
	
	local Items = {} -- Array, name of items to spawn (buy)
	local ItemsNum -- total amount of all mats to spawn
	local CheckItem
	local SpawnCount = {} -- Array, how many should be spawned?
	local PayMoney = true -- do you have to pay? Setting this to false would be a cheat but could improve AI-behavior
	
	local BldType = BuildingGetType(BldAlias)
	
	if BldType == GL_BUILDING_TYPE_SMITHY then
		Items = { "Iron", "Pinewood", "Oakwood"
				}
		ItemsNum = 3
		SpawnCount = { 10, 5, 5 }
		
		if BuildingCanProduce(BldAlias, "Steel") then
			Items = { "Iron", "Pinewood", "Oakwood", "Charcoal" }
			ItemsNum = 4
			SpawnCount = { 10, 5, 5, 10 }
		end
		
	elseif BldType == GL_BUILDING_TYPE_ALCHEMIST then
		Items = { "Oil", "Fruit"
				}
		ItemsNum = 2
		SpawnCount = { 5, 5 }
		
	elseif BldType == GL_BUILDING_TYPE_TAILORING then
		Items = {	"Flachs", "Wool"
					}
		ItemsNum = 2
		SpawnCount = { 10, 10 }
		
		if BuildingGetLevel(BldAlias) > 1 then
		
			Items = {	"Flachs", "Wool", "Leather", "Dye"
					}
			ItemsNum = 4
			SpawnCount = { 10, 10, 10, 10 }
		end
		
	elseif BldType == GL_BUILDING_TYPE_BAKERY then
		Items = {	"WheatFlour", "Salt", "Fat", "Honey"
				}
		ItemsNum = 4
		SpawnCount = { 10, 10, 10, 10 }
	
	elseif BldType == GL_BUILDING_TYPE_TAVERN then
		Items = {	"Wheat", "Salat", "Fruit"
				}
		ItemsNum = 3
		SpawnCount = { 10, 5, 5 }
		if BuildingGetLevel(BldAlias) > 1 then
			Items = { "Wheat", "Salat", "Weingeist" }
			ItemsNum = 3
			SpawnCount = { 10, 5, 5 }
		end
		
		
	elseif BldType == GL_BUILDING_TYPE_JOINERY then
		Items = {	"Pinewood", "Pech", "Oakwood", "Leather"
					}
		ItemsNum = 4
		SpawnCount = { 10, 5, 10, 5 }
		
	elseif BldType == GL_BUILDING_TYPE_CHURCH_EV then
		Items = {	"WheatFlour", "Honey", "Dye", "Pinewood"
					}
		ItemsNum = 4
		SpawnCount = { 10, 5, 10, 5 }
		
	elseif BldType == GL_BUILDING_TYPE_CHURCH_CATH then
		Items = {	"WheatFlour", "Honey", "Dye", "Pinewood"
					}
		ItemsNum = 4
		SpawnCount = { 10, 5, 10, 5 }
		
	elseif BldType == GL_BUILDING_TYPE_HOSPITAL then
		Items = {	"Fat", "Flachs", "Pech" }
		ItemsNum = 3
		SpawnCount = { 10, 10, 5 }
		
		if BuildingGetLevel(BldAlias) >= 2 then
			Items = {	"Fat", "Flachs", "Pech", "Honey", "Weingeist" }
			ItemsNum = 5
			SpawnCount = { 10, 10, 5, 10, 5 }
		end
		
	elseif BldType == GL_BUILDING_TYPE_BANKHOUSE then
		Items = {	"Iron", "Oakwood", "Dye"
					}
		ItemsNum = 3
		SpawnCount = { 5, 10, 10 }
		
		if BuildingGetLevel(BldAlias) >= 2 then
			Items = {	"Iron", "Oakwood", "Dye", "Honey"
					}
			ItemsNum = 4
			SpawnCount = { 5, 10, 5, 10 }
		end
		
	elseif BldType == GL_BUILDING_TYPE_STONEMASON then
		Items = {	"Dye"
					}
		ItemsNum = 1
		SpawnCount = { 4 }
		
		if BuildingGetLevel(BldAlias) > 1 then
			Items = {	"Dye", "Pinewood", "Iron"
					}
			ItemsNum = 3
			SpawnCount = { 4, 10, 10 }
		end
	else
		return
	end
	
	local ItemId
	local Price
	local MarketStock
	
	for i=1, ItemsNum do
		CheckItem = Items[i] -- check every material
		if CheckItem ~= nil then -- just a safety check
			if GetItemCount(BldAlias, CheckItem, INVENTORY_STD) == 0 then -- only spawn mats if we have 0
				ItemId = ItemGetID(CheckItem)
				MarketStock = GetItemCount("Market", CheckItem, INVENTORY_STD) 
				if MarketStock < SpawnCount[i] and MarketStock > 1 then
					Price = ItemGetPriceSell(CheckItem, "Market")*MarketStock
					if PayMoney == true then
						if GetMoney("MyBoss") >= Price then -- check if we have the money
							if f_SpendMoney("MyBoss", Price, "misc") then
								RemoveItems("Market", CheckItem, MarketStock, INVENTORY_STD)
								Transfer(nil, nil, INVENTORY_STD, "Market", INVENTORY_STD, CheckItem, MarketStock)
								AddItems(BldAlias, CheckItem, MarketStock, INVENTORY_STD)
							end
						end
					else
						RemoveItems("Market", CheckItem, MarketStock, INVENTORY_STD)
						Transfer(nil, nil, INVENTORY_STD, "Market", INVENTORY_STD, CheckItem, MarketStock)
						AddItems(BldAlias, CheckItem, MarketStock, INVENTORY_STD)
					end
				elseif MarketStock >= SpawnCount[i] then
					Price = ItemGetPriceSell(CheckItem, "Market")*SpawnCount[i]
					if PayMoney == true then
						if GetMoney("MyBoss") >= Price then -- check if we have the money
							if f_SpendMoney("MyBoss", Price, "misc") then
								RemoveItems("Market", CheckItem, SpawnCount[i], INVENTORY_STD)
								Transfer(nil, nil, INVENTORY_STD, "Market", INVENTORY_STD, CheckItem, SpawnCount[i])
								AddItems(BldAlias, CheckItem, SpawnCount[i], INVENTORY_STD)
							end
						end
					else
						RemoveItems("Market", CheckItem, SpawnCount[i], INVENTORY_STD)
						Transfer(nil, nil, INVENTORY_STD, "Market", INVENTORY_STD, CheckItem, SpawnCount[i])
						AddItems(BldAlias, CheckItem, SpawnCount[i], INVENTORY_STD)
					end
				end
			end
		end
	end
end

function RemoveCart(BldAlias)

	local CartCount = BuildingGetCartCount(BldAlias)
	if CartCount > 2 then
		for i=1, BuildingGetCartCount("")-1 do
			if BuildingGetCart("", i, "CartAlias") then
				if not GetState("CartAlias", STATE_CHECKFORSPINNINGS) then -- means it is standing still
					if GetDistance("CartAlias", BldAlias) < 500 then -- is the cart at home?
						-- Check for currently loaded items
						local ItemId
						local Found = 0
						local Count = InventoryGetSlotCount("CartAlias", INVENTORY_STD)
						local HasItems = false
						for i=0, Count-1 do
							ItemId, Found = InventoryGetSlotInfo("CartAlias", i, INVENTORY_STD)
							if ItemId and ItemId>0 and Found>0 then
								HasItems = true
							end
						end
						if not HasItems then -- only remove cart if it is empty
							f_CreditMoney(BldAlias, 250, "misc") -- add some money for compensation (needs testing)
							InternalRemove("CartAlias")
							break
						end
					end
				end
			end
		end
	end
end

function ForceLevelUp(BldAlias)
	
	if not ReadyToRepeat(BldAlias, "ai_ForceLevelUp") then
		return
	end
	
	if GetRound() < 3 then
		return
	end

	if not BuildingGetOwner(BldAlias, "MyBoss") then
		return
	end
	
	if GetState(BldAlias, STATE_BUILDING) or GetState(BldAlias, STATE_LEVELINGUP) then
		return
	end
	
	local BuildLevel = BuildingGetLevel(BldAlias)
	
	if BuildLevel == 3 then
		return
	end
	
	local BuildType = BuildingGetType(BldAlias)
	
	local Cost = 0
	local BossLevel = 0
	
	if BuildLevel == 2 then
		Cost = 22500
		BossLevel = 5
	else
		Cost = 7500
		BossLevel = 3
	end
	
	if GetMoney("MyBoss") < Cost then
		SetRepeatTimer(BldAlias, "ai_ForceLevelUp", 8)
		return
	end
	
	if SimGetLevel("MyBoss") < BossLevel then
		SetRepeatTimer(BldAlias, "ai_ForceLevelUp", 16)
		return
	end
	
	-- Special case SubLevel
	local SubLevel = -1
	if BuildType == GL_BUILDING_TYPE_ALCHEMIST then
		if BuildLevel == 1 then
			SubLevel = 1 + Rand(2)
		else
			-- only upgrade to the sublevel you already had
			if BuildingHasUpgrade(BldAlias, "Perfume") then -- building id 171
				SubLevel = 1
			else
				SubLevel = 2
			end
		end
			
	elseif BuildType == GL_BUILDING_TYPE_SMITHY then
		if BuildLevel == 1 then
			SubLevel = 1 + Rand(2)
		else
			-- only upgrade to the sublevel you already had
			if BuildingHasUpgrade(BldAlias, "engravingtoolet") then -- building id 141
				SubLevel = 1
			else
				SubLevel = 2
			end
		end
	end
	
	local Proto = ScenarioFindBuildingProto(2, BuildType, BuildLevel+1, SubLevel)
	
	if f_SpendMoney("MyBoss", Cost, "BuildingLevelUp", false) then
		local RepeatTime = 120 - 12*ScenarioGetDifficulty()
		SetRepeatTimer(BldAlias, "ai_ForceLevelUp", RepeatTime)
		SetProperty(BldAlias, "LevelUpProto", Proto)
		SetState(BldAlias, STATE_LEVELINGUP, true)
		return
	end
end

function HandleSetup(BldAlias)
	bld_ResetWorkers(BldAlias)
	if BuildingGetAISetting(BldAlias, "Produce_Selection") > 0 then
		bld_SetupAI(BldAlias)
		bld_SpawnMaterial(BldAlias)
	end
	economy_CalculateSalesRanking(BldAlias)
	SetProperty(BldAlias, "BuySell_SellStock", 0)
end

function HandleOnLevelUp(BldAlias)
	economy_CalculateSalesRanking(BldAlias)
	SetProperty(BldAlias, "BuySell_SellStock", 0)
end

function HandlePingHour(BldAlias)
	-- Improve AI management
	if BuildingGetAISetting(BldAlias, "Produce_Selection") > 0 then
		bld_SetupAI(BldAlias)
		--bld_SpawnMaterial(BldAlias)
	end
	
	local Count, Items = economy_GetItemsForSale(BldAlias)
	-- 9am and 9pm with AI management
	if math.mod(GetGametime(), 12) == 9 and (DynastyIsAI(BldAlias) or BuildingGetAISetting(BldAlias, "BuySell_SellStock") > 0) then 
		economy_InitializeDefaultSalescounter(BldAlias, Count, Items)
	end
	economy_UpdateSalescounter(BldAlias, Count, Items)
	-- at 3, 11, 19 
	if math.mod(GetGametime(), 8) == 3 then
		economy_CalculateSalesRanking(BldAlias, Count, Items)
	end
	-- at 1am: subtract current wages from balance
	if math.mod(GetGametime(), 24) == 1 then
		local Wages = economy_CalculateWages(BldAlias)
		economy_UpdateBalance(BldAlias, "Wages", -Wages)
	end
	
	-- Manage carts
	if BuildingGetOwner(BldAlias, "MyBoss") then
		if DynastyIsShadow("MyBoss") then -- shadows shall only have 1 cart
			bld_RemoveCart(BldAlias)
		end
		
		if DynastyIsAI("MyBoss") then
			bld_CheckRivals(BldAlias)
			bld_ForceLevelUp(BldAlias)
			-- attempt to fix stagnant money of AI dynasties
			--f_CreditMoney("MyBoss", Rand(100)*BuildingGetLevel(BldAlias))
		end
	end
end

function HandleNewOwner(BldAlias, FormerOwner)
	bld_ClearBuildingStash(BldAlias, FormerOwner)
	bld_BuildingWorkersStopWorking(BldAlias)
	bld_ResetWorkers(BldAlias)
	economy_ClearBalance(BldAlias)
	SetProperty(BldAlias, "BuySell_SellStock", 0)
end
