-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Myrmidons_1b"
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

	SetMainQuestTitle("Myrmidons", "@L_TUTORIAL_CHAPTER_7_COMBAT_NAME")
	SetMainQuestDescription("Myrmidons","@L_TUTORIAL_CHAPTER_7_COMBAT_QUESTBOOK")	
	
	SetMainQuest("Myrmidons")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_7_COMBAT_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_7_COMBAT_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_7_COMBAT_NAME","@L_TUTORIAL_CHAPTER_7_COMBAT_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 630, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_7_COMBAT_NAME",  "@L_TUTORIAL_CHAPTER_7_COMBAT_TASK",  "Hud/Buttons/btn_036_AttackEnemy.tga")
	
	StartQuest("A_Myrmidons_1c","#Player","",false)
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
end




