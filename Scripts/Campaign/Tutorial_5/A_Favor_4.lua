-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Favor_4"
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

	SetMainQuest("Favor")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_5_FAVOR_SYSTEM_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_5_FAVOR_SYSTEM_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_FAVOR_SYSTEM_NAME","@L_TUTORIAL_CHAPTER_5_FAVOR_SYSTEM_QUESTBOOK")
	
	SetMainQuest("Favor")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_5_FAVOR_SYSTEM_NAME")
	SetQuestDescription("$N$N",false)
	
	SetMainQuest("Favor")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_5_FAVOR_SYSTEM_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_5_FAVOR_SYSTEM_QUESTBOOK2",false)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_FAVOR_SYSTEM_NAME","@L_TUTORIAL_CHAPTER_5_FAVOR_SYSTEM_QUESTBOOK2")
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

	StartQuest("B_Marriage_1","#Player","",false)

	KillQuest()
end




