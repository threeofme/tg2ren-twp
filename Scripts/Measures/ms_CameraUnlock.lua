function Run()
	CameraenableUserUnlock(true)
	CameraUnlock()
	
	this:DisableModule("CameraCtrl")
	this:EnableModule("CameraCtrl", 4)
end