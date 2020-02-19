-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_1\C_Hud_5"
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

--	STEP 5 MAP

	MsgQuestNoWait("#Player",0,"@L_TUTORIAL_CHAPTER_1_HUD_MAP_NAME","@L_TUTORIAL_CHAPTER_1_HUD_MAP_QUESTBOOK")

	ShowTutorialBoxNoWait(930, 650, 400, 150, 1, RIGHTLOWER, "@L_TUTORIAL_CHAPTER_1_HUD_MAP_NAME",  "@L_TUTORIAL_CHAPTER_1_HUD_MAP_TASK",  "Hud/NoCompression/btn_map.tga")
	
	while true do
		if HudPanelIsVisible("MapSheet") then
			break
		end
		Sleep(0.5)
	end
	
	while true do
		if HudPanelIsVisible("MapSheet") == false then
			HideTutorialBox()
			break
		end	
		Sleep(1)
	end
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_HUD_MAP_NAME","@L_TUTORIAL_CHAPTER_1_HUD_MAP_SUCCESS")		
	
	KillQuest("C_Hud_5_b")
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_NAME","@L_TUTORIAL_CHAPTER_1_EXIT")
	
	CampaignExit(true)	
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




