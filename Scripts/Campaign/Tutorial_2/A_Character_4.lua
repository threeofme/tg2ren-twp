-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_2\A_Character_4"
----
----	APILITIES SCREEN
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

	SetMainQuest("Character")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ABILITIES_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ABILITIES_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ABILITIES_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ABILITIES_QUESTBOOK")
	
	Sleep(0.2)
	
	ShowTutorialBoxNoWait(100, 700, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ABILITIES_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ABILITIES_TASK2",  "")
	
end

function CheckEnd()
	local Count
	local HasAbility = 0
	
	if not HudPanelIsVisible("AbilitySheet") then
		local object = FindNode("\\application\\game\\Hud")
		object:ShowSheet("AbilitySheet","Character")
	end
		
	for Count=1,32 do
		if SimHasAbility("#Player",Count) and (HasAbility == 0) then
			HasAbility = 1
		end
	end
	if (HasAbility == 1) then
		HasAbility = 2
		HideTutorialBox()
		return true
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

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_SKILLS_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_FAMILY_TREE_START")
	
	StartQuest("A_Character_5_b","#Player","",false)
	
	KillQuest("A_Character_4")
end




