-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\A_Resources_6"
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
	SetMainQuest("Resources")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_QUESTBOOK",true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_NAME","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_QUESTBOOK")

	ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_NAME",  "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_TASK",  "Hud/Items/Item_Iron.tga")

	local Slots = InventoryGetSlotCount("#Smithy")
	local ItemId
	local ItemCount
	local Number
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("#Smithy", Number)
		if ItemId == 241 then
			RemoveItems("#Smithy", ItemId, ItemCount)
		end
	end

	SetData("NoCart",0)
end

function CheckEnd()
	if (GetItemCount("#Smithy","Iron") >= 2) then
		HideTutorialBox()
		return true
	else
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
				ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_NAME",  "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_TASK",  "Hud/Items/Item_Iron.tga")
			end
			local CartCount = BuildingGetCartCount("#Smithy")
			local IronCount = 0
			for CurrentCart=0,CartCount-1 do
				BuildingGetCart("#Smithy",CurrentCart,"MyCart")
				IronCount = IronCount + GetItemCount("MyCart","Iron")
			end
			if (IronCount == 0) then
				BuildingGetCart("#Smithy",0,"MyCart")
				AddItems("MyCart","Iron",2)
			end
		end
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_NAME","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_STORE_IRON_SUCCESS")

	StartQuest("B_Production_1","#Player","",false)

	KillQuest()
end




