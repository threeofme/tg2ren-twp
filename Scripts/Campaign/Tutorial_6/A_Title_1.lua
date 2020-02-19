-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Title_1"
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

	SetMainQuestTitle("Title", "@L_TUTORIAL_CHAPTER_6_BUY_TITLE_NAME")
	SetMainQuestDescription("Title","@L_TUTORIAL_CHAPTER_6_BUY_TITLE_QUESTBOOK")	
	
	SetMainQuest("Title")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_6_BUY_TITLE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_6_BUY_TITLE_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_6_BUY_TITLE_NAME","@L_TUTORIAL_CHAPTER_6_BUY_TITLE_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 690, 450, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_6_BUY_TITLE_NAME",  "@L_TUTORIAL_CHAPTER_6_BUY_TITLE_TASK",  "")
end

function CheckEnd()
	if (GetInsideBuildingID("#Player") == GetID("#CouncilBuilding") and CameraIndoorGetBuilding("CameraBuilding") and GetID("CameraBuilding") == GetID("#CouncilBuilding")) then
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
	StartQuest("A_Title_2","#Player","",false)

	KillQuest()
end




