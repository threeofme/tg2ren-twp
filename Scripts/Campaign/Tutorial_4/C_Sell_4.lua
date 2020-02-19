-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\C_Sell_4"
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
	SetMainQuest("Sell")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_SELL_GOODS_MARKET_PLACE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_SELL_GOODS_MARKET_PLACE_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_MARKET_PLACE_NAME","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_MARKET_PLACE_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_MARKET_PLACE_NAME",  "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_MARKET_PLACE_TASK",  "")
end

function CheckEnd()
	if HudPanelIsVisible("MarketInventorySheet") then
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
	StartQuest("C_Sell_5","#Player","",false)

	KillQuest()
end




