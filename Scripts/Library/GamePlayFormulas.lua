function Init()
 --needed for caching
end

function LockPick(LockPickerLevel,LockLevel)
	if(LockPickerLevel >= LockLevel) then
		return 1
	end	
	return 0	
end

function CalcBuildProgress(DefaultProgress,Workers)
	return DefaultProgress + Workers
end

function CalcBurnDamageProgress()
	return 1
end

function CalcCartBuyPrice(CartType)
		return 250*(CartType+1) 
end

function CalcCartSellPrice(CartType,HPRelative)
		Price = gameplayformulas_CalcCartBuyPrice(CartType)
		Price = Price * HPRelative * 0.75
		return Price
end

-- -----------------------
-- CalcCartRepairPrice
-- -----------------------
function CalcCartRepairPrice(CartType, HPRelative)
		Price = gameplayformulas_CalcCartBuyPrice(CartType)
		Price = Price * (1 - HPRelative)
		return Price
end

function CalcFindRange(ObjectAlias)
	local Level = SimGetLevel(ObjectAlias)
	local Skillvalue = GetSkillValue(ObjectAlias,SECRET_KNOWLEDGE)
	local BaseRange = 1000
	
	return BaseRange * Level + (Skillvalue * 500)
end

function CalcSightRange(ObjectAlias)
	
	if BuildingGetType("Destination") ~= -1 then
		return 1500
	end

	local Level = SimGetLevel(ObjectAlias)
	local Skillvalue = GetSkillValue(ObjectAlias,EMPATHY)
	local BaseRange = 250
	return BaseRange + (Level * 50) + (Skillvalue * 150)
end

function CalcDamage(fWeaponDamage)
	return gameplayformulas_GetDamage("", fWeaponDamage)
end

function GetDamage(SimAlias, fWeaponDamage)
	local AttackValue	= GetSkillValue(SimAlias,FIGHTING)
	local Damage	= fWeaponDamage + (SimGetLevel(SimAlias) + AttackValue)*1.5
	return Damage	
end

function CalcArmorValue()
	return gameplayformulas_GetArmorValue("")
end

function GetArmorValue(SimAlias)
	local Armor	= GetArmor(SimAlias) + GetImpactValue(SimAlias, "FightArmor")
	return Armor	
end

function SimAttackWithRangeWeapon(SimAlias,DestAlias)
	log_death(DestAlias, "is getting attacked by ranged weapon by "..GetName(SimAlias) .. " (GamePlayFormulas)")
	local Distance = GetDistance(SimAlias,DestAlias)

	if IsType(SimAlias, "Sim") then
	--players require ammo, ai is cheating scum
	
		local lock = 0
		if GetItemCount(SimAlias, "Pistole", INVENTORY_EQUIPMENT) > 0 then
			lock = 4
		elseif GetItemCount(SimAlias, "Snaplock", INVENTORY_EQUIPMENT) > 0 then
			lock = 3
		elseif GetItemCount(SimAlias, "Wheellock", INVENTORY_EQUIPMENT) > 0 then
			lock = 2
		elseif GetItemCount(SimAlias, "Matchlock", INVENTORY_EQUIPMENT) > 0 then
			lock = 1
		end
		
		if (IsType(DestAlias, "Sim") and lock > 0 and not DynastyIsPlayer(SimAlias)) or (IsType(DestAlias, "Sim") and DynastyIsPlayer(SimAlias) and lock > 0 and GetItemCount(SimAlias, "Round", INVENTORY_STD) > 0) then
			if GetHP(DestAlias)<=0 or GetHP(SimAlias)<=0 or GetState(SimAlias,STATE_UNCONSCIOUS) then
				StopMeasure(SimAlias)--if either is dead, we break the current measure
			end
			
			if GetState(DestAlias, STATE_INVISIBLE) then
				StopMeasure(SimAlias) -- stop if target is hidden
			end
			
			local time
			--GetSkillValue(SimAlias,"dex")
			
			if Distance>1000 then
				f_MoveTo(SimAlias,DestAlias,GL_MOVESPEED_RUN, 1000)
			end

			if IsMounted(SimAlias) then
					Unmount(SimAlias)
			end
			if IsMounted(DestAlias) then
					Unmount(DestAlias)
			end
			
			AlignTo(SimAlias,DestAlias)
			Sleep(0.3)
			
			CarryObject(SimAlias,"Handheld_Device/ANIM_gun.nif",false)
			time = PlayAnimationNoWait(SimAlias,"duel_shoot")
			Sleep(time*0.5)

			RemoveItems(SimAlias,"Round",1)

			if GetPositionOfSubobject(DestAlias, "Game_Chest_Scale","Game_Chest_Scale") then
				StartSingleShotParticle("particles/bloodsplash.nif", "Game_Chest_Scale", 1, 3.0)
			end
			time = PlayAnimationNoWait(DestAlias,"duel_shoot_gothit")
			PlaySound3D(SimAlias,"Effects/combat_strike_fist/combat_strike_fist+4.wav",1)
			Sleep(0.2)
			PlaySound3D(DestAlias,"combat/pain/Hurt_s_01.wav",1)
			
			ModifyHP(DestAlias,-15*lock,true)
			
			if AliasExists(SimAlias) then
				CarryObject(SimAlias,"",false)
			end

		elseif (IsType(DestAlias, "Sim") or IsType(DestAlias, "Building") or IsType(DestAlias, "Cart")) and GetItemCount(SimAlias, "Sparkingsteel", INVENTORY_EQUIPMENT)>0 and GetItemCount(SimAlias, "Granate", INVENTORY_STD)>0 then
			local time
			--GetSkillValue(SimAlias,"dex")
			
			if GetHP(SimAlias)<=0 then
				StopMeasure(SimAlias)--if we are dead, break the current measure
			end

			if IsMounted(DestAlias) then
					Unmount(DestAlias)
			end

			AlignTo(SimAlias,DestAlias)
			Sleep(0.5)
			
			GetPosition(DestAlias,"ParticleSpawnPos")
			PlayAnimationNoWait(SimAlias,"fetch_store_obj_R")
			Sleep(1)
			PlaySound3D(SimAlias,"Locations/wear_clothes/wear_clothes+1.wav", 1.0)
			CarryObject(SimAlias, "Handheld_Device/ANIM_Bomb_02.nif", false)
			time = PlayAnimationNoWait(SimAlias, "throw")
			Sleep(time)

			local fDuration = ThrowObject(SimAlias, DestAlias, "Handheld_Device/ANIM_Bomb_02.nif",0.1,"snowball",0,150,0)
			CarryObject(SimAlias, "" ,false)
			RemoveItems(SimAlias,"Granate",1)
			Sleep(fDuration)

			StartSingleShotParticle("particles/Explosion.nif", "ParticleSpawnPos",1,5)
			PlaySound3D(DestAlias,"Effects/combat_bomb_explode/combat_bomb_explode+0.wav", 1.0)
			
			if IsType(DestAlias, "Sim") then
				if Distance>500 then
					f_MoveTo(SimAlias,DestAlias,GL_MOVESPEED_RUN, 500)
				end
				StartSingleShotParticle("particles/bloodsplash.nif", "ParticleSpawnPos",1,5)	
				PlaySound3D(DestAlias,"combat/pain/Hurt_s_01.wav",1)
				ModifyFavorToSim(DestAlias,SimAlias,-50)
			elseif IsType(DestAlias, "Building") then
				if BuildingGetOwner(DestAlias,"BuildingOwner") then
					ModifyFavorToSim("BuildingOwner",SimAlias,-50)
				end
			end
			
			ModifyHP(DestAlias,-100,true)

			local victims = Find(DestAlias,"__F((Object.GetObjectsByRadius(Sim) == 30)","DestSim", -1)
			for i=0,victims-1 do
				PlaySound3D("DestSim","combat/pain/Hurt_s_01.wav",1)
				ModifyHP("DestSim",-100,true)
				ModifyFavorToSim("DestSim",SimAlias,-50)
			end

		elseif IsType(DestAlias, "Building") and GetItemCount(SimAlias, "Cannon", INVENTORY_EQUIPMENT)>0 and GetItemCount(SimAlias, "Cannonball", INVENTORY_STD)>0 then
			local time
			--GetSkillValue(SimAlias,"dex")
			GetFleePosition("", DestAlias, 3400, "DestPos")
			f_MoveTo(SimAlias,"DestPos",GL_MOVESPEED_RUN)
			
			
			

			AlignTo(SimAlias,DestAlias)
			Sleep(0.5)

			GetPosition(SimAlias,"OwnerPos")
			GetPosition(DestAlias,"TargetPos")
			GfxAttachObject("Cannon", "weapons/Cannon.nif")
			GfxSetPositionTo("Cannon", "OwnerPos")
			Sleep(2)
	
			CarryObject(SimAlias,"Handheld_Device/ANIM_torch.nif",false)
			Sleep(2)
			PlayAnimation(SimAlias,"manipulate_middle_low_r")

			StartSingleShotParticle("particles/cannonshot.nif","OwnerPos",1,4)
			local BuildingLevel = BuildingGetLevel(DestAlias)
			local side = -1
			GetPosition(DestAlias,"BuildingPos")
			local OffsetArray = {
				0,400*BuildingLevel,0,1,
				-100,400*BuildingLevel,100,1,
				100,400*BuildingLevel,-100,1,
			}
			local fDuration = ThrowObject(SimAlias, "TargetPos", "Outdoor/NewAssets/cannonball.nif",0.1, "CannonBall", OffsetArray[1]*side, OffsetArray[2], OffsetArray[3])
			RemoveItems(SimAlias,"Cannonball",1)
			PlaySound3DVariation(SimAlias,"Effects/combat_cannon_shot",1)
			Sleep(fDuration)	
			StartSingleShotParticle("particles/Explosion.nif","BuildingPos",Rand(2)+1,2)
			PlaySound3D(DestAlias,"Effects/combat_bomb_explode/combat_bomb_explode+0.wav", 1.0)

			local HP = GetHP(DestAlias) / 5
			ModifyHP(DestAlias,-HP,true)

			CarryObject("","",false)
			GfxDetachObject("Cannon")

			if BuildingGetOwner(DestAlias,"BuildingOwner") then
				ModifyFavorToSim("BuildingOwner",SimAlias,-100)
			end

			local victims = Find(DestAlias,"__F((Object.GetObjectsByRadius(Sim) == 30)","DestSim", -1)
			for i=0,victims-1 do
				PlaySound3D("DestSim","combat/pain/Hurt_s_01.wav",1)
				ModifyHP("DestSim",-100,true)
				ModifyFavorToSim("DestSim",SimAlias,-100)
			end
		end

		--if Distance>500 then
		--	f_MoveTo(SimAlias,DestAlias,GL_MOVESPEED_RUN, 500)
		--end
		if IsMounted(SimAlias) then
				Unmount(SimAlias)
		end
	end
	if AliasExists(DestAlias) then	
		if IsType(DestAlias, "Sim") then
			if IsMounted(DestAlias) then
				Unmount(DestAlias)
			end
		end
	end
end

function SimIsGuildmaster()
	if not GetSettlement("", "City") then
		return 0
	end
	if HasProperty("City","Guildhall") then
		local gh = GetProperty("City","Guildhall")
		if not GetAliasByID(gh,"Guildhouse") then
		return 0
	end	

		local Class
		if SimGetClass("")==1 then
			Class = "PatronMaster"
		elseif SimGetClass("")==2 then
			Class = "ArtisanMaster"
		elseif SimGetClass("")==3 then
			Class = "ScholarMaster"
		elseif SimGetClass("")==4 then
			Class = "ChiselerMaster"
		else
		return 0
	end
	
		if GetID("")==GetProperty("Guildhouse", Class) then
	if SimGetGender("") == 0 then
		if SimGetClass("")==1 then
			return 1
		elseif SimGetClass("")==2 then
			return 2
		elseif SimGetClass("")==3 then
			return 3
		elseif SimGetClass("")==4 then
			return 4
		end
	else
		if SimGetClass("")==1 then
			return 5
		elseif SimGetClass("")==2 then
			return 6
		elseif SimGetClass("")==3 then
			return 7
		elseif SimGetClass("")==4 then
			return 8
		end
	end
		else
			return 0
		end
	end
	
	return 0
end

function SimIsAlderman()
	if chr_GetAlderman()==GetID("") then
		if SimGetGender("") == 0 then
			return 1
		else
			return 2
		end
	else
		return 0
	end
end

function GetImpFameDynasty()
	if IsDynastySim("") and GetDynasty("", "family") then
		return chr_DynastyGetImperialFameLevel("")
	else
		return -1
	end
end

function GetImpFameSim()
	return chr_SimGetImperialFameLevel("")
end

function GetImpFameValue(SimAlias)
	if (HasProperty(SimAlias,"ImperialFame")) then
		return GetProperty(SimAlias,"ImperialFame")
	else
		return -1
	end
end

function GetFameDynasty()
	if IsDynastySim("") and GetDynasty("", "family") then
		return chr_DynastyGetFameLevel("")
	else
		return -1
	end
end

function GetFameSim()
	return chr_SimGetFameLevel("")
end

function GetFameValue(SimAlias)
	if (HasProperty(SimAlias,"Fame")) then
		return GetProperty(SimAlias,"Fame")
	else
		return -1
	end
end

function GetDatabaseIdByName(table, name)
	local id = 1
	while id<1000 do
		if (GetDatabaseValue(table, id, "name")==name) then
			break
		else
			id = id + 1
		end
	end
	return id
end

function GetTotalOfficeIncome(city)
	local citylvl = CityGetLevel(city)
	local highestlvl = CityGetHighestOfficeLevel(city)
	local officecount = 0
	local costs = 0
	local id = 1
	local OfficeNameLabel = ""
	local officelabel = ""

	for o=1,highestlvl do
		officecount = CityGetOfficeCountAtLevel(city, o)
		for i=0, officecount-1 do
			if CityGetOffice(city, o, i, "office") then
				if OfficeGetHolder("office", "holder") then
					OfficeNameLabel = OfficeGetTextLabel("office")
					local a,b = string.find(OfficeNameLabel, "_CHARACTERS_3_OFFICES_NAME_")
					officelabel = string.sub(OfficeNameLabel, b+1 , string.len(OfficeNameLabel)-3)

					id = 1
					while id<37 do
						if (GetDatabaseValue("Offices", id, "title")==officelabel) then
							costs = costs + GetDatabaseValue("Offices", id, "income")
							break
						else
							id = id + 1
						end
					end
				end
			end
		end
	end

	return costs
end

function ChangeWarRisk(Value)
	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")
	local WarRiskVal = GetProperty("WarChooser","WarRisk")
	
	WarRiskVal = WarRiskVal + Value
	
	if WarRiskVal > 100 then
		SetProperty("WarChooser","WarRisk",100)
	elseif WarRiskVal < 1 then
		SetProperty("WarChooser","WarRisk",1)
	else
		SetProperty("WarChooser","WarRisk",WarRiskVal)
	end
	
	return true	
end

function ChangeEnemyHostility(Enemy,Value)
	-- Enemy : 1 to 4
	-- Value : have to be a positive value

	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")
	local enemyHost1 = GetProperty("WarChooser","Hostility1")
	local enemyHost2 = GetProperty("WarChooser","Hostility2")
	local enemyHost3 = GetProperty("WarChooser","Hostility3")
	local enemyHost4 = GetProperty("WarChooser","Hostility4")

	local tmpVal
	local enemyRand

	if Enemy == 1 then

		tmpVal = enemyHost1 - Value
		if tmpVal < 1 then
			tmpVal = Value - enemyHost1
		end
		enemyHost1 = enemyHost1 - tmpVal
		if tmpVal > 0 then
			for x=1,tmpVal do
				enemyRand = Rand(3) + 1
				if enemyRand == 1 then
					if enemyHost2 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost2 = enemyHost2 + 1
					end
				elseif enemyRand == 2 then
					if enemyHost3 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost3 = enemyHost3 + 1
					end
				else
					if enemyHost4 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost4 = enemyHost4 + 1
					end
				end
			end
		end

	elseif Enemy == 2 then
		tmpVal = enemyHost2 - Value
		if tmpVal < 1 then
			tmpVal = Value - enemyHost2
		end
		enemyHost2 = enemyHost2 - tmpVal
		if tmpVal > 0 then
			for x=1,tmpVal do
				enemyRand = Rand(3) + 1
				if enemyRand == 1 then
					if enemyHost1 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost1 = enemyHost1 + 1
					end
				elseif enemyRand == 2 then
					if enemyHost3 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost3 = enemyHost3 + 1
					end
				else
					if enemyHost4 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost4 = enemyHost4 + 1
					end
				end
			end
		end

	elseif Enemy == 3 then
		tmpVal = enemyHost3 - Value
		if tmpVal < 1 then
			tmpVal = Value - enemyHost3
		end
		enemyHost3 = enemyHost3 - tmpVal
		if tmpVal > 0 then
			for x=1,tmpVal do
				enemyRand = Rand(3) + 1
				if enemyRand == 1 then
					if enemyHost1 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost1 = enemyHost1 + 1
					end
				elseif enemyRand == 2 then
					if enemyHost2 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost2 = enemyHost2 + 1
					end
				else
					if enemyHost4 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost4 = enemyHost4 + 1
					end
				end
			end
		end

	elseif Enemy == 4 then
		tmpVal = enemyHost4 - Value
		if tmpVal < 1 then
			tmpVal = Value - enemyHost4
		end
		enemyHost4 = enemyHost4 - tmpVal
		if tmpVal > 0 then
			for x=1,tmpVal do
				enemyRand = Rand(3) + 1
				if enemyRand == 1 then
					if enemyHost1 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost1 = enemyHost1 + 1
					end
				elseif enemyRand == 2 then
					if enemyHost2 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost2 = enemyHost2 + 1
					end
				else
					if enemyHost3 > 96 then
						tmpVal = tmpVal + 1
					else
						enemyHost3 = enemyHost3 + 1
					end
				end
			end
		end
	end

	SetProperty("WarChooser","Hostility1",enemyHost1)
	SetProperty("WarChooser","Hostility2",enemyHost2)
	SetProperty("WarChooser","Hostility3",enemyHost3)
	SetProperty("WarChooser","Hostility4",enemyHost4)
		
	return true	
end

function GetEnemyHostilityLevel(Enemy)
	-- Enemy : 1 to 4

	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")

	local enemyHost
	if Enemy == 1 then
		enemyHost = GetProperty("WarChooser","Hostility1")
	elseif Enemy == 2 then
		enemyHost = GetProperty("WarChooser","Hostility2")
	elseif Enemy == 3 then
		enemyHost = GetProperty("WarChooser","Hostility3")
	else
		enemyHost = GetProperty("WarChooser","Hostility4")
	end
		
	if enemyHost < 3 then
		return 0
	elseif enemyHost < 10 then
		return 1
	elseif enemyHost < 20 then
		return 2
	elseif enemyHost < 40 then
		return 3
	elseif enemyHost < 75 then
		return 4
	else
		return 5
	end

	return 0

end

function GetWarRiskLevel()
	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")

	local risk = GetProperty("WarChooser","WarRisk")
		
	if risk < 5 then
		return 0
	elseif risk < 15 then
		return 1
	elseif risk < 30 then
		return 2
	elseif risk < 60 then
		return 3
	elseif risk < 85 then
		return 4
	else
		return 5
	end

	return 0

end

function CheckDistance(Sim,Victim)
	local Dist = 0
	local MaxDist = 5000

	Dist = GetDistance(Sim, Victim)
	if Dist < MaxDist then
		return 1
	end
	return 0	
end

function GetMaxFavByDiffForAttack()
	local Difficulty = ScenarioGetDifficulty()

	if Difficulty == 0 then
		return 60
	elseif Difficulty == 1 then
		return 55
	elseif Difficulty == 2 then
		return 45
	elseif Difficulty == 3 then
		return 35
	else
		return 30
	end
end

function BlockMusicForConcert(force)
	SetData("#BlockMusicForConcert",force)
	if force==1 then
		StartHighPriorMusic(48, true)
	end
end

function StartHighPriorMusic(event, val)
	if GetData("#BlockMusicForConcert")==nil or GetData("#BlockMusicForConcert")==0 then
		if val then
			StartHighPriorMusic(event, val)
		else
			StartHighPriorMusic(event)
		end
	end
end

function CheckPublicBuilding(city,building)
	-- return {building level in this city, building level in next city level}

	if not AliasExists(city) then
		return {0, 0}
	else
		local Level = CityGetLevel(city)
		if building==GL_BUILDING_TYPE_BANK then
			if Level==1 then
				return {0, 0}
			elseif Level==2 then
				return {0, 1}
			elseif Level==3 then
				return {1, 2}
			elseif Level==4 then
				return {2, 2}
			elseif Level==5 then
				return {2, 2}
			elseif Level==6 then
				return {2, 2}
			end
		elseif building==GL_BUILDING_TYPE_SCHOOL or building==GL_BUILDING_TYPE_SOLDIERPLACE then
			if Level==1 then
				return {0, 0}
			elseif Level==2 then
				return {0, 0}
			elseif Level==3 then
				return {0, 1}
			elseif Level==4 then
				return {1, 2}
			elseif Level==5 then
				return {2, 2}
			elseif Level==6 then
				return {2, 2}
			end
		end
	end
	return {0, 0}
end

function GetCityUpgradeCost(curLvl)
	if curLvl==2 then
		return 5000
	elseif curLvl==3 then
		return 15000
	elseif curLvl==4 then
		return 35000
	elseif curLvl==5 then
		return 100000
	elseif curLvl==6 then
		return 0
	end
end

function CheckMoneyForTreatment(SimAlias)

	if IsPartyMember(SimAlias)==false then
		return 1
	end

	local Costs = 0
	if GetImpactValue(SimAlias,"Sprain")==1 then
		Costs = diseases_GetTreatmentCost("Sprain")
	elseif GetImpactValue(SimAlias,"Cold")==1 then
		Costs = diseases_GetTreatmentCost("Cold")
	elseif GetImpactValue(SimAlias,"Influenza")==1 then
		Costs = diseases_GetTreatmentCost("Influenza")
	elseif GetImpactValue(SimAlias,"BurnWound")==1 then
		Costs = diseases_GetTreatmentCost("BurnWound")
	elseif GetImpactValue(SimAlias,"Pox")==1 then
		Costs = diseases_GetTreatmentCost("Pox")
	elseif GetImpactValue(SimAlias,"Pneumonia")==1 then
		Costs = diseases_GetTreatmentCost("Pneumonia")
	elseif GetImpactValue(SimAlias,"Blackdeath")==1 then
		Costs = diseases_GetTreatmentCost("Blackdeath")
	elseif GetImpactValue(SimAlias,"Fracture")==1 then
		Costs = diseases_GetTreatmentCost("Fracture")
	elseif GetImpactValue(SimAlias,"Caries")==1 then
		Costs = diseases_GetTreatmentCost("Caries")
	elseif GetHPRelative(SimAlias) < 0.99 then
		Costs = GetMaxHP(SimAlias)-GetHP(SimAlias)
	else
		return 0
	end
		
	local Money = GetMoney(SimAlias)
	if Costs > Money then
		return 0
	else
		return 1
	end
end

function CheckImperialOfficer()
	local currentRound = GetRound()
	if currentRound > -1 then

		local currentGameTime = math.mod(GetGametime(),24)
		if (currentGameTime == 13) or ((currentGameTime > 13) and (currentGameTime < 14)) then

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
						if not SimGetOfficeLevel("Sim")==7 then
							local num = 0
							while num<100 do
								if chr_SimGetImperialFameLevel("Sim")>1 and chr_DynastyGetImperialFameLevel("Sim")>0 then
									if SimArray[num]==GetID("Sim") then
										break
									elseif SimArray[num]==nil then
										SimArray[num] = GetID("Sim")
										SimFameArray[num] = chr_SimGetImperialFame("Sim") + math.floor(chr_DynastyGetImperialFame("Sim")/10)
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

			local ImperialWinner
			local ImperialFame = -1
			if SimArrayCount>0 then
				for x=0,SimArrayCount do
					if SimFameArray[x]~=nil and SimFameArray[x]>ImperialFame then
						ImperialFame = SimFameArray[x]
						ImperialWinner = x
					end
				end
				
				local oldimperialofficer = chr_GetImperialOfficer()
				if oldimperialofficer>0 then
					GetAliasByID(oldimperialofficer,"Old")
					RemoveProperty("Old", "ImperialOfficer")
				end						
				SetData("#ImperialOfficer",0)
				if GetAliasByID(SimArray[ImperialWinner],"New") then
					SetProperty("New","ImperialOfficer",1)
					SetData("#ImperialOfficer",SimArray[ImperialWinner])

					local label = "@L_IMPERIAL_OFFICER"
					local gender = ""

					if SimGetGender("New")==GL_GENDER_MALE then
						label = label.."_MALE_+1"
						gender = gender.."MALE"
					else
						label = label.."_FEMALE_+1"
						gender = gender.."MALE"
					end

					GetScenario("scenario")
					local mapid = GetProperty("scenario", "mapid")
					local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+0"

					GetSettlement("New", "settlement")
					famelevelsim = "@L_IMPERIAL_FAME_SIM_+"..chr_SimGetImperialFameLevel("New")
					fameleveldyn = "@L_IMPERIAL_FAME_DYNASTY_+"..chr_DynastyGetImperialFameLevel("New")

					MsgNewsNoWait("All","New","","politics",-1,
							"@L_IMPERIAL_OFFICER_"..gender.."_+0",
							"@L_CHECKIMPERIALOFFICER_BODY_+0",
							GetYear(), GetID("New"), GetID("settlement"), label, famelevelsim, chr_SimGetImperialFame("New"), fameleveldyn, chr_DynastyGetImperialFame("New"), lordlabel)

				end
			else
				SetData("#ImperialOfficer",0)
			end
		end
	end
end

function checkBuildingNoRoom(building)
-- checks if the building is of a type which has no room
	if (BuildingGetType(building)==GL_BUILDING_TYPE_FARM) or (BuildingGetType(building)==GL_BUILDING_TYPE_ROBBER) or
			(BuildingGetType(building)==GL_BUILDING_TYPE_MINE) or (BuildingGetType(building)==GL_BUILDING_TYPE_RANGERHUT) or
			(BuildingGetType(building)==GL_BUILDING_TYPE_CASTLE) or (BuildingGetType(building)==GL_BUILDING_TYPE_TOWER) or
			(BuildingGetType(building)==GL_BUILDING_TYPE_MERCENARY) or
			(BuildingGetType(building)==102) or (BuildingGetType(building)==35) or (BuildingGetType(building)==38) or
			(BuildingGetType(building)==GL_BUILDING_TYPE_MILL) or (BuildingGetType(building)==GL_BUILDING_TYPE_FRUITFARM) then
		return 1
	else
		return 0
	end
end