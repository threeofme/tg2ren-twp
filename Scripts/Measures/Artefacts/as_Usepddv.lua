function Run()

	if IsStateDriven() then
		local ItemName = "Pddv"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local favormodify = 100
	local MaxDistance = 1500
	local ActionDistance = 130
	local YearsToLive
	if Rand(4) == 0 then
		YearsToLive = (-10)
	else
		YearsToLive = (-6)
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
	  MsgQuick("","_HPFZ_ARTEFAKT_ALLGEMEIN_FEHLER_+0")
		StopMeasure()
	end

	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)	
	AlignTo("Owner", "Destination")
	AlignTo("Destination", "Owner")
	Sleep(0.5)
	GetPosition("Destination", "ParticleSpawnPos")
	PlayAnimationNoWait("Destination","cogitate")
	if RemoveItems("","pddv",1) then
		CommitAction("poison","","Destination","Destination")
		PlayAnimationNoWait("","use_object_standing")
		Sleep(1)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
		Sleep(5)
		StartSingleShotParticle("particles/smoke_medium.nif", "ParticleSpawnPos",2.7,5)
		PlaySound3D("","Locations/destillery/destillery+1.wav", 1.0)		
		PlayFE("Owner", "smile", 1, 2, 0)
		Sleep(1)
		PlayAnimationNoWait("Destination", "cough")
		if SimGetGender("Destination") == 1 then
			PlaySound3D("Destination","CharacterFX/cough/Husten+1.wav", 1.0)
			Sleep(3)
		else
			PlaySound3D("Destination","CharacterFX/cough/Husten+0.wav", 1.0)
			Sleep(3)
		end
		CarryObject("","",false)
		StopAction("poison","")
		PlayFE("Owner", "anger", 1, 2, 0)
		MsgSay("Destination","_HPFZ_ARTEFAKT_PDDV_SPRUCH_+0")

		if (GetSkillValue("Owner",SHADOW_ARTS) >= GetSkillValue("Destination",EMPATHY)) then	
			AddImpact("Destination","LifeExpanding",YearsToLive,-1)
			AddImpact("Destination","BadDay",1,16)
		
			MsgNewsNoWait("","Destination","","intrigue",-1,
				"@L_HPFZ_ARTEFAKT_PDDV_NUTZER_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_PDDV_NUTZER_RUMPF_+0",GetID("Destination"))
			MsgNewsNoWait("Destination","","","intrigue",-1,
				"@L_HPFZ_ARTEFAKT_PDDV_OPFER_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_PDDV_OPFER_RUMPF_+0",GetID(""))
				
			Sleep(1)	
		end
		chr_ModifyFavor("Destination","",-favormodify)
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end

function CleanUp()
	StopAction("poison","")
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
