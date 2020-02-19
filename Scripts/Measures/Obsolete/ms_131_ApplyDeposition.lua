function Run()

	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)

	if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
		return
	end

	if not GetInsideBuilding("","councilbuilding") then
		return
	end

	if not GetHomeBuilding("","HomeBuilding") then
		MsgQuick("", "@L_PRIVILEGES_131_APPLYDEPOSITION_+1",GetID("city"))
		return
	end

	if (GetSettlementID("councilbuilding") ~= GetSettlementID("HomeBuilding")) then
		MsgQuick("", "@L_PRIVILEGES_131_APPLYDEPOSITION_FAILURES_+1",GetID("city"))
		return
	end

	if not HasProperty("councilbuilding","CutsceneAhead") then
		if HasProperty("councilbuilding","CityLevelUpAhead") then
			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+1")
			return
		end
	end
	
	if not GetSettlement("councilbuilding", "city") then
		return
	end

	if not GetLocatorByName("councilbuilding", "ApproachUsherPos", "destpos") then
		MsgQuick("", "@L_PRIVILEGES_131_APPLYDEPOSITION_FAILURES_+0")
		return
	end

	while true do
		if not IsGUIDriven() then
			if ai_IsDeploymentInProgress("DepositVictim") then
				return
			end
		end

		if f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
			break
		end
		Sleep(2)

	end
	
	if HasProperty("councilbuilding","MeetingTasks") then
		if GetProperty("councilbuilding","MeetingTasks") >= 4 then
			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+3")
			return
		end
	end			

	SetData("ReleaseLocator", 1)

	BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 1,"Usher")

	--cutscene cam
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Usher")
	CutsceneCameraCreate("cutscene","")
	camera_CutsceneBothLock("cutscene", "")

	PlayAnimationNoWait("","talk")
	MsgSay("","@L_PRIVILEGES_131_APPLYDEPOSITION_COMMENT_ACTOR",GetID("destination"))
	-- MsgMeasure("","You charge somebody(debug)")

	--WalkTo Scribe locator

	-- der sim erzeugt ein settlementevent mit alias "trial"
	-- das event erhält automatisch einen termin, und eine guildworldID.

	camera_CutsceneBothLockCam("cutscene", "Usher", "Far_HUpYRight")

	if GetImpactValue("destination","holdoffice") ~= 1 then
		if SimApplyDeposition("","destination") then
			if DynastyIsPlayer("Owner") then
				chr_ModifyFavor("destination","Owner", -15)
			end
			PlayAnimationNoWait("Usher",ms_131_applydeposition_getRandomTalk())
			MsgSay("Usher","@L_PRIVILEGES_131_APPLYDEPOSITION_COMMENT_TOWN_CLERK_SUCCESS",GetID("destination"))
			SetMeasureRepeat(TimeUntilRepeat)
		else
			PlayAnimationNoWait("Usher",ms_131_applydeposition_getRandomTalk())
			MsgSay("Usher","@L_PRIVILEGES_131_APPLYDEPOSITION_COMMENT_TOWN_CLERK_FAILED",GetID("destination"))
		end
	else
		PlayAnimationNoWait("Usher",ms_131_applydeposition_getRandomTalk())
		MsgSay("Usher","@L_PRIVILEGES_131_APPLYDEPOSITION_COMMENT_TOWN_CLERK_FAILED",GetID("destination"))
	end
	StopAnimation("")
	StopAnimation("Usher")
	f_StrollNoWait("",250,1)
	StopMeasure()
end

function getRandomTalk()
	local TargetArray = {"sit_talk_short","sit_talk","sit_talk_02"}
	local TargetCount = 3
	return TargetArray[Rand(TargetCount)+1]
end

function CleanUp()
	DestroyCutscene("cutscene")
	if GetData("ReleaseLocator")==1 then
		f_EndUseLocatorNoWait("","destpos", GL_STANCE_STAND)
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

