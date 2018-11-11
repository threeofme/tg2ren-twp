function GetWorld()
	return ""
end

-- this function is called directly after the world is loaded
-- use this function for creating dynasties and sim's
-- on success return nothing or a empty string
-- on error return the error message

function Prepare()
	LogMessage("DefaultCampaign::Prepare()")
	SetTime(EN_SEASON_SPRING,1400, 6, 0)
	return true
end

function CreateShadowDynasty(Number, City, NewDynastyAlias)
	LogMessage("DefaultCampaign::CreateShadowDynasty()")
	local PrimTypes = { GL_BUILDING_TYPE_MINE, GL_BUILDING_TYPE_RANGERHUT, GL_BUILDING_TYPE_HOSPITAL, GL_BUILDING_TYPE_FARM, GL_BUILDING_TYPE_TAVERN, GL_BUILDING_TYPE_FRUITFARM, GL_BUILDING_TYPE_MILL, -1 }
	local	Protos = { GL_BUILDING_TYPE_BAKERY, GL_BUILDING_TYPE_SMITHY, GL_BUILDING_TYPE_JOINERY, GL_BUILDING_TYPE_TAILORING, GL_BUILDING_TYPE_ROBBER, 
									 GL_BUILDING_TYPE_ALCHEMIST, GL_BUILDING_TYPE_CHURCH_EV, GL_BUILDING_TYPE_CHURCH_CATH,  GL_BUILDING_TYPE_THIEF, 
									 GL_BUILDING_TYPE_PIRAT, GL_BUILDING_TYPE_BANKHOUSE, GL_BUILDING_TYPE_FRIEDHOF, GL_BUILDING_TYPE_GAUKLER,
									 GL_BUILDING_TYPE_STONEMASON }
	local Pos
	local Count = 0
	local y = 0
	local CityLevel = CityGetLevel(City)
	
	if CityLevel<=2 then
		y = 1
	elseif CityLevel==3 then
		y = 1
	elseif CityLevel==4 then
		y = 2
	elseif CityLevel==5 then
		y = 3
	else
		y = 4
	end
	
	for x=0,y-1 do
		if not AliasExists("WorkingHut") then
			local Start = Rand(7)+1
			Pos = Start
			while PrimTypes[Pos] do
				Count = CityGetBuildingCount(City, -1, PrimTypes[Pos], -1, -1, FILTER_HAS_DYNASTY)
				if Count > 0 then
					break
				elseif CityGetRandomBuilding(City, -1, PrimTypes[Pos], -1, -1, FILTER_NO_DYNASTY, "WorkingHut") then
					break
				end
				Pos = Pos + 1
				if Pos > 7 then
					Pos = 1
				end
				if Pos == Start then
					break
				end
			end
		end
	
		if not AliasExists("WorkingHut") or Count>0 then
			local Start = Rand(14)+1
			Pos = Start
			while Protos[Pos] do
				if CityGetRandomBuilding(City, -1, Protos[Pos], -1, -1, FILTER_NO_DYNASTY, "WorkingHut") then
					break
				end
				Pos = Pos + 1
				if Pos > 14 then
					Pos = 1
				end
				if Pos == Start then
					break
				end
			end
		end

		if not AliasExists("WorkingHut") then
			return "no WorkingHut found for shadow dynasty on startup"
		end
		
		local Class = BuildingGetCharacterClass("WorkingHut")
		if Class == -1 then
			return "Illegal character class for building "..GetName("WorkingHut")
		end
		local	Gender = Rand(2)
		
		if not DynastyCreate(-1, false, 0, NewDynastyAlias, true) then
			return "cannot create the dynasty"
		end
		
		if not BossCreate("WorkingHut", Gender, Class, 5, "boss") then
			return "unable to create boss of the dynasty"
		end
		
		local Religion = BuildingGetReligion("WorkingHut")
		if Religion~=RELIGION_NONE then
			SimSetReligion("boss", Religion)
		end
		
		DynastyAddMember(NewDynastyAlias, "boss")
		if not BuildingBuy("WorkingHut", "boss", BM_STARTUP) then
			return "unable to buy the building for the dynasty"
		end
		
		SetHomeBuilding("boss", "WorkingHut")
	
		local Difficulty = ScenarioGetDifficulty()
		local	Fame = 0
		local	ImpFame = 0
		local	NobLevel = 2
		local	XP = 0
		local StartMoney = 0
	
		if Difficulty == 0 then
			NobLevel = Rand(2)+2
			XP = Rand(51)*10
			StartMoney = 1000+Rand(2500)
			Fame = Rand(2)
			ImpFame = Rand(2)
		elseif Difficulty == 1 then
			NobLevel = Rand(3)+2
			XP = Rand(51)*10 + 50
			StartMoney = 2500+Rand(2500)
			Fame = Rand(3)
			ImpFame = Rand(3)
			-- Some starting items
			if GetDynastyID("boss")>0 then
				AddItems("boss","Dagger",1,INVENTORY_EQUIPMENT)
			end
		elseif Difficulty == 2 then
			NobLevel = Rand(4)+2
			XP = Rand(101)*10 + 50
			StartMoney = 5000+Rand(5000)
			Fame = Rand(4)
			ImpFame = Rand(4)
			-- Some starting items
			if GetDynastyID("boss")>0 then
				if Rand(2) == 0 then
					AddItems("boss","Dagger",1,INVENTORY_EQUIPMENT)
				else
					AddItems("boss","Mace",1,INVENTORY_EQUIPMENT)
				end
				
				if Rand(2) == 0 then
					AddItems("boss","LeatherArmor",1,INVENTORY_EQUIPMENT)
				end
			end
		elseif Difficulty == 3 then
			NobLevel = Rand(5)+2
			XP = Rand(100)*10 + 100
			StartMoney = 7500+Rand(7500)
			Fame = Rand(5)
			ImpFame = Rand(5)
			-- Some starting items
			if GetDynastyID("boss")>0 then
				local RandEquip = Rand(4)
				if RandEquip == 0 then
					AddItems("boss","Dagger",1,INVENTORY_EQUIPMENT)
				elseif RandEquip == 1 then
					AddItems("boss","Mace",1,INVENTORY_EQUIPMENT)
				elseif RandEquip == 2 then
					AddItems("boss","Shortsword",1,INVENTORY_EQUIPMENT)
				elseif RandEquip == 3 then
					AddItems("boss","Longsword",1,INVENTORY_EQUIPMENT)
				end
				
				if Rand(2) == 0 then
					AddItems("boss","LeatherArmor",1,INVENTORY_EQUIPMENT)
				else
					AddItems("boss","Chainmail",1,INVENTORY_EQUIPMENT)
				end
			end
		else
			NobLevel = Rand(6)+2
			XP = Rand(101)*10 + 250
			StartMoney = 10000+Rand(10000)
			Fame = Rand(8)+1
			ImpFame = Rand(8)+1
			-- Some starting items
			if GetDynastyID("boss")>0 then
				local RandEquip = Rand(5)
				if RandEquip == 0 then
					AddItems("boss","Dagger",1,INVENTORY_EQUIPMENT)
				elseif RandEquip == 1 then
					AddItems("boss","Mace",1,INVENTORY_EQUIPMENT)
				elseif RandEquip == 2 then
					AddItems("boss","Shortsword",1,INVENTORY_EQUIPMENT)
				elseif RandEquip == 3 then
					AddItems("boss","Longsword",1,INVENTORY_EQUIPMENT)
				elseif RandEquip == 4 then
					AddItems("boss","Axe",1,INVENTORY_EQUIPMENT)
				end
				
				if Rand(3) < 2 then
					AddItems("boss","LeatherArmor",1,INVENTORY_EQUIPMENT)
				else
					AddItems("boss","Platemail",1,INVENTORY_EQUIPMENT)
				end
			end
		end
		
		if AliasExists("Office") then
			SimSetOffice("boss", "Office")
			NobLevel = NobLevel + math.floor(OfficeGetLevel("Office")*0.5)
			
			if BossCreate("WorkingHut", 1 - SimGetGender("boss"), SimGetClass("boss"), 5, "Spouse") then
				SimMarry("boss", "Spouse")
			end
			DynastyAddMember(NewDynastyAlias, "Spouse")
			IncrementXP("Spouse", XP)
			XP = XP + OfficeGetLevel("Office")*250
			local ChildGender = Rand(2)
			if ChildGender == 0 then
				ChildGender = 8
			else
				ChildGender = 7
			end
			SimCreate(ChildGender, "WorkingHut", "WorkingHut", "Shadowchild")
			if SimGetGender("boss")==GL_GENDER_MALE then
				SimSetFamily("Shadowchild", "Spouse", "boss")
			else
				SimSetFamily("Shadowchild", "boss", "Spouse")
			end
			if GetHomeBuilding("boss", "Residence") then
				SetHomeBuilding("Shadowchild", "Residence")
			end
			DoNewBornStuff("Shadowchild")
			SimSetAge("Shadowchild", Rand(12)+1)
			SimSetBehavior("Shadowchild", "Childness")
			SetState("Shadowchild", STATE_CHILD, true)
		end
		
		SetNobilityTitle("boss", NobLevel, true)
		IncrementXP("boss", XP)
		CreditMoney("boss", StartMoney, "GameStart")
		if Fame and ImpFame then
			chr_SimAddFame("boss",Fame)
			chr_SimAddImperialFame("boss",ImpFame)
		end

	end
	
	return ""
end

function CreateDynasty(ID, SpawnPoint, IsPlayer, PeerID, PlayerDescLabel)
	LogMessage("DefaultCampaign::CreateDynasty()")
	local DynastyAlias	= "NewDynasty"

	if not AliasExists(SpawnPoint) then
		return "invalid spawn point"
	end
	
	local PlayerDescNode = nil
	local CityName = nil

	if PlayerDescLabel~=nil then
		local PlayerDescPath = "\\Application\\Game\\PlayerDesc"..PlayerDescLabel
		PlayerDescNode = FindNode(PlayerDescPath)
	end
	
	if IsPlayer then
		if not PlayerCreate(nil, "boss") then
			return "unable to create player character"
		end	
	else
		if not BossCreate(nil, Rand(2), 0, -1, "boss") then
			return "unable to create boss of the dynasty"
		end
	end	
	
	if not DynastyCreate(ID, IsPlayer, PeerID, DynastyAlias, false) then
		return "cannot create the dynasty "..ID
	end
	
	if(CityName == nil) then
		CityName = ""
	end
	
	local	CityAlias
	local	Section
	local BeamPos
	
	Section 	= "INIT-"
	if IsPlayer then
		Section = Section .. "PLAYER-"
	else
		Section = Section .. "AI-"
	end
	
	Section = Section .. ScenarioGetDifficulty()
	
	local HasResidence 	= GetSettingNumber(Section, "HasResidence", 0)
	local Workshops 		= GetSettingNumber(Section, "Workshops", 0)
	local Money 		= GetSettingNumber(Section, "Money", 5000)
	local Married 		= GetSettingNumber(Section, "Married", 0)
	local Childs		= GetSettingNumber(Section, "Childs", 0)
	local InitialTitle 	= GetSettingNumber(Section, "InitialTitle", 0)
	
	CityAlias	= "CityName"
	CityName = ""
	
	-- get city name from playerdescnode
	if PlayerDescNode~=nil then
		CityName = PlayerDescNode:GetValueString("City")
	end
	
	if IsPlayer then
		if CityName and CityName~="" then
			ScenarioGetObjectByName("Settlement", CityName, CityAlias)
		end

		if not AliasExists(CityAlias) then
			CityName = GetSettingString("ENDLESS", "City", "")
			if CityName~="" then
				ScenarioGetObjectByName("Settlement", CityName, CityAlias)
			end
		end
	end

	if HasResidence or Workshops > 0 then
		if not AliasExists(CityAlias) then
			-- find a good start city for the dynasty
			
			local CityCount = ScenarioGetObjects("Settlement", 10, "CityList")
			local	cc
			local	FreeWorkshops
			local	FreeResidences
			local Total = 0
			local	BestTotal = 0
			local	BestCity
			for cc=0,CityCount-1 do
				FreeResidences	= CityGetBuildingCount( "CityList"..cc, nil, GL_BUILDING_TYPE_RESIDENCE, 1, -1, FILTER_IS_BUYABLE)
				FreeWorkshops	= CityGetBuildingCount( "CityList"..cc, GL_BUILDING_CLASS_WORKSHOP, nil, 1, -1, FILTER_IS_BUYABLE)
				
				
				if FreeResidences > 4  then 
					FreeResidences = 4
				end
				if FreeWorkshops > 4  then 
					FreeWorkshops = 4
				end
				
				Total = FreeResidences + FreeWorkshops
				
				if Total == BestTotal then -- if the city has the same amount of free residences than the last one, keep the last one.
					Total = Total - 1
				end
				
				if Total > BestTotal then -- if the city has more amount of free residences than the last one, take the new one.
					BestTotal = Total -- and save the amount find for the next check.
					BestCity	= "CityList"..cc
				end
			end
			
			if BestCity then
				CopyAlias(BestCity, CityAlias)
			else
				if not ScenarioGetRandomObject("Settlement", CityAlias) then
					HasResidence = 0
					Workshops = 0
				end
			end
		end
	end	
	
	if HasResidence==1 then
		if not CityGetRandomBuilding(CityAlias, nil, GL_BUILDING_TYPE_RESIDENCE, 1, -1, FILTER_IS_BUYABLE, "Residence") then -- buy a residence if possible
			local Proto = ScenarioFindBuildingProto(nil, GL_BUILDING_TYPE_RESIDENCE, 1, -1) -- if not, build a new one
			if Proto and Proto~=-1 then
				if not CityBuildNewBuilding(CityAlias, Proto, nil, "Residence") then
					return "unable to create main residence" -- bad luck?
				end
			end
		end
	end
	

	if not IsPlayer then
		-- find a good character class for the new boss
		if Workshops>0 then
			local	BestClass
			local	BestAmount = 0
			for Class = GL_CLASS_PATRON, GL_CLASS_CHISELER do
				local Count = CityGetBuildingCountForCharacter(CityAlias, Class, RELIGION_NONE, true)
				if Count >= Workshops and Count > 1 and Count > BestAmount then -- we want enough workshops for our starting setting and we want more than before.
					BestClass = Class -- save our new best class
					BestAmount = Count -- save the new amount we found
				elseif Count > 0 and Count > BestAmount then -- we did not found enough workshops, but at least 1, so save that
					BestClass = Class
					BestAmount = Count
				end
			end

			if BestClass then
			--	SimSetClass("boss", BestClass)
				SimSetClass("boss",1+Rand(4))
			else
				SimSetClass("boss", 1+Rand(4))
			end
		end

	end
	
	if not DynastyAddMember(DynastyAlias, "boss") then
		return "unable to add the first member to the dynasty"
	end
	
	if (InitialTitle > 0) then
		SetNobilityTitle("boss", InitialTitle)
	end		
	
	if AliasExists("Residence") then
		BuildingBuy("Residence", "boss", BM_STARTUP)
		GetOutdoorMovePosition("boss", "Residence", "BeamPos")
		BeamPos = "BeamPos"
	else
		if GetOutdoorMovePosition("boss", SpawnPoint, "Position") then
			BeamPos = "Position"
		else
			BeamPos = SpawnPoint
		end
	end
	SimBeamMeUp("boss", BeamPos)
	
	-- buy the workshops for the character
	
	local Class = SimGetClass("boss")
	while Workshops>0 do
		if not DynastyFindNewBuilding("boss", BM_STARTUP, "WorkShop") then
			local Proto = ScenarioFindBuildingProtoForCharacter("boss", 1, -1)
			if Proto and Proto~=-1 then
				local BuildingPrice = BuildingGetPriceProto(Proto)
				if BuildingPrice>0 then
					CreditMoney(DynastyAlias, BuildingPrice, "GameStart")
				end
			end
		end
		Workshops = Workshops - 1
	end
	
	-- create a spouse
	
	if Married == 1 then
		if BossCreate(nil, 1 - SimGetGender("boss"), SimGetClass("boss"), -1, "spouse") then
			SimBeamMeUp("spouse", BeamPos)
			SimMarry("boss", "spouse")
		end
	end
	
	-- save the DynID to the townhall
	if IsPlayer then
		if GetSettlement("boss", "MyTown") then
			if CityGetRandomBuilding("MyTown", 3, 23, -1, -1, FILTER_IGNORE, "Townhall") then
				if HasProperty("Townhall", "PlayerCount") then
					local PlayerCount = GetProperty("Townhall","PlayerCount")
					-- Add the player
					PlayerCount = PlayerCount+1
					SetProperty("Townhall","PlayerCount",PlayerCount)
					SetProperty("Townhall","Player"..PlayerCount,GetDynastyID("boss"))
				end
			end
		end
	end
						
	-- init mission
	local PlayerDescNode = nil

	if PlayerDescLabel~=nil then
		local PlayerDescPath = "\\Application\\Game\\PlayerDesc"..PlayerDescLabel
		PlayerDescNode = FindNode(PlayerDescPath)
	end

	if PlayerDescNode~=nil then

		local Team
		local Success
		
		Success, Team = PlayerDescNode:GetValueInt("Team", 0)
		if Team and Team>0 then
			DynastySetTeam(DynastyAlias, Team)
		end
		
		SetProperty(DynastyAlias,"PlayerDesc",PlayerDescLabel)
		local MissionType = PlayerDescNode:GetValueInt("MissionType")
		local MissionSubtype = PlayerDescNode:GetValueInt("MissionSubType")
	
	
		if (MissionType==0) then			-- ausloeschung
			StartMission("Mission_DeathMatch",DynastyAlias)
		elseif (MissionType==1) then		-- timelimit
			StartMission("Mission_TimeLimit",DynastyAlias)
		elseif (MissionType==2)  then		-- common goal 
			if (MissionSubtype==0) then
				StartMission("Mission_MakeMoney",DynastyAlias)
			elseif (MissionSubtype==1) then
				StartMission("Mission_Office",DynastyAlias)
			elseif (MissionSubtype==2) then
				StartMission("Mission_Acuss",DynastyAlias)
			elseif (MissionSubtype==3) then
				StartMission("Mission_Criminal",DynastyAlias)
			end
		elseif (MissionType==4) then
			StartMission("Mission_Endless",DynastyAlias)
		end
	end

	CreditMoney(DynastyAlias, Money, "GameStart")

	local ChildAge = 0

	if not IsPlayer then
		local Difficulty = ScenarioGetDifficulty()
		local XP
		local StartMoney
		local	Fame
		local	ImpFame
		local Age = 17
		
		if Difficulty == 0 then
			XP = 0
			StartMoney = 500
			Fame = 0
			ImpFame = 0
			Age = Age+Rand(14)
			ChildAge = ChildAge + 2
		elseif Difficulty == 1 then
			XP = 500
			StartMoney = 1000
			Age = Age+Rand(12)
			ChildAge = ChildAge + 4
		elseif Difficulty == 2 then
			XP = Rand(10)*10 + 500
			StartMoney = 2000
			Fame = Rand(2)+1
			ImpFame = Rand(2)+1
			if Childs==0 then
				Childs=Rand(2)
			end
			Age = Age+Rand(10)
			ChildAge = ChildAge + 6
		elseif Difficulty == 3 then
			XP = Rand(50)*10 + 500
			StartMoney = 3000
			Fame = Rand(4)+1
			ImpFame = Rand(4)+1
			if Childs==0 then
				Childs=Rand(2)+1
			end
			Age = Age+6+Rand(6)
			ChildAge = ChildAge + 4 + Rand(4)
		else
			XP = Rand(76)*10 + 500
			StartMoney = 5000
			Fame = Rand(6)+2
			ImpFame = Rand(6)+2
			if Childs==0 then
				Childs=Rand(2)+2
			end
			Age = Age+8+Rand(6)
			ChildAge = ChildAge + 6 + Rand(6)
			-- Some starting items
			local RandEquip = Rand(4)
			if RandEquip == 0 then
				AddItems("boss","Dagger",1,INVENTORY_EQUIPMENT)
			elseif RandEquip == 1 then
				AddItems("boss","Mace",1,INVENTORY_EQUIPMENT)
			elseif RandEquip == 2 then
				AddItems("boss","Shortsword",1,INVENTORY_EQUIPMENT)
			elseif RandEquip == 3 then
				AddItems("boss","Longsword",1,INVENTORY_EQUIPMENT)
			end
			
			if Rand(2) == 0 then
				AddItems("boss","LeatherArmor",1,INVENTORY_EQUIPMENT)
			else
				AddItems("boss","Chainmail",1,INVENTORY_EQUIPMENT)
			end
		end

		local BossAge = Age-2+Rand(5)
		local SpouseAge = Age-2+Rand(5)

		if (BossAge-16-ChildAge)<0 then
			BossAge = BossAge + (-1*(BossAge-16-ChildAge))
		end
		
		if (SpouseAge-16-ChildAge)<0 then
			SpouseAge = SpouseAge + (-1*(SpouseAge-16-ChildAge))
		end
		
		SimSetAge("boss", BossAge)
		if Married == 1 then
			SimSetAge("spouse", SpouseAge)
			IncrementXP("spouse", XP)
		end

		IncrementXP("boss", XP)
		CreditMoney("boss", StartMoney, "GameStart")
		chr_SimAddFame("boss",Fame)
		chr_SimAddImperialFame("boss",ImpFame)
	end
	
	if Childs>0	then
	
		if AliasExists("Residence") then
			local	ch
			for ch=0,Childs-1 do
				local Age = Rand(ChildAge)+1
				if Rand(2)==0 then
					SimCreate(8, "Residence", "Residence", "NewBorn"..ch) -- it's a girl!
				else
					SimCreate(7, "Residence", "Residence", "NewBorn"..ch) --it's a boy!
				end
				if SimGetGender("boss")==GL_GENDER_MALE then
					SimSetFamily("NewBorn"..ch, "spouse", "boss")
				else
					SimSetFamily("NewBorn"..ch, "boss", "spouse")
				end
				SimSetAge("NewBorn"..ch, Age)
			end
		end
	end

	return ""
end

function CreateComputerDynasty(Number, SpawnPoint)
	return defaultcampaign_CreateDynasty(Number, SpawnPoint, false, -1)
end

-- this function is called, after the init of the scenario is finished.
function Start()
	LogMessage("DefaultCampaign::Start()")
	defaultcampaign_SetupDiplomacy()
	local CityCount = ScenarioGetObjects("Settlement", 10, "CityList")
	for c = 0, CityCount - 1 do
		-- initialize buildings
		local WorkshopCount = CityGetBuildings("CityList"..c, GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_HAS_DYNASTY, "Workshop")
		for i=0, WorkshopCount-1 do
			local BldAlias = "Workshop"..i
			bld_HandleSetup(BldAlias)
		end
	end
end

function SetupDiplomacy()
	
	local CityCount = ScenarioGetObjects("Settlement", -1, "Cities")
	local DynCount 	= ScenarioGetObjects("Dynasty", 150, "DynList")
	if CityCount == 0 or DynCount == 0 then
		return
	end
	
	local CityID
	local Count
	
	for dyn=0, DynCount-1 do
		if DynastyGetBuilding2("DynList"..dyn, 0, "Home"..dyn) then
			SetData("CityID"..dyn, GetSettlementID("Home"..dyn))
		else
			SetData("CityID"..dyn, -1)
		end
	end
	
	local Difficulty = ScenarioGetDifficulty()
	
	for CityNo=0, CityCount-1 do
	
		CityID 	= GetID("Cities"..CityNo)
		Count 	= 0
		
		for dyn=0, DynCount-1 do
			if GetData("CityID"..dyn)==CityID then
				CopyAlias("DynList"..dyn, "Dynasties"..Count)
				Count = Count + 1
			end
		end
		
		local FoeCount = math.floor((Count+1)/4)
		local FriendCount = math.floor((Count+1)/3)
		
		local Alias
		
		for dyn=0,Count-1 do
		
			Alias = "Dynasties"..dyn
			
			local Friends = defaultcampaign_GetStateCount(Alias, DIP_NAP, Count)
			local Foes = defaultcampaign_GetStateCount(Alias, DIP_FOE, Count)
			
			while Friends<FriendCount or Foes<FoeCount do
			
				if Friends<FriendCount and Rand(3) == 0 then
					local Friend = defaultcampaign_FindDynasty(DIP_NAP, FriendCount, dyn+1, Count, Friends==0)
					if Friend then
						DynastySetDiplomacyState(Alias, Friend, DIP_NAP)
					end
					Friends = Friends + 1
				end
	
				if Foes<FoeCount and Rand(2) == 0 then
					local Foe = defaultcampaign_FindDynasty(DIP_FOE, FoeCount, dyn+1, Count, Foes==0 )
					if Foe then
						DynastySetDiplomacyState(Alias, Foe, DIP_FOE)
						f_DynastyAddEnemy(Alias,Foe)
						f_DynastyAddEnemy(Foe,Alias)
					end
					Foes = Foes + 1
				end
			end
		end
		
	end
end

function InitCameraPosition()

	if GetLocalPlayerDynasty("LocalPlayer") then
		if DynastyGetMember("LocalPlayer", 0, "Boss") then
			local Rotation = 180
			if GetHomeBuilding("Boss", "Home") then
				Rotation = GetRotation("Boss", "home") + 90
			end
			CameraTerrainSetPos("Boss", 1200, Rotation)
		end
	end
end

function FindDynasty(DipState, MaxState, StartNo, EndNo, FirstOfType)
	local DynNo
	local	Found
	local	Count = 0
	for DynNo=StartNo, EndNo-1 do
		if DynastyGetDiplomacyState("Dynasties"..(StartNo-1), "Dynasties"..DynNo)==DIP_NEUTRAL then
			if defaultcampaign_GetStateCount("Dynasties"..DynNo, DipState, EndNo) < MaxState then
				Count = Count + 1
				if Rand(100) <= 100/Count then
					Found = "Dynasties"..DynNo
					if FirstOfType and GetSettlementID("Dynasties"..(StartNo-1)) == GetSettlementID("Dynasties"..DynNo) then
						return Found
					end
				end
			end
		end
	end
	return Found
end

function GetStateCount(DynAlias, DipState, EndNo)
	local Count = 0
	local i
	local	Alias

	for i=0,EndNo-1 do
		Alias = "Dynasties"..i
		if Alias~=DynAlias then
			if DynastyGetDiplomacyState(DynAlias, Alias)==DipState then
				Count = Count + 1
			end
		end
	end
	
	return Count
end

-- this function is called right bevor starting the frames
function GameStart()
	LogMessage("DefaultCampaign::GameStart()")
	defaultcampaign_InitiateGodModule()
end

function InitiateGodModule()
	local NumCities = ScenarioGetObjects("Settlement", 15 ,"City")
	if NumCities > 0 then
		for i=0,NumCities-1 do
			if CityGetLevel("City"..i) >= 2 then
				if CityGetRandomBuilding("City"..i, GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_TOWNHALL, -1, -1, FILTER_IGNORE, "Townhall") then
					GetPosition("Townhall","TownhallPos")
					Position2GuildObject("TownhallPos", "CityGodModule")
					local CityID = GetID("City"..i)
					SetProperty("CityGodModule", "CityID", CityID)
					MeasureRun("CityGodModule", nil, "CityControl", true)
				end
			end
		end
	end	
end

