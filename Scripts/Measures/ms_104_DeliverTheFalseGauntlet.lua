-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_104_DeliverTheFalseGauntlet"
----
----	with this privilege the office bearer can decrease the favor of a dynasty
----	(Destination) towards an character (Believer)
----
-------------------------------------------------------------------------------

function Init()
	if not AliasExists("Believer") then
		InitAlias("Believer",MEASUREINIT_SELECTION, "__F(NOT(Object.BelongsToMe()))",
					"@L_PRIVILEGES_104_DELIVERTHEFALSEGAUNTLET_TARGET2"
					,ms_104_deliverthefalsegauntlet_AIInit)
		MsgMeasure("","")
	end

end

function Run()

	--how far the Destination can be to start this action
	local MaxDistance = 3000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 120
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	--amount of favor
	local ModifyValue = (GetSkillValue("",RHETORIC)*2)
	if ModifyValue < 5 then
		ModifyValue = 5	
	end
	local OwnerRhetoric = (GetSkillValue("",RHETORIC))
	local BelieverRhetoric = (GetSkillValue("Believer",RHETORIC))
	local BelieverGender = (SimGetGender("Believer"))
	local DestinationGender = (SimGetGender("Destination"))

	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Believer", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	SetData("CameraActive",1)
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Believer")
	CutsceneCameraCreate("cutscene","")		
	camera_CutsceneBothLock("cutscene", "")
	
	AlignTo("Owner", "Believer")
	AlignTo("Believer", "Owner")
	Sleep(0.5)
	
	time1 = PlayAnimationNoWait("Owner", "talk_short")
	Sleep(time1)
	
	
	--combine textlabel by checking rhetoric skill and gender
	local RhethoricType
	if OwnerRhetoric < 4 then
		RhethoricType = "_WEAK_RHETORIC"
	elseif OwnerRhetoric < 7 then
		RhethoricType = "_NORMAL_RHETORIC"
	else
		RhethoricType = "_GOOD_RHETORIC"
	end
	
	local GenderType
	if BelieverGender == 0 then
		GenderType = "_TOFEMALE"
	else
		GenderType = "_TOMALE"
	end
	time1 = PlayAnimationNoWait("Believer", "talk_short")
	Sleep(time1)
	MsgSay("","@L_PRIVILEGES_104_DELIVERTHEFALSEGAUNTLET_ACTOR"..RhethoricType..GenderType, GetID("Destination"))
	
	
	--combine textlabel by checking rhetoric skill and gender
	local RhethoricType2
	if BelieverRhetoric < 4 then
		RhethoricType2 = "_WEAK_RHETORIC"
	elseif OwnerRhetoric < 7 then
		RhethoricType2 = "_NORMAL_RHETORIC"
	else
		RhethoricType2 = "_GOOD_RHETORIC"
	end
	
	local GenderType2
	if DestinationGender == 0 then
		GenderType2 = "_ABOUTFEMALE"
	else
		GenderType2 = "_ABOUTMALE"
	end
	camera_CutsceneBothLock("cutscene", "Believer")
	MsgSay("Believer","@L_PRIVILEGES_104_DELIVERTHEFALSEGAUNTLET_DESTINATION_SUCCESS"..RhethoricType2..GenderType2)
	
	Sleep(time1)
	
	--modify the favor
	ModifyFavorToDynasty("Believer","Destination",-ModifyValue)
	
	-- reset the timer for this action
	SetRepeatTimer("", GetMeasureRepeatName2("DeliverTheFalseGauntlet"), TimeOut)
	chr_GainXP("",GetData("BaseXP"))
	-- let the other sim be locked/waiting for a moment
	SimLock("Believer", 1)
	
	MsgNewsNoWait("Believer","Destination","","intrigue",-1,
		"@L_PRIVILEGES_104_DELIVERTHEFALSEGAUNTLET_MSG_BELIEVER_HEADLINE",
			"@L_PRIVILEGES_104_DELIVERTHEFALSEGAUNTLET_MSG_BELIEVER_BODY",GetID(""),GetID("Destination"))

	MsgNewsNoWait("Destination","Believer","","intrigue",-1,
		"@L_PRIVILEGES_104_DELIVERTHEFALSEGAUNTLET_MSG_VICTIM_HEADLINE",
			"@L_PRIVILEGES_104_DELIVERTHEFALSEGAUNTLET_MSG_VICTIM_BODY",GetID(""),GetID("Believer"))
	
	StopMeasure()

end

function CleanUp()
	if HasData("CameraActive") then
		DestroyCutscene("cutscene")
	end
	feedback_OverheadActionName("Believer")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

