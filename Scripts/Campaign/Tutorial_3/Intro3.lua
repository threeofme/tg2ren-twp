-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\Intro1"
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
-------------------------------------------------------------------------------
----	Disable the HUD measure >BuildBuilding<
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
	SetMainQuestTitle("Tutorial", "@L_TUTORIAL_CHAPTER_3_NAME")
	SetMainQuestDescription("Tutorial","@L_TUTORIAL_CHAPTER_3_WELCOME")	

	SetMainQuest("Tutorial")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_WELCOME",true)	
-------------------------------------------------------------------------------
----	Show the intro text of the chapter
-------------------------------------------------------------------------------
	SetState("#Player", STATE_CUTSCENE, true)
	
	HudEnableElement("BuildBuilding", false)
	
	Sleep(3)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_NAME","@L_TUTORIAL_CHAPTER_3_WELCOME")
	
		
end

function Run()
end

function CheckEnd()
	return true
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()

	StartQuest("A_Build_1","#Player","",false)

	KillQuest()	
end




