function Init()

	local SplashScreen = 0 --this:GetSettingInt("GAME", "SplashScreen", 1)
	if SplashScreen==0 then
		this:ChangeGameState("StartMenu")
		return
	end
	
	this:EnableModule("CharacterCreationSessionCtrl", 0)
	
	this:AttachModule("HelloController", "cl_HelloController")
	this:EnableModule("HelloController", 4)
	local HelloController = FindNode("\\Application\\Game\\HelloController")
	if(HelloController) then
		HelloController:SetValueString("NextGameState","StartMenu")		
	end
	this:AttachModule("SeasonBlender", "cl_SeasonBlendController")
	this:EnableModule("SeasonBlender", 0)
	
	cl_LoadingScreen:GetInstance():HideLoadingScreen(1)
	
end

function CleanUp()
	this:DetachModule("HelloController")
	this:DetachModule("SeasonBlender")
	this:DisableModule("CharacterCreationSessionCtrl")
end

