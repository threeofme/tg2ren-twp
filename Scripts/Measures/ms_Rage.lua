-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_Rage"
----
----	With this measure the player can get a bonus on the fighting skill of
----  himselfe and his fellows
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	MeasureSetNotRestartable()
	chr_StartRage("")
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

