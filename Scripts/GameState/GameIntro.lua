function Init()

	this:DisableModule("RenderCtrl")

	this:AttachModule("MovieCtrl", "cl_MovePlayController")

	Ctrl = FindNode("\\Application\\Game\\MovieCtrl")	
	Ctrl:SetValueString("FileName", "movie/GameIntro.wmv")
	Ctrl:SetValueString("NextGameState", "GameStartUp")

	this:EnableModule("MovieCtrl", 4)

end

function CleanUp()

	this:DetachModule("MovieCtrl")
	this:EnableModule("RenderCtrl", 0)

end





