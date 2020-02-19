function Init()

	this:AttachModule("WinInputCtrl", "cl_WinInputModule")
	this:AttachModule("Menu", "cl_MainMenu")
	this:EnableModule("Menu", 4)

end

function CleanUp()

	this:DetachModule("Menu")

end

