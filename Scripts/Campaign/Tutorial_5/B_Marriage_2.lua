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

	SetMainQuest("Marriage")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_NAME","@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 640, 550, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_NAME",  "@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_TASK",  "", GetID("#Spoose"))
	
	SetExclusiveMeasure("#Player", "HugCharacter", EN_BOTH)
	SetExclusiveMeasure("#Player", "KissCharacter", EN_BOTH)
	SetExclusiveMeasure("#Player", "UsePerfume", EN_BOTH)
	SetExclusiveMeasure("#Player", "MakeAPresent", EN_BOTH)
	SetExclusiveMeasure("#Player", "MakeACompliment", EN_BOTH)
	SetExclusiveMeasure("#Player", "Flirt", EN_BOTH)
	
	SetExclusiveMeasure("#Spoose", "HugCharacter", EN_PASSIVE)
	SetExclusiveMeasure("#Spoose", "KissCharacter", EN_PASSIVE)
	SetExclusiveMeasure("#Spoose", "UsePerfume", EN_PASSIVE)
	SetExclusiveMeasure("#Spoose", "MakeAPresent", EN_PASSIVE)
	SetExclusiveMeasure("#Spoose", "MakeACompliment", EN_PASSIVE)
	SetExclusiveMeasure("#Spoose", "Flirt", EN_PASSIVE)
	SetExclusiveMeasure("#Spoose", "StartDialog", EN_PASSIVE)		
	
	SimSetProgress("#Player",50)
end

function CheckEnd()
	if GetItemCount("#Player","Perfume") == 0 then
		AddItems("#Player","Perfume",1)
	end
	if SimGetCourtLover("#Player","LoverAlias") then
		if SimGetProgress("#Player") >= 98 then
			ForbidMeasure("#Player", "HugCharacter", EN_BOTH)
			ForbidMeasure("#Player", "KissCharacter", EN_BOTH)
			ForbidMeasure("#Player", "UsePerfume", EN_BOTH)
			ForbidMeasure("#Player", "MakeAPresent", EN_BOTH)
			ForbidMeasure("#Player", "MakeACompliment", EN_BOTH)
			ForbidMeasure("#Player", "Flirt", EN_BOTH)
			
			ForbidMeasure("#Spoose", "HugCharacter", EN_BOTH)
			ForbidMeasure("#Spoose", "KissCharacter", EN_BOTH)
			ForbidMeasure("#Spoose", "UsePerfume", EN_BOTH)
			ForbidMeasure("#Spoose", "MakeAPresent", EN_BOTH)
			ForbidMeasure("#Spoose", "MakeACompliment", EN_BOTH)
			ForbidMeasure("#Spoose", "Flirt", EN_BOTH)				
			
			HideTutorialBox()
			return true
		end
	else
		SetFavorToSim("#Spoose","#Player",75)
		SimSetCourtLover("#Player","#Spoose")
		SimSetProgress("#Player",50)
		MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_NAME","@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_FAILED")
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_NAME","@L_TUTORIAL_CHAPTER_5_MARRIAGE_COURT_LOVER_SUCCESS")

	StartQuest("B_Marriage_3","#Player","",false)

	KillQuest()
end




