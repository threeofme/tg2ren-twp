function Init()

	this:AttachModule("Hud","cl_Hud")
	this:EnableModule("Hud",6)

	this:AttachModule("SceneInit", "cl_SceneCreator")

	this:AttachModule("CameraCtrl", "cl_IndoorCameraController")
	this:EnableModule("CameraCtrl", 0)

	this:AttachModule("WinInputCtrl", "cl_WinInputModule")
	this:EnableModule("WinInputCtrl",4)
	
				
end

function CleanUp()

	this:DetachModule("Hud")
	this:DetachModule("WinInputCtrl")
	this:DetachModule("CameraCtrl")
	this:DetachModule("SceneInit")

end


