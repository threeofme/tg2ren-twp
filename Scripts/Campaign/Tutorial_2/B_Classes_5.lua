-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_2\B_Classes_5"
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
	SetQuestSource("#TutNPC4")
	SetQuestDestination("#TutNPC4")
	return true
end

function CheckStart()
	return true
end

function Start()
	b_classes_5_DoTalk()
	
	SetProperty("#TutNPC4","NoBard",0)
	KillQuest()
end

function CheckEnd()
	return false
end


function Run()
	b_classes_5_DoTalk()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
end


function DoTalk()
	HideTutorialBox()
	
	SimSetBehavior("#TutNPC4","")
	
	chr_AlignExact("", "#TutNPC4", 128)

	SetState("Actor", STATE_LOCKED, true)
	SetState("#TutNPC4", STATE_LOCKED, true)

	AlignTo("#TutNPC4", "Actor")
	AlignTo("Actor", "#TutNPC4")

	SetAvoidanceGroup("Actor", "#TutNPC4")
	MoveSetActivity("Actor", "converse")
	MoveSetActivity("#TutNPC4", "converse")

	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","Actor")
	CutsceneAddSim("cutscene","#TutNPC4")
	CutsceneCameraCreate("cutscene","Actor")

	-- Actually speak out the compliment
	camera_CutscenePlayerLock("cutscene", "#TutNPC4")

	Sleep(1)

	PlayAnimationNoWait("#TutNPC4", "talk")

	local Gender = SimGetGender("#TutNPC4")
	local Genderlabel = "+1"
	if (Gender == GL_GENDER_FEMALE) then
		Genderlabel = "+0"
	end

	MsgSay("#TutNPC4","@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_CHISELER_SPEECH_"..Genderlabel)

	StopAnimation("#TutNPC4")

	DestroyCutscene("cutscene")
	ReleaseAvoidanceGroup("Actor")
	MoveSetActivity("Actor")

	ReleaseAvoidanceGroup("#TutNPC4")
	MoveSetActivity("#TutNPC4")

	SetState("Actor", STATE_LOCKED, false)
	SetState("#TutNPC4", STATE_LOCKED, false)
	
	SimSetBehavior("#TutNPC4", "QuestNPCStrollMarket")
	
	ShowTutorialBoxNoWait(100, 650, 500, 175, 1, LEFTLOWER_NOARROW,  "@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_TASK",  "Hud/Buttons/btn_046_StartDialog.tga")
	
	AlignTo("Actor", "")
end



