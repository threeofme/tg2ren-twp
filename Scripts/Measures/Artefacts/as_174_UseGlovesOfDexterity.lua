-------------------------------------------------------------------------------
----
----	OVERVIEW "as_174_UseGlovesOfDexterity"
----
----	with this artifact, the player can increase the dexterity of
----	all his employees in range by 2
----	TFTODO: rework
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "GlovesOfDexterity"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end


	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local skillmodify = 1

	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	
	Sleep(5);
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time-7)
		
	SetMeasureRepeat(TimeOut)
	if RemoveItems("","GlovesOfDexterity",1)>0 then
		AddImpact("","Fighting",skillmodify,duration)
		AddImpact("","dexterity",skillmodify,duration)
		AddImpact("","glovesofdexterity",1,duration)
		
		GetPosition("","ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
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

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

