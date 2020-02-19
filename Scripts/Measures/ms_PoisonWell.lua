function Run()
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not GetPosition("Destination","MovePos") then
		StopMeasure()
	end
	if not f_MoveTo("","MovePos",GL_MOVESPEED_RUN,175) then
		StopMeasure()
	end
	AlignTo("","Destination")
	Sleep(2)
	PlayAnimation("","manipulate_middle_twohand")
	SetMeasureRepeat(TimeOut)
	AddImpact("Destination","polluted",1,duration)
	SetState("Destination",STATE_CONTAMINATED,true)
	-- Fajeth Mod
	SetProperty("Destination","PollutedWell",1)
	-- Mod End
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end




function CleanUp()

	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end


