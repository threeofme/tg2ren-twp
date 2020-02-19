-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_SendApplicant"
----
----	With this measure the player can send an applicant to court a partner
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	if not GetHomeBuilding("","MyHome") then
		StopMeasure()
	end
	
	if not GetLocatorByName("MyHome","entry1","ApplicantSpawnPos") then
		StopMeasure()
	end
	
	CalculateCourtingDifficulty("", "Destination")
	SetProperty("", "LoverID", GetID("Destination"))
	if not (MsgBox("", 0, "CourtLover", 0, 0) == "O") then
		RemoveProperty("", "LoverID")
		StopMeasure()
	end
	SimSetCourtLover("", "Destination")
	
	if not SimCreate(903, "MyHome", "ApplicantSpawnPos", "Applicant") then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	SetMeasureRepeat(TimeOut)
	
	SetProperty("Applicant","DestID",GetID("Destination"))
	SetProperty("Applicant","MrApplicant",GetID(""))
	SimSetBehavior("Applicant","DoCourting")
	
end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

