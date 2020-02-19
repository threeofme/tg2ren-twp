function Run()

	if IsStateDriven() then
		local ItemName = "Robe"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local skillmodify = 3

	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)	
	local Time = PlayAnimationNoWait("","fetch_store_obj_R")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+0.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_Cloth.nif",false)
	Sleep(Time-1)
	CarryObject("","",false)
	if GetImpactValue("","robe")<1 then
		if RemoveItems("","Robe",1) > 0 then
			feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
					"@L_TALENTS_secret_knowledge_ICON_+0", "@L_TALENTS_secret_knowledge_NAME_+0", skillmodify)		
			Sleep(1)	
			feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
					"@L_TALENTS_empathy_ICON_+0", "@L_TALENTS_empathy_NAME_+0", skillmodify)
			Sleep(1)	
			
			GetPosition("Owner", "ParticleSpawnPos")
			StartSingleShotParticle("particles/rage.nif", "ParticleSpawnPos",1,5)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)			
			       
			AddImpact("","empathy",skillmodify,duration)
			AddImpact("","secret_knowledge",skillmodify,duration)
			AddImpact("","robe",1,duration)
			Sleep(1)
		end
	else
		if DynastyIsPlayer("") then
			MsgBoxNoWait("","","@L_GENERAL_ERROR_HEAD_+0", "@L_GENERAL_MEASURES_ARTEFACT_FAIL_+0", GetID(""))
		end
	end

	StopMeasure()
end

function CleanUp()
	StopAnimation("")
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end
