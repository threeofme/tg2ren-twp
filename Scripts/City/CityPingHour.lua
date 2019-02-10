function Run()
	GetScenario("World")
	if not HasProperty("World", "static") then
		
		local Level = CityGetLevel("")
		local DefaultID = GetID("")
		local City0ID = GetID("City0")
		
		if City0ID == -1 then
			local CityCount = ScenarioGetObjects("Settlement", 1, "City")
			City0ID = GetID("City0")
		end
		
		if ScenarioGetTimePlayed() > 3 then
		
			if Level==1 then
				-- kontor city - do nothing here
				return
			elseif Level==2 then
				citypinghour_CheckVillage()
			elseif Level==3 then
				citypinghour_CheckSmallTown()
			elseif Level==4 then
				citypinghour_CheckTown()
			elseif Level==5 then
				citypinghour_CheckCapital()
			elseif Level==6 then
				citypinghour_CheckCapital()
			end
		end
	
		if GetData("#MusiciansChooser")==nil then
			SetData("#MusiciansChooser",GetID(""))
		elseif GetData("#MusiciansChooser")==0 then
			SetData("#MusiciansChooser",GetID(""))
		end
		if GetData("#MusiciansChooser")==GetID("") then
			citypinghour_CheckMusicians()
		end
	
		if GetData("#AldermanChooser")==nil then
			if CityGetRandomBuilding("", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "Guildhouse") and (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1]>0) then
				SetData("#AldermanChooser",GetID(""))
			end
		elseif GetData("#AldermanChooser")==0 then
			if CityGetRandomBuilding("", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "Guildhouse") and (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1]>0) then
				SetData("#AldermanChooser",GetID(""))
			end
		end
		if GetData("#AldermanChooser")==GetID("") then
			citypinghour_CheckAlderman()
		end
	
		if GetData("#ImperialChooser")==nil then
			if CityGetRandomBuilding("", -1, GL_BUILDING_TYPE_SCHOOL, -1, -1, FILTER_IGNORE, "Arsenal") and (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1]>0) then
				SetData("#ImperialChooser",GetID(""))
			end
		elseif GetData("#ImperialChooser")==0 then
			if CityGetRandomBuilding("", -1, GL_BUILDING_TYPE_SCHOOL, -1, -1, FILTER_IGNORE, "Arsenal") and (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1]>0) then
				SetData("#ImperialChooser",GetID(""))
			end
		end
		if GetData("#ImperialChooser")==GetID("") then
			gameplayformulas_CheckImperialOfficer()
		end
		
		if ScenarioGetTimePlayed() > 16 then
			citypinghour_CheckCrimes()
		end
		
	------------------------------------------------------------------------------
		local currentGameTime = math.mod(GetGametime(),24)
		if (currentGameTime == 1) then	
			
			-- check weather (stop raining if it bugs!)
			Weather_SetWeather("Fine", 4.0)
		
			local TaxValue = 0+ GetProperty("","TurnoverTax")
			local Tax = 0
			local cost = 0
			local repairTotal = 0
			local repairedbuildings = 0
			local Alias
	
			-- taxes (income)
			local WorkshopCount = CityGetBuildings("", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_HAS_DYNASTY, "Workshop")
			for l=0,WorkshopCount-1 do
				Alias = "Workshop"..l
				WorkshopLvl = BuildingGetLevel(Alias)
				if BuildingGetOwner(Alias, "Sim") then
					Tax = Tax + ((Rand(50) + 475) * WorkshopLvl * (TaxValue/10))
				end
			end
			SetProperty("", "Workshops", WorkshopCount)
			if Tax>0 then
				CreditMoney("", Tax, "Tax")
			end
			SetProperty("", "TaxValue", TaxValue)
			SetProperty("", "TaxMoney", Tax)
	
			-- offices costs
			local officecostsTotal = gameplayformulas_GetTotalOfficeIncome("")
			if officecostsTotal>0 then
				if GetMoney("")>officecostsTotal then
					SpendMoney("", officecostsTotal, "OfficeIncome")				
				else
					local tmpcosts = GetMoney("")
					SpendMoney("", tmpcosts, "OfficeIncome")				
				end
			end
			SetProperty("", "OfficeMoney", officecostsTotal)
	
			-- repair costs for workerhuts
			local WorkerhutCount = CityGetBuildings("", -1, GL_BUILDING_TYPE_WORKER_HOUSING, 1, -1, FILTER_IGNORE, "Workerhut")
			for f=0,WorkerhutCount-1 do
				Alias = "Workerhut"..f
				if not BuildingGetOwner(Alias, "Sim") and (GetHP(Alias)<GetMaxHP(Alias)) then
					cost = BuildingGetRepairPrice(Alias)
	
					if GetMoney("")>cost then
						repairedbuildings = repairedbuildings + 1
						SpendMoney("", cost, "BuildingRepairs")				
						ModifyHP(Alias,(GetMaxHP(Alias)-GetHP(Alias)),false)
						repairTotal = repairTotal + cost
					end
				end
			end
	
			-- repair costs for residences without owner
			local FreeResidenceCount = CityGetBuildings("", nil, GL_BUILDING_TYPE_RESIDENCE, -1, -1, FILTER_IS_BUYABLE, "FreeResidence")
			for f=0,FreeResidenceCount-1 do
				Alias = "FreeResidence"..f
				if not BuildingGetOwner(Alias, "Sim") and (GetHP(Alias)<GetMaxHP(Alias)) then
					cost = BuildingGetRepairPrice(Alias)
	
					if GetMoney("")>cost then
						repairedbuildings = repairedbuildings + 1
						SpendMoney("", cost, "BuildingRepairs")				
						ModifyHP(Alias,(GetMaxHP(Alias)-GetHP(Alias)),false)
						repairTotal = repairTotal + cost
					end
				end
			end
	
			-- repair costs for workshops without owner
			local FreeWorkshopCount = CityGetBuildings("", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_IS_BUYABLE, "FreeWorkshop")
			for f=0,FreeWorkshopCount-1 do
				Alias = "FreeWorkshop"..f
				if not BuildingGetOwner(Alias, "Sim") and (GetHP(Alias)<GetMaxHP(Alias)) then
					cost = BuildingGetRepairPrice(Alias)
	
					if GetMoney("")>cost then
						repairedbuildings = repairedbuildings + 1
						SpendMoney("", cost, "BuildingRepairs")				
						ModifyHP(Alias,(GetMaxHP(Alias)-GetHP(Alias)),false)
						repairTotal = repairTotal + cost
					end
				end
			end
	
			SetProperty("", "repairedbuildings", repairedbuildings)
			SetProperty("", "BuildingRepairs", repairTotal)

			local NobilityMoney = 0
			if HasProperty("", "NobilityMoney") then
				NobilityMoney = GetProperty("", "NobilityMoney")
			end
			SetProperty("", "NobilityMoneyLY", NobilityMoney)
			SetProperty("", "NobilityMoney", 0)

			local WarMoney = 0
			if HasProperty("", "Warcosts") then
				WarMoney = GetProperty("", "Warcosts")
			end
			SetProperty("", "WarcostsLY", WarMoney)
			SetProperty("", "Warcosts", 0)

		end
	end
end

function CheckMusicians()
	if not CityGetRandomBuilding("",3,23,-1,-1,FILTER_IGNORE,"MusicianHomeBuilding") then
		return
	end
	GetLocatorByName("MusicianHomeBuilding", "Entry1", "MusicianSpawnPos")	
	--GetPosition("MusicianHomeBuilding","MusicianSpawnPos")

	if GetData("#MusicStage")==nil then
		SetData("#MusicStage",0)
	end
	if GetData("#RestPlace")==nil then
		SetData("#RestPlace",0)
	end

	if not AliasExists("#Musician1") then
		SimCreate(900,"MusicianHomeBuilding","MusicianSpawnPos","#Musician1")
		SimSetFirstname("#Musician1", "@L_VERSENGOLD_MUSICIAN_FIRSTNAME_+0")
		SimSetLastname("#Musician1", "@L_VERSENGOLD_MUSICIAN_LASTNAME_+0")
		SimSetBehavior("#Musician1","Musician")

		--Groupie
		SimCreate(6,"MusicianHomeBuilding","MusicianSpawnPos","Groupie1")
		SimSetAge("Groupie1", 16)
		SetState("Groupie1",STATE_TOWNNPC,true)
		SimSetBehavior("Groupie1","Groupie")
	end
	if not AliasExists("#Musician2") then
		SimCreate(901,"MusicianHomeBuilding","MusicianSpawnPos","#Musician2")
		SimSetFirstname("#Musician2", "@L_VERSENGOLD_MUSICIAN_FIRSTNAME_+1")
		SimSetLastname("#Musician2", "@L_VERSENGOLD_MUSICIAN_LASTNAME_+1")
		SimSetBehavior("#Musician2","Musician")

		--Groupie
		SimCreate(6,"MusicianHomeBuilding","MusicianSpawnPos","Groupie2")
		SimSetAge("Groupie2", 16)
		SetState("Groupie2",STATE_TOWNNPC,true)
		SimSetBehavior("Groupie2","Groupie")
	end
	if not AliasExists("#Musician3") then
		SimCreate(902,"MusicianHomeBuilding","MusicianSpawnPos","#Musician3")
		SimSetFirstname("#Musician3", "@L_VERSENGOLD_MUSICIAN_FIRSTNAME_+2")
		SimSetLastname("#Musician3", "@L_VERSENGOLD_MUSICIAN_LASTNAME_+2")
		SimSetBehavior("#Musician3","Musician")

		--Groupie
		SimCreate(6,"MusicianHomeBuilding","MusicianSpawnPos","Groupie3")
		SimSetAge("Groupie3", 16)
		SetState("Groupie3",STATE_TOWNNPC,true)
		SimSetBehavior("Groupie3","Groupie")
	end
	if not AliasExists("#Musician4") then
		SimCreate(905,"MusicianHomeBuilding","MusicianSpawnPos","#Musician4")
		SimSetFirstname("#Musician4", "@L_VERSENGOLD_MUSICIAN_FIRSTNAME_+3")
		SimSetLastname("#Musician4", "@L_VERSENGOLD_MUSICIAN_LASTNAME_+3")
		SimSetBehavior("#Musician4","Musician")

		--Groupie
		SimCreate(6,"MusicianHomeBuilding","MusicianSpawnPos","Groupie4")
		SimSetAge("Groupie4", 16)
		SetState("Groupie4",STATE_TOWNNPC,true)
		SimSetBehavior("Groupie4","Groupie")
	end
	if not AliasExists("#Musician5") then
		SimCreate(946,"MusicianHomeBuilding","MusicianSpawnPos","#Musician5")
		SimSetFirstname("#Musician5", "@L_VERSENGOLD_MUSICIAN_FIRSTNAME_+4")
		SimSetLastname("#Musician5", "@L_VERSENGOLD_MUSICIAN_LASTNAME_+4")
		SimSetBehavior("#Musician5","Musician")

		--Groupie
		SimCreate(6,"MusicianHomeBuilding","MusicianSpawnPos","Groupie5")
		SimSetAge("Groupie5", 16)
		SetState("Groupie5",STATE_TOWNNPC,true)
		SimSetBehavior("Groupie5","Groupie")
	end
end

function CheckCrimes()
	ListCrimeReport("crime_report_list")		-- liste mit (DynastyID, ActorID, CrimeTotal) 
	
	-- modifizieren
	local TopBias = -1
	local TopReport = -1
	local TopDynastyID = -1
	local TopActorID = -1
	local TopCrimeTotal = -1
	
	local DepositionTopBias = -1
	local DepositionTopReport = -1
	local DepositionTopDynastyID = -1
	local DepositionTopActorID = -1
	local DepositionTopCrimeTotal = -1
		
	for iReport = 0,ListSize("crime_report_list")-1 do
		ListGetElement("crime_report_list",iReport,"crime_report")
		local DynastyID  = GetProperty("crime_report", "DynastyID")
		local ActorID	 = GetProperty("crime_report", "ActorID")
		local CrimeTotal = GetProperty("crime_report", "CrimeTotal")
		
		if GetAliasByID(ActorID,"_actor") then
			if SimCanBeCharged("_actor")==0 then
				if GetAliasByID(DynastyID,"_dyn") then
					for iMember = 0, DynastyGetMemberCount("_dyn")-1 do
						if DynastyGetMember("_dyn",iMember,"_sim") then
							if GetSettlementID("_sim")==GetID("") then
								local Bias = CrimeTotal * 10	-- 0.. ~200
								
								local Hours = GetHoursToNextTrial("")
								if Hours>16 then 
									Bias = Bias - Hours * 2	-- 
								end
								
								local DiplomaticState = DynastyGetDiplomacyState("_dyn", "_actor")
								
								if DiplomaticState> DIP_NEUTRAL then
									Bias = 0
								elseif DiplomaticState==DIP_FOE then
									Bias = Bias
								else
									Bias = Bias * ((100.0-GetFavorToDynasty("_dyn","_actor"))/100)
								end

								if GetImpactValue("_actor","HaveImmunity")==1 then
									if Bias>DepositionTopBias and Bias>0 then
										DepositionTopBias = Bias
										DepositionTopReport = iReport
										DepositionTopDynastyID = DynastyID
										DepositionTopActorID = GetID("_actor")
										DepositionTopCrimeTotal = CrimeTotal
									end
								else
									if Bias>TopBias and Bias>0 then
										TopBias = Bias
										TopReport = iReport
										TopDynastyID = DynastyID
										TopActorID = GetID("_actor")
										TopCrimeTotal = CrimeTotal
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	SetProperty("","Crimes_TopAccuserDynastyID",TopDynastyID)
	SetProperty("","Crimes_TopActorID",TopActorID)
	SetProperty("","Crimes_TopBias",TopBias)
	SetProperty("","Crimes_TopCrimeTotal",TopCrimeTotal)

	SetProperty("","Crimes_DepositionTopActorID",DepositionTopActorID)
end

function CheckVillage()

	CitySetMaxWorkerhutLevel("", 1)

	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_TOWNHALL, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_PRISON, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_WELL, 1, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_LINGERPLACE, 1, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_EXECUTIONS_PLACE, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_DUELPLACE, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_GRAVEYARD, -1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_MARKET, GL_BUILDING_TYPE_HARBOR, 1)

	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_BANK, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1])
	end
	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_SCHOOL, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1])
	end
	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SOLDIERPLACE)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_SOLDIERPLACE, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SOLDIERPLACE)[1])
	end

	AICheckWorkingPlace("", GL_BUILDING_TYPE_FARM, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_TAVERN, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_HOSPITAL, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_MILL, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_MINE, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_RANGERHUT, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_FRUITFARM, 1)
	
	-- for water-maps
	GetScenario("World")
	if HasProperty("World", "seamap") then
		if GetProperty("World", "seamap") == 1 then
			AICheckWorkingPlace("", GL_BUILDING_TYPE_FISHINGHUT, 1)
		end
	end
end

function CheckSmallTown()

	CitySetMaxWorkerhutLevel("", 2)

	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_TOWNHALL, 2)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_PRISON, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_WELL, 1, 2)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_LINGERPLACE, 1, 2)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_GRAVEYARD, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_EXECUTIONS_PLACE, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_DUELPLACE, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_MARKET, GL_BUILDING_TYPE_HARBOR, 2)

	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_BANK, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1])
	end
	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_SCHOOL, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1])
	end
	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SOLDIERPLACE)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_SOLDIERPLACE, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SOLDIERPLACE)[1])
	end

	AICheckWorkingPlace("", GL_BUILDING_TYPE_FARM, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_TAVERN, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_HOSPITAL, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_MILL, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_MINE, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_RANGERHUT, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_ROBBER, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_FRUITFARM, 1)
	
	-- for water-maps
	GetScenario("World")
	if HasProperty("World", "seamap") then
		if GetProperty("World", "seamap") == 1 then
			AICheckWorkingPlace("", GL_BUILDING_TYPE_FISHINGHUT, 1)
		end
	end
	
	AICheckWorkingPlace("", GL_BUILDING_TYPE_SMITHY, 1)
	
	citypinghour_CheckChurch(1)
end

function CheckTown()

	CitySetMaxWorkerhutLevel("", 3)

	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_TOWNHALL, 3)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_PRISON, 2)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_WELL, 1, 3)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_LINGERPLACE, 1, 4)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_GRAVEYARD, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_EXECUTIONS_PLACE, 2)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_DUELPLACE, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_MARKET, GL_BUILDING_TYPE_HARBOR, 3)

	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_BANK, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1])
	end
	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_SCHOOL, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1])
	end
	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SOLDIERPLACE)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_SOLDIERPLACE, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SOLDIERPLACE)[1])
	end

	AICheckWorkingPlace("", GL_BUILDING_TYPE_FARM, 2)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_TAVERN, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_HOSPITAL, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_MILL, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_MINE, 2)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_RANGERHUT, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_ROBBER, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_FRUITFARM, 1)
	
	-- for water-maps
	GetScenario("World")
	if HasProperty("World", "seamap") then
		if GetProperty("World", "seamap") == 1 then
			AICheckWorkingPlace("", GL_BUILDING_TYPE_FISHINGHUT, 1)
			AICheckWorkingPlace("", GL_BUILDING_TYPE_PIRATESNEST, 1)
		end
	end
	
	AICheckWorkingPlace("", GL_BUILDING_TYPE_STONEMASON, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_ALCHEMIST, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_SMITHY, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_TAILORING, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_BAKERY, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_THIEF, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_BANKHOUSE, 1)

	citypinghour_CheckChurch(2)
	
end

function CheckCapital()

	CitySetMaxWorkerhutLevel("", 3)

	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_TOWNHALL, 4)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_PRISON, 2)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_WELL, 1, 3)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_LINGERPLACE, 1, 5)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_EXECUTIONS_PLACE, 3)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_DUELPLACE, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_GRAVEYARD, 1)
	citypinghour_CheckBuilding( GL_BUILDING_CLASS_MARKET, GL_BUILDING_TYPE_HARBOR, 3)

	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_BANK, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_BANK)[1])
	end
	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_SCHOOL, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SCHOOL)[1])
	end
	if (gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SOLDIERPLACE)[1]>0) then
		citypinghour_CheckBuilding( GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_SOLDIERPLACE, gameplayformulas_CheckPublicBuilding("", GL_BUILDING_TYPE_SOLDIERPLACE)[1])
	end

	AICheckWorkingPlace("", GL_BUILDING_TYPE_FARM, 2)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_TAVERN, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_HOSPITAL, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_MILL, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_MINE, 2)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_RANGERHUT, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_ROBBER, 2)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_FRUITFARM, 1)
	
	-- for water-maps
	GetScenario("World")
	if HasProperty("World", "seamap") then
		if GetProperty("World", "seamap") == 1 then
			AICheckWorkingPlace("", GL_BUILDING_TYPE_FISHINGHUT, 2)
			AICheckWorkingPlace("", GL_BUILDING_TYPE_PIRATESNEST, 2)
		end
	end
	
	AICheckWorkingPlace("", GL_BUILDING_TYPE_STONEMASON, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_ALCHEMIST, 2)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_SMITHY, 2)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_TAILORING, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_BAKERY, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_THIEF, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_JOINERY, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_BANKHOUSE, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_NEKRO, 1)
	AICheckWorkingPlace("", GL_BUILDING_TYPE_JUGGLER, 1)		

	citypinghour_CheckChurch(2)
	
end

function CheckBuilding(Class, Type, Level, Count)

	if not Count then
		Count = 1
	end
	
	local	BuildTotal = CityGetBuildings("", Class, Type, -1, -1, FILTER_IGNORE, "Found")
	local	Ist = 0
	
	for l=0,BuildTotal-1 do
		if BuildingGetLevel("Found"..l) >= Level then
			Ist = Ist + 1
			if Ist >= Count then
				return
			end
		end
	end
	
	for l=0,BuildTotal-1 do
		if BuildingGetLevel("Found"..l) < Level then
			BuildingLevelMeUp("Found"..l, -1)
			Ist = Ist + 1
			if Ist>=Count then
				return
			end
		end
	end
	
	while Ist < Count do
		local Proto = ScenarioFindBuildingProto(Class, Type, Level, -1)
		if not Proto or Proto==-1 then
			break
		end

		if not CityBuildNewBuilding("", Proto, nil, "Building") then
			break
		end
		Ist = Ist + 1
	end

end

function CheckChurch(MaxCount)
	local ChEv			= CityGetBuildingCount("", -1, GL_BUILDING_TYPE_CHURCH_EV, -1, -1, FILTER_HAS_DYNASTY)
	local ChCa			= CityGetBuildingCount("", -1, GL_BUILDING_TYPE_CHURCH_CATH, -1, -1, FILTER_HAS_DYNASTY)

	if ChEv + ChCa < MaxCount then
		-- no church, so create one
	
		local TotalChEv	= CityGetBuildingCount("", -1, GL_BUILDING_TYPE_CHURCH_EV, -1, -1, FILTER_NO_DYNASTY)
		local TotalChCa	= CityGetBuildingCount("", -1, GL_BUILDING_TYPE_CHURCH_CATH, -1, -1, FILTER_NO_DYNASTY)
	
		if TotalChEv>0 and TotalChCa==0 then
			AICheckWorkingPlace("", GL_BUILDING_TYPE_CHURCH_EV, ChEv+1)
		elseif TotalChCa>0 and TotalChEv==0 then
			AICheckWorkingPlace("", GL_BUILDING_TYPE_CHURCH_CATH, ChCa+1)
		else
			if Rand(100) < 50 then
				AICheckWorkingPlace("", GL_BUILDING_TYPE_CHURCH_EV, ChEv+1)
			else
				AICheckWorkingPlace("", GL_BUILDING_TYPE_CHURCH_CATH, ChCa+1)
			end
		end
	end
end

function CheckAlderman()
	local currentRound = GetRound()
	if currentRound > 1 then

		local currentGameTime = math.mod(GetGametime(),24)
		if (currentGameTime == 12) or ((currentGameTime > 12) and (currentGameTime < 13)) then

			local year = GetYear() - 2 + math.mod(GetGametime(),6)
			local DynCount = ScenarioGetObjects("cl_Dynasty", 99, "Dyn")
			local SimCount
			local Alias
			local SimArray = {}
			local SimFameArray = {}
			local SimArrayCount = 0

			for d=0,DynCount-1 do
				Alias = "Dyn"..d
				if GetID(Alias)>0 and DynastyIsPlayer(Alias) or DynastyIsAI(Alias) or DynastyIsShadow(Alias) then
					SimCount = DynastyGetMemberCount(Alias)
					for e=0,SimCount do
						DynastyGetMember(Alias, e, "Sim")
						if HasProperty("Sim", "PatronMaster") or HasProperty("Sim", "ArtisanMaster") or HasProperty("Sim", "ScholarMaster") or HasProperty("Sim", "ChiselerMaster") then
							local num = 0
							while num<100 do
								if chr_SimGetFameLevel("Sim")>1 and chr_DynastyGetFameLevel("Sim")>0 then
									if SimArray[num]==GetID("Sim") then
										break
									elseif SimArray[num]==nil then
										SimArray[num] = GetID("Sim")
										SimFameArray[num] = chr_SimGetFame("Sim") + math.floor(chr_DynastyGetFame("Sim")/10)
										SimArrayCount = SimArrayCount + 1
										break
									end
								end
							num = num + 1
							end
						end
					end
				end
			end

			local AldermanWinner
			local AldermanFame = -1
			if SimArrayCount>0 then
				for x=0,SimArrayCount do
					if SimFameArray[x]~=nil and SimFameArray[x]>AldermanFame then
						AldermanFame = SimFameArray[x]
						AldermanWinner = x
					end
				end
				
				local oldalderman = chr_GetAlderman()
				if oldalderman>0 then
					GetAliasByID(oldalderman,"Old")
					chr_SimAddImperialFame("Old",1)
					RemoveProperty("Old", "Alderman")
				end
				
				SetData("#Alderman",0)
				if GetAliasByID(SimArray[AldermanWinner],"New") then
					SetProperty("New","Alderman",1)
					SetData("#Alderman",SimArray[AldermanWinner])

					local label
					if SimGetClass("New")==1 then
						label = "@L_GUILDHOUSE_MASTERLIST_PATRON"
					elseif SimGetClass("New")==2 then
						label = "@L_GUILDHOUSE_MASTERLIST_ARTISAN"
					elseif SimGetClass("New")==3 then
						label = "@L_GUILDHOUSE_MASTERLIST_SCHOLAR"
					elseif SimGetClass("New")==4 then
						label = "@L_GUILDHOUSE_MASTERLIST_CHISELER"
					end

					if SimGetGender("New")==GL_GENDER_MALE then
						label = label.."_MALE_+0"
					else
						label = label.."_FEMALE_+0"
					end

					GetSettlement("New", "settlement")
					famelevelsim = "@L_GUILDHOUSE_FAME_SIM_+"..chr_SimGetFameLevel("New")
					fameleveldyn = "@L_GUILDHOUSE_FAME_DYNASTY_+"..chr_DynastyGetFameLevel("New")

					MsgNewsNoWait("All","New","","politics",-1,
							"@L_CHECKALDERMAN_HEAD_+0",
							"@L_CHECKALDERMAN_BODY_+0",
							GetYear(),GetID("New"), label, GetID("settlement"), famelevelsim, chr_SimGetFame("New"), fameleveldyn, chr_DynastyGetFame("New"))

				end
			else
				SetData("#Alderman",0)
			end
		end
	end
end
