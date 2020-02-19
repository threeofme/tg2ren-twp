-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_2\A_Character_2"
----
----	GET CHAR OVERVIEW INFO
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

	SetState("#Player", STATE_CUTSCENE, true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_OVERVIEW_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_OVERVIEW_QUESTBOOK")

	StartQuest("A_Character_3","#Player","",false)

	KillQuest("A_Character_2")	
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
end




