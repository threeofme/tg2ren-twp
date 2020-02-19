-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseArgusEyeglasses"
----
----	with this artifact, the player can increase his empathy by "modifier"
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "ArgusEyeglasses"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--how much empathy is increased
	local modifier = 3
	
	--eat something
	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(0.5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time)
	
	if RemoveItems("","ArgusEyeglasses",1)>0 then
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
			"@L_TALENTS_empathy_ICON_+0", "@L_TALENTS_empathy_NAME_+0", modifier)
	
		GetPosition("", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)	
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		--add the impacts and remove the artefact from inventory
		SetMeasureRepeat(TimeOut)
		AddImpact("","empathy",modifier,duration)
		AddImpact("","ArgusEyeglasses",1,duration)
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
				
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	CarryObject("","",false)
	Sleep(1)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

