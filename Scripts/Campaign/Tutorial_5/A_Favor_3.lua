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
	SetQuestSource("#TutNPC2")
	SetQuestDestination("#TutNPC2")
	return true
end

function CheckStart()
	return true
end

function Start()
	a_favor_3_DoTalk()
	
	SetProperty("#TutNPC2","NoBard",0)
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
	
	SimSetBehavior("#TutNPC2","")
	
	chr_AlignExact("", "#TutNPC2", 128)

	SetState("Actor", STATE_LOCKED, true)
	SetState("#TutNPC2", STATE_LOCKED, true)

	AlignTo("#TutNPC2", "Actor")
	AlignTo("Actor", "#TutNPC2")

	SetAvoidanceGroup("Actor", "#TutNPC2")
	MoveSetActivity("Actor", "converse")
	MoveSetActivity("#TutNPC2", "converse")

	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","Actor")
	CutsceneAddSim("cutscene","#TutNPC2")
	CutsceneCameraCreate("cutscene","Actor")

	-- Actually speak out the compliment
	camera_CutscenePlayerLock("cutscene", "#TutNPC2")

	Sleep(1)

	PlayAnimationNoWait("#TutNPC2", "talk")

	MsgSay("#TutNPC2","@L_TUTORIAL_CHAPTER_5_FAVOR_CHARACTER_2_SPEECH")

	StopAnimation("#TutNPC2")

	DestroyCutscene("cutscene")
	ReleaseAvoidanceGroup("Actor")
	MoveSetActivity("Actor")

	ReleaseAvoidanceGroup("#TutNPC2")
	MoveSetActivity("#TutNPC2")

	SetState("Actor", STATE_LOCKED, false)
	SetState("#TutNPC2", STATE_LOCKED, false)
	
	SimSetBehavior("#TutNPC2", "QuestNPCStrollMarket")
	
	ShowTutorialBoxNoWait(100, 640, 500, 175, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_5_FAVOR_NAME",  "@L_TUTORIAL_CHAPTER_5_FAVOR_TASK",  "Hud/Buttons/btn_046_StartDialog.tga")
end


