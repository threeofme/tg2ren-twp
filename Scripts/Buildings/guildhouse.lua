function Run()
end


function OnLevelUp()
end


function Setup()
	--SetState("", STATE_MOVING_BUILDING, true)
	BuildingGetCity("", "my_settlement")
	if (gameplayformulas_CheckPublicBuilding("my_settlement", GL_BUILDING_TYPE_BANK)[1]>0) then
		SetProperty("my_settlement","Guildhall",GetID(""))
		MeasureRun("", nil, "GuildTrading")
	end
end


function PingHour()
	BuildingGetCity("", "my_settlement")
	if (gameplayformulas_CheckPublicBuilding("my_settlement", GL_BUILDING_TYPE_BANK)[1]>0) then
		if not HasProperty("my_settlement","Guildhall") then
			SetProperty("my_settlement","Guildhall",GetID(""))
		end
		guildhouse_CheckGuildMasters()
		guildhouse_CheckGuildElders()
		if GetCurrentMeasureName("") ~= "GuildTrading" then
			MeasureRun("", nil, "GuildTrading")
		end
	end
	
	guildhouse_CheckSimsInside()
end


function CheckGuildElders()
	if GetProperty("", "PatronElder")==nil then
		GetLocatorByName("","PatronElder","SpawnPos1")
		SimCreate(930,"","SpawnPos1","Patron")
		if SimGetGender("Patron")==GL_GENDER_MALE then
			local name = GetName("Patron")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Patron", "@L_GUILDHOUSE_ELDER_MALE_+0")
			SimSetLastname("Patron", newlastname)
		else
			local name = GetName("Patron")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Patron", "@L_GUILDHOUSE_ELDER_FEMALE_+0")
			SimSetLastname("Patron", newlastname)
		end
		SimSetAge("Patron", 65)
		SetState("Patron",STATE_TOWNNPC,true)
		SimSetBehavior("Patron","GuildElder")
		SetProperty("", "PatronElder", GetID("Patron"))
	end
	if GetProperty("", "ArtisanElder")==nil then
		GetLocatorByName("","ArtisanElder","SpawnPos2")
		SimCreate(931,"","SpawnPos2","Artisan")
		if SimGetGender("Artisan")==GL_GENDER_MALE then
			local name = GetName("Artisan")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Artisan", "@L_GUILDHOUSE_ELDER_MALE_+0")
			SimSetLastname("Artisan", newlastname)
		else
			local name = GetName("Artisan")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Artisan", "@L_GUILDHOUSE_ELDER_FEMALE_+0")
			SimSetLastname("Artisan", newlastname)
		end
		SimSetAge("Artisan", 65)
		SetState("Artisan",STATE_TOWNNPC,true)
		SimSetBehavior("Artisan","GuildElder")
		SetProperty("", "ArtisanElder", GetID("Artisan"))
	end
	if GetProperty("", "ScholarElder")==nil then
		GetLocatorByName("","ScholarElder","SpawnPos3")
		SimCreate(932,"","SpawnPos3","Scholar")
		if SimGetGender("Scholar")==GL_GENDER_MALE then
			local name = GetName("Scholar")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Scholar", "@L_GUILDHOUSE_ELDER_MALE_+0")
			SimSetLastname("Scholar", newlastname)
		else
			local name = GetName("Scholar")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Scholar", "@L_GUILDHOUSE_ELDER_FEMALE_+0")
			SimSetLastname("Scholar", newlastname)
		end
		SimSetAge("Scholar", 65)
		SetState("Scholar",STATE_TOWNNPC,true)
		SimSetBehavior("Scholar","GuildElder")
		SetProperty("", "ScholarElder", GetID("Scholar"))
	end
	if GetProperty("", "ChiselerElder")==nil then
		GetLocatorByName("","ChiselerElder","SpawnPos4")
		SimCreate(933,"","SpawnPos4","Chiseler")
		if SimGetGender("Chiseler")==GL_GENDER_MALE then
			local name = GetName("Chiseler")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Chiseler", "@L_GUILDHOUSE_ELDER_MALE_+0")
			SimSetLastname("Chiseler", newlastname)
		else
			local name = GetName("Chiseler")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Chiseler", "@L_GUILDHOUSE_ELDER_FEMALE_+0")
			SimSetLastname("Chiseler", newlastname)
		end
		SimSetAge("Chiseler", 65)
		SetState("Chiseler",STATE_TOWNNPC,true)
		SimSetBehavior("Chiseler","GuildElder")
		SetProperty("", "ChiselerElder", GetID("Chiseler"))
	end
end


function CheckGuildMasters()
	local currentRound = GetRound()
	if currentRound > 0 then

		local currentGameTime = math.mod(GetGametime(),24)
		if (currentGameTime == 5) or ((currentGameTime > 5) and (currentGameTime < 6)) then

			--add fame to last PatronMaster
			local PatronMaster = GetProperty("", "PatronMaster")
			if PatronMaster~=nil then
				if GetAliasByID(PatronMaster,"Patron") and GetState("Patron", STATE_DEAD)==false then
					chr_SimAddFame("Patron",1)
					RemoveProperty("Patron", "PatronMaster")
				end
			end
			--add fame to last ArtisanMaster
			local ArtisanMaster = GetProperty("", "ArtisanMaster")
			if ArtisanMaster~=nil then
				if GetAliasByID(ArtisanMaster,"Artisan") and GetState("Artisan", STATE_DEAD)==false then
					chr_SimAddFame("Artisan",1)
					RemoveProperty("Artisan", "ArtisanMaster")
				end
			end
			--add fame to last ScholarMaster
			local ScholarMaster = GetProperty("", "ScholarMaster")
			if ScholarMaster~=nil then
				if GetAliasByID(ScholarMaster,"Scholar") and GetState("Scholar", STATE_DEAD)==false then
					chr_SimAddFame("Scholar",1)
					RemoveProperty("Scholar", "ScholarMaster")
				end
			end
			--add fame to last ChiselerMaster
			local ChiselerMaster = GetProperty("", "ChiselerMaster")
			if ChiselerMaster~=nil then
				if GetAliasByID(ChiselerMaster,"Chiseler") and GetState("Chiseler", STATE_DEAD)==false then
					chr_SimAddFame("Chiseler",1)
					RemoveProperty("Chiseler", "ChiselerMaster")
				end
			end

			BuildingGetCity("","city")		
			local BuildingCount = CityGetBuildings("city", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_IGNORE, "Building")
			local year = GetYear()
			local Alias
			local BuildingLvl
			local tmpPoints
			local PatronArray = {}
			local PatronPointArray = {}
			local PatronArrayCount = 0
			local ArtisanArray = {}
			local ArtisanPointArray = {}
			local ArtisanArrayCount = 0
			local ScholarArray = {}
			local ScholarPointArray = {}
			local ScholarArrayCount = 0
			local ChiselerArray = {}
			local ChiselerPointArray = {}
			local ChiselerArrayCount = 0
			local PlayerCity = false
			
			for l=0,BuildingCount-1 do
				Alias = "Building"..l
				BuildingLvl = BuildingGetLevel(Alias)
				
				if BuildingGetOwner(Alias, "Sim") and (GetSettlementID("Sim")==GetID("city")) then
					
					if DynastyIsPlayer("Sim") then
						PlayerCity = true
					end
					
					--Patron
					if SimGetClass("Sim")==1 and BuildingGetCharacterClass(Alias)==1 then
						local num = 0
						while num<100 do
							if PatronArray[num]==GetID("Sim") then
								tmpPoints = PatronPointArray[num] + BuildingLvl + chr_SimGetFame("Sim")
								PatronPointArray[num] = tmpPoints
								break
							elseif PatronArray[num]==nil then
								PatronArray[num] = GetID("Sim")
								tmpPoints = BuildingLvl
								PatronPointArray[num] = tmpPoints
								PatronArrayCount = PatronArrayCount + 1
								break
							end
							num = num + 1
						end
		
					--Artisan
					elseif SimGetClass("Sim")==2 and BuildingGetCharacterClass(Alias)==2 then
						local num = 0
						while num<100 do
							if ArtisanArray[num]==GetID("Sim") then
								tmpPoints = ArtisanPointArray[num] + BuildingLvl + chr_SimGetFame("Sim")
								ArtisanPointArray[num] = tmpPoints
								break
							elseif ArtisanArray[num]==nil then
								ArtisanArray[num] = GetID("Sim")
								tmpPoints = BuildingLvl
								ArtisanPointArray[num] = tmpPoints
								ArtisanArrayCount = ArtisanArrayCount + 1
								break
							end
							num = num + 1
						end
		
					--Scholar
					elseif SimGetClass("Sim")==3 and BuildingGetCharacterClass(Alias)==3 then
						local num = 0
						while num<100 do
							if ScholarArray[num]==GetID("Sim") then
								tmpPoints = ScholarPointArray[num] + BuildingLvl + chr_SimGetFame("Sim")
								ScholarPointArray[num] = tmpPoints
								break
							elseif ScholarArray[num]==nil then
								ScholarArray[num] = GetID("Sim")
								tmpPoints = BuildingLvl
								ScholarPointArray[num] = tmpPoints
								ScholarArrayCount = ScholarArrayCount + 1
								break
							end
							num = num + 1
						end
		
					--Chiseler
					elseif SimGetClass("Sim")==4 and BuildingGetCharacterClass(Alias)==4 then
						local num = 0
						while num<100 do
							if ChiselerArray[num]==GetID("Sim") then
								tmpPoints = ChiselerPointArray[num] + BuildingLvl + chr_SimGetFame("Sim")
								ChiselerPointArray[num] = tmpPoints
								break
							elseif ChiselerArray[num]==nil then
								ChiselerArray[num] = GetID("Sim")
								tmpPoints = BuildingLvl
								ChiselerPointArray[num] = tmpPoints
								ChiselerArrayCount = ChiselerArrayCount + 1
								break
							end
							num = num + 1
						end
					end
				end
			end

			SetProperty("", "year", year)
	
			local PatronWinner
			local PatronPoints = 0
			if PatronArrayCount>0 then
				for x=0,PatronArrayCount-1 do
					if PatronPointArray[x]>PatronPoints then
						PatronPoints = PatronPointArray[x]
						PatronWinner = x
					end
				end
				SetProperty("", "PatronMaster", PatronArray[PatronWinner])
			else
				SetProperty("", "PatronMaster", 0)
			end	
	
			local ArtisanWinner
			local ArtisanPoints = 0
			if ArtisanArrayCount>0 then
				for x=0,ArtisanArrayCount-1 do
					if ArtisanPointArray[x]>ArtisanPoints then
						ArtisanPoints = ArtisanPointArray[x]
						ArtisanWinner = x
					end
				end
				SetProperty("", "ArtisanMaster", ArtisanArray[ArtisanWinner])
			else
				SetProperty("", "ArtisanMaster", 0)
			end
	
			local ScholarWinner
			local ScholarPoints = 0
			if ScholarArrayCount>0 then
				for x=0,ScholarArrayCount-1 do
					if ScholarPointArray[x]>ScholarPoints then
						ScholarPoints = ScholarPointArray[x]
						ScholarWinner = x
					end
				end
				SetProperty("", "ScholarMaster", ScholarArray[ScholarWinner])
			else
				SetProperty("", "ScholarMaster", 0)
			end
	
			local ChiselerWinner
			local ChiselerPoints = 0
			if ChiselerArrayCount>0 then
				for x=0,ChiselerArrayCount-1 do
					if ChiselerPointArray[x]>ChiselerPoints then
						ChiselerPoints = ChiselerPointArray[x]
						ChiselerWinner = x
					end
				end
				SetProperty("", "ChiselerMaster", ChiselerArray[ChiselerWinner])
			else
				SetProperty("", "ChiselerMaster", 0)
			end
	
			-- PatronLabel, PatronName, ArtisanLabel, ArtisanName, ScholarLabel, ScholarName, ChiselerLabel, ChiselerName, 
			local textArray = {"","","","","","","","","","","",""}
	--		GetLocalPlayerDynasty("Player")

			if PatronArray[PatronWinner]~=nil then
				GetAliasByID(PatronArray[PatronWinner],"Patron")
				SetProperty("Patron", "PatronMaster", GetID("city"))
				if GetDynasty("Patron", "Dyn") and not DynastyIsShadow("Dyn") then
					local tmpflag = DynastyGetFlagNumber("Dyn") + 29
					textArray[8] = "@L$S[20"..tmpflag.."]"
				else
					textArray[8] = "@L$S[2008]"
				end
				if SimGetGender("Patron")==GL_GENDER_MALE then
					textArray[0] = "@L_GUILDHOUSE_MASTERLIST_PATRON_MALE_+0"
					textArray[1] = GetName("Patron")
				else
					textArray[0] = "@L_GUILDHOUSE_MASTERLIST_PATRON_FEMALE_+0"
					textArray[1] = GetName("Patron")
				end
				if SimGetGender("Patron")==GL_GENDER_MALE then
					feedback_MessagePolitics("Patron","@L_GUILDHOUSE_MASTERLIST_PLAYER_HEAD_+0","@L_GUILDHOUSE_MASTERLIST_PLAYER_MALE_+0",GetID("city"),PatronArray[PatronWinner],GetYear(),"@L_GUILDHOUSE_MASTERLIST_PATRON_MALE_+0")
				else
					feedback_MessagePolitics("Patron","@L_GUILDHOUSE_MASTERLIST_PLAYER_HEAD_+0","@L_GUILDHOUSE_MASTERLIST_PLAYER_FEMALE_+0",GetID("city"),PatronArray[PatronWinner],GetYear(),"@L_GUILDHOUSE_MASTERLIST_PATRON_FEMALE_+0")
				end
			else
					textArray[0] = "@L_GUILDHOUSE_MASTERLIST_PATRON_MALE_+0"
					textArray[1] = "@L_GUILDHOUSE_MASTERLIST_NO_ENTRY_+0"
			end

			if ArtisanArray[ArtisanWinner]~=nil then
				GetAliasByID(ArtisanArray[ArtisanWinner],"Artisan")
				SetProperty("Artisan", "ArtisanMaster", GetID("city"))
				if GetDynasty("Artisan", "Dyn") and not DynastyIsShadow("Dyn") then
					local tmpflag = DynastyGetFlagNumber("Dyn") + 29
					textArray[9] = "@L$S[20"..tmpflag.."]"
				else
					textArray[9] = "@L$S[2008]"
				end
				if SimGetGender("Artisan")==GL_GENDER_MALE then
					textArray[2] = "@L_GUILDHOUSE_MASTERLIST_ARTISAN_MALE_+0"
					textArray[3] = GetName("Artisan")
				else
					textArray[2] = "@L_GUILDHOUSE_MASTERLIST_ARTISAN_FEMALE_+0"
					textArray[3] = GetName("Artisan")
				end
				if SimGetGender("Artisan")==GL_GENDER_MALE then
					feedback_MessagePolitics("Artisan","@L_GUILDHOUSE_MASTERLIST_PLAYER_HEAD_+0","@L_GUILDHOUSE_MASTERLIST_PLAYER_MALE_+0",GetID("city"),ArtisanArray[ArtisanWinner],GetYear(),"@L_GUILDHOUSE_MASTERLIST_ARTISAN_MALE_+0")
				else
					feedback_MessagePolitics("Artisan","@L_GUILDHOUSE_MASTERLIST_PLAYER_HEAD_+0","@L_GUILDHOUSE_MASTERLIST_PLAYER_FEMALE_+0",GetID("city"),ArtisanArray[ArtisanWinner],GetYear(),"@L_GUILDHOUSE_MASTERLIST_ARTISAN_FEMALE_+0")
				end
			else
					textArray[2] = "@L_GUILDHOUSE_MASTERLIST_ARTISAN_MALE_+0"
					textArray[3] = "@L_GUILDHOUSE_MASTERLIST_NO_ENTRY_+0"
			end

			if ScholarArray[ScholarWinner]~=nil then
				GetAliasByID(ScholarArray[ScholarWinner],"Scholar")
				SetProperty("Scholar", "ScholarMaster", GetID("city"))
				if GetDynasty("Scholar", "Dyn") and not DynastyIsShadow("Dyn") then
					local tmpflag = DynastyGetFlagNumber("Dyn") + 29
					textArray[10] = "@L$S[20"..tmpflag.."]"
				else
					textArray[10] = "@L$S[2008]"
				end
				if SimGetGender("Scholar")==GL_GENDER_MALE then
					textArray[4] = "@L_GUILDHOUSE_MASTERLIST_SCHOLAR_MALE_+0"
					textArray[5] = GetName("Scholar")
				else
					textArray[4] = "@L_GUILDHOUSE_MASTERLIST_SCHOLAR_FEMALE_+0"
					textArray[5] = GetName("Scholar")
				end
				if SimGetGender("Scholar")==GL_GENDER_MALE then
					feedback_MessagePolitics("Scholar","@L_GUILDHOUSE_MASTERLIST_PLAYER_HEAD_+0","@L_GUILDHOUSE_MASTERLIST_PLAYER_MALE_+0",GetID("city"),ScholarArray[ScholarWinner],GetYear(),"@L_GUILDHOUSE_MASTERLIST_SCHOLAR_MALE_+0")
				else
					feedback_MessagePolitics("Scholar","@L_GUILDHOUSE_MASTERLIST_PLAYER_HEAD_+0","@L_GUILDHOUSE_MASTERLIST_PLAYER_FEMALE_+0",GetID("city"),ScholarArray[ScholarWinner],GetYear(),"@L_GUILDHOUSE_MASTERLIST_SCHOLAR_FEMALE_+0")
				end
			else
					textArray[4] = "@L_GUILDHOUSE_MASTERLIST_SCHOLAR_MALE_+0"
					textArray[5] = "@L_GUILDHOUSE_MASTERLIST_NO_ENTRY_+0"
			end

			if ChiselerArray[ChiselerWinner]~=nil then
				GetAliasByID(ChiselerArray[ChiselerWinner],"Chiseler")
				SetProperty("Chiseler", "ChiselerMaster", GetID("city"))
				if GetDynasty("Chiseler", "Dyn") and not DynastyIsShadow("Dyn") then
					local tmpflag = DynastyGetFlagNumber("Dyn") + 29
					textArray[11] = "@L$S[20"..tmpflag.."]"
				else
					textArray[11] = "@L$S[2008]"
				end
				if SimGetGender("Chiseler")==GL_GENDER_MALE then
					textArray[6] = "@L_GUILDHOUSE_MASTERLIST_CHISELER_MALE_+0"
					textArray[7] = GetName("Chiseler")
				else
					textArray[6] = "@L_GUILDHOUSE_MASTERLIST_CHISELER_FEMALE_+0"
					textArray[7] = GetName("Chiseler")
				end
				if SimGetGender("Chiseler")==GL_GENDER_MALE then
					feedback_MessagePolitics("Chiseler","@L_GUILDHOUSE_MASTERLIST_PLAYER_HEAD_+0","@L_GUILDHOUSE_MASTERLIST_PLAYER_MALE_+0",GetID("city"),ChiselerArray[ChiselerWinner],GetYear(),"@L_GUILDHOUSE_MASTERLIST_CHISELER_MALE_+0")
				else
					feedback_MessagePolitics("Chiseler","@L_GUILDHOUSE_MASTERLIST_PLAYER_HEAD_+0","@L_GUILDHOUSE_MASTERLIST_PLAYER_FEMALE_+0",GetID("city"),ChiselerArray[ChiselerWinner],GetYear(),"@L_GUILDHOUSE_MASTERLIST_CHISELER_FEMALE_+0")
				end
			else
					textArray[6] = "@L_GUILDHOUSE_MASTERLIST_CHISELER_MALE_+0"
					textArray[7] = "@L_GUILDHOUSE_MASTERLIST_NO_ENTRY_+0"
			end

			if PlayerCity==true then
				MsgNewsNoWait("All","","","politics",-1, "@L_GUILDHOUSE_MASTERLIST_HEAD_+0","@L_GUILDHOUSE_MASTERLIST_BODY_+0",GetID("city"),GetYear(),textArray[0],textArray[1],textArray[2],textArray[3],textArray[4],textArray[5],textArray[6],textArray[7],textArray[8],textArray[9],textArray[10],textArray[11])
			end
		end	
	end
end

function CheckSimsInside()
	local forceexit = false
	
	BuildingGetCity("", "my_settlement")
	if (gameplayformulas_CheckPublicBuilding("my_settlement", GL_BUILDING_TYPE_BANK)[1]==0) then
		forceexit = true
	end

	BuildingGetInsideSimList("","SimList")

	local SimCnt = ListSize("SimList")

	for i=0,SimCnt - 1 do
		ListGetElement("SimList",i,"Sim")
		
		if forceexit then
			if not GetState("Sim", STATE_TOWNNPC) then
				f_ExitCurrentBuilding("Sim")
			end
		elseif (DynastyIsAI("Sim") and not(GetState("Sim", STATE_TOWNNPC))) then
			if GetCurrentMeasurePriority("Sim") < 2 then
				f_ExitCurrentBuilding("Sim")
			end
		end
	end
end

