function Init()
	
	--ToolModuleFlags:
	
	--Active in every Mode
	EN_ALWAYS = 1 
	--Active if the Mode (Property: Tool->EditorMode) is correct
	EN_MULTI = 2
	--Active if the Mode is correct and this is the tool of choice. (Property: Tool->ActiveUniqueModule)
	EN_UNIQUE = 3 
	
	--Set editor modes where 0=3d mode, 1=GUI Mode, 2=ParticleSystem mode
	-- erstmal soll -1 der 
	this:SetValueInt("EditorMode", -1) 
	
	this:SetValueString("SessionType", "LOCALHOST")

	--- ###3DEdit Modules
	
	RegisterToolModule("cl_ObjectCreationCtrl", "ObjectCreator", "3DEdit", EN_UNIQUE, 0)
	RegisterToolModule("cl_TerrainBrushCtrl", "TerrainBrush", "3DEdit", EN_UNIQUE, 0)
	RegisterToolModule("cl_FenceCreationCtrl", "FenceCreator", "3DEdit", EN_UNIQUE, 1)
	RegisterToolModule("cl_Object3DSelectionCtrl", "Object3DSelector", "3DEdit", EN_UNIQUE, 0) 
	--RegisterToolModule("cl_Object3DMoveCtrl", "Object3DMover", "3DEdit", EN_UNIQUE, 8)
	AddIncludedUnique("Object3DMover", "Object3DSelector");
	--RegisterToolModule("cl_Object3DRotationCtrl", "Object3DRotator", "3DEdit", EN_UNIQUE, 0)
	AddIncludedUnique("Object3DRotator", "Object3DSelector");
		
	--this:SetValueInt("CameraMode", 0)
			
	--ShooterCamCon = "Node = FindNode(\"\\\\Application\\\\Game\") \n\r if(Node:GetValueInt(\"CameraMode\") == 1) then \r\n return 1 \r\n end \r\n return 0"
	--RegisterToolModule("cl_ShooterCameraCtrl", "ShooterCam", "3DEdit", EN_MULTI, ShooterCamCon, 4)
	
	--GildeCamCon = "Node = FindNode(\"\\\\Application\\\\Game\") \n\r if(Node:GetValueInt(\"CameraMode\") == 0) then \r\n return 1 \r\n end \r\n return 0"
	--RegisterToolModule("cl_GildeCameraCtrl", "GildeCam", "3DEdit", EN_MULTI, GildeCamCon, 4)
	RegisterToolModule("cl_ShooterCameraCtrl", "PSShooterCam", "PSEdit", EN_MULTI, ShooterCamCon, 4)
	
	-- ###GUI Editor Ctrl -- 
	
	this:SetValueInt("GuiPreview", 0)
	
	RegisterToolModule("cl_GUISelectionCtrl", "GUISelector", "2DEdit", EN_MULTI, 0) 	
	RegisterToolModule("cl_WinRenderModule", "WinRenderCtrl", "2DEdit", EN_MULTI, 2)
	RegisterToolModule("cl_GUIMoveCtrl", "GUIMover", "2DEdit", EN_MULTI, 4)
	RegisterToolModule("cl_GUIScaleCtrl", "GUIScaler", "2DEdit", EN_MULTI, 8)	
	RegisterToolModule("cl_GUIAddObjCtrl", "GUIAdder", "2DEdit", EN_UNIQUE, 16)
	RegisterToolModule("cl_GUIBrushCtrl", "GUIBrush", "2DEdit", EN_UNIQUE, 16)

	RegisterToolModule("cl_ParticleSystem", "ParticleSystem", "PSEdit", EN_MULTI, 0)
	RegisterToolModule("cl_Object3DSelectionCtrl", "PSObject3DSelector", "PSEdit", EN_UNIQUE, 0) 
	RegisterToolModule("cl_Object3DMoveCtrl", "PSObject3DMover", "PSEdit", EN_UNIQUE, 8)
	AddIncludedUnique("PSObject3DMover", "PSObject3DSelector");
	RegisterToolModule("cl_Object3DRotationCtrl", "PSObject3DRotator", "PSEdit", EN_UNIQUE, 4)
	AddIncludedUnique("PSObject3DRotator", "PSObject3DSelector");
	
	--SetEditorMode("3DEdit")
	--SetActiveUniqueModule("Object3DMover")

end

function CleanUp()
end

