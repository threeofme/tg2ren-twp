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

	SetMainQuestTitle("Marriage", "@L_TUTORIAL_CHAPTER_5_MARRIAGE_NAME")
	SetMainQuestDescription("Marriage","@L_TUTORIAL_CHAPTER_5_MARRIAGE_QUESTBOOK")	

	SetMainQuest("Marriage")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_5_MARRIAGE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_5_MARRIAGE_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_MARRIAGE_NAME","@L_TUTORIAL_CHAPTER_5_MARRIAGE_QUESTBOOK")
	SetProperty("#Player","Tutorial",1)
	
	AddImpact("#Spoose","FinnishQuest",1,-1)	
	
	ShowTutorialBoxNoWait(100, 640, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_5_MARRIAGE_NAME",  "@L_TUTORIAL_CHAPTER_5_MARRIAGE_TASK",  "HUD/Buttons/btn_045_CourtLover.tga", GetID("#Spoose"))
	
	StartQuest("B_Marriage_1b","#Player","",false)
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




