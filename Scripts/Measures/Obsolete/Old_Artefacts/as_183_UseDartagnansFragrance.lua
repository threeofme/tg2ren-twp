-------------------------------------------------------------------------------
----
----	OVERVIEW "as_183_UseDartagnansFragrance"
----
----	with this artifact, the player can increase his Fighting and dexterity 
----	skill by 1
----
-------------------------------------------------------------------------------

function Run()
	if GetImpactValue("","perfume")>0 then
		MsgQuick("", "@L_GENERAL_MEASURES_PERFUME_FAILURES_+0", GetID(""))
		StopMeasure()
	end

	if IsStateDriven() then
		local ItemName = "DartagnansFragrance"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	local skillmodify = 2
	

	--play animation and spawn particles
	local Time
	Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_perfumebottle.nif",false)
	Sleep(1)
	if RemoveItems("","DartagnansFragrance",1)>0 then
		--show particles
		GetPosition("Owner", "ParticleSpawnPos")
		StartSingleShotParticle("particles/dartagnansfragrance.nif", "ParticleSpawnPos",2,5)
		PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
		Sleep(2.5)
		StartSingleShotParticle("particles/dartagnansfragrance.nif", "ParticleSpawnPos",2,5)
		PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
		Sleep(Time-5)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)
		
		SetRepeatTimer("", GetMeasureRepeatName2("UseDartagnansFragrance"), TimeOut)
		AddImpact("","perfume",1,duration)
		SetState("",STATE_CONTAMINATED,true)

		SetProperty("","perfume",3)

		AddImpact("","Fighting",skillmodify,duration)
		AddImpact("","dexterity",skillmodify,duration)
		AddImpact("","dartagnansfragrance",1,duration)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
			"@L_TALENTS_fighting_ICON_+0", "@L_TALENTS_fighting_NAME_+0", skillmodify)
		Sleep(1)
		
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
			"@L_TALENTS_dexterity_ICON_+0", "@L_TALENTS_dexterity_NAME_+0", skillmodify)
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end
