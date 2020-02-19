-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_2\A_Character_4_b"
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
	ShowTutorialBoxNoWait(500, 125, 500, 150, 2, LEFTUPPER, "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ABILITIES_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ABILITIES_TASK",  "")
	while true do
		if HudPanelIsVisible("AbilitySheet") then
			HideTutorialBox()
			KillQuest("A_Character_4_b")
			StartQuest("A_Character_4","#Player","",false)
			break
		end

		if not HudPanelIsVisible("CharacterSheet") then
			local object = FindNode("\\application\\game\\Hud")
			object:ShowSheet("CharacterSheet","Character", true)
		end		
		Sleep(0.5)
	end
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




