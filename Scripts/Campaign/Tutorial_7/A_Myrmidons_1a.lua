-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Myrmidons_1a"
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
	SetMainQuestTitle("Myrmidons", "@L_TUTORIAL_CHAPTER_7_MYRMIDONS_NAME")
	SetMainQuestDescription("Myrmidons","@L_TUTORIAL_CHAPTER_7_MYRMIDONS_QUESTBOOK")	
	
	SetMainQuest("Myrmidons")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_7_MYRMIDONS_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_7_MYRMIDONS_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_7_MYRMIDONS_NAME","@L_TUTORIAL_CHAPTER_7_MYRMIDONS_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 700, 450, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_7_MYRMIDONS_NAME",  "@L_TUTORIAL_CHAPTER_7_MYRMIDONS_TASK",  "")
	
	CreditMoney("#Player",1000,"Hire Worker")
	
	HireWorker("#Residence","#MyMyrmidon")
	
	SetExclusiveMeasure("#MyMyrmidon", "run", EN_BOTH)
	SetExclusiveMeasure("#MyMyrmidon", "Walk", EN_BOTH)
	
	IncrementSkillValue("#MyMyrmidon",fighting, 7)
	IncrementXP("#MyMyrmidon",5000)	
					
	GetLocatorByName("#Residence","Stroll1","Stroll1")
	StopAllAnimations("#MyMyrmidon")
	SimBeamMeUp("#MyMyrmidon","Stroll1")		
end

function CheckEnd()
	if GetInsideBuildingID("#MyMyrmidon") == -1 then
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_7_MYRMIDONS_NAME","@L_TUTORIAL_CHAPTER_7_MYRMIDONS_SUCCESS")
	
	StartQuest("A_Myrmidons_1b","#Player","",false)
	
	KillQuest()
end




