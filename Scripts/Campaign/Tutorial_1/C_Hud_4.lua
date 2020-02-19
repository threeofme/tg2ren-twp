-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_1\C_Hud_4"
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

--	STEP 4 IMPORTANT PERSON

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_HUD_STEP_4_NAME","@L_TUTORIAL_CHAPTER_1_HUD_STEP_4_QUESTBOOK")

	ShowTutorialBoxNoWait(970, 635, 400, 135, 1, RIGHTLOWER, "@L_TUTORIAL_CHAPTER_1_HUD_STEP_4_NAME",  "@L_TUTORIAL_CHAPTER_1_HUD_STEP_4_TASK",  "Hud/NoCompression/btn_character.tga")

	while true do
		if HudPanelIsVisible("CharacterSheet") then
			local object = FindNode("\\application\\game\\Hud")
--			object:ShowSheet("ImportantPersons",1)
			object:ShowSheet("CharacterSheet","Character")
			object:ShowSheet("ImportantPersons","Character")
			HideTutorialBox()
			MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_HUD_STEP_4_NAME","@L_TUTORIAL_CHAPTER_1_HUD_STEP_4_SUCCESS")
			break
		end
		if HudPanelIsVisible("ImportantPersons") then
			HideTutorialBox()
			MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_HUD_STEP_4_NAME","@L_TUTORIAL_CHAPTER_1_HUD_STEP_4_SUCCESS")
			break			
		end
		Sleep(0.5)
	end


	local SettlementName = GetName("#Capital")

	local object = FindNode("\\application\\game\\Hud")
	object:ShowSheet("ImportantPersons","Character")

--	local object = FindNode("\\application\\game\\Hud")
--	object:ShowPanel("PoliticsOverview"..SettlementName,false)
--	object:ShowPanel("SheetNavi",false)
--	object:ShowPanel("SheetHeader",false)

	StartQuest("C_Hud_5_b","#Player","",false)

	KillQuest("C_Hud_4_b")
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




