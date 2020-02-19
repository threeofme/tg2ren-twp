-------------------------------------------------------------------------------
----
----	OVERVIEW "as_165_UseBeltOfMetaPhysic"
----
----	with this artifact, the player can increase his constitution skill by 2
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "BeltOfMetaphysic"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local skillmodify = 2


	Time = PlayAnimationNoWait("","fetch_store_obj_R")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time-1)
	if GetImpactValue("","beltofmetaphysic")<1 then
		if RemoveItems("","BeltOfMetaphysic",1)>0 then
			--show overhead text
			feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
				"@L_TALENTS_constitution_ICON_+0", "@L_TALENTS_constitution_NAME_+0", skillmodify)
			Sleep(0.5)
			feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
				"@L_TALENTS_fighting_ICON_+0", "@L_TALENTS_fighting_NAME_+0", skillmodify)
		
			--show particles
			GetPosition("Owner", "ParticleSpawnPos")
			StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)			
			AddImpact("","constitution",2,duration) -- duration 450 = 1/2 day
			AddImpact("","fighting",2,duration)
			AddImpact("","beltofmetaphysic",1,duration)
			SetMeasureRepeat(TimeOut)
			Sleep(1)
			chr_GainXP("",GetData("BaseXP"))
		end
	else
		if DynastyIsPlayer("") then
			MsgBoxNoWait("","","@L_GENERAL_ERROR_HEAD_+0", "@L_GENERAL_MEASURES_ARTEFACT_FAIL_+0", GetID(""))
		end
	end
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

