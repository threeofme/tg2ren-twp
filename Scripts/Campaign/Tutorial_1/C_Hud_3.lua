-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_1\C_Hud_3"
----
----
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

--	STEP 3 MEASUREBAR

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_HUD_STEP_3_NAME","@L_TUTORIAL_CHAPTER_1_HUD_STEP_3_QUESTBOOK")
	
	SetExclusiveMeasure("#Player","ToggleInventory",EN_BOTH)
	
	ShowTutorialBoxNoWait(220, 685, 500, 150, 1, LEFTLOWER, "@L_TUTORIAL_CHAPTER_1_HUD_STEP_3_NAME",  "@L_TUTORIAL_CHAPTER_1_HUD_STEP_3_TASK",  "Hud/Buttons/ToggleInventory.tga")
	
	while true do
		if HudPanelIsVisible("InventorySheet") then
			ShowTutorialBoxNoWait(100, 690, 450, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_1_HUD_STEP_3_NAME",  "@L_TUTORIAL_CHAPTER_1_HUD_STEP_3_TASK2",  "")
			break
		end
		Sleep(0.5)
	end
	
	MsgQuestNoWait("#Player",0,"@L_TUTORIAL_CHAPTER_1_HUD_STEP_3_NAME","@L_TUTORIAL_CHAPTER_1_HUD_STEP_3_SUCCESS")
	
	while true do
		if not HudPanelIsVisible("InventorySheet") then
			HideTutorialBox()
			break
		end
		Sleep(0.5)
	end
	
	ForbidMeasure("#Player","ToggleInventory",EN_BOTH)

	StartQuest("C_Hud_4_b","#Player","",false)

	KillQuest("C_Hud_3_b")
	KillQuest()	
end

function CheckEnd()
	return true
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
end




