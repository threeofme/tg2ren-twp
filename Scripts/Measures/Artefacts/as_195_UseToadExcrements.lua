-------------------------------------------------------------------------------
----
----	OVERVIEW "as_195_UseToadExcrements"
----
----	with this artifact, the player can keep all workers of an building
----	from work for 4h
----
-------------------------------------------------------------------------------

function Run()
	
	if not AliasExists("Destination") then
		StopMeasure()
	end

	if IsStateDriven() then
		local ItemName = "ToadExcrements"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--how far the destination can be to start this action
	local MaxDistance = 2000
	--how far from the destination, the owner should stand when throwing toadexcrements
	local ActionDistance = 800
	
	if BuildingGetType("Destination")==GL_BUILDING_TYPE_FARM or BuildingGetType("Destination")==GL_BUILDING_TYPE_ROBBER or BuildingGetType("Destination")==GL_BUILDING_TYPE_MINE or BuildingGetType("Destination")==GL_BUILDING_TYPE_RANGERHUT or BuildingGetType("Destination")==GL_BUILDING_TYPE_THIEF then
		MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+26")
		StopMeasure()
	end
	
	if (GetImpactValue("Destination","DivineBlessing")==1) then
		MsgQuick("","@L_CHURCH_089_PRAYFORGODSBLESSING_MESSAGES_FAILURES_+0",GetID("Destination"))
		StopMeasure()
	end
	
	if not GetOutdoorMovePosition("","Destination","MovePos") then
		StopMeasure()
	end
	
	if not f_MoveTo("","MovePos",GL_MOVESPEED_RUN,1000) then
		StopMeasure()
	end
	
	MsgMeasure("","")

	-- Commit the action
	BuildingGetOwner("Destination", "Victim")
	CommitAction("lay_bomb", "Owner", "Victim", "Destination")

	--throw the toadexcrements

	AlignTo("", "Destination")
	if GetImpactValue("Destination","toadexcrements")<1 then
		if RemoveItems("","ToadExcrements",1)>0 then
			CarryObject("", "Handheld_Device/ANIM_perfumebottle.nif", false)
			PlayAnimationNoWait("", "throw")
			
			Sleep(2.03)
			local fDuration = ThrowObject("", "Destination", "Handheld_Device/ANIM_perfumebottle.nif",0.1,"excrements",30,150,0)
			Sleep(0.13)
			CarryObject("", "" ,false)
			Sleep(fDuration)
		
			GetLocatorByName("Destination", "Entry1", "ParticleSpawnPos")
			StartSingleShotParticle("particles/toadexcrements_hit.nif", "ParticleSpawnPos",6,5)
			PlaySound3D("Destination","measures/toadexcrements+0.wav", 1.0)
			
		
			StopAction("lay_bomb", "")
		
			Sleep(1.0)
		
			DynastyMakeImpact("Owner", GL_IMPACT_AGGRESSIV, 1)
			SetMeasureRepeat(TimeOut)
		
			feedback_MessageWorkshop("Owner",
					"@L_ARTEFACTS_195_USETOADEXCREMENTS_MSG_ACTOR_HEAD_+0",
					"@L_ARTEFACTS_195_USETOADEXCREMENTS_MSG_ACTOR_BODY_+0", GetID("Destination"))
		
			feedback_MessageWorkshop("Destination",
					"@L_ARTEFACTS_195_USETOADEXCREMENTS_MSG_VICTIM_HEAD_+0",
					"@L_ARTEFACTS_195_USETOADEXCREMENTS_MSG_VICTIM_BODY_+0", GetID("Destination"))
		
			Sleep(1)
		
			-- get the workers out
		
			Evacuate("Destination")
			SetState("Destination", STATE_CONTAMINATED, true)
			AddImpact("Destination","toadexcrements",1,duration)
		
			chr_GainXP("",GetData("BaseXP"))
			
			-- flee from the crime scene
			GetFleePosition("", "Destination", 1500, "Away")
			f_MoveTo("", "Away", GL_MOVESPEED_RUN)
			AlignTo("", "Destination")
		end
	else
		if DynastyIsPlayer("") then
			MsgBoxNoWait("","","@L_GENERAL_ERROR_HEAD_+0", "@L_GENERAL_MEASURES_ARTEFACT_FAIL_+1", GetID("Destination"))
		end
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopAction("lay_bomb", "Owner")
end

function GetOSHData(MeasureID)
	--wieder benutzbar in
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--wirkungsdauer
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

