function Run()
	if IsStateDriven() then
		if (HasProperty("","Blissstone") == true) then
			return
		end		
		local ItemName = "Blissstone"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

    MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)
	
	if RemoveItems("","Blissstone",1)>0 then
		GetPosition("Owner", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_empathy_ICON_+0", "@L_TALENTS_empathy_NAME_+0", 2)
		Sleep(1)
		
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_dexterity_ICON_+0", "@L_TALENTS_dexterity_NAME_+0", 2)
	    Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
        SetState("",58,true)		
		
	end
	StopMeasure()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

function CleanUp()
	
end
