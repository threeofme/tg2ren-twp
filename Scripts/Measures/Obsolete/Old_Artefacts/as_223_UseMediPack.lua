-------------------------------------------------------------------------------
----
----	OVERVIEW "as_190_UseMead"
----
----	with this artifact, the player can increase his HP by 50
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "MediPack"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	--how far the Destination can be to start this action
	local MaxDistance = 800
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 80
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	--amount of HP added
	local HPBonus = GetMaxHP("")/2
	local SkillValue = GetSkillValue("",10) --secret knowledge
	if SkillValue > 10 then
		SkillValue = 10
	end
	SkillValue = ((SkillValue * 10) / 100) * HPBonus
	HPBonus = HPBonus + SkillValue
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	--play anims 
	if RemoveItems("","MediPack",1)>0 then
		local Time = PlayAnimationNoWait("","manipulate_middle_twohand")
		GetPosition("Destination", "ParticleSpawnPos")
		Sleep(Time-2)
		StartSingleShotParticle("particles/healthglow.nif", "ParticleSpawnPos",1, 2.0)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		
		if GetState("Destination",STATE_UNCONSCIOUS) then
			SetState("Destination",STATE_UNCONSCIOUS,false)
		end
		
		ModifyHP("Destination", HPBonus,true)
	end
	StopMeasure()
	
end

function CleanUp()
	StopAnimation("")
end


