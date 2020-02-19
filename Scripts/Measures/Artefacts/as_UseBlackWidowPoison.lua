 -------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseBlackWidowPoison"
----
----	with this artifact, the player can poison an opponent
----
-------------------------------------------------------------------------------

function Run()
	if GetImpactValue("Destination","poisoned")>0 then
		MsgQuick("", "@L_MEASURE_USEPOISON_FAILURE_+0", GetID("Destination"))
		StopMeasure()
	end

	if IsStateDriven() then
		local ItemName = "BlackWidowPoison"
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

	f_MoveTo("","Destination",GL_MOVESPEED_RUN, 100)

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if RemoveItems("", "BlackWidowPoison", 1) > 0 then	
		AlignTo("", "Destination")
		Sleep(1.5)

		local AnimTime = PlayAnimationNoWait("","play_instrument_01_in")
		Sleep(1)
		CarryObject("","Handheld_Device/ANIM_Flute.nif",false)
		Sleep(AnimTime)
		--PlayAnimation("","play_instrument_01_loop")
		AnimTime = PlayAnimationNoWait("","play_instrument_01_out")
		Sleep(1.5)
		CarryObject("","",false)
		Sleep(AnimTime-1)

		SetRepeatTimer("", GetMeasureRepeatName2("UseBlackWidowPoison"), TimeOut)
		AddImpact("Destination", "poisoned", 1, duration)
		SetProperty("Destination", "poisoned", 3)
		SetState("Destination", STATE_POISONED, true)

		MsgNewsNoWait("Destination","Destination","","intrigue",-1,
					"@L_MEASURE_USEPOISON_HEAD_+0",
					"@L_MEASURE_USEPOISON_BODY_+0",GetID("Destination"))

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

