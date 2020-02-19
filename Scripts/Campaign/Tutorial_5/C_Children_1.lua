-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\C_Children_1"
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

	SetMainQuestTitle("Children", "@L_TUTORIAL_CHAPTER_5_CHILDREN_NAME")
	SetMainQuestDescription("Children","@L_TUTORIAL_CHAPTER_5_CHILDREN_QUESTBOOK")	

	SetMainQuest("Children")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_5_CHILDREN_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_5_CHILDREN_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_CHILDREN_NAME","@L_TUTORIAL_CHAPTER_5_CHILDREN_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 690, 450, 160, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_5_CHILDREN_NAME",  "@L_TUTORIAL_CHAPTER_5_CHILDREN_TASK",  "")
end

function CheckEnd()
	if (GetInsideBuildingID("#Player") == GetID("#Residence") and GetInsideBuildingID("#Spoose") == GetID("#Residence") and CameraIndoorGetBuilding("CameraBuilding") and GetID("CameraBuilding") == GetID("#Residence")) then
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_CHILDREN_NAME","@L_TUTORIAL_CHAPTER_5_CHILDREN_SUCCESS")

	StartQuest("C_Children_2","#Player","",false)

	KillQuest()
end




