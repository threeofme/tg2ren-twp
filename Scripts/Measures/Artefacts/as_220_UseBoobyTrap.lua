function Run()

	if IsStateDriven() then
		local ItemName = "BoobyTrap"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not AliasExists("Destination") then
		StopMeasure()
	end
	if not GetFreeLocatorByName("Destination","Bomb",1,3,"TrapPos") then
		StopMeasure()
	end
	
	if not f_MoveTo("","TrapPos") then
		if not GetOutdoorMovePosition("","Destination","TrapPos") then
			StopMeasure()
		elseif not f_MoveTo("","TrapPos") then
			StopMeasure()
		end
	end
	
	Time = PlayAnimationNoWait("","manipulate_middle_twohand")
	Sleep(3)
	if GetImpactValue("Destination","BoobyTrap")<1 then
		if RemoveItems("","BoobyTrap",1)>0 then
			PlaySound3DVariation("","Effects/digging_shelf", 1.0)
			Sleep(3)
			SetMeasureRepeat(TimeOut)				
			AddImpact("Destination","BoobyTrap",1,duration) 
			chr_GainXP("",GetData("BaseXP"))
		end
	else
		if DynastyIsPlayer("") then
			MsgBoxNoWait("","","@L_GENERAL_ERROR_HEAD_+0", "@L_GENERAL_MEASURES_ARTEFACT_FAIL_+1", GetID("Destination"))
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


