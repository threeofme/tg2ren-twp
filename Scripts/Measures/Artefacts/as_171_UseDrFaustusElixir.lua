-------------------------------------------------------------------------------
----
----	OVERVIEW "as_171_UseDrFaustusElixir"
----
----	with this artifact, the player can increase his life time with a
----	bit of luck
----
-------------------------------------------------------------------------------
function Run()

	if IsStateDriven() then
		local ItemName = "DrFaustusElixir"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	--amount of years, the life will be expanded
	local YearsToLive = 4
	
	--play animation and spawn particles
	local Time = PlayAnimationNoWait("","use_potion_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_perfumebottle.nif",false)
	Sleep(Time-2)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)
	Sleep(1)
	if RemoveItems("","DrFaustusElixir",1)>0 then
		SetMeasureRepeat(TimeOut)
		if Rand(100)>=24 then --75% chance of success
			Time = PlayAnimationNoWait("","cheer_01")
			if DynastyIsPlayer("") then
				GetPosition("","ParticleSpawnPos")
				StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos",1,4)
				PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			end
			AddImpact("","LifeExpanding",YearsToLive,-1)
			ShowOverheadSymbol("", false, true,"OverheadSymbolID","@L_LIFE_EXPANDING_OVERHEAD",YearsToLive)
			feedback_MessageCharacter("","@L_ARTEFACTS_171_USEDRFAUSTUSELIXIR_MSG_SUCCES_HEAD_+0",
							"@L_ARTEFACTS_171_USEDRFAUSTUSELIXIR_MSG_SUCCES_BODY_+0")
		else	
			Time = PlayAnimationNoWait("","appal")
			if DynastyIsPlayer("") then
				GetPosition("","ParticleSpawnPos")
				StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.2,3)
				feedback_MessageCharacter("","@L_ARTEFACTS_171_USEDRFAUSTUSELIXIR_MSG_FAILED_HEAD_+0",
								"@L_ARTEFACTS_171_USEDRFAUSTUSELIXIR_MSG_FAILED_BODY_+0")
			end
		end
		chr_GainXP("",GetData("BaseXP"))
		Sleep(Time)
	end
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+1",Gametime2Total(mdata_GetDuration(MeasureID)))
end

