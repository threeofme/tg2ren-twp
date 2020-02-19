-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_ArrangeLiaison"
----
----	with this measure the player can arrange a liaison
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	local InteractionDistance = 115
	
	-- Get the court lover and call it "Destination" because the older version of the measure worked with a selection
	if not SimGetCourtLover("", "Destination") then
		StopMeasure()
		return
	end
	
	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		StopMeasure()
		return
	end
	
	SetAvoidanceGroup("", "Destination")
	MoveSetActivity("", "converse")
	MoveSetActivity("Destination", "converse")
	
	feedback_OverheadActionName("Destination")
	Sleep(0.5)
	
	chr_AlignExact("", "Destination", InteractionDistance)
		
	----------
	-- Propose
	----------	
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","destination")
	CutsceneCameraCreate("cutscene","")			
	
	camera_CutsceneBothLock("cutscene", "")
	local OwnerAnimLength = PlayAnimationNoWait("", "proposal_male")
	local DestinationAnimLength = PlayAnimationNoWait("Destination", "proposal_female")
	local AnimLength = 0
	if (OwnerAnimLength > DestinationAnimLength) then
		AnimLength = OwnerAnimLength
	else
		AnimLength = DestinationAnimLength
	end
	
	Sleep(AnimLength * 0.4)
	
--	MsgSay("", talk_AskLiaison(GetSkillValue("", RHETORIC), SimGetGender("")));
	
	camera_CutscenePlayerLock("cutscene", "Destination")
	MsgSay("Destination", talk_AnswerLiaison(GetSkillValue("Destination", RHETORIC), SimGetGender("Destination")));		
	
	SimArrangeLiaison("", "Destination")
	local Difficulty = GetProperty("Destination", "CourtDiff")
	xp_CourttingSuccess("", Difficulty)
	RemoveProperty("Destination", "CourtDiff")
	StopMeasure()
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	
	DestroyCutscene("cutscene")
	ReleaseAvoidanceGroup("")
	MoveSetActivity("")
	StopAnimation("")
	
	if AliasExists("Destination") then
		MoveSetActivity("Destination")
		feedback_OverheadActionName("Destination")
		SimLock("Destination", 0.25)
	end	
	
end

