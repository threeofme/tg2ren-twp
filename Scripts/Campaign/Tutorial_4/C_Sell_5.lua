-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\C_Sell_5"
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
	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_SELL_GOODS_SELL_TOOLS_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_SELL_GOODS_SELL_TOOLS_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_SELL_TOOLS_NAME","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_SELL_TOOLS_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_SELL_TOOLS_NAME",  "@L_TUTORIAL_CHAPTER_4_SELL_GOODS_SELL_TOOLS_TASK",  "Hud/Items/Item_Tool.tga")
	
	SetData("StartMoney",GetMoney("#Player"))
end

function CheckEnd()
	local CartCount = BuildingGetCartCount("#Smithy")
	local CurrentCart
	local ToolCount = 0
	for CurrentCart=0,CartCount-1 do
		BuildingGetCart("#Smithy",CurrentCart,"MyCart")
		ToolCount = ToolCount + GetItemCount("MyCart","Tool")
	end

	if (ToolCount == 0) then
		if GetData("StartMoney") ~= GetMoney("#Player") then
			HideTutorialBox()
			return true
		else
			local CartCount = BuildingGetCartCount("#Smithy")
			local CurrentCart
			for CurrentCart=0,CartCount-1 do
				BuildingGetCart("#Smithy",CurrentCart,"MyCart")	
				AddItems("MyCart","Tool",5)		
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_SELL_TOOLS_NAME","@L_TUTORIAL_CHAPTER_4_SELL_GOODS_SELL_TOOLS_SUCCESS")
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_NAME","@L_TUTORIAL_CHAPTER_4_EXIT")
	
	KillQuest()
	
	CampaignExit(true)
end




