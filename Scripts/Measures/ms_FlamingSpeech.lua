-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_FlamingSpeech"
----
----	With this measure the player can deliver a flaming speech and influence
----  the peoples favor
----  
----  1. Sim geht zum Zielgebiet und hält die Rede
----  2. Jeder Sim im Aktionsradius jubelt dem König zu
----  3. Die Gunst dieser Sims zu einem steigt dadurch (mögl. auch die der Sims innerhalb von Gebäuden)
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	if not f_MoveTo("","Destination") then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--do the progress bar stuff
	local Time = GetGametime()
	local EndTime = Time + duration
	SetData("Time",duration)
	SetData("EndTime",EndTime)
	SetProcessMaxProgress("",duration*10)
	SendCommandNoWait("","Progress")
	
	CommitAction("flamingspeech","","")
	
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	
	while GetGametime() < EndTime do
		MsgSay("","@L_PRIVILEGES_FLAMINGSPEECH")
		Sleep(5)
	end
	
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end

function Progress()
	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime") 
		local CurrentTime = GetGametime() 
		CurrentTime = EndTime - CurrentTime 
		CurrentTime = Time - CurrentTime 
		SetProcessProgress("",CurrentTime*10)
		Sleep(3)
	end
end

function CleanUp()
	ResetProcessProgress("")
	StopAnimation("")
	StopAction("flamingspeech", "")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

