-------------------------------------------------------------------------------
----
----	OVERVIEW "as_170_UseCrossOfProtection"
----
----	with this artifact, the player is protected by beeing attacked 
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "CrossOfProtection"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--play anims, and show overhead text
	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(0.5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(0.5)
	CarryObject("","Handheld_Device/ANIM_crossofprotection.nif",false)
	Sleep(Time-2)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)
	
	if GetImpactValue("","crossofprotection")<1 then
		if RemoveItems("","CrossOfProtection",1)>0 then
			--show particles
			if DynastyIsPlayer("") then
				GetPosition("Owner", "ParticleSpawnPos")
				StartSingleShotParticle("particles/pray_glow.nif", "ParticleSpawnPos",2,5)
				PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			end
			
			-- add impacts and timeout
			SetMeasureRepeat(TimeOut)
			AddImpact("","Unantastbar",1,duration)
			AddImpact("","crossofprotection",1,duration)
			chr_GainXP("",GetData("BaseXP"))
		end
	else
		if DynastyIsPlayer("") then
			MsgBoxNoWait("","","@L_GENERAL_ERROR_HEAD_+0", "@L_GENERAL_MEASURES_ARTEFACT_FAIL_+0", GetID(""))
		end
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

