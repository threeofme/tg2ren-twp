-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_2\A_Character_5"
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
	SetQuestTitle("@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ADD_WIFE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ADD_WIFE_QUESTBOOK",true)
		
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_FAMILY_TREE_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_FAMILY_TREE_QUESTBOOK")
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ADD_WIFE_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ADD_WIFE_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 50, 500, 150, 1, LEFTUPPER_NOARROW,  "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ADD_WIFE_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ADD_WIFE_TASK",  "")
end

function CheckEnd()

	if not HudPanelIsVisible("FamilyTreeSheet") then
		local object = FindNode("\\application\\game\\Hud")
		object:ShowSheet("FamilyTreeSheet","Character")
	end

	if IsPartyMember("#Spoose") then
		SetState("#Spoose", STATE_CUTSCENE, false)
		HideTutorialBox()
		return true
	else
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
	Sleep(1)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ADD_WIFE_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ADD_WIFE_SUCCESS")

	local object = FindNode("\\application\\game\\Hud")
	object:ShowSheet("FamilyTreeSheet",0)
--	object:ShowPanel("FamilyTreeSheet",false)
--	object:ShowPanel("SheetNavi",false)
--	object:ShowPanel("SheetHeader",false)

	StartQuest("B_Classes_1","#Player","",false)

	KillQuest("A_Character_5")
end




