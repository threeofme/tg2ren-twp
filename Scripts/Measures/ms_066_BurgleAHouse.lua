-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_066_BurgleAHouse"
----
----	with this measure, the player can send a thief, to burgle a building
----
-------------------------------------------------------------------------------

-- changed: reduced duration to 400 from 500, and added a 100 gold amount of base earning on each successful burglary

function Run()

	if not BuildingGetOwner("Destination","BOwner") then
		MsgQuick("", "@L_THIEF_066_BURGLEAHOUSE_FAILURES_+3", GetID("Destination"))
		StopMeasure()
	end

	--timeout before building can be burgled again
	local TimeOut = 24
	local OwnerID = GetID("dynasty")

	-- Get the Owner of the Building
	if not BuildingGetOwner("Destination", "Victim") then
		--no owner found, workers hut is target
		CopyAlias("Destination","Victim")
	end
	
	-- Get my working place
	if not SimGetWorkingPlace("","MyThievesGuild") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_THIEF)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"MyThievesGuild")
		else
			StopMeasure()
		end
	end
	
	-- Combine the Thief Property by ThievesGuild ID and Destination ID
	local DestID = GetID("Destination")
	local ThiefProperty = "Thief"..OwnerID.."on"..DestID
	SetData("ThiefProperty",ThiefProperty)
	
	-- Set the Property
	SetProperty("",ThiefProperty,1)
	
	-- die measure darf/sollte nicht restarten, da nach einem erwischt/entdeckt werden ansonsten die Measure immer wieder neu
	-- aufgerufen werden würde, was zu vielen Beweisen führen würde
	MeasureSetNotRestartable()
	
	--check if building has been burgled 12 hours ago
	if GetImpactValue("Destination","buildingburgledtoday")~=0 then
		MsgQuick("", "@L_THIEF_066_BURGLEAHOUSE_FAILURES_+0", GetID("Destination"))
		StopMeasure()
	end	
	
	--the money the thief steals
	local Value = 1
	-- added some base earning from burglary (that money is spawned)
	local ValueBonus = 200+Rand(200)
	
	-- if the building was scouted before you gain some bonus
	local OwnerDyn = GetDynastyID("")
	local IsScouted = HasProperty("Destination","ScoutedBy"..OwnerDyn)
	if IsScouted then
		ValueBonus = math.floor(ValueBonus * 1.5)
	end
	
	Value = ms_066_burgleahouse_GetMaxHaulValue("Destination", GetID("dynasty"), SimGetLevel(""))
	
	-- Try to block and move to the locator
	if GetFreeLocatorByName("Destination", "Bomb", 1, 3, "SabotagePosition") then
		if not f_BeginUseLocator("", "SabotagePosition", GL_STANCE_STAND, true) then
			if GetOutdoorMovePosition("","Destination","SabotagePosition") then
				if not f_MoveTo("","SabotagePosition", GL_MOVESPEED_RUN) then
					MsgQuick("","@L_THIEF_066_BURGLEAHOUSE_FAILURES_+2",GetID("Destination"))
					StopMeasure()
				end
			else
				MsgQuick("","@L_THIEF_066_BURGLEAHOUSE_FAILURES_+2",GetID("Destination"))
				StopMeasure()
			end
		end
	else
		if GetOutdoorMovePosition("","Destination","SabotagePosition") then
			if not f_MoveTo("","SabotagePosition", GL_MOVESPEED_RUN) then
				MsgQuick("","@L_THIEF_066_BURGLEAHOUSE_FAILURES_+2",GetID("Destination"))
				MsgMeasure("","")
				StopMeasure()
			end				
		else
			MsgQuick("","@L_THIEF_066_BURGLEAHOUSE_FAILURES_+2",GetID("Destination"))
			StopMeasure()
		end
	end
	
	SetData("ReleaseLocator", 1)

	-- Check if the building still exists
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	

	--add the BurgleTime Property to the Destination Building
	local ProtectionValue = GetImpactValue("Destination","ProtectionOfBurglary")
	local TimeToBurgle = 120 * (1+ ProtectionValue/100) + 120
	
	if not HasProperty("Destination","TimeToBurgle"..GetID("dynasty")) then
		SetProperty("Destination","TimeToBurgle"..GetID("dynasty"),0)
	end
	
	--get the burgle skill , dexterity skill of the thief
	local Skill = GetSkillValue("", DEXTERITY)*10			-- from 40 to 100
	local SpeedupTime = GetImpactValue("", 43) / 100	-- 43 = BurglarySpeedup  --0.25 wenn aktiv
	if SpeedupTime > 0 then
		Skill = Skill + (Skill*SpeedupTime)
	end
	if IsScouted then
		Skill = math.floor(Skill * 1.3)
	end
		
	--start the action
	if BuildingGetOwner("Destination","BOwner") then
		CommitAction("burgleahouse", "", "Destination", "Destination")
	else
		if BuildingGetSim("Destination",0,"DummyOwner") then
			CommitAction("burgleahouse", "", "DummyOwner", "Destination")
		end
	end
	
	-- do some animation stuff while trying to get into the house
	AlignTo("","Destination")
	Sleep(0.7)
	
	--do he progress bar stuff
	SetProcessMaxProgress("",TimeToBurgle)
	SetProcessProgress("",0)
	
	--hide the thief
	SetState("",STATE_HIDDEN,true)
	
	while GetProperty("Destination","TimeToBurgle"..GetID("dynasty")) < TimeToBurgle do
		local NewValue = GetProperty("Destination","TimeToBurgle"..GetID("dynasty")) + Skill
		SetProperty("Destination","TimeToBurgle"..GetID("dynasty"),NewValue)
		SetProcessProgress("",NewValue)
		if not AliasExists("Destination") then
			StopMeasure()
		end
		local AnimTime = PlayAnimationNoWait("", "burgle")
		Sleep(1)
		CarryObject("","Handheld_Device/Anim_Crowbar.nif",false)
		Sleep(AnimTime-2)
		CarryObject("","",false)
		Sleep(2)
		if GetImpactValue("Destination","BoobyTrap")~=0 then
			RemoveImpact("Destination","BoobyTrap")
			GetPosition("","ParticleSpawnPos")
			PlaySound3D("","fire/Explosion_01.wav", 1.0)
			StartSingleShotParticle("particles/Explosion.nif", "ParticleSpawnPos", 1,5)
			ModifyHP("",-(GetMaxHP("")),true)
			if GetImpactValue("Destination","buildingburgledtoday")==0 then
				AddImpact("Destination","buildingburgledtoday",1,6)
			end
			CommitAction("explosion", "", "Destination", "Destination")
			StopMeasure()
		end
	end
	ResetProcessProgress("")
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	--save the haul amount
	if not HasProperty("Destination","NumThieves"..OwnerID) then
		SetProperty("Destination","NumThieves"..OwnerID,1)
	end
	--local LocatorName = GetName("SabotagePosition")
	if GetProperty("Destination","NumThieves"..OwnerID)==1 then
		SetProperty("Destination","Thief1Haul"..OwnerID,Value)
		SetProperty("Destination","NumThieves"..OwnerID,GetProperty("Destination","NumThieves"..OwnerID)+1)
	elseif GetProperty("Destination","NumThieves"..OwnerID)==2 then
		SetProperty("Destination","Thief2Haul"..OwnerID,Value)
		SetProperty("Destination","NumThieves"..OwnerID,GetProperty("Destination","NumThieves"..OwnerID)+1)
	elseif GetProperty("Destination","NumThieves"..OwnerID)==3 then
		SetProperty("Destination","Thief3Haul"..OwnerID,Value)
		SetProperty("Destination","NumThieves"..OwnerID,GetProperty("Destination","NumThieves"..OwnerID)+1)
	else
		--something went wrong
		MsgDebugMeasure("too many Bomb Locators found")
		StopMeasure()
	end
	
	--add the impact, the first thief
	if GetImpactValue("Destination","buildingburgledtoday")==0 then
		--set the impact
		AddImpact("Destination","buildingburgledtoday",1,TimeOut)
		SetProperty("","Bandleader",1)
		SetProperty("","ThiefReady",1)
		StopAction("burgleahouse", "")
		--if there is haul, take it
		if(Value > 0) then
			
			ModifyHP("Destination",-(GetMaxHP("Destination")*0.05),false,10)
			
			local VicMoney = GetMoney("Victim")
			if VicMoney > (Value + ValueBonus) then
				f_SpendMoney("Destination", (Value + ValueBonus), "CostThiefs")
				chr_RecieveMoney("Owner",(Value + ValueBonus), "IncomeThiefs")
				mission_ScoreCrime("", (Value + ValueBonus))
			elseif VicMoney > 0 then
				f_SpendMoney("Destination", VicMoney, "CostThiefs")
				chr_RecieveMoney("Owner", VicMoney, "IncomeThiefs")
				mission_ScoreCrime("", VicMoney)
			else
				chr_RecieveMoney("Owner", ValueBonus, "IncomeThiefs")
				mission_ScoreCrime("", ValueBonus)
			end

			--Plunder("", "Destination",10)			
		end
		
		--wait until the other thieves are ready
		while true do
			local Radius = 2000
			local count
			local i = 0
			
			--check how many thieves has stolen something
			local NumThieves = 0
			local k = 1
			for k=1,3 do
				if HasProperty("Destination","Thief"..k.."Haul"..OwnerID) then 
					NumThieves = NumThieves + 1
				end
			end
			
			--look how many thieves of the own dynasty are trying to burgle this building
			local Filter = "__F((Object.GetObjectsByRadius(Sim) == "..Radius..") AND (Object.Property."..ThiefProperty.."==1) AND NOT(Object.Property.Bandleader ==1))"
			count = Find("Owner", Filter,"Thief", -1)
			
			--owner must be the only thief
			if count == 0 then
				NumThieves = 0
			--there are other thieves here
			else
				--check if all present thieves have stolen something
				NumThieves = NumThieves - (count +1)
				
				for i=0,count-1 do
					if HasProperty("Thief"..i,"ThiefReady") then	
						RemoveProperty("Thief"..i,"ThiefReady")
						SetProperty("Thief"..i,"ThiefWaiting",1)
					elseif HasProperty("Thief"..i,"ThiefWaiting") then
						
					end
				end
			end
			
			--if all thieves have finished their "work"
			if NumThieves == 0 then
				
				count = Find("Owner", Filter,"Thief", -1)
				if count > 0 then
					for i=0,count-1 do
						if HasProperty("Thief"..i,"ThiefWaiting") then
							SetProperty("Thief"..i,"ThiefGoHome",1)
							
						end				
					end
				end
				SetProperty("","ThiefGoHome",1)
				break
			end
			PlayAnimation("","watch_for_guard")	
		end
	--the other thieves
	else
		--debug
		--MsgSay("","Ich auch!")
		if not HasProperty("","ThiefReady") then
			StopAction("burgleahouse", "")
			if(Value > 0) then
				Value = Value/2
				ValueBonus = ValueBonus/2
				local VicMoney = GetMoney("Victim")
				if VicMoney > (Value + ValueBonus) then
					f_SpendMoney("Destination", Value + ValueBonus, "CostThiefs")
					chr_RecieveMoney("Owner", Value + ValueBonus, "IncomeThiefs")
					mission_ScoreCrime("", Value + ValueBonus)
				elseif VicMoney > 0 then
					f_SpendMoney("Destination", VicMoney, "CostThiefs")
					chr_RecieveMoney("Owner", VicMoney, "IncomeThiefs")
					mission_ScoreCrime("", VicMoney)
				end
	
				--Plunder("", "Destination",10)			
			end
			SetProperty("","ThiefReady",1)
		end
	end
	
	--wait until all thieves have finished
	while not HasProperty("","ThiefGoHome") do
		PlayAnimation("","watch_for_guard")
	end
	
	if HasProperty("","Bandleader") then
		RemoveProperty("","Bandleader")
		if not IsGUIDriven() then
			local DynID = GetDynastyID("")
			RemoveProperty("Destination","AIScouted"..DynID)
		end
		
		--determine money stolen
		local HaulBonus = 0
		local Haul = 0
		for i=1,3 do
			if HasProperty("Destination","Thief"..i.."Haul"..OwnerID) then
				Haul = Haul + GetProperty("Destination","Thief"..i.."Haul"..OwnerID)
				HaulBonus = HaulBonus + ValueBonus
				RemoveProperty("Destination","Thief"..i.."Haul"..OwnerID)
			end
		end
		
		local OwnerDyn = GetDynastyID("")
		if HasProperty("Destination","ScoutedBy"..OwnerDyn) then
			RemoveProperty("Destination","ScoutedBy"..OwnerDyn)
			RemoveProperty("Destination","ScoutedProt"..OwnerDyn)
			RemoveProperty("Destination","ScoutedLoot"..OwnerDyn)
			RemoveImpact("Destination", "Scouted")
		end
		
		feedback_MessageCharacter("Owner",
			"@L_THIEF_066_BURGLEAHOUSE_MSG_ACTOR_SUCCESS_HEAD_+0",
			"@L_THIEF_066_BURGLEAHOUSE_MSG_ACTOR_SUCCESS_BODY_+0",GetID("Destination"), Haul + HaulBonus )
		
		feedback_MessageCharacter("Destination",
			"@L_THIEF_066_BURGLEAHOUSE_MSG_VICTIM_SUCCESS_HEAD_+0",
			"@L_THIEF_066_BURGLEAHOUSE_MSG_VICTIM_SUCCESS_BODY_+0",GetID("Destination"), Haul)
	end
	
	SetData("finished",1)
	RemoveProperty("","ThiefGoHome")
	
	-- Let the thief flee from the crime scene
	GetFleePosition("", "Destination", 1000, "Away")
	f_MoveToNoWait("", "Away", GL_MOVESPEED_RUN)
	Sleep(1)
	chr_GainXP("Owner",GetData("BaseXP"))
end



-- -----------------------
-- GetMaxHaulValue 
-- berechnet den maximalen wert der beute, die ein dieb abhängig von der gebäudestufe klauen kann
-- -----------------------

function GetMaxHaulValue(DestAlias, DynastyID, ThiefLevel)
	local BaseValue	= BuildingGetValue(DestAlias)
	if BaseValue < 1000 then
		return 0
	end
	
	BaseValue = BaseValue * 0.05	
--	if HasProperty(DestAlias,"ScoutedBy"..DynastyID) then
--		BaseValue = BaseValue * 2
--	end

	local LootFactor	= math.min(100, ((101 - GetImpactValue(DestAlias,"ProtectionOfBurglary"))*100 + 5*(ThiefLevel-1)))
	local LootValue		=	math.max(100, BaseValue * LootFactor / 100)
	
	return LootValue
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopAction("explosion", "")
	CarryObject("","",false)
	ResetProcessProgress("")
	SetState("",STATE_HIDDEN,false)
	local ThiefProperty
	
	if HasData("ThiefProperty") then
		ThiefProperty = GetData("ThiefProperty")
		if HasProperty("",ThiefProperty) then
			RemoveProperty("",ThiefProperty)
		end
	end
	
	local OwnerID = GetID("dynasty")
	
	if AliasExists("Destination") then
		for k=1,3 do
			if HasProperty("Destination","Thief"..k.."Haul"..OwnerID) then 
				RemoveProperty("Destination","Thief"..k.."Haul"..OwnerID)
			end
		end
		if HasData("finished") then
			RemoveProperty("Destination","TimeToBurgle"..GetID("dynasty"))
		end
		if HasProperty("Destination","NumThieves"..OwnerID) then
			RemoveProperty("Destination","NumThieves"..OwnerID)
		end
	end
	
	if HasProperty("","Bandleader") then
		
		local Radius = 2000
		local Filter = "__F((Object.GetObjectsByRadius(Sim) == "..Radius..") AND (Object.Property."..ThiefProperty.."==1) AND NOT(Object.Property.Bandleader ==1))"
		local count = Find("Owner", Filter,"Thief", -1)
		for i=0,count-1 do	
			SetProperty("Thief"..i,"ThiefGoHome")					
		end
		
		if SetProperty("Thief"..0,"Bandleader",1) then
		elseif SetProperty("Thief"..1,"Bandleader",1)then
		end
	end
	
	if GetData("ReleaseLocator")==1 then
		f_EndUseLocator("", "SabotagePosition", GL_STANCE_STAND)
	end
	StopAction("burgleahouse", "")
	RemoveProperty("","ThiefReady")
	RemoveProperty("","ThiefWaiting")
	RemoveProperty("","ThiefGoHome")
	RemoveProperty("","Bandleader")
end

