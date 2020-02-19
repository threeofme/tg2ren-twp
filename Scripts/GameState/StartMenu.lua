function Init()

	this:DetachModule("Hud")

	if not this:GetValueInt("GameStarted", 0) then
		local StartMenu = this:GetSettingInt("GAME", "UseStartMenu", 1)
		if StartMenu==0 then
			this:ChangeGameState("CharacterCreation")
			return
		end
	end

	this:AttachModule("StartMenuCtrl","cl_StartMenuCtrl")
	this:EnableModule("StartMenuCtrl", 0)
	
	this:EnableModule("CharacterCreationSessionCtrl", 0)

	this:AttachModule("Hud","cl_Hud")
	local Hud = FindNode("\\Application\\Game\\Hud")
	if(Hud) then
		if this:IsDemo() then
			Hud:SetValueString("InitScript", "StartMenuHud_demo.lua")
		else
			Hud:SetValueString("InitScript", "StartMenuHud.lua")
		end
	end			
	this:EnableModule("Hud",6)
	
	this:AttachModule("WinInputCtrl", "cl_WinInputModule")
	this:EnableModule("WinInputCtrl",10)
	
	cl_LoadingScreen:GetInstance():HideLoadingScreen(1)	

end

function CleanUp()
	this:DetachModule("Hud")
	this:DetachModule("StartMenuCtrl")
	this:DetachModule("WinInputCtrl")
	this:DisableModule("CharacterCreationSessionCtrl")
end





