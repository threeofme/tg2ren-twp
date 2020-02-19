function Init()
	log_death("", "Player is dead (state_dead).")
	log_death("", "Was executing measure " .. (GetCurrentMeasureName("") or "none"))

	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_upgrades")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_charge")
	SetStateImpact("no_arrestable")
	SetStateImpact("no_enter")
	SetStateImpact("no_enter_camera")
	SetStateImpact("no_action")
	SetStateImpact("no_cancel_button")

	SetState("", STATE_FIGHTING, false)
	SetState("", STATE_HIJACKED, false)
	SetState("", STATE_CAPTURED, false)
	SetState("", STATE_IMPRISONED, false)
	SetState("", STATE_WORKING, false)
	SetState("", STATE_SICK, false)
	if GetState("", STATE_ROBBERGUARD) then
		SetState("", STATE_ROBBERGUARD, false)
	end
 
	StopMeasure()
end

function Run()

	----------------------
	------ Sim die -------
	----------------------
	MoveStop("")
	if IsType("", "Sim") then

		if SquadGet("", "Squad") then
			if SquadGetLeaderId("Squad") == GetID("") then
				SquadDestroy("Squad")
			end
		end

		-- Let the sim play the die animation in case he is not already unconscious
		if not (GetState("", STATE_UNCONSCIOUS)) then
			if not (HasProperty("", "SenilDecay") or HasProperty("","Executed")) then
				PlayAnimation("", "fight_die")
				if HasProperty("","WasSick") then
					PlayAnimation("","die_sick_idle_in")
					PlayAnimation("","die_sick_idle_loop")
					Sleep(1)
					PlayAnimation("","die_sick_idle_loop")
					Sleep(1)
				end
			end
			if HasProperty("","Executed") then
				MoveSetActivity("","")
			end
		end
		
		-- decrement sicksimcounter if some sick sim dies
		if GetSettlement("","City") then
			if GetImpactValue("","Sprain")==1 then
				chr_decrementInfectionCount("SprainInfected", "City")
			elseif GetImpactValue("","Cold")==1 then
				chr_decrementInfectionCount("ColdInfected", "City")
			elseif GetImpactValue("","Influenza")==1 then
				chr_decrementInfectionCount("InfluenzaInfected", "City")
			elseif GetImpactValue("","BurnWound")==1 then
				chr_decrementInfectionCount("BurnWoundInfected", "City")
			elseif GetImpactValue("","Pox")==1 then
				chr_decrementInfectionCount("PoxInfected", "City")
			elseif GetImpactValue("","Pneumonia")==1 then
				chr_decrementInfectionCount("PneumoniaInfected", "City")
			elseif GetImpactValue("","Blackdeath")==1 then
				chr_decrementInfectionCount("BlackdeathInfected", "City")
			elseif GetImpactValue("","Fracture")==1 then
				chr_decrementInfectionCount("FractureInfected", "City")
			elseif GetImpactValue("","Caries")==1 then
				chr_decrementInfectionCount("CariesInfected", "City")
			end
		end
		
		-- Let the sim lay on the ground or in his bed for a while
		-- local SleepTime = Gametime2Realtime(GL_TIME_LYING_DEAD_ON_THE_GROUND)
	
		Sleep(10)

		---------------------
		------ Lay out ------
		---------------------  
        
		if HasProperty("", "WasDynastySim") then

			-- Indicates if a sim of the local player dynasty is dead
			local IsFuneralOfMyDynasty = 0

			-- Fire messages (differ between player and other dynasties)
			GetLocalPlayerDynasty("LocalPlayerDyn")

			local Age = SimGetAge("")
			local SettlementId = GetSettlementID("")			
			GetSettlement("", "DeadSimsSettlement")
			local Gender = SimGetGender("")
			local DynastyID = GetID("dynasty")
	
			if DynastyID == GetID("LocalPlayerDyn") then
				IsFuneralOfMyDynasty = 1
				if Gender == GL_GENDER_MALE then
					feedback_MessageCharacter("", "@L_FAMILY_6_DEATH_MSG_DEAD_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_OWNER_BODY_MALE", GetID(""), Age, SettlementId)
				else
					feedback_MessageCharacter("", "@L_FAMILY_6_DEATH_MSG_DEAD_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_OWNER_BODY_FEMALE", GetID(""), Age, SettlementId)
				end
			else
				feedback_MessageCharacter("All", "@L_FAMILY_6_DEATH_MSG_DEAD_OTHER_DYNASTIES_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_OTHER_DYNASTIES_BODY", GetID(""))
			end

			if (SimGetOfficeID("") ~= -1) then
				GetHomeBuilding("","home")
				BuildingGetCity("home","homecity")				
				CityRemoveFromOffice("homecity","")
			end
			
			-- Spawn the priest at the graveyard
			local MaxTries=10
			while MaxTries > 0 do
				GetHomeBuilding("","home")
				BuildingGetCity("home","homecity")
				if CityGetRandomBuilding("homecity",-1,GL_BUILDING_TYPE_GRAVEYARD, -1, -1, FILTER_IGNORE,"graveyard") then
					if not BuildingGetNPC("graveyard", 9, "Undertaker") then
						Assert(false, "state_dead - no undertake found in the graveyard")
					end
						
					if not HasProperty("Undertaker","DeadBody") then
						SetData("Priest",1)
						SetProperty("Undertaker","DeadBody",GetID(""))

						-- Let the priest go to the dead sim
						if SimIsInside("") then
							GetInsideBuilding("", "DeadHouse")
							f_MoveTo("Undertaker", "DeadHouse", GL_MOVESPEED_RUN)
							if GetLocatorByName("Home", "Priest", "Priest") then
								f_BeginUseLocator("Undertaker", "Priest", GL_STANCE_STAND, true)
								f_EndUseLocator("Undertaker","Priest",GL_STANCE_STAND)
							end
						else
							if GetPosition("", "SimPos") then
								f_MoveTo("Undertaker", "SimPos", GL_MOVESPEED_RUN, 80)
								AlignTo("Undertaker", "")
							end
						end

						if HasProperty("", "SenilDecay") then
							MsgSayNoWait("Undertaker", "@L_FAMILY_6_DEATH_ANOINTING")
							PlayAnimation("Undertaker", "manipulate_middle_twohand")
						else
							MoveSetStance("Undertaker", GL_STANCE_KNEEL)
							-- Give the priest some time to kneel down
							Sleep(4)
							SetData("PriestKneeing", 1)
							MsgSay("Undertaker", "@L_FAMILY_6_DEATH_ANOINTING")

							Sleep(2)
							SimResetBehavior("Undertaker")
						end
					
						GfxMoveToPosition("", 0, -50, 0, 6, false)					
						return
						
					end
				else
					GfxMoveToPosition("", 0, -50, 0, 6, false)
					return
				end
				Sleep(5)
				MaxTries = MaxTries - 1
			end
		else
			GfxMoveToPosition("", 0, -50, 0, 6, false)
			return
		end
	---------------------------
	------ Building die -------
	---------------------------
	elseif IsType("", "Building") then

		InternalDie("")

		BuildingSetForSale("", false)
		SetState("", STATE_BURNING, false)
		SetState("", STATE_MONITORDAMAGE, false)
		SetState("", STATE_REPAIRING, false)
		SetState("", STATE_CONTAMINATED, false)
		SetState("", STATE_BUILDING, false)
		SetState("", STATE_MOVING_BUILDING, false)
		SetState("", STATE_SELLFLAG, false)
		
		if GetImpactValue("","Scouted")>0 then
			RemoveImpact("","Scouted")
		end
		
		if BuildingGetClass("")==6 then		--resource 
			SetState("",STATE_DEAD,false)
			return
		end

		Evacuate("")

		if not ((GetRound()==0) and (math.mod(GetGametime(),24)<8)) then
			-- add particles
		 	PlaySound3D("","measures/76_TearDownBuilding+0.wav", 1.0)
		 	GetPosition("", "ParticleSpawnPos")
		 	PlaySound3D("Owner","fire/Explosion_s_04.wav",0.9)
			StartSingleShotParticle("particles/smoketrail2.nif", "ParticleSpawnPos",2.5,3)
			StartSingleShotParticle("particles/wreckage.nif", "ParticleSpawnPos",2,3)
		 	StartSingleShotParticle("particles/big_crash.nif", "ParticleSpawnPos",4,20)
	
			--initiate
			local i = 1
			local Locatorcount
			local WreckageType
			local WreckageCount
			local LocatorType = "Bomb"
			local ParticleCount
			local SmokeCount = 0
			local RotateValue
	
	
			--go through all types of locators
			for i=1,3 do
				if (i==1) then
					LocatorType = "Bomb"
				elseif (i==2) then
					LocatorType = "Fire"
				elseif (i==3) then
					LocatorType = "Entry"
				end
				LocatorCount = 1
				while GetLocatorByName("Owner", LocatorType..LocatorCount, LocatorType.."Locator"..LocatorCount) do
					LocatorCount = LocatorCount + 1
				end
	
	
				--run through all locators of one type
				WreckageCount = LocatorCount-1
				while(WreckageCount > 0) do
	
					WreckageValue = Rand(4)
					if (WreckageValue == 0) then
						WreckageType = "buildings/Building_Ruins/Ruin_1.nif"
					elseif (WreckageValue == 1) then
						WreckageType = "buildings/Building_Ruins/Ruin_2.nif"
					elseif (WreckageValue == 2) then
						WreckageType = "buildings/Building_Ruins/Ruin_3.nif"
					elseif (WreckageValue == 3) then
						WreckageType = "buildings/Building_Ruins/Ruin_4.nif"
					end
	
					--create the wreckage, size and position them
					RotateValue = Rand(359)
					GfxAttachObject(LocatorType.."Truemmer"..WreckageCount, WreckageType)
					GfxScale(LocatorType.."Truemmer"..WreckageCount,0.8)
					GfxRotateNoWait(LocatorType.."Truemmer"..WreckageCount, 0, RotateValue, 0, 360)
					GfxSetPositionTo(LocatorType.."Truemmer"..WreckageCount, LocatorType.."Locator"..WreckageCount)
					GfxDropToFloor(LocatorType.."Truemmer"..WreckageCount)
					WreckageCount = WreckageCount -1
					if (LocatorType == "Fire") then
						SmokeCount = SmokeCount +1
					end
	
				end
			end
	
			--start another nice particle smoke
			ParticleCount = 1
			LocatorType = "Fire"
	
			while (ParticleCount < SmokeCount) do
				GetPosition(LocatorType.."Truemmer"..ParticleCount,"ParticleSpawnPos"..ParticleCount)
		 		GfxStartParticle("BigSmoke"..ParticleCount, "particles/smoke_light.nif", "ParticleSpawnPos"..ParticleCount, 3)
		 		ParticleCount = ParticleCount + 1
		 	end
	
	
			-- pull the building under the ground
			-- needed fixed value to avoid possible async form GfxGetHeight
			Height = 2500		--GfxGetHeight("")
			Duration = Height/100
			GfxMoveToPositionNoWait("", 0, -Height, 0, Duration, false)
			Sleep(45)
	
			--remove particles
			while (ParticleCount > 0) do
				GfxStopParticle("BigSmoke"..ParticleCount)
				ParticleCount = ParticleCount -1
			end
	
			--remove wreckage
			i = 1
			for i=1, 3 do
				if (i==1) then
					LocatorType = "Bomb"
				elseif (i==2) then
					LocatorType = "Fire"
				elseif (i==3) then
					LocatorType = "Entry"
				end
	
				WreckageCount = 1
				while AliasExists(LocatorType.."Truemmer"..WreckageCount,"Result"..WreckageCount) do
					GfxMoveToPosition(LocatorType.."Truemmer"..WreckageCount, 0, -300, 0, 10, false)
					WreckageCount = WreckageCount +1
				end			
			end
		end

	---------------------------
	------ Ship die -------
	---------------------------
	elseif IsType("", "Ship") then
		 
		SetState("", STATE_MONITORDAMAGE, false)
		SetState("", STATE_REPAIRING, false)
		
		if HasProperty("","CityShip") then
			GetHomeBuilding("","MyHarbor")
			local NumShipsHarbor = GetProperty("MyHarbor","ShipCount")
			SetProperty("MyHarbor","ShipCount",NumShipsHarbor-1)
			local MainPlunderCount = GetProperty("MyHarbor","Plundered")
			MainPlunderCount = MainPlunderCount + 2
			SetProperty("MyHarbor","Plundered",MainPlunderCount)
		end
		
		local ShipType = CartGetType("")
		local ShipSize = "Small"
		local Platz
		if ShipType == EN_CT_MERCHANTMAN_SMALL then
			ShipSize = "Medium"
			Platz = 2
		elseif ShipType == EN_CT_MERCHANTMAN_BIG then
			ShipSize = "Big"
			Platz = 5
		elseif ShipType == EN_CT_CORSAIR then
			ShipSize = "Big"
			Platz = 4
		elseif ShipType == EN_CT_WARSHIP then
			ShipSize = "Big"
			Platz = 6
		elseif ShipType == EN_CT_FISHERBOOT then
			ShipSize = "Small"
		end
	
		GetPosition("","ShipPos")
		local rotation = (ObjectGetRotationY("") / 360) * (2 * math.pi)		

		InternalDie("")
		
		-- pull the ship under the ground
		SetInvisible("", true) 
		Height = GfxGetHeight("")+500
		Duration = Height/100 
		
		
		local OffsetArray = 	{150,60,200,1,
					170,60,100,1,
					190,60,0,1,
					170,60,-100,1,
					150,60,-200,1
					}
		
		local EndTime = GetGametime() + 0.15
		
		local tx,ty,tz = PositionGetVector("ShipPos")
		
		
		GfxMoveToPositionNoWait("", 0, -Height, 0, Duration, false)
		
		PlaySound3DVariation("","ship/ShipDrown/"..ShipSize,1)
		
			
			
		while GetGametime() < EndTime do
			local Gun = Rand(5)
			local side = Rand(10)
			if side < 4 then
				side = 1 
			else
				side = -1
			end
			local nx = (OffsetArray[(Gun*4)+1]*side) * math.cos(rotation) + OffsetArray[(Gun*4)+3] * math.sin(rotation)
			local ny = ty - 100
			local nz = OffsetArray[(Gun*4)+3] * math.cos(rotation) - (OffsetArray[(Gun*4)+1]*side) * math.sin(rotation)
			nx = nx + tx + (Rand(200)-100)
			nz = nz + tz + (Rand(200)-100)		
			PositionSetVector("ShipPos",nx,ny,nz)
			OffsetArray[(Gun*4)+4] = 0
			
			GfxStartParticle("ParticleSpawn","particles/water_splash.nif","ShipPos",Rand(4)+1)
			Sleep(0.3)
			GfxStopParticle("ParticleSpawn")
		end
				
	end

end

function CleanUp()	
	-- remove the object from the world
	if not IsType("", "Sim") then
		InternalRemove("")
		return
	end


	-- Get rid of the priest
	if HasData("Priest") then
		if HasData("PriestKneeing") then
			MoveSetStance("Undertaker", GL_STANCE_STAND)
		end
	end
	
	if GetState("", STATE_DUEL) then
		SetState("", STATE_DUEL, false)
	end

	-- Now let the sim rest in peace ...
	InternalDie("")

	-- Remove the sim from the world
	InternalRemove("")

end

