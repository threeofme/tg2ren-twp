-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_103_CurryFavor"
----
----	with this privilege the office bearer can force a friendship to an sim
----	
----
-------------------------------------------------------------------------------

function Run()
	if (GetState("", STATE_CUTSCENE)) then
		ms_103_curryfavor_Cutscene()
	else
		ms_103_curryfavor_Normal()
	end
end


function Normal()

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while the owner is talking
	local ActionDistance = 120
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	local OwnerRhetoric = (GetSkillValue("",RHETORIC))
	local DestinationRhetoric = (GetSkillValue("Destination",RHETORIC))
	local OwnerGender = (SimGetGender(""))
	local DestinationGender = (SimGetGender("Destination"))
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	SetData("CameraActive",1)
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Destination")
	CutsceneCameraCreate("cutscene","")		
	camera_CutsceneBothLock("cutscene", "")	-- irgend ein befehl um die cutscene camera zu setzen
	
	--look at each other
	feedback_OverheadActionName("Destination")
	AlignTo("", "Destination")
	AlignTo("Destination", "")
	Sleep(0.5)
	
	SetRepeatTimer("", GetMeasureRepeatName2("CurryFavor"), TimeOut)
	
	--combine textlabel by checking rhetoric skill for text1
	local RhethoricType
	if OwnerRhetoric < 4 then
		RhethoricType = "_WEAK_RHETORIC"
	elseif OwnerRhetoric < 7 then
		RhethoricType = "_NORMAL_RHETORIC"
	else
		RhethoricType = "_GOOD_RHETORIC"
	end
	
	PlayAnimationNoWait("","talk")
	MsgSay("","@L_PRIVILEGES_103_CURRYFAVOR_ACTOR"..RhethoricType)
	
	--combine textlabel by checking rhetoric skill and gender for text2
	local RhethoricType
	if DestinationRhetoric < 4 then
		RhethoricType2 = "_WEAK_RHETORIC"
	elseif OwnerRhetoric < 7 then
		RhethoricType2 = "_NORMAL_RHETORIC"
	else
		RhethoricType2 = "_GOOD_RHETORIC"
	end
	camera_CutsceneBothLock("cutscene", "Destination")	
	PlayAnimationNoWait("Destination","talk")
	MsgSay("Destination","@L_PRIVILEGES_103_CURRYFAVOR_DESTINATION_SUCCESS"..RhethoricType2)
	PlayAnimation("Destination","bow")
	chr_GainXP("",GetData("BaseXP"))
	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_PRIVILEGES_103_CURRYFAVOR_MSG_VICTIM_HEAD_+0",
		"@L_PRIVILEGES_103_CURRYFAVOR_MSG_VICTIM_BODY_+0",GetID("Destination"),GetID(""))
	
	--force dynasty relations to alliance
	DynastySetMinDiplomacyState("", "Destination", DIP_ALLIANCE, GetID(""), duration)
	DynastyForceCalcDiplomacy("")
	DynastyForceCalcDiplomacy("Destination")
	StopMeasure()

end



function Cutscene()

	if SimGetCutscene("","cutscene") then
		CutsceneSetMeasureLockTime("cutscene", 2.0)
	end
	
	Sleep(1)

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while the owner is talking
	local ActionDistance = 40
	--how long the friendship will be 
	--time before privilege can be used again
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	local OwnerRhetoric = (GetSkillValue("",RHETORIC))
	local DestinationRhetoric = (GetSkillValue("Destination",RHETORIC))
	local OwnerGender = (SimGetGender(""))
	local DestinationGender = (SimGetGender("Destination"))
	
	--run to destination and start action at MaxDistance
--	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
--		StopMeasure()
--	end
	
	SetRepeatTimer("", GetMeasureRepeatName2("CurryFavor"), TimeOut)

	--combine textlabel by checking rhetoric skill and gender for text2
	local RhethoricType
	if DestinationRhetoric < 4 then
		RhethoricType2 = "_WEAK_RHETORIC"
	elseif OwnerRhetoric < 7 then
		RhethoricType2 = "_NORMAL_RHETORIC"
	else
		RhethoricType2 = "_GOOD_RHETORIC"
	end
	
	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_PRIVILEGES_103_CURRYFAVOR_MSG_VICTIM_HEAD_+0",
		"@L_PRIVILEGES_103_CURRYFAVOR_MSG_VICTIM_BODY_+0",GetID("Destination"),GetID(""))
	
	--force dynasty relations to alliance
	DynastySetMinDiplomacyState("", "Destination", DIP_ALLIANCE, GetID(""), duration)
	DynastyForceCalcDiplomacy("")
	DynastyForceCalcDiplomacy("Destination")
	chr_GainXP("",GetData("BaseXP"))
	if SimGetCutscene("","cutscene") then
		CutsceneCallUnscheduled("cutscene", "UpdatePanel")
		Sleep(0.1)
	else
		return
	end
	
	MsgSay("Destination","@L_PRIVILEGES_103_CURRYFAVOR_DESTINATION_SUCCESS"..RhethoricType2)
	
	StopMeasure()		
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if HasData("CameraActive") then
		DestroyCutscene("cutscene")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end


