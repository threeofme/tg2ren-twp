-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_116_PropitiateEnemies"
----
----	with this privilege the office bearer can increase the favor of two dynastys
----	towards each other 
----
-------------------------------------------------------------------------------

function Init()
	--target text: Wer soll die erste Partei eurer Friedensbemühungen sein
	
	if not AliasExists("Destination2") then
		InitAlias("Destination2",MEASUREINIT_SELECTION, "__F(NOT(Object.BelongsToMe())AND(Object.IsDynastySim()))",
			"@L_PRIVILEGES_116_PROPITIATEENEMIES_SELECT_TARGET2_+0")
	end
	MsgMeasure("","")

end

function Run()
	if not AliasExists("Destination") or not AliasExists("Destination2") then
		StopMeasure()
	end
	if GetDynastyID("Destination") == GetDynastyID("Destination2") then
		MsgQuick("","@L_PRIVILEGES_116_PROPITIATEENEMIES_FAILURES_+0")
		StopMeasure()
	end

	--how far the Destination can be to start this action
	local MaxDistance = 3000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 120
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	--amount of favor
	local ModifyValue = (GetSkillValue("",RHETORIC)*2)
	if ModifyValue < 5 then
		ModifyValue = 5	
	end
	local OwnerRhetoric = (GetSkillValue("",RHETORIC))
	local Destination2Rhetoric = (GetSkillValue("Destination2",RHETORIC))
	local Destination2Gender = (SimGetGender("Destination2"))
	local DestinationGender = (SimGetGender("Destination"))

	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination2", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	SetMeasureRepeat(TimeOut)
	
	SetData("CameraActive",1)
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Destination2")
	CutsceneCameraCreate("cutscene","")		
	camera_CutsceneBothLock("cutscene", "")
	
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
	
	MsgSay("","@L_PRIVILEGES_116_PROPITIATEENEMIES_ACTOR"..RhethoricType, GetID("Destination"))
	camera_CutsceneBothLock("cutscene", "Destination2")
	time1 = PlayAnimationNoWait("Destination2", "talk_short")
	Sleep(time1)
	MsgSay("Destination2","@L_PRIVILEGES_116_PROPITIATEENEMIES_DESTINATION_SUCCESS")
	
	--modify the favor
	ModifyFavorToDynasty("Destination2","Destination",ModifyValue)
	
	-- let the other sim be locked/waiting for a moment
	SimLock("Destination2", 1)
	
	MsgNewsNoWait("Destination","Destination2","","intrigue",-1,
		"@L_PRIVILEGES_116_PROPITIATEENEMIES_MSG_VICTIM_1_HEAD",
		"@L_PRIVILEGES_116_PROPITIATEENEMIES_MSG_VICTIM_1_BODY",GetID(""),GetID("Destination2"))
	
	MsgNewsNoWait("Destination2","Destination","","intrigue",-1,
		"@L_PRIVILEGES_116_PROPITIATEENEMIES_MSG_VICTIM_2_HEAD",
		"@L_PRIVILEGES_116_PROPITIATEENEMIES_MSG_VICTIM_2_BODY",GetID(""),GetID("Destination2"),GetID("Destination"))
	
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()

end

function CleanUp()
	if HasData("CameraActive") then
		DestroyCutscene("cutscene")
	end
	if AliasExists("Destination2") then
		feedback_OverheadActionName("Destination2")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

