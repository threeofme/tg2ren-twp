-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\C_Sell_2"
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
--	SetMainQuest("Sell")
--	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_SELL_GOODS_LOAD_GOODS_NAME")
--	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_SELL_GOODS_LOAD_GOODS_QUESTBOOK",true)

--	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_LOAD_GOODS_NAME","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_LOAD_GOODS_QUESTBOOK")

	ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_LOAD_GOODS_NAME",  "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_LOAD_GOODS_TASK",  "Hud/Items/Item_Tool.tga")

	SetData("NoCart",0)
end

function CheckEnd()
	local CartCount = BuildingGetCartCount("#Smithy")
	local CurrentCart
	if CartCount <= 0 then
		if (GetData("NoCart") == 0) then
			SetData("NoCart",2)
			ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_NAME",  "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_NOCART",  "")
			if HudPanelIsVisible("ProductionSheet") then
				local object = FindNode("\\application\\game\\Hud")
				object:ShowInventoryPanel("ProductionSheet",false)
				object:ShowInventoryPanel("StoreSheet",false)
				object:ShowInventoryPanel("TransportSheet",false)
			end
		end
	else
		if (GetData("NoCart") == 2) then
			SetData("NoCart",0)
			ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_LOAD_GOODS_NAME",  "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_LOAD_GOODS_TASK",  "Hud/Items/Item_Tool.tga")
		end
		for CurrentCart=0,CartCount-1 do
			BuildingGetCart("#Smithy",CurrentCart,"MyCart")
			if (GetItemCount("MyCart","Tool") >= 5) then
				HideTutorialBox()
				return true
			end
		end

		local ToolCount = GetItemCount("#Smithy","Tool")
		if (ToolCount < 5) then
			AddItems("#Smithy","Tool",5 - ToolCount)
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
	StartQuest("C_Sell_3","#Player","",false)

	KillQuest()
end




