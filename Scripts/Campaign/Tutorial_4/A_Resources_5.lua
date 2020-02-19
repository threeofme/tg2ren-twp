-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\A_Resources_5"
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
	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_SMITHY_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_SMITHY_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_SMITHY_NAME","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_SMITHY_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_SMITHY_NAME",  "@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_SMITHY_TASK",  "Hud/Buttons/ToggleProductionAndStock.tga")
	
	
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
	StartQuest("A_Resources_6","#Player","",false)

	KillQuest()
end




