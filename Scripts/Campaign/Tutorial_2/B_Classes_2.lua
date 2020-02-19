-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_2\B_Classes_2"
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
	b_classes_2_DoTalk()
	
	SetProperty("#TutNPC1","NoBard",0)
	KillQuest()
end

function CheckEnd()
	return false
end


function Run()
	b_classes_2_DoTalk()
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

	local Gender = SimGetGender("#TutNPC1")
	local Genderlabel = "+1"
	if (Gender == GL_GENDER_FEMALE) then
		Genderlabel = "+0"
	end

	MsgSay("#TutNPC1","@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_PATRON_SPEECH_"..Genderlabel)

	StopAnimation("#TutNPC1")

	DestroyCutscene("cutscene")
	ReleaseAvoidanceGroup("Actor")
	MoveSetActivity("Actor")

	ReleaseAvoidanceGroup("#TutNPC1")
	MoveSetActivity("#TutNPC1")

	SetState("Actor", STATE_LOCKED, false)
	SetState("#TutNPC1", STATE_LOCKED, false)
	
	SimSetBehavior("#TutNPC1", "QuestNPCStrollMarket")
	
	ShowTutorialBoxNoWait(100, 650, 500, 175, 1, LEFTLOWER_NOARROW,  "@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_TASK",  "Hud/Buttons/btn_046_StartDialog.tga")
	
	AlignTo("Actor", "")
end


