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
	SetQuestSource("#TutNPC3")
	SetQuestDestination("#TutNPC3")
	return true
end

function CheckStart()
	return true
end

function Start()
	b_classes_4_DoTalk()
	
	SetProperty("#TutNPC3","NoBard",0)
	KillQuest()
end

function CheckEnd()
	return false
end


function Run()
	b_classes_4_DoTalk()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
end


function DoTalk()
	HideTutorialBox()
	
	SimSetBehavior("#TutNPC3","")
	
	chr_AlignExact("", "#TutNPC3", 128)

	SetState("Actor", STATE_LOCKED, true)
	SetState("#TutNPC3", STATE_LOCKED, true)

	AlignTo("#TutNPC3", "Actor")
	AlignTo("Actor", "#TutNPC3")

	SetAvoidanceGroup("Actor", "#TutNPC3")
	MoveSetActivity("Actor", "converse")
	MoveSetActivity("#TutNPC3", "converse")

	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","Actor")
	CutsceneAddSim("cutscene","#TutNPC3")
	CutsceneCameraCreate("cutscene","Actor")

	-- Actually speak out the compliment
	camera_CutscenePlayerLock("cutscene", "#TutNPC3")

	Sleep(1)

	PlayAnimationNoWait("#TutNPC3", "talk")

	local Gender = SimGetGender("#TutNPC3")
	local Genderlabel = "+1"
	if (Gender == GL_GENDER_FEMALE) then
		Genderlabel = "+0"
	end

	MsgSay("#TutNPC3","@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_SCHOLAR_SPEECH_"..Genderlabel)

	StopAnimation("#TutNPC3")

	DestroyCutscene("cutscene")
	ReleaseAvoidanceGroup("Actor")
	MoveSetActivity("Actor")

	ReleaseAvoidanceGroup("#TutNPC3")
	MoveSetActivity("#TutNPC3")

	SetState("Actor", STATE_LOCKED, false)
	SetState("#TutNPC3", STATE_LOCKED, false)
	
	SimSetBehavior("#TutNPC3", "QuestNPCStrollMarket")
	
	ShowTutorialBoxNoWait(100, 650, 500, 175, 1, LEFTLOWER_NOARROW,  "@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_TASK",  "Hud/Buttons/btn_046_StartDialog.tga")
	
	AlignTo("Actor", "")
end




