-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\B_Office_1"
----
----	OPEN CHAR OVERVIEW
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

	SetMainQuestTitle("Office", "@L_TUTORIAL_CHAPTER_6_OFFICE_NAME")
	SetMainQuestDescription("Office","@L_TUTORIAL_CHAPTER_6_OFFICE_QUESTBOOK")

	SetMainQuest("Office")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_6_OFFICE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_6_OFFICE_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_6_OFFICE_NAME","@L_TUTORIAL_CHAPTER_6_OFFICE_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 640, 500, 175, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_6_OFFICE_NAME",  "@L_TUTORIAL_CHAPTER_6_OFFICE_TASK",  "Hud/Buttons/btn_118_RunForAnOffice.tga")
	SetExclusiveMeasure("#Player","RunForAnOffice",EN_BOTH)
end

function CheckEnd()
	local time = GetGametime()
	if (time >= 12) then
		HideTutorialBox()
		StartQuest("End6","#Player","",false)
		KillQuest()		
	end
	if (SimIsAppliedForOffice("#Player") == true) then
		ForbidMeasure("#Player","RunForAnOffice",EN_BOTH)
		HideTutorialBox()
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
	Sleep(4)
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_6_OFFICE_NAME","@L_TUTORIAL_CHAPTER_6_OFFICE_SUCCESS")
	
	StartQuest("B_Office_2","#Player","",false)

	KillQuest()
end




