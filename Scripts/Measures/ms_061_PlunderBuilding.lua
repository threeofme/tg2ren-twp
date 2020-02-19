function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	if not SimGetWorkingPlace("","Workbuilding") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_ROBBER)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"Workbuilding")
		else
			StopMeasure()
		end
	end
	GetOutdoorMovePosition("", "Destination", "DoorPos")
	
	f_MoveTo("", "DoorPos", GL_MOVESPEED_RUN,1200)
	MeasureSetNotRestartable()
	SetState("", STATE_HIDDEN, false)
	
	PlaySound3DVariation("","Locations/alarm_horn_single",1)
	PlayAnimation("","attack_them")
	CommitAction("burgleahouse","","Destination", "Destination")
	DynastySetDiplomacyState("Destination","",DIP_FOE)
	-- add the new property
	f_DynastyAddEnemy("","Destination")
	f_DynastyAddEnemy("Destination","")
	
	if BuildingGetType("Destination") == GL_BUILDING_TYPE_FARM or BuildingGetType("Destination") == GL_BUILDING_TYPE_RANGERHUT or BuildingGetType("Destination") == GL_BUILDING_TYPE_MINE or BuildingGetType("Destination") == GL_BUILDING_TYPE_ROBBER then
		f_MoveTo("","DoorPos",GL_MOVESPEED_RUN) 
	else
		SetProperty("Destination", "CanEnter_"..GetID(""),1)
		f_MoveTo("","Destination",GL_MOVESPEED_RUN)
	end
	
	if GetImpactValue("Destination","buildingburgledtoday")==0 then
		if GetImpactValue("Destination","BoobyTrap")~=0 then
			RemoveImpact("Destination","BoobyTrap")
			GetPosition("","ParticleSpawnPos")
			PlaySound3D("","fire/Explosion_01.wav", 1.0)
			StartSingleShotParticle("particles/Explosion.nif", "ParticleSpawnPos", 1,5)
			ModifyHP("",-(GetMaxHP("")),true)
			if not AliasExists("Destination") then
				StopMeasure()
			end
			if GetImpactValue("Destination","buildingburgledtoday")==0 then
				AddImpact("Destination","buildingburgledtoday",1,6)
			end
			CommitAction("explosion", "", "Destination", "Destination")
			StopMeasure()
		end
		if GetLocatorByName("Destination","bomb1","ParticleSpawnPos") then
			StartSingleShotParticle("particles/plunder.nif","ParticleSpawnPos",8,5)
		end
		if GetLocatorByName("Destination","bomb2","ParticleSpawnPos2") then
			StartSingleShotParticle("particles/plunder.nif","ParticleSpawnPos2",7,5)
		end
		feedback_MessageMilitary("Destination","@L_BATTLE_061_PLUNDERBUILDING_MSG_VICTIM_START_HEAD_+0",
						"@L_BATTLE_061_PLUNDERBUILDING_MSG_VICTIM_START_BODY_+0",GetID(""),GetID("Destination"))
	end
	PlaySound3DVariation("Destination","measures/plunderbuilding",1)
	
	local Money = Plunder("","Destination",22)
	if (Money > 0) then
		AddImpact("Destination","buildingburgledtoday",1,12)
		ModifyHP("Destination",-(0.05*GetMaxHP("Destination")),false)
		Time = MoveSetActivity("","carry")
		Sleep(2)
		CarryObject("","Handheld_Device/ANIM_Bag.nif",false)
		PlaySound3DVariation("","measures/plunderbuilding",1)
		Sleep(Time-2)
		MsgQuick("","@L_BATTLE_061_PLUNDERBUILDING_MSG_ACTOR_END_BODY_+0",GetID("Destination"))
		chr_GainXP("",GetData("BaseXP"))		
		--for the mission
		mission_ScoreCrime("",Money)
		
	else
		MsgQuick("","@L_BATTLE_061_PLUNDERBUILDING_FAILURES_+1")
	end
	f_ExitCurrentBuilding("")
	GetFleePosition("", "Destination", 1500, "Away")
	f_MoveTo("", "Away", GL_MOVESPEED_RUN)
	StopAction("burgleahouse","")
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
-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("Destination") then
		if HasProperty("Destination", "CanEnter_"..GetID("")) then
			RemoveProperty("Destination", "CanEnter_"..GetID(""))
		end
	end
	if GetInsideBuilding("","CurrentBuilding") then
		if (GetID("CurrentBuilding") == GetID("Destination")) then
			if GetOutdoorMovePosition("", "Destination", "DoorPos") then
				SimBeamMeUp("", "DoorPos", false) -- false added
			end
		end
	end
		
	StopAction("burgleahouse","")
	MoveSetActivity("","")
	CarryObject("","",false)
end




