-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Favor_1"
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

	SetMainQuestTitle("Favor", "@L_TUTORIAL_CHAPTER_5_FAVOR_NAME")
	SetMainQuestDescription("Favor","@L_TUTORIAL_CHAPTER_5_FAVOR_QUESTBOOK")	
	
	SetMainQuest("Favor")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_5_FAVOR_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_5_FAVOR_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_FAVOR_NAME","@L_TUTORIAL_CHAPTER_5_FAVOR_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 640, 500, 175, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_5_FAVOR_NAME",  "@L_TUTORIAL_CHAPTER_5_FAVOR_TASK",  "Hud/Buttons/btn_046_StartDialog.tga")
	
	BindQuest("A_Favor_2","#TutNPC1","#Player",false)
	
	BindQuest("A_Favor_3","#TutNPC2","#Player",false)	
	
	SetProperty("#Player","CanTalk",1)
end

function CheckEnd()
	local TotalBard = 0
	local Count
	for Count=1,2 do
		TotalBard = TotalBard + GetProperty("#TutNPC"..Count,"NoBard")
	end
	if TotalBard == 0 then
		HideTutorialBox()
		return true
	end
	return false
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_FAVOR_NAME","@L_TUTORIAL_CHAPTER_5_FAVOR_SUCCESS")

	StartQuest("A_Favor_4","#Player","",false)

	KillQuest()
end




