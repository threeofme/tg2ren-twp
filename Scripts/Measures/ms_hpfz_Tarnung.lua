function Init()
end

function Run()

    local MeasureID = GetCurrentMeasureID("")
    local TimeOut	= mdata_GetTimeOut(MeasureID)
    local duration = mdata_GetDuration(MeasureID)
    local Endtime = math.mod(GetGametime(),24)+duration
    SetMeasureRepeat(TimeOut)
    GetPosition("","standPos")
	PlayAnimationNoWait("","crouch_down")
	Sleep(1)
	local filter ="__F((Object.GetObjectsByRadius(Building)==1000))"
	local k = Find("",filter,"Umgebung",15)
	if k > 0 then
	    GfxAttachObject("tarn","Handheld_Device/barrel_new.nif")
	else
	    GfxAttachObject("tarn","Outdoor/Bushes/bush_08_big.nif")
	end
	GfxSetPositionTo("tarn","standPos")
	SetState("", STATE_INVISIBLE, true)
	while Endtime>(math.mod(GetGametime(),24)) do
	    Sleep(2)
	end
	
	StopMeasure()

end

function CleanUp()

    SimBeamMeUp("","standPos",false)
	GfxDetachAllObjects()
    SetState("", STATE_INVISIBLE, false)
	PlayAnimationNoWait("","crouch_up")

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end