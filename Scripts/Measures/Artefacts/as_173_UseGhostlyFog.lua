-------------------------------------------------------------------------------
----
----	OVERVIEW "as_173_UseGhostlyFog"
----
----	with this artifact, the player can decrease the Destinations empathy by 5
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "GhostlyFog"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local modifyvalue = 5
	--how much the favor of the Destination to the owner is decreased
	local favormodify = 10
	--how far the Destination can be to start this action
	local MaxDistance = 1500
	--how far from the destination, the owner should stand while performing
	local ActionDistance = 130
	
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
		
	--look at each other
	feedback_OverheadActionName("Destination")
	AlignTo("Owner", "Destination")
	AlignTo("Destination", "Owner")
	Sleep(0.25)
	
	--play the animation and start particles
	GetPosition("Destination", "ParticleSpawnPos")
	time2 = PlayAnimationNoWait("Destination","cogitate")
	--play animation and spawn particles
	if RemoveItems("","Ghostlyfog",1)>0 then
		CommitAction("poison","","Destination","Destination")
		local Time
		Time = PlayAnimationNoWait("","use_object_standing")
		Sleep(1)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","Handheld_Device/ANIM_perfumebottle.nif",false)
		Sleep(5)
		StartSingleShotParticle("particles/GhostlyFog.nif", "ParticleSpawnPos",2.7,5)
		PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
		PlayAnimationNoWait("Destination", "appal")				
		PlayFE("Owner", "smile", 1, 2, 0)
		Sleep(1)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)
		Sleep(1)
		StopAction("poison","")
		SetMeasureRepeat(TimeOut)
		--modify the empathy
		AddImpact("Destination","empathy",-modifyvalue,duration)
		AddImpact("Destination","ghostlyfog",1,duration)
		--show overhead text
		feedback_OverheadSkill("Destination", "@L_ARTEFACTS_OVERHEAD_+1", false, 
			"@L$S[2022]", "@L_TALENTS_empathy_NAME_+0", modifyvalue)
	
		Sleep(1)	
		--let the Destination run away
		GetFleePosition("Destination", "Owner", 500, "Away")
		f_MoveToNoWait("Destination", "Away", GL_MOVESPEED_RUN)
		
		--modify the favor
		chr_ModifyFavor("Destination","",-favormodify)
		MsgNewsNoWait("Destination","","","intrigue",-1,
				"@L_ARTEFACTS_173_USEGHOSTLYFOG_MSG_VICTIM_HEAD_+0",
				"@L_ARTEFACTS_173_USEGHOSTLYFOG_MSG_VICTIM_BODY_+0", GetID("Destination"), GetID(""))
	
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopAction("poison","")
	feedback_OverheadActionName("Destination")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

