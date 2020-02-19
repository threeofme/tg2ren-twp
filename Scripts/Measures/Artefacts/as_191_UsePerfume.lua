 -------------------------------------------------------------------------------
----
----	OVERVIEW "as_191_UsePerfume"
----
----	with this artifact, the player can increase the favour of the opposite gender
----	in range by 5
----
-------------------------------------------------------------------------------

function Run()
	if GetImpactValue("","perfume")>0 then
		MsgQuick("", "@L_GENERAL_MEASURES_PERFUME_FAILURES_+0", GetID(""))
		StopMeasure()
	end

	if (GetState("", STATE_CUTSCENE)) then
		as_191_useperfume_Cutscene()
	else
		as_191_useperfume_Normal()
	end
end


function Normal()

	if IsStateDriven() then
		if (HasProperty("","HaveCutscene") == true) then
			return
		end		
		local ItemName = "Perfume"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

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
	
	GetPosition("Owner", "ParticleSpawnPos")
	StartSingleShotParticle("particles/perfume.nif", "ParticleSpawnPos",2,5)
	PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
	Sleep(2.5)
	StartSingleShotParticle("particles/perfume.nif", "ParticleSpawnPos",2,5)
	PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
	Sleep(Time-5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)
	if RemoveItems("","Perfume",1)>0 then	
		SetRepeatTimer("", GetMeasureRepeatName2("UsePerfume"), TimeOut)
		AddImpact("","perfume",1,duration)
		SetState("",STATE_CONTAMINATED,true)

		SetProperty("","perfume",5)
		
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end

function Snuffle()
	Sleep(0.5)
	AlignTo("", "Owner")
	Sleep(2)
	PlayAnimation("", "cogitate")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

function CleanUp()
	
end



-- -----------------------------
--
-- This Part is for cutscenes 
--
-- -----------------------------

function Cutscene()

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	--show particles
	GetPosition("Owner", "ParticleSpawnPos")
	if RemoveItems("","Perfume",1)>0 then
		GetPositionOfSubobject("","Game_Head","ParticleSpawnPos")
		StartSingleShotParticle("particles/perfume_sit.nif", "ParticleSpawnPos",2,5)
		PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
		Sleep(2.5)
		StartSingleShotParticle("particles/perfume_sit.nif", "ParticleSpawnPos",2,5)
		PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
		
		SetRepeatTimer("", GetMeasureRepeatName2("UsePerfume"), TimeOut)
		AddImpact("","perfume",1,duration)
		SetState("",STATE_CONTAMINATED,true)

		SetProperty("","perfume",5)

		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end


