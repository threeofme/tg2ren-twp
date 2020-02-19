-------------------------------------------------------------------------------
----
----	OVERVIEW "as_171_UseDrFaustusElixir"
----
----	with this artifact, the player can increase his life time
----
-------------------------------------------------------------------------------
function Run()

	if IsStateDriven() then
		local ItemName = "StaffOfAesculap"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local duration = mdata_GetDuration(MeasureID)
	
	if GetImpactValue("","Sickness")>0 then
		MsgQuick("","@L_MEDICUS_FAILURES_+0")
		StopMeasure()
	end
	
	--play anims, and show overhead text
	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(0.5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(0.5)
	CarryObject("","Handheld_Device/ANIM_Aesculap_Staff.nif",false)
	Sleep(Time-2)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)
	--remove item, add impacts
	if RemoveItems("","StaffOfAesculap",1)>0 then
		--show particles
		GetPosition("Owner", "ParticleSpawnPos")
		StartSingleShotParticle("particles/aesculap.nif", "ParticleSpawnPos",1,4)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
				
		SetMeasureRepeat(TimeOut)
		AddImpact("","Resist",1,duration)
		AddImpact("","staffofaesculap",1,duration)
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()

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

