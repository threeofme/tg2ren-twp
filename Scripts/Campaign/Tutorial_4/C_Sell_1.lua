-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\C_Sell_1"
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
	SetMainQuestTitle("Sell", "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_NAME")
	SetMainQuestDescription("Sell","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_QUESTBOOK")	
	
	SetMainQuest("Sell")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_SELL_GOODS_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_SELL_GOODS_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_NAME","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_NAME",  "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_TASK",  "Hud/Buttons/ToggleProductionAndStock.tga")
	
	AddItems("#Smithy","Tool",5)
end

function CheckEnd()
	if (HudGetSelected("MySelection")) then 
		if (GetID("MySelection") == GetID("#Smithy")) then
			if HudPanelIsVisible("ProductionSheet") then
				HideTutorialBox()
				return true
			end
		end
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
	StartQuest("C_Sell_2","#Player","",false)

	KillQuest()
end




