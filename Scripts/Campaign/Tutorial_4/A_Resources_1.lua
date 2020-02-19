-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\A_Resources_1"
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

	SetMainQuestTitle("Resources", "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_NAME")
	SetMainQuestDescription("Resources","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_QUESTBOOK")	
	
	SetMainQuest("Resources")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_QUESTBOOK",true)
	
	SetState("#Player", STATE_CUTSCENE, true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_NAME","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_NAME",  "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_TASK",  "")
	
	SetData("NoCart",0)
end

function CheckEnd()
	local MinMoney = 700
	if GetMoney("#Player") < MinMoney then
		local GiveMoney = MinMoney - GetMoney("#Player")
		CreditMoney("#Player",GiveMoney,"Buy Resources Credit")
	end
	
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
			ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_NAME",  "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_TASK",  "")
		end
		for CurrentCart=0,CartCount do
			BuildingGetCart("#Smithy",CurrentCart,"MyCart")
			local DistanceToMarket = GetDistance("MyCart","#Market")
			if (DistanceToMarket <= 1600) then
				HideTutorialBox()
				local Money = GetMoney("#Player")
				SpendMoney("#Player",Money,"Tutorial")						
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
	Sleep(1)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_NAME","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_SUCCESS")
	
	ShowTutorialBoxNoWait(100, 690, 500, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_NAME",  "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_TASK2",  "")
	
	while true do
		if HudPanelIsVisible("MarketInventorySheet") then
			break
		end
		Sleep(0.5)
	end
	
	HideTutorialBox()
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_MAKET_PLACE_NAME","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_MAKET_PLACE_QUESTBOOK")
	
	StartQuest("A_Resources_3","#Player","",false)

	KillQuest()
end




