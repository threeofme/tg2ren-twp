function Run()

-- Not restartable
MeasureSetNotRestartable()

--how long message for destination will be displayed
	local MsgTimeOut = 1 --60 sekunden
	
	-- if there is no owner stop
	if not BuildingGetOwner("Destination","victim") then
	   MsgQuick("", "@L_MERCENARY_RAZZIA_FILTER_NOOWNER_+0")
	   StopMeasure()
	end
	
	
	-- check for evidences against the destination
	local EvidenceValueSum = GetEvidenceValues("", "victim")
	if(EvidenceValueSum < 35) then
	    MsgQuick("", "@L_MERCENARY_RAZZIA_FILTER_NOEVIDENCES_+0")
		StopMeasure()
	end
	
	-- so sim knows where to bring his loot
	if not SimGetWorkingPlace("","Workbuilding") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_CASTLE)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"Workbuilding")
		else
			StopMeasure()
		end
	end
	
	-- so he knows where to run
	if not GetOutdoorMovePosition("", "Destination", "DoorPos") then
		StopMeasure()
	end
	
	-- go to your victim's building
	f_MoveTo("", "DoorPos", GL_MOVESPEED_RUN,500)
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)	
	
	-- some roleplay ;)
	PlayAnimationNoWait("", "threat")
	MsgSay("", "@L_MERCENARY_RAZZIA_SPEECH_BEGIN_+0")
	-- Dynasty will hate you for this
	DynastySetDiplomacyState("Destination","",DIP_FOE)
	-- add the new property
	f_DynastyAddEnemy("","Destination")
	f_DynastyAddEnemy("Destination","")
	-- Remove the evidences here so that the player cannot cancel the measure when he recognizes a possible failure and keep the evidences this way
	RemoveEvidences("", "victim")
	Sleep (5)
    local Result = MsgNews("Destination","",
		"@B[1,@L__MERCENARY_RAZZIA_MSG_BEGIN_BUTTON_+0]"..
		"@B[2,@L__MERCENARY_RAZZIA_MSG_BEGIN_BUTTON_+1]",
		ms_razzia_AIDecision,  --AIFunc
		"intrigue", --MessageClass
		MsgTimeOut, --TimeOut
		"@L_INTRIGUE_THREAT_CHARACTER_MSG_THREATENED_HEAD_+0",
		"@L_MERCENARY_RAZZIA_MSG_BEGIN_BODY_+0",
		GetID(""), GetID("Destination"))
	if Result == 1 then
	    MsgSay("Destination", "@L_MERCENARY_RAZZIA_SPEECH_RESPONDNO_+0")
		Sleep(3)
	    MsgSay("", "@L_MERCENARY_RAZZIA_SPEECH_ATTACK_+0")
	    Sleep (3)
		PlaySound3DVariation("","Locations/alarm_horn_single",1)
		PlayAnimationNoWait("","attack_them")
		MsgSay("", "@L_MERCENARY_RAZZIA_SPEECH_ATTACK_+1")
		SetProperty("","WasInFight",1)
		BattleJoin("", "Destination", true, false)
		Sleep(5)
		if AliasExists("") then
			if GetProperty("", "WasInFight") == 1 then
				-- laugh
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_joy_loop",1)
				else
					PlaySound3DVariation("","CharacterFX/female_joy_loop",1)
				end
				PlayAnimationNoWait("", "talk_2")
				MsgSay("", "@L_MERCENARY_RAZZIA_SPEECH_ATTACK_NOENEMY_+0")
				Sleep(3)
				f_MoveTo("", "Destination", GL_MOVESPEED_RUN)
				Sleep(4)
				local money = (((GetSkillValue("", EMPATHY)) + (GetSkillValue("", FIGHTING)))*75)
				MsgSay("", "_MERCENARY_RAZZIA_SPEECH_ATTACK_END_+0")
				PlayAnimation("","manipulate_bottom_r")
				f_CreditMoney("Workbuilding", money,"")
				economy_UpdateBalance("Workbuilding", "Service", money)
				f_SpendMoney("Destination", money, "")
				feedback_MessageMilitary("",
				"@L_MERCENARY_RAZZIA_MSG_END_HEAD_+0",
				"@L_MERCENARY_RAZZIA_MSG_END_BODY_+0",
				GetID("victim"), GetID("Destination"), money)
				feedback_MessageMilitary("Destination",
				"@L_MERCENARY_RAZZIA_MSG_END_HEAD_+0",
				"@L_MERCENARY_RAZZIA_MSG_END_BODY_+1",
				GetID("Destination"), GetID(""), money)
				Sleep(7)
			end
		end
	else
		MsgSay("Destination", "@L_MERCENARY_RAZZIA_SPEECH_RESPONDNO_+1")
		Sleep(3)
		MsgSay("", "@L_MERCENARY_RAZZIA_SPEECH_SURRENDER_+0")
		Sleep (2)
	end

	if BuildingGetType("Destination") == GL_BUILDING_TYPE_FARM or BuildingGetType("Destination") == GL_BUILDING_TYPE_RANGERHUT or BuildingGetType("Destination") == GL_BUILDING_TYPE_MINE or BuildingGetType("Destination") == GL_BUILDING_TYPE_ROBBER then
		if not f_MoveTo("","DoorPos",GL_MOVESPEED_RUN) then
			StopMeasure()
		end
	else

		SetProperty("Destination", "CanEnter_"..GetID(""),1)
		if not f_MoveTo("","Destination",GL_MOVESPEED_RUN) then
			StopMeasure()
		end
	end
	
	-- the smoke animation
	if GetLocatorByName("Destination","bomb1","ParticleSpawnPos") then
		StartSingleShotParticle("particles/plunder.nif","ParticleSpawnPos",8,5)
	end
	if GetLocatorByName("Destination","bomb2","ParticleSpawnPos2") then
		StartSingleShotParticle("particles/plunder.nif","ParticleSpawnPos2",7,5)
	end
	PlaySound3DVariation("Destination","measures/plunderbuilding",1)
	
	local Money = Plunder("","Destination",22)
	if (Money > 0) then
		AddImpact("Destination","buildingburgledtoday",1,4)
		ModifyHP("Destination",-(0.15*GetMaxHP("Destination")),false)
		Sleep(5)
		Time = MoveSetActivity("","carry")
		CarryObject("","Handheld_Device/ANIM_Bag.nif",false)
		MsgSay("","@L_MERCENARY_RAZZIA_SPEECH_SURRENDER_END+0")
		Sleep(3)
		PlaySound3DVariation("","measures/plunderbuilding",1)
		Sleep(Time-2)
	end
	local money2 = (((GetSkillValue("", EMPATHY)) + (GetSkillValue("", FIGHTING)))*125)
	f_CreditMoney("Workbuilding", money2,"")
	economy_UpdateBalance("Workbuilding", "Service", money2)
	feedback_MessageMilitary("",
		"@L_MERCENARY_RAZZIA_MSG_END_HEAD_+1",
		"@L_MERCENARY_RAZZIA_MSG_END_BODY_+2",
		GetID("victim"), GetID("Destination"), money2)
	feedback_MessageMilitary("Destination",
		"@L_MERCENARY_RAZZIA_MSG_END_HEAD_+1",
		"@L_MERCENARY_RAZZIA_MSG_END_BODY_+3",
		GetID("Destination"), GetID(""))
	chr_GainXP("",GetData("BaseXP"))
		

	f_ExitCurrentBuilding("")
	GetFleePosition("", "Destination", 1500, "Away")
	f_MoveTo("", "Away", GL_MOVESPEED_RUN)
	f_MoveTo("","Workbuilding",GL_MOVESPEED_RUN)
	local	ItemId
	local	Found
	local RemainingSpace
	local Removed
	
	local Count = InventoryGetSlotCount("", INVENTORY_STD)
	for i=0,Count-1 do
		ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
		if ItemId and ItemId>0 and Found>0 then
			RemainingSpace	= GetRemainingInventorySpace("Workbuilding",ItemId)
			Removed		= RemoveItems("", ItemId, RemainingSpace)
			if Removed>0 then
				AddItems("Workbuilding", ItemId, Removed)
			end
		end
	end
end

function AIDecision()
	--AI accept or decline
	local strenght = (Rand(100)+(((GetSkillValue("", EMPATHY)) + (GetSkillValue("", FIGHTING)))*5))
	if strenght > 110 then
		return 2 --rob me
	else
		return 1 --attack
	end

end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("Destination") then
		if HasProperty("Destination", "CanEnter_"..GetID("")) then
			RemoveProperty("Destination", "CanEnter_"..GetID(""))
		end
	end
	if AliasExists("") then
		if HasProperty("", "WasInFight") then
			RemoveProperty("", "WasInFight")
		end
	end
	if GetInsideBuilding("","CurrentBuilding") then
		if (GetID("CurrentBuilding") == GetID("Destination")) then
			if GetOutdoorMovePosition("", "Destination", "DoorPos") then
				SimBeamMeUp("", "DoorPos", false) -- false added
			end
		end
	end
	
	MoveSetActivity("","")
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end


