function Run()
	
	if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
		return
	end

	if not GetInsideBuilding("","councilbuilding") then
		return
	end

	if not GetLocatorByName("councilbuilding", "ApproachUsherPos", "destpos") then
		MsgQuick("", "@L_PRIVILEGES_133_LEAVEOFFICE_FAILURES_+0", GetID("Building"))
		return
	end
	
	if not f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
		MsgQuick("", "@L_PRIVILEGES_133_LEAVEOFFICE_FAILURES_+0", GetID("Building"))
		return
	end
	
	SetData("ReleaseLocator", 1)
	
	--cutscene cam
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneCameraCreate("cutscene","")		
	camera_CutsceneBothLock("cutscene", "")

	PlayAnimationNoWait("","talk")
	MsgSay("","@L_PRIVILEGES_133_LEAVEOFFICE_COMMENT_ACTOR")
	BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 1,"Usher")
	-- MsgMeasure("","You charge somebody(debug)")

	--WalkTo Scribe locator
		
	-- der sim erzeugt ein settlementevent mit alias "trial"
	-- das event erhält automatisch einen termin, und eine guildworldID.

	GetSettlement("", "Settlement")
	CityRemoveFromOffice("Settlement","")
	camera_CutsceneBothLock("cutscene", "Usher")
	PlayAnimationNoWait("Usher","talk")
	MsgSay("Usher","@L_PRIVILEGES_133_LEAVEOFFICE_COMMENT_TOWN_CLERK_SUCCESS")
	-- erzeugt ein event (GuildObject mit ID mit dem alias "trial", Current Sim charges "Destination")
	-- event wird in end
end

function CleanUp()
	DestroyCutscene("cutscene")
	if GetData("ReleaseLocator")==1 then
		f_EndUseLocatorNoWait("","destpos", GL_STANCE_STAND)
	end
end
