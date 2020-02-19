-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseTool.lua"
----
----	with this artifact, the player can increase his craftsmanship talent by 1
---- 
---- author: Fajeth
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "Tool"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("") 
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local modifier = 1
	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
								
	Sleep(Time)
	if RemoveItems("","Tool",1)>0 then
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
			"@L_TALENTS_craftsmanship_ICON_+0", "@L_TALENTS_craftsmanship_NAME_+0", modifier)
		
		GetPosition("", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		SetMeasureRepeat(TimeOut)
		AddImpact("","craftsmanship",modifier,duration)
		AddImpact("","Tool",1,duration)
		
		Sleep(1)
		chr_GainXP("",75)
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

