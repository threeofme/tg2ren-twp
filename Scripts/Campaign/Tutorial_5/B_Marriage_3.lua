-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\B_Marriage_3"
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

	SetMainQuest("Marriage")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_5_MARRIAGE_FINAL_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_5_MARRIAGE_FINAL_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_MARRIAGE_FINAL_NAME","@L_TUTORIAL_CHAPTER_5_MARRIAGE_FINAL_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 640, 550, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_5_MARRIAGE_FINAL_NAME",  "@L_TUTORIAL_CHAPTER_5_MARRIAGE_FINAL_TASK",  "Hud/Buttons/btn_marry.tga", GetID("#Spoose"))
	
	SetExclusiveMeasure("#Player", "Marry", EN_BOTH)
	SetExclusiveMeasure("#Spoose", "Marry", EN_PASSIVE)
end

function CheckEnd()
	if SimGetSpouse("#Player","MySpoose") and GetID("MySpoose") == GetID("#Spoose") then
		ForbidMeasure("#Player", "Marry", EN_BOTH)
		ForbidMeasure("#Spoose", "Marry", EN_BOTH)		
		
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_MARRIAGE_FINAL_NAME","@L_TUTORIAL_CHAPTER_5_MARRIAGE_FINAL_SUCCESS")
	SimSetBehavior("#Spoose","")
	f_MoveToNoWait("#Spoose","#Residence",GL_MOVESPEED_RUN)

	StartQuest("C_Children_1","#Player","",false)

	KillQuest()
end




