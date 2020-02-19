function Init()

 	--this:AddPanel("CharName","cl_StaticPanel","gui/charactercreation/panel_name.gui", false)
 	--this:AddPanel("CharGender","cl_StaticPanel","gui/charactercreation/panel_gender.gui", false)
 	--this:AddPanel("CharReligion","cl_StaticPanel","gui/charactercreation/panel_religion.gui", false)
 	--this:AddPanel("CharClass","cl_StaticPanel","gui/charactercreation/panel_class.gui", false)
 	--this:AddPanel("CharSkills","cl_CharacterSheet","gui/charactercreation/panel_skills.gui", false) 	
 	--this:AddPanel("ChangeAppearancePanel","cl_ChangeAppearancePanel","gui/charactercreation/panel_changeappearance.gui",false)
 
 	this:AddPanel("InGameQuit","cl_StartMenuPanel","gui/menu/ingame_quitgame.gui", false)
 	this:AddPanel("MainMenu","cl_StartMenuPanel","gui/menu/mainmenu.gui", false)
 	this:AddPanel("SinglePlayer","cl_StartMenuPanel","gui/menu/singleplayermenu.gui", false)
 	this:AddPanel("MultiPlayer","cl_StartMenuPanel","gui/menu/networktype.gui", false)
 	this:AddPanel("GameList","cl_StartMenuPanel","gui/menu/gamelist.gui", false)
 	this:AddPanel("Login","cl_StartMenuPanel","gui/menu/multiplayerlogin.gui", false)
 	this:AddPanel("CreateAccount","cl_StartMenuPanel","gui/menu/multiplayercreateaccount.gui", false)
 	this:AddPanel("ChangeCDKey","cl_StartMenuPanel","gui/menu/multiplayerchangecdkey.gui", false)
 	this:AddPanel("NetworkError","cl_StartMenuPanel","gui/menu/networkerror.gui", false)
 	this:AddPanel("HostGame","cl_StartMenuPanel","gui/menu/hostgame.gui", false)
 	this:AddPanel("JoinGame","cl_StartMenuPanel","gui/menu/Joingame.gui", false)
 	this:AddPanel("WaitForPlayers","cl_StartMenuPanel","gui/menu/PlayerList.gui", false)
 	this:AddPanel("WaitForPlayersClient","cl_StartMenuPanel","gui/menu/PlayerList.gui", false)
 	this:AddPanel("Message","cl_StartMenuPanel","gui/menu/Message.gui", false)
 	this:AddPanel("ChooseCampaign","cl_StartMenuPanel","gui/menu/ChooseCampaign.gui",false)
 	this:AddPanel("ChooseTutorial","cl_StartMenuPanel","gui/menu/ChooseCampaign.gui",false)
 	this:AddPanel("ChooseMap","cl_StartMenuPanel","gui/menu/ChooseMap.gui",false)
 	this:AddPanel("WorldDeleteSheet", "cl_MessageBox","GUI/Menu/panel_delete_world.gui",false)
 	this:AddPanel("SelectSaveGame","cl_StartMenuPanel","gui/menu/SelectSaveGame.gui", false)
 	this:AddPanel("Options_Gfx","cl_StartMenuPanel","gui/menu/options_gfx.gui", false)
 	this:AddPanel("Options_Game","cl_StartMenuPanel","gui/menu/options_game.gui", false)
 	this:AddPanel("Options_Sound","cl_StartMenuPanel","gui/menu/options_sound.gui", false)
 	this:AddPanel("RestartWarning","cl_StartMenuPanel","gui/menu/restartwarning.gui", false) 	
 	this:AddPanel("EnterName","cl_StartMenuPanel","gui/menu/multiplayername.gui", false)
 	this:AddPanel("StartWarning","cl_StartMenuPanel","gui/menu/Startwarning.gui", false) 	
 	this:AddPanel("Credits", "cl_Credits", "gui/menu/credits.gui", false) 	
 	
 
 	
 	this:ShowStartMenu()
	
end

function CleanUp()

end

