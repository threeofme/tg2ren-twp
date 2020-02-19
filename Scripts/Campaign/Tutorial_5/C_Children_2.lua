-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\C_Children_2"
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

	SetMainQuest("Children")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_5_CHILDREN_COHABIT_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_5_CHILDREN_COHABIT_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_CHILDREN_COHABIT_NAME","@L_TUTORIAL_CHAPTER_5_CHILDREN_COHABIT_QUESTBOOK")
	
	SetExclusiveMeasure("#Player", "CohabitWithCharacter", EN_BOTH)
	SetExclusiveMeasure("#Spoose", "CohabitWithCharacter", EN_PASSIVE)
	
	ShowTutorialBoxNoWait(100, 640, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_5_CHILDREN_COHABIT_NAME",  "@L_TUTORIAL_CHAPTER_5_CHILDREN_COHABIT_TASK",  "HUD/Buttons/btn_044_CohabitWithCharacter.tga")
end

function CheckEnd()
	if GetState("#Spoose",STATE_PREGNANT) then
		HideTutorialBox()
		Sleep(5)
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_NAME","@L_TUTORIAL_CHAPTER_5_EXIT")

	KillQuest()
	
	CampaignExit(true)
end




