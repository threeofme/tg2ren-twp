
function On_Enable()

	--this:AttachModule("ShooterCam", "cl_ShooterCameraCtrl")
	--this:AttachModule("GildeCam", "cl_GildeCameraCtrl")
	--this:EnableModule("GildeCam", 4)
	--this:SetValueInt("CameraMode", 0)
	landscapeeditor_SetToolMode(0)
	
end

function On_MOUSE_RB_RELEASED( Value)

	Mode = this:GetValueInt("Object3DToolMode")
	if(Mode == 2) then
	
		--disable object creation
		landscapeeditor_SetToolMode(0)
	
	end

end

function On_GILDECAM( Value)

	this:SetValueInt("CameraMode", 0)
	UpdateRegisteredModules()
	
end

function On_SHOOTERCAM( Value)

	this:SetValueInt("CameraMode", 1)
	UpdateRegisteredModules()
end


function On_GUIMODE(Value)

	CamMode = this:GetValueInt("CameraMode")
	
	if(Value == 1) then
	
		SetEditorMode("2DEdit")
	else
	 
		SetEditorMode("3DEdit")

	end	
end

function On_NEW_OBJECT( Value)

	--enable ObjectCreator
	Mode = this:GetValueInt("Object3DToolMode")
	if not (Mode == 2) then
	
		landscapeeditor_SetToolMode(2)
		
	end
	
end

function On_KEYBOARD_PRESSED( Value)

 	-- 'space' now in MainFrame.cpp
	-- if(Value == 32) then

	--	Mode = this:GetValueInt("CameraMode")
			
	--	if(Mode == 0) then
	--		this:SetValueInt("CameraMode", 1)
	--	else
	--		this:SetValueInt("CameraMode", 0)
	--	end
	
	--	UpdateRegisteredModules()

	--end

 	-- 'm' & 'M'
	if ((Value == 77) or (Value == 109)) then

		Mode = this:GetValueInt("Object3DToolMode") + 1

		landscapeeditor_SetToolMode(Mode)

	end
	
	--delete selection
	if (Value == 46) then

		DoScriptCommand( 
			"Delete( GetChildIDs(GetSelection())) "..
			"UnselectAll()"
				)

	end
	
	if (Value == 82) then
	
		--landscapeeditor_SetToolMode(2)
	
	end
	
	-- '1'
	-- if (Value == 49) then
		
		--enable movement
	-- 	landscapeeditor_SetToolMode(0)
	
	-- end
	
	-- '2'
	-- if (Value == 50) then
	
		--enable rotation
	-- 	landscapeeditor_SetToolMode(1)
		
	-- end
	
end


function SetToolMode( Mode)


	if(Mode > 3) then
	
		Mode = 0
		
	end

	if(Mode == 0) then

		SetActiveUniqueModule("Object3DMover")

	end
	
	if(Mode == 1) then

		SetActiveUniqueModule("Object3DRotator")

	end
	
	if(Mode == 2) then

		SetActiveUniqueModule("ObjectCreator")

	end
	if(Mode == 3) then

		SetActiveUniqueModule("TerrainBrush")

	end

	this:SetValueInt("Object3DToolMode", Mode)

end

