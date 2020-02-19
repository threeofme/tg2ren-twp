function Run()

	if not IsType("Destination", "cl_Position") then
		return
	end

	if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN,1000) then
		return
	end
	
	if not Position2GuildObject("Destination", "PosObject") then
		return
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local duration = mdata_GetDuration(MeasureID)
	
	
	AlignTo("","PosObject")	
	CarryObject("", "Handheld_Device/ANIM_Bomb_02.nif", false)
	Sleep(1)
	PlayAnimationNoWait("", "throw")
	Sleep(2.1)
	CarryObject("", "" ,false)
	
	if RemoveItems("","StinkBomb",1)==0 then
		return
	end
	SetMeasureRepeat(TimeOut)
	local ThrowTime = ThrowObject("","PosObject","Handheld_Device/ANIM_Bomb_02.nif",0.3,"stinkbomb",30,150,0)
	Sleep(ThrowTime)
	
	MeasureRun("PosObject", nil, "StinkOMat")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

