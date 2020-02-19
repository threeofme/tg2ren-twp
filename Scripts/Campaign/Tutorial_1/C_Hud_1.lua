-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_1\C_Hud_1"
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

	SetState("#Player", STATE_CUTSCENE, true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_HUD_NAME","@L_TUTORIAL_CHAPTER_1_HUD_QUESTBOOK")
	
	
--	STEP 1 HELPCHARACTERS PANEL

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_HUD_STEP_1_NAME","@L_TUTORIAL_CHAPTER_1_HUD_STEP_1_QUESTBOOK")
	
	ShowTutorialBoxNoWait(150, 180, 500, 150, 1, LEFTUPPER, "@L_TUTORIAL_CHAPTER_1_HUD_NAME",  "@L_TUTORIAL_CHAPTER_1_HUD_STEP_1_TASK",  "")
	
	while true do
		if HudPanelIsVisible("HelpCharacters") then
			break
		end
		Sleep(0.5)
	end
	
	HideTutorialBox()
	
--	Sleep(5)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_HUD_STEP_1_NAME","@L_TUTORIAL_CHAPTER_1_HUD_STEP_1_SUCCESS")
	

	StartQuest("C_Hud_2_b","#Player","",false)

	KillQuest("C_Hud_1_b")
	KillQuest()
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




