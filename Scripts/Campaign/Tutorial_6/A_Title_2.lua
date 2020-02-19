-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Title_1"
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

	SetMainQuest("Title")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_6_BUY_TITLE_TOWNHALL_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_6_BUY_TITLE_TOWNHALL_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_6_BUY_TITLE_TOWNHALL_NAME","@L_TUTORIAL_CHAPTER_6_BUY_TITLE_TOWNHALL_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 640, 500, 175, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_6_BUY_TITLE_TOWNHALL_NAME",  "@L_TUTORIAL_CHAPTER_6_BUY_TITLE_TOWNHALL_TASK",  "Hud/Buttons/btn_BuyTitleOfNobility.tga")
	
	SetExclusiveMeasure("#Player","BuyNobilityTitle",EN_BOTH)
end

function CheckEnd()
	local MinMoney = 7500
	if GetMoney("#Player") < MinMoney then
		local GiveMoney = 7500 - GetMoney("#Player")
		CreditMoney("#Player",GiveMoney,"Money for Title Buy")
	end
	
	local Title = GetNobilityTitle("#Player")
	if Title > 3 then
		ResetGamespeed()
		ForbidMeasure("#Player","BuyNobilityTitle",EN_BOTH)
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_6_BUY_TITLE_TOWNHALL_NAME","@L_TUTORIAL_CHAPTER_6_BUY_TITLE_TOWNHALL_SUCCESS")
	
	StartQuest("B_Office_1","#Player","",false)

	KillQuest()
end




