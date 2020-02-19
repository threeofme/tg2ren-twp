function Init()

 	--onscreen 	
 	this:AddPanel("HelpZodiac","cl_OnscreenHelpPanel","gui/Hud/Helppanels/zodiac.gui",false)
 	this:AddPanel("HelpClass","cl_OnscreenHelpPanel","gui/Hud/Helppanels/class.gui",false)
 	this:AddPanel("HelpSkill","cl_OnscreenHelpPanel","gui/Hud/Helppanels/skill.gui",false)
 	
 	
 	
 	this:AddPanel("CharSign","cl_StaticPanel","gui/charactercreation/panel_class.gui")
 	this:AddPanel("CharName","cl_StaticPanel","gui/charactercreation/panel_name.gui")
 	this:AddPanel("CharGender","cl_StaticPanel","gui/charactercreation/panel_gender.gui")
 	this:AddPanel("CharReligion","cl_StaticPanel","gui/charactercreation/panel_religion.gui")
 	this:AddPanel("CharSkills","cl_CharacterSheet","gui/charactercreation/panel_skills.gui")
 	
 	this:AddPanel("ChangeAppearancePanel","cl_ChangeAppearancePanel","gui/charactercreation/panel_changeappearance.gui",false)  	
 	this:AddPanel("CharacterCreationPanel","cl_CharacterCreationPanel","gui/charactercreation/panel_exit.gui")
 	
	--this:AddPanel("CharacterCreationExitPanel","cl_CharacterCreationExitPanel","gui/charactercreation/panel_exit.gui",false)  
	--this:AddPanel("InfoPanel","cl_InfoPanel","gui/Hud/panel_info.gui")
		
		
		
		
		
	
end

function CleanUp()

 	-- Obsolete?
	--this:RemovePanel("StatusPanel")
	--this:RemovePanel("UserInputPanel")
	--this:RemovePanel("InstantMeasurePanel")
	--this:RemovePanel("MapPanel")
	--this:RemovePanel("OverlayPanel")
	--this:RemovePanel("TestPanel")
	--this:RemovePanel("ActionsPanel")
end

