-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_1\B_CharControl"
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
	return true
end

function CheckStart()
	return true
end

function Start()

	SetMainQuest("Control")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_1_CONTROLS_MOVEMENT_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_1_CONTROLS_MOVEMENT_QUESTBOOK",true)

	SetState("#Player", STATE_CUTSCENE, true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_CONTROLS_MOVEMENT_NAME","@L_TUTORIAL_CHAPTER_1_CONTROLS_MOVEMENT_QUESTBOOK")

	SetState("#Player", STATE_CUTSCENE, false)
	
	ShowTutorialBoxNoWait(100, 700, 470, 180, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_1_CONTROLS_MOVEMENT_NAME",  "@L_TUTORIAL_CHAPTER_1_CONTROLS_MOVEMENT_TASK",  "")
end

function CheckEnd()
	
	local Distance = GetDistance("#Player","#Market")

	if (Distance <= 1600) then
		HideTutorialBox()
		SetState("#Player", STATE_CUTSCENE, true)
		return true
	else
		return false
	end
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
	Sleep(1)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_CONTROLS_MOVEMENT_NAME","@L_TUTORIAL_CHAPTER_1_CONTROLS_MOVEMENT_SUCCESS")

	StartQuest("C_Hud_1_b","#Player","",false)

	KillQuest()
end




