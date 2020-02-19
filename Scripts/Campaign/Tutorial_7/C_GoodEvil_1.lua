-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Myrmidons_1"
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

	SetMainQuestTitle("GoodEvil", "@L_TUTORIAL_CHAPTER_7_GOOD_AND_EVIL_NAME")
	SetMainQuestDescription("GoodEvil","@L_TUTORIAL_CHAPTER_7_GOOD_AND_EVIL_QUESTBOOK")	
	
	SetMainQuest("GoodEvil")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_7_GOOD_AND_EVIL_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_7_GOOD_AND_EVIL_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_7_GOOD_AND_EVIL_NAME","@L_TUTORIAL_CHAPTER_7_GOOD_AND_EVIL_QUESTBOOK")

	Sleep(1)	
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_7_NAME","@L_TUTORIAL_CHAPTER_7_EXIT")
	CampaignExit(true)

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




