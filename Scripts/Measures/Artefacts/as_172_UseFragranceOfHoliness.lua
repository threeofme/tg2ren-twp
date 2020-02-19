-------------------------------------------------------------------------------
----
----	OVERVIEW "as_172_UseFragranceOfHoliness"
----
----	this artefact can only be used durring an Trail. And is only usefull for the Accused Sim 
----	The effect is that all avidences against the accused sim get the chance of 30% to 
----	condemned as untrustworthy
----
-------------------------------------------------------------------------------

function Run()
	if GetImpactValue("","perfume")>0 then
		MsgQuick("", "@L_GENERAL_MEASURES_PERFUME_FAILURES_+0", GetID(""))
		StopMeasure()
	end

	if (GetState("", STATE_CUTSCENE)) then
		as_172_usefragranceofholiness_Cutscene()
	else
		as_172_usefragranceofholiness_Normal()
	end
end


function Normal()

	if IsStateDriven() then
		local ItemName = "FragranceOfHoliness"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local chance = 30
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--play animation and spawn particles
	local Time
	Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_perfumebottle.nif",false)
	Sleep(1)
	
	--show particles
	if RemoveItems("","FragranceOfHoliness",1)>0 then
		GetPosition("Owner", "ParticleSpawnPos")
		StartSingleShotParticle("particles/perfume.nif", "ParticleSpawnPos",2,5)
		PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
		Sleep(2.5)
		StartSingleShotParticle("particles/perfume.nif", "ParticleSpawnPos",2,5)
		PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
		Sleep(Time-5)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)
			
		if Rand(100) < chance then
			AddImpact("","EvidenceSuppression",1,duration)
			
			--show particles
			GetPosition("", "ParticleSpawnPos")		
			StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		end
		AddImpact("","fragranceofholiness",1,duration)
		SetRepeatTimer("", GetMeasureRepeatName2("UseFragranceOfHoliness"), TimeOut)

		AddImpact("","perfume",1,duration)
		SetState("",STATE_CONTAMINATED,true)

		SetProperty("","perfume",3)

		chr_GainXP("",GetData("BaseXP"))
	end
	
	StopMeasure()
	
end


function Cutscene()
	local chance = 30
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
--	duration = duration + (chr_ArtifactsDuration("Owner",duration))

	--show particles
	if RemoveItems("","FragranceOfHoliness",1)>0 then
		GetPositionOfSubobject("", "Game_Head", "ParticleSpawnPos")		
		StartSingleShotParticle("particles/perfume_sit.nif", "ParticleSpawnPos",2,5)
		Sleep(2.5)
		StartSingleShotParticle("particles/perfume_sit.nif", "ParticleSpawnPos",2,5)	
		
		if Rand(100) < chance then
			AddImpact("","fragranceofholiness",1,duration)
			AddImpact("","EvidenceSuppression",1,duration)
		end
		
		SetRepeatTimer("", GetMeasureRepeatName2("UseFragranceOfHoliness"), TimeOut)
		AddImpact("","perfume",1,duration)
		SetState("",STATE_CONTAMINATED,true)

		SetProperty("","perfume",3)
		
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

