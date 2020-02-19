-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseMedicine.lua"
----
----	Allows your dynasty members to cure Influenza/Burnwound/Pox for themselves.
----     By Fajeth, based on "ms_SelfApplyMedicine.lua" by Manc
----
-------------------------------------------------------------------------------


function Run()

	if IsStateDriven() then
		local ItemName = "Medicine"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	--play animation and spawn particles
	local Time
	local Skill = GetSkillValue("", SECRET_KNOWLEDGE)
	local Difficulty = 6
	--SetMeasureRepeat(TimeOut)
	
if RemoveItems("","Medicine",1,INVENTORY_STD) then
	MsgSay("","_SELFHEAL_SPRUCH_+0")
	Sleep(1)
	Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_perfumebottle.nif",false)
	Sleep(1)
	if ((Rand(3)+Skill)>=Difficulty) then
	--show particles
	GetPosition("Owner", "ParticleSpawnPos")
	StartSingleShotParticle("particles/perfume.nif", "ParticleSpawnPos",2,5)
	PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
	Sleep(2.5)
	StartSingleShotParticle("particles/perfume.nif", "ParticleSpawnPos",2,5)
	PlaySound3D("","Locations/destillery/destillery+0.wav", 1.0)
	Sleep(Time-5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)
	
	-- heal by Fajeth
	diseases_Influenza("",false)
	--diseases_BurnWound("",false)
	diseases_Pox("",false)
	MsgSay("","_SELFHEAL_SPRUCH_+2")
	
	else
	GetLocatorByName("Destination", "Entry1", "ParticleSpawnPos")
	StartSingleShotParticle("particles/toadexcrements_hit.nif", "ParticleSpawnPos",6,5)
	PlaySound3D("Destination","measures/toadexcrements+0.wav", 1.0)
	Sleep(0.5)
	MsgSay("","_SELFHEAL_SPRUCH_+1")
	end
	
	end
	StopMeasure()
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


function CleanUp()

end
