-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_2\B_Classes_1"
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

	SetMainQuestTitle("Classes", "@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_NAME")
	SetMainQuestDescription("Classes","@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_QUESTBOOK")	
	
	SetMainQuest("Classes")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_QUESTBOOK",true)
	
	SetState("#Player", STATE_CUTSCENE, true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 640, 500, 175, 1, LEFTLOWER_NOARROW,  "@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_CLASSES_TASK",  "Hud/Buttons/btn_046_StartDialog.tga")
	
	SetProperty("#Player","CanTalk",1)
	SetProperty("#Spoose","CanTalk",1)
	
	SetState("#Player", STATE_CUTSCENE, false)
	
	SetState("#Spoose", STATE_CUTSCENE, false)
	
	BindQuest("B_Classes_2","#TutNPC1","#Player",false)
	
	BindQuest("B_Classes_3","#TutNPC2","#Player",false)
	
	BindQuest("B_Classes_4","#TutNPC3","#Player",false)
	
	BindQuest("B_Classes_5","#TutNPC4","#Player",false)	
end

function CheckEnd()
	local TotalBard = 0
	local Count
	for Count=1,4 do
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
	Sleep(1)
	
	KillQuest()
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_NAME","@L_TUTORIAL_CHAPTER_2_EXIT")
	
	CampaignExit(true)
end




