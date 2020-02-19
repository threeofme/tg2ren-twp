 -------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseAntidote"
----
----	with this artifact, the player can neutralize a poison
----
-------------------------------------------------------------------------------

function Run()
	if not GetImpactValue("","poisoned") then
		MsgQuick("", "@L_MEASURE_USEANTIDOTE_FAILURE_+0", GetID(""))
		StopMeasure()
	end

	if IsStateDriven() then
		local ItemName = "Antidote"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	if RemoveItems("","Antidote",1)>0 then	
		local Time = PlayAnimationNoWait("","use_object_standing")
		Sleep(1)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","Handheld_Device/ANIM_perfumebottle.nif",false)
		Sleep(Time-2)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)
		Sleep(1)
		GetPosition("","ParticleSpawnPos")
		StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos",1,4)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		RemoveImpact("","poisoned")	
	end

	StopMeasure()
end

function CleanUp()
	
end

