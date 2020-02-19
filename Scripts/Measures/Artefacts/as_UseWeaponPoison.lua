 -------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseWeaponPoison"
----
----	with this artifact, the player can poison an opponent
----
-------------------------------------------------------------------------------

function Run()
	log_death("Destination", "is getting poisoned (as_UseWeaponPoison)")

	if GetImpactValue("Destination","poisoned")>0 then
		MsgQuick("", "@L_MEASURE_USEPOISON_FAILURE_+0", GetID("Destination"))
		StopMeasure()
	end

	if IsStateDriven() then
		if (HasProperty("","HaveCutscene") == true) then
			return
		end		
		local ItemName = "WeaponPoison"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MaxDistance = 1500
	GetPosition("","OwnerPos")
	GetPosition("Destination","DestPos")
	if GetDistance("OwnerPos","DestPos") > MaxDistance then
		MsgQuick("", "@L_MEASURE_USEPOISON_FAILURE_+1", GetID(""), GetID("Destination"), MaxDistance/30)
		StopMeasure()
	end

	BlockChar("Destination")

	f_MoveTo("","Destination",GL_MOVESPEED_RUN, 30)

	AlignTo("", "Destination")

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if RemoveItems("","WeaponPoison",1)>0 then	
		MoveSetActivity("","fighting")
		PlayAnimationNoWait("","fight_draw_weapon")
		Sleep(1.5)
		CarryObject("","weapons/sword_01.nif",false)
		Sleep(1)

		PlayAnimationNoWait("", "attack_middle")	
		GetPosition("Destination", "ParticleSpawnPos")
		StartSingleShotParticle("particles/bloodsplash.nif", "ParticleSpawnPos", 1, 3.0)
		PlaySound3D("Destination","Effects/combat_strike_fist/combat_strike_fist+4.wav",1)
	
		local ActualHP = GetHP("Destination")
		ModifyHP("Destination",-(ActualHP/2),true)
	
		CarryObject("","",false)
		MoveSetActivity("","")

		SetRepeatTimer("", GetMeasureRepeatName2("UseWeaponPoison"), TimeOut)
		AddImpact("Destination","poisoned",1,duration)
		SetProperty("Destination","poisoned",1)
		SetState("Destination",STATE_POISONED,true)

		MeasureRun("","Destination","AttackEnemy",true)	
	end

	StopMeasure()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

function CleanUp()
	
end

