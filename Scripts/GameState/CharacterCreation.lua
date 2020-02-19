function Init()

	if not this:GetValueInt("GameStarted", 0) then
		local CharacterCreation = this:GetSettingInt("GAME", "UseCharacterCreation", 1)
		if CharacterCreation==0 then
			this:PushGameState("Game")
			return
		end
	end


	-- load the relevant modules and so on
	this:EnableModule("CharacterCreationSessionCtrl", 0)
	
	this:AttachModule("WinInputCtrl", "cl_WinInputModule")
	this:EnableModule("WinInputCtrl",10)
	
	this:AttachModule("CharacterCreationCameraController", "cl_CharacterCreationCameraController")
	this:EnableModule("CharacterCreationCameraController", 4)	
	
	this:AttachModule("ScreenShotSaver", "cl_ScreenShotSaveCtrl")
	this:EnableModule("ScreenShotSaver", 0)
	
	this:AttachModule("TextSystem","cl_TextSystemModule")
	
	this:AttachModule("Hud","cl_Hud")
	local Hud = FindNode("\\Application\\Game\\Hud")
	if(Hud) then
		if this:IsDemo() then
			Hud:SetValueString("InitScript", "CharacterCreationHud_demo.lua")
		else
			Hud:SetValueString("InitScript", "CharacterCreationHud.lua")
		end
	end
	this:EnableModule("Hud",6)
	this:AttachModule("ObjectCreator", "cl_ObjectCreationCtrl")
	

	this:DetachModule("SeasonBlender")
	this:AttachModule("SeasonBlender", "cl_SeasonBlendController")
	this:EnableModule("SeasonBlender", 0)	
	
	this:SetValueString("NextGameState","Game")	
	
	cl_LoadingScreen:GetInstance():HideLoadingScreen(1)
	
end

function CleanUp()

	local Success
	local Value

	Success, Value = this:GetValueInt("_Multiplayer", 0)

	if (Value==0) then
		this:DetachModule("Hud")
	else
		Success, Value = this:GetValueInt("ExitGame", 0)
		if(Value==1) then
			this:DetachModule("Hud")
		end
	end

	this:DetachModule("ObjectCreator")
	this:AttachModule("TextSystem","cl_TextSystemModule")
	this:DetachModule("ScreenShotSaver")
	this:DetachModule("CharacterCreationCameraController")
	this:DetachModule("SeasonBlender")
end



