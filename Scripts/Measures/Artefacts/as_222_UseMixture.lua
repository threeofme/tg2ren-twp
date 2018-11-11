-------------------------------------------------------------------------------
----
----	OVERVIEW "as_222_UseMixture"
----
----	with this artifact, the player can infect someone with a disease
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "Mixture"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	--how much the favor of the Destination to the owner is decreased
	local favormodify = 20
	--how far the Destination can be to start this action
	local MaxDistance = 1500
	--how far from the destination, the owner should stand while reading the letter from rome
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
	Sleep(0.5)
	
	--play the animation and start particles
	GetPosition("Destination", "ParticleSpawnPos")
	time2 = PlayAnimationNoWait("Destination","cogitate")
	--play animation and spawn particles
	if RemoveItems("","Mixture",1)>0 then
		CommitAction("poison","","Destination","Destination")
		local Time
		Time = PlayAnimationNoWait("","use_object_standing")
		Sleep(1)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","Handheld_Device/ANIM_perfumebottle.nif",false)
		Sleep(5)
		StartSingleShotParticle("particles/disease.nif", "ParticleSpawnPos",2.7,5)
		PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
		PlayAnimationNoWait("Destination", "appal")				
		PlayFE("Owner", "smile", 1, 2, 0)
		Sleep(1)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)
		Sleep(1)
		StopAction("poison","")
		
		SetState("Destination",STATE_UNCONSCIOUS,true)
		AddImpact("Destination","BadDay",1,12)
		
		CreateScriptcall("StartDisease",1,"Measures/Artefacts/as_222_UseMixture.lua","StartDisease","Owner","Destination")
		
		--let the Destination run away
		GetFleePosition("Destination", "Owner", 500, "Away")
		f_MoveToNoWait("Destination", "Away", GL_MOVESPEED_RUN)
		
		
		--modify the favor
		chr_ModifyFavor("Destination","",-favormodify)
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
		SetMeasureRepeat(TimeOut)
		Sleep(2)
	end
	StopMeasure()
end

function StartDisease()
	--infect
	if GetImpactValue("Destination","soap")>0 then
		--no effect
	else	
		diseases_Blackdeath("Destination",true,true)
	end
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
	
end

