function Init()

	
	--this:AttachModule("CameraCtrl", "cl_IndoorCameraController")
	--this:EnableModule("CameraCtrl", 0)

	this:AttachModule("WinInputCtrl", "cl_WinInputModule")
	this:EnableModule("WinInputCtrl",3);

	this:AttachModule("GuiInit", "cl_GuiCreator")
	this:EnableModule("GuiInti",0)
	
					
end

function CleanUp()

	--this:DetachModule("CameraCtrl")
	this:DetachModule("WinInputCtrl")
	this:DetachModule("GuiInit")

end


