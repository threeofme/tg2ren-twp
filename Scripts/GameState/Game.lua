function Init()

	-- detach hud, so it gets reinitialized with the actual world
	this:DetachModule("Hud")

	cl_LoadingScreen:GetInstance():ShowLoadingScreen("LoadingScreen/balken.dds", 183, 684, 657, 32, 7, 3)
	
	if not this:EnableModule("WorldSessionCtrl", 0) then
		return
	end

	this:AttachModule("WinInputCtrl", "cl_WinInputModule")
	this:EnableModule("WinInputCtrl",20)

	local World = FindNode("\\World")
	if not World then
		return
	end
	
	this:SetValueInt("GameStarted", 1)

	this:AttachModule("TreeGraphCtrl", "cl_PropertyGraphManager")
	this:RegisterEventReceiver("TreeGraphCtrl", "Physics", 16)
	
	this:AttachModule("TreeViewCtrl", "cl_TreeViewController")

	this:AttachModule("GeneralInputCtrl", "cl_GeneralInputCtrl")	
	this:EnableModule("GeneralInputCtrl", 2)
	
	if(this:GetSettingInt("GAME", "UseAutoInput", 0) > 0) then
		this:AttachModule("AutoInputController","cl_AutoInputController")
		this:EnableModule("AutoInputController",50)
	end

	this:AttachModule("Hud","cl_Hud")
	Hud = FindNode("\\Application\\Game\\Hud")
	if(Hud) then
		if this:IsDemo() then
			Hud:SetValueString("InitScript", "GameHud_demo.lua")
		else
			Hud:SetValueString("InitScript", "GameHud.lua")
		end
	end
	this:EnableModule("Hud",6)
		
	this:AttachModule("ObjectCreator", "cl_ObjectCreationCtrl")
	
	this:AttachModule("SeasonBlender", "cl_SeasonBlendController")
	this:EnableModule("SeasonBlender", 0)
		
	this:AttachModule("ScreenShotSaver", "cl_ScreenShotSaveCtrl")
	this:EnableModule("ScreenShotSaver", 0)
		
	RenderCtrl = FindNode("\\Application\\Game\\RenderCtrl")
	
	if(this:GetSettingInt("GAME", "CameraReplay", 0) > 0) then
	
		RenderCtrl = FindNode("\\Application\\Game\\RenderCtrl")
		RenderCtrl:SetValueFloat("FixedFrameRate", 25)
		this:AttachModule("CameraReplayCtrl", "cl_CameraPlayController")
		this:EnableModule("CameraReplayCtrl", 0)
		
		ScreenSaver = FindNode("\\Application\\Game\\ScreenShotSaver")
		ScreenSaver:SetValueInt("SaveMovie", 1)
	
	elseif (this:GetSettingInt("GAME", "MeasureRendering", 0) > 0) then
	
		cl_LoadingScreen:GetInstance():HideLoadingScreen(1)
		this:AttachModule("CameraReplayCtrl", "cl_CameraPlayController")
		this:EnableModule("CameraReplayCtrl", 0)		
		return
	
	else 
	
		if(this:GetSettingInt("GAME", "CameraSave", 0) > 0) then
		
			this:AttachModule("CameraSaver", "cl_CameraSaveController")
			this:EnableModule("CameraSaver", 0)
	
		end
	
	end

	cl_LoadingScreen:GetInstance():HideLoadingScreen(1)
		
end

function CleanUp()

	this:DetachModule("Hud")
	this:DetachModule("TreeViewCtrl")
	this:DetachModule("TreeGraphCtrl")
	this:DetachModule("SeasonBlender")
	this:DisableModule("WorldSessionCtrl")
	this:DetachModule("NetworkCtrl")
	this:DetachModule("GeneralInputCtrl")

end

