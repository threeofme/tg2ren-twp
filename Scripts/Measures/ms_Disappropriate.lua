-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_Disappropriate"
----
----	With this measure the player can disappropriate and capture a building
----  
----  1. Das Gebäude geht in den Besitz des Sims über
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	BuildingGetOwner("Destination","Victim")
	
	if not GetOutdoorMovePosition("","Destination","MovePos") then
		StopMeasure()
	end
	
	if not f_MoveTo("","MovePos") then
		StopMeasure()
	end
	
	MsgSay("","@L_PRIVILEGES_DISAPPROPRIATE_SPEECH",GetID("Destination"))
	
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	chr_GainXP("",GetData("BaseXP"))
	chr_ModifyFavor("Victim","",-50)
	
	MsgNewsNoWait("","Victim","","politics",-1,
				"@L_PRIVILEGES_DISAPPROPRIATE_MSG_ACTOR_HEAD_+0",
				"@L_PRIVILEGES_DISAPPROPRIATE_MSG_ACTOR_BODY_+0", GetID("Destination"),GetID("Victim"))
	MsgNewsNoWait("Victim","","","politics",-1,
				"@L_PRIVILEGES_DISAPPROPRIATE_MSG_VICTIM_HEAD_+0",
				"@L_PRIVILEGES_DISAPPROPRIATE_MSG_VICTIM_BODY_+0", GetID(""),GetID("Destination"),GetNobilityTitleLabel(GetNobilityTitle("")))
	
	BuildingBuy("Destination", "", BM_CAPTURE)
	
	StopMeasure()
	
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

