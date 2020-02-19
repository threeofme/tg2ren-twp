-------------------------------------------------------------------------------
----
----	OVERVIEW "as_167_UseCamouflageCloak"
----
----	with this artifact, the player can increase the talent shadow arts by 3
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "CamouflageCloak"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("") 
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local modifier = 3

	local count = 0
	
	-- boost shadow arts of all own employees in range

	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time)


	if RemoveItems("","CamouflageCloak",1)>0 then
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
			"@L_TALENTS_shadow_arts_ICON_+0", "@L_TALENTS_shadow_arts_NAME_+0", modifier)
		GetPosition("", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)	
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		SetMeasureRepeat(TimeOut)
		AddImpact("","camouflagecloak",1,duration)
		AddImpact("","shadow_arts",modifier,duration)
		
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

