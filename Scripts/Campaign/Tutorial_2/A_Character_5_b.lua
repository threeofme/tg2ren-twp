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
	ShowTutorialBoxNoWait(650, 125, 400, 170, 2, RIGHTUPPER, "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_FAMILY_TREE_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_FAMILY_TREE_TASK",  "")
	while true do
		if HudPanelIsVisible("FamilyTreeSheet") then
			HideTutorialBox()
			StartQuest("A_Character_5","#Player","",false)
			KillQuest("A_Character_5_b")
			break
		end

		if not HudPanelIsVisible("AbilitySheet") then
			local object = FindNode("\\application\\game\\Hud")
			object:ShowSheet("AbilitySheet","Character", true)
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




