function Run(MovieName)

	this:DisableModule("RenderCtrl")
	this:AttachModule("MovieCtrl", "cl_MovePlayController")
	
	-- mute the menumusic
	MusicGameModule = FindNode("\\Application\\Game\\MusicCtrl")	
	MusicGameModule:SwapMute()
	
	Ctrl = FindNode("\\Application\\Game\\MovieCtrl")	
	Ctrl:SetValueString("FileName", MovieName)
	Ctrl:SetValueInt("NoSwitch", 1)
	Ctrl:SetValueInt("Finished", 0)

	this:EnableModule("MovieCtrl", 4)
	
	while (Ctrl:GetValueInt("Finished")==0) do
		Sleep(0.5)
	end

	-- unmute the menumusic
	MusicGameModule:SwapMute()
	
	this:DetachModule("MovieCtrl")
	this:EnableModule("RenderCtrl", 0)
end

