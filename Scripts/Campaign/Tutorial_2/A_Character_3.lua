-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_2\A_Character_3"
----
----	CHANGE CHAR SKILL
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
	SetQuestTitle("@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_SKILLS_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_SKILLS_QUESTBOOK",true)

	SetState("#Player", STATE_CUTSCENE, true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_SKILLS_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_SKILLS_QUESTBOOK")
	
	ShowTutorialBoxNoWait(770, 470, 500, 140, 2, RIGHTUPPER, "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_SKILLS_NAME",  "@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_SKILLS_TASK",  "")
	
--	local MyXP = IncrementXP("#Player",0)
	
--	SetData("StartXP",MyXP)

	IncrementXP("#Player",200)
	
	local totalSkill = 0
	totalSkill = totalSkill+GetSkillValue("#Player",CONSTITUTION)
	totalSkill = totalSkill+GetSkillValue("#Player",DEXTERITY)
	totalSkill = totalSkill+GetSkillValue("#Player",CHARISMA)
	totalSkill = totalSkill+GetSkillValue("#Player",FIGHTING)
	totalSkill = totalSkill+GetSkillValue("#Player",CRAFTSMANSHIP)
	totalSkill = totalSkill+GetSkillValue("#Player",SHADOW_ARTS)
	totalSkill = totalSkill+GetSkillValue("#Player",RHETORIC)
	totalSkill = totalSkill+GetSkillValue("#Player",EMPATHY)
	totalSkill = totalSkill+GetSkillValue("#Player",BARGAINING)
	totalSkill = totalSkill+GetSkillValue("#Player",SECRET_KNOWLEDGE)
	SetData("OldTotalSkill",totalSkill)
end

function CheckEnd()

--	local CurrentXP = IncrementXP("#Player",0)
--	
--	if CurrentXP == GetData("StartXP") then
--		IncrementXP("#Player",200)
--	end

	
	if not HudPanelIsVisible("CharacterSheet") then
		local object = FindNode("\\application\\game\\Hud")
		object:ShowSheet("CharacterSheet","Character", true)
	end

	local totalSkill = 0
	totalSkill = totalSkill+GetSkillValue("#Player",CONSTITUTION)
	totalSkill = totalSkill+GetSkillValue("#Player",DEXTERITY)
	totalSkill = totalSkill+GetSkillValue("#Player",CHARISMA)
	totalSkill = totalSkill+GetSkillValue("#Player",FIGHTING)
	totalSkill = totalSkill+GetSkillValue("#Player",CRAFTSMANSHIP)
	totalSkill = totalSkill+GetSkillValue("#Player",SHADOW_ARTS)
	totalSkill = totalSkill+GetSkillValue("#Player",RHETORIC)
	totalSkill = totalSkill+GetSkillValue("#Player",EMPATHY)
	totalSkill = totalSkill+GetSkillValue("#Player",BARGAINING)
	totalSkill = totalSkill+GetSkillValue("#Player",SECRET_KNOWLEDGE)

	if (GetData("OldTotalSkill") ~= totalSkill) then
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_SKILLS_NAME","@L_TUTORIAL_CHAPTER_2_CHARACTER_VIEW_ABILITIES_START")
	
	StartQuest("A_Character_4_b","#Player","",false)
	
	KillQuest("A_Character_3")
end




