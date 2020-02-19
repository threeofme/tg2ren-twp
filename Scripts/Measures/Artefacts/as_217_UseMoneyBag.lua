-------------------------------------------------------------------------------
----
----	OVERVIEW "as_217_UseMoneyBag"
----
----	with this artifact, the player can increase his bargaining talent by 2
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "MoneyBag"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("") 
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local modifier = 2
	
	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
								
	-- Play a coin sound for the local player
	if dyn_IsLocalPlayer("") then
		PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
	end
	
	Sleep(Time)
	if RemoveItems("","MoneyBag",1)>0 then
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
			"@L_TALENTS_bargaining_ICON_+0", "@L_TALENTS_bargaining_NAME_+0", modifier)
		
		GetPosition("", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		SetMeasureRepeat(TimeOut)
		AddImpact("","bargaining",modifier,duration)
		AddImpact("","MoneyBag",1,duration)
		
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

