-------------------------------------------------------------------------------
----
----	OVERVIEW "as_166_UseBoozyBreathBeer"
----
----	with this artifact, the player can protect himself of beeing insulted,
----	hijacked or slugged for 12h. disadvantage -25% rhetoric.
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "BoozyBreathBeer"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local malus = (math.floor(GetSkillValue("","rhetoric")*.25))
	if GetSkillValue("","rhetoric")<2 then
		malus = 0
	end
	
	if GetImpactValue("","boozybreathbeer")<1 then
		if RemoveItems("","BoozyBreathBeer",1)>0 then
			local Time = PlayAnimationNoWait("","use_potion_standing")
			PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
			Sleep(1)
			CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
			Sleep(Time-2)
			PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
			CarryObject("","",false)
			
			--show particles
			GetPosition("", "ParticleSpawnPos")
			
			if (malus > 0) then
				if DynastyIsPlayer("") then
					StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)		
					PlaySound3DVariation("","measures/boozybreathbeer",1)
					--show overhead text
					feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+1", false, 
						"@L_TALENTS_rhetoric_ICON_+0", "@L_TALENTS_rhetoric_NAME_+0", malus)
				end
			end
			
			SetMeasureRepeat(TimeOut)
			AddImpact("","rhetoric",-malus,duration)
			AddImpact("","boozybreathbeer",1,duration) 
			
			StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.7,3)
			Sleep(1)
			chr_GainXP("",GetData("BaseXP"))						
			LoopAnimation("","idle_drunk",3)
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

