-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\A_Resources_3"
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
	SetMainQuest("Resources")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_IRON_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_IRON_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_IRON_NAME","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_IRON_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 650, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_IRON_NAME",  "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_IRON_TASK",  "Hud/Items/Item_Iron.tga")

	StartQuest("A_Resources_3b","#Player","",false)
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
	KillQuest()
end




