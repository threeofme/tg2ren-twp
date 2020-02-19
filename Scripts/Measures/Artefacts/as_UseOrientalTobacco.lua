-------------------------------------------------------------------------------
----
----	OVERVIEW "as_179_UseAboutTalents1"
----
----	with this artifact, the player can increase his rhetoric, empathy,
----	bargaining and secret knowledge skill by 1
----	TFTODO: rework
-------------------------------------------------------------------------------

function Run()
	if IsStateDriven() then
		local ItemName = "OrientalTobacco"
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

	PlayAnimation("","eat_standing")
	GetPosition("", "ParticleSpawnPos")
	StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.7,3)
	
	
	
	--show particles
	if RemoveItems("","OrientalTobacco",1)>0 then
		GetPosition("Owner", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		--show overhead text
		local SkillArray = {"constitution","dexterity","charisma","fighting","craftsmanship",
					"shadow_arts","rhetoric","empathy","bargaining","secret_knowledge"}
		local NumSkills = 10
		
		for i=1,NumSkills do
			AddImpact("",SkillArray[i],skillmodify,duration)
		end
		SetMeasureRepeat(TimeOut)
		AddImpact("","TobaccoActive",1,duration)
		for i=1,NumSkills do
			feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_"..SkillArray[i].."_ICON_+0", "@L_TALENTS_"..SkillArray[i].."_NAME_+0", skillmodify)
			Sleep(1)
		end
		
		Sleep(1)
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

