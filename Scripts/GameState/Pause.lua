function Init()

	this:DisableModule("CameraCtrl")


	this:AttachModule("Menu", "cl_TestMenu")
	this:EnableModule("Menu", 4)

	--set the pause state

	Menu = FindNode("\\Application\\Game\\Menu")	
	Menu:SetValueInt("State", 100)

end

function CleanUp()

	this:EnableModule("CameraCtrl", 4)

	this:DetachModule("Menu")

end


