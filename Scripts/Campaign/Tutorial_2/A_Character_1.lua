-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_2\A_Character_1"
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

	SetMainQuestTitle("Character", "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_NAME")
	SetMainQuestDescription("Character","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_QUESTBOOK")	
	
	SetMainQuest("Character")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_QUESTBOOK",true)
	
	SetState("#Player", STATE_CUTSCENE, true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_QUESTBOOK")
	
	ShowTutorialBoxNoWait(980, 630, 500, 150, 1, RIGHTLOWER, "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_TASK",  "Hud/NoCompression/btn_character.tga")
end

function CheckEnd()
	if HudPanelIsVisible("CharacterSheet") then
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

	StartQuest("A_Character_2","#Player","",false)

	KillQuest()
end




