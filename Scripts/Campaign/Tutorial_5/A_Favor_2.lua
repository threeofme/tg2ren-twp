-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Favor_2"
----
----
----
----	1. function Bind
----
----	2. Bind / Start the next Quest(s)
----
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
----	1. function Bind
-------------------------------------------------------------------------------
function Bind()
	SetQuestSource("#TutNPC1")
	SetQuestDestination("#TutNPC1")
	return true
end

function CheckStart()
	return true
end

function Start()
	a_favor_2_DoTalk()
	SetProperty("#TutNPC1","NoBard",0)
	KillQuest()
end

function CheckEnd()
	return false
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
end



function DoTalk()
	HideTutorialBox()
	
	SimSetBehavior("#TutNPC1","")
	
	chr_AlignExact("", "#TutNPC1", 128)

	SetState("Actor", STATE_LOCKED, true)
	SetState("#TutNPC1", STATE_LOCKED, true)

	AlignTo("#TutNPC1", "Actor")
	AlignTo("Actor", "#TutNPC1")

	SetAvoidanceGroup("Actor", "#TutNPC1")
	MoveSetActivity("Actor", "converse")
	MoveSetActivity("#TutNPC1", "converse")

	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","Actor")
	CutsceneAddSim("cutscene","#TutNPC1")
	CutsceneCameraCreate("cutscene","Actor")

	-- Actually speak out the compliment
	camera_CutscenePlayerLock("cutscene", "#TutNPC1")

	Sleep(1)

	PlayAnimationNoWait("#TutNPC1", "talk")

	MsgSay("#TutNPC1","@L_TUTORIAL_CHAPTER_5_FAVOR_CHARACTER_1_SPEECH")

	StopAnimation("#TutNPC1")

	DestroyCutscene("cutscene")
	ReleaseAvoidanceGroup("Actor")
	MoveSetActivity("Actor")

	ReleaseAvoidanceGroup("#TutNPC1")
	MoveSetActivity("#TutNPC1")

	SetState("Actor", STATE_LOCKED, false)
	SetState("#TutNPC1", STATE_LOCKED, false)
	
	SimSetBehavior("#TutNPC1", "QuestNPCStrollMarket")
	
	ShowTutorialBoxNoWait(100, 640, 500, 175, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_5_FAVOR_NAME",  "@L_TUTORIAL_CHAPTER_5_FAVOR_TASK",  "Hud/Buttons/btn_046_StartDialog.tga")
end


