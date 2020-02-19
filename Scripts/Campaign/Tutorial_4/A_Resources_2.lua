-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\A_Resources_2"
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
	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_MAKET_PLACE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_MAKET_PLACE_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_MAKET_PLACE_NAME","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_MAKET_PLACE_QUESTBOOK")
end


function CheckEnd()
	return true
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
	StartQuest("A_Resources_3","#Player","",false)

	KillQuest()
end




