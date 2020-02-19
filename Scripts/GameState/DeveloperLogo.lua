function Init()

	this:DisableModule("RenderCtrl")

	if (this:GetSettingInt("GAME", "SplashScreen", 0) == 0) then
	
		this:ChangeGameState("GameStartUp")

	else

		this:AttachModule("MovieCtrl", "cl_MovePlayController")

		Ctrl = FindNode("\\Application\\Game\\MovieCtrl")	
		--Ctrl:SetValueString("FileName", "movie/DeveloperLogo.mpg")
		Ctrl:SetValueString("FileName", "movie/RuneforgeLogo.wmv")
		Ctrl:SetValueString("NextGameState", "GameIntro")

		this:EnableModule("MovieCtrl", 4)
	end

end

function CleanUp()

	this:DetachModule("MovieCtrl")

	this:EnableModule("RenderCtrl", 0)

end





