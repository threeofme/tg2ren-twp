-------------------------------------------------------------
---- This library offers a number of special camera settings
-------------------------------------------------------------
function Init()

end


-------------------------------------------------------------
---- fades the camera into the QuestDialogCam mode
-------------------------------------------------------------
function QuestDialogCam(character, duration, blending, force)
-- character	-> the character in focus of the camera
-- duration	-> the duration of the blending 
-- blending	-> the mode -> 0(linear) or 1(sigmoid) of the blending 
-- force	-> Left or Right or Front or TotalLeft or TotalRight


	-- if target character and camera are located in a different universe
	-- then move the camera to the characters universe; sleep while doing
	-- this
	if GetInsideBuilding(character, "BuildingSim") then
		CameraIndoorGetBuilding("BuildingCam")
		if not(GetID("BuildingSim") == GetID("BuildingCam")) then
			CameraIndoorSetBuilding("BuildingSim")
			Sleep(1)
		end		
	elseif CameraIndoorGetBuilding("BuildingCam") then
		ExitBuildingWithCamera()
		Sleep(1)
	end


	if duration then
		if blending then
			CameraBlend(duration,blending)
		else
			CameraBlend(duration,1)
		end
	else
		CameraBlend(1.0,1)
	end


	if force then
		CameraLock("Talk-"..force,character)
	else
		local random = GFXRand(3)
	
		if random == 0 then
			CameraLock("Talk-Left",character)
		elseif random == 1 then
			CameraLock("Talk-Front",character)
		elseif random == 2 then
			CameraLock("Talk-Right",character)
		end
	end

end


-------------------------------------------------------------
---- fades the camera into the DialogCam mode
-------------------------------------------------------------
function DialogCam(character, blending, duration, force)
-- character	-> the character in focus of the camera
-- duration	-> the duration of the blending 
-- blending	-> the mode -> 0(linear) or 1(sigmoid) of the blending 
-- force	-> Left or Right or Front or TotalLeft or TotalRight


	if duration then
		if blending then
			CameraBlend(duration,blending)
		else
			CameraBlend(duration,1)
		end
	else
		CameraBlend(1.0,1)
	end


	if force then
		CameraLock("Talk-"..force.."",character)
	else
		local random = GFXRand(3)
	
		if random == 0 then
			CameraLock("Talk-Left",character)
		elseif random == 1 then
			CameraLock("Talk-Front",character)
		elseif random == 2 then
			CameraLock("Talk-Right",character)
		end
	end
end


-------------------------------------------------------------
---- fades the camera into the DialogCam mode
-------------------------------------------------------------
function CutsceneDialogCam(cutscene, character, blending, duration, force)
-- cutscene -> the cutscene that controls the camera
-- character	-> the character in focus of the camera
-- duration	-> the duration of the blending 
-- blending	-> the mode -> 0(linear) or 1(sigmoid) of the blending 
-- force	-> Left or Right or Front or TotalLeft or TotalRight
	Assert(GetID(cutscene)~=-1, "!cutscene")		-- MMTODO: testing cutscenes

	if duration then
		if blending then
			CutsceneCameraBlend(cutscene,duration,blending)
		else
			CutsceneCameraBlend(cutscene,duration,1)
		end
	else
		CameraBlend(cutscene,1.0,1)
	end


	if force then
		CutsceneCameraSetRelativePosition(cutscene,"Talk-"..force.."",character)
	else
		local random = GFXRand(3)
	
		if random == 0 then
			CutsceneCameraSetRelativePosition(cutscene,"Talk-Left",character)
		elseif random == 1 then
			CutsceneCameraSetRelativePosition(cutscene,"Talk-Front",character)
		elseif random == 2 then
			CutsceneCameraSetRelativePosition(cutscene,"Talk-Right",character)
		end
	end
end


-------------------------------------------------------------
---- fades the camera into the DialogSitCam mode
-------------------------------------------------------------
function DialogSitCam(character, blending, duration, distance, force)
-- character	-> the character in focus of the camera
-- duration	-> the duration of the blending 
-- blending	-> the mode -> 0(linear) or 1(sigmoid) of the blending 
-- force	-> Left or Right or Front or TotalLeft or TotalRight


	if duration then
		if blending then
			CameraBlend(duration,blending)
		else
			CameraBlend(duration,1)
		end
	else
		CameraBlend(1.0,1)
	end

	if not distance then
		if GFXRand(2) == 0 then
			distance = "Near"
		else
			distance = "Far"
		end
	end
	
	if force then
		CameraLock("TalkSit-"..force.."-"..distance,character)
	else
		local random = GFXRand(6)
	
		if random == 0 then
			CameraLock("TalkSit-Left-"..distance,character)
		elseif random == 1 then
			CameraLock("TalkSit-Front-"..distance,character)
		elseif random == 2 then
			CameraLock("TalkSit-Right-"..distance,character)
		elseif random == 3 then
			CameraLock("TalkSit-Left-"..distance,character)
		elseif random == 4 then
			CameraLock("TalkSit-Front-"..distance,character)
		elseif random == 5 then
			CameraLock("TalkSit-Right-"..distance,character)
		end
	end
end

-- -----------------------
-- PlayerLock
-- -----------------------
function PlayerLock(Player, FocusSim, CameraType)
	
	local random = GFXRand(6)

	if not camera_AllowToSwitch(Player) then
		return
	end
	
	if not CameraType then
		
		if random == 0 then
			CameraType = "Far_HCenterYLeft"
		elseif random == 1 then
			CameraType = "Far_HUpYRight"
		elseif random == 2 then
			CameraType = "Mid_HCenterYLeft"
		elseif random == 3 then
			CameraType = "Far_HCenterYRight"
		elseif random == 4 then
			CameraType = "Mid_HCenterYRight"
		elseif random == 5 then
			CameraType = "Far_HUpYLeft"
		elseif random == 6 then
			CameraType = "Mid_HCenterYCenter" -- Köpfe gucken durch die cam
		elseif random == 7 then
			CameraType = "Up_HSkyYRight" -- zu steil
		elseif random == 8 then
			CameraType = "Up_HSkyYLeft"
		elseif random == 9 then
			CameraType = "Mid_HBottomYCenter"
		elseif random == 10 then
			CameraType = "Mid_HBottomYLeft"
		elseif random == 11 then
			CameraType = "Mid_HBottomYRight"
		elseif random == 12 then
			CameraType = "Close_HCenterYCenter"
		elseif random == 13 then
			CameraType = "Close_HBottomYCenter"
		elseif random == 14 then
			CameraType = "Close_HCenterYLeft"
		elseif random == 15 then
			CameraType = "Close_HBottomYLeft"
		elseif random == 16 then
			CameraType = "Close_HCenterYRight"
		elseif random == 17 then
			CameraType = "Close_HBottomYRight"
		end
		
	end

	CameraLock(CameraType, FocusSim)
end

-- -----------------------
-- PlayerLock
-- -----------------------
function CutscenePlayerLock(Cutscene, FocusSim, CameraType)

	Assert(GetID(Cutscene)~=-1, "!cutscene")		-- MMTODO: testing cutscenes
	
	local random = GFXRand(6)

	if not CameraType then
		
		if random == 0 then
			CameraType = "Far_HCenterYLeft"
		elseif random == 1 then
			CameraType = "Far_HUpYRight"
		elseif random == 2 then
			CameraType = "Mid_HCenterYLeft"
		elseif random == 3 then
			CameraType = "Far_HCenterYRight"
		elseif random == 4 then
			CameraType = "Mid_HCenterYRight"
		elseif random == 5 then
			CameraType = "Far_HUpYLeft"
		elseif random == 6 then
			CameraType = "Mid_HCenterYCenter" -- Köpfe gucken durch die cam
		elseif random == 7 then
			CameraType = "Up_HSkyYRight" -- zu steil
		elseif random == 8 then
			CameraType = "Up_HSkyYLeft"
		elseif random == 9 then
			CameraType = "Mid_HBottomYCenter"
		elseif random == 10 then
			CameraType = "Mid_HBottomYLeft"
		elseif random == 11 then
			CameraType = "Mid_HBottomYRight"
		elseif random == 12 then
			CameraType = "Close_HCenterYCenter"
		elseif random == 13 then
			CameraType = "Close_HBottomYCenter"
		elseif random == 14 then
			CameraType = "Close_HCenterYLeft"
		elseif random == 15 then
			CameraType = "Close_HBottomYLeft"
		elseif random == 16 then
			CameraType = "Close_HCenterYRight"
		elseif random == 17 then
			CameraType = "Close_HBottomYRight"
		end
		
	end

	CutsceneCameraSetRelativePosition(Cutscene,CameraType, FocusSim)
end

-- -----------------------
-- PlayerLockSit
-- -----------------------
function CutscenePlayerLockSit(Cutscene, FocusSim, CameraType)
	
	Assert(GetID(Cutscene)~=-1, "!cutscene")		-- MMTODO: testing cutscenes

	local random = GFXRand(6)

	if not CameraType then
		
		if random == 0 then
			CameraType = "TalkSit-Left-Near"
		elseif random == 1 then
			CameraType = "TalkSit-Front-Near"
		elseif random == 2 then
			CameraType = "TalkSit-Right-Near"
		elseif random == 3 then
			CameraType = "TalkSit-Left-Far"
		elseif random == 4 then
			CameraType = "TalkSit-Front-Far"
		elseif random == 5 then
			CameraType = "TalkSit-Right-Far"
		end
		
	end

	CutsceneCameraSetRelativePosition(Cutscene, CameraType, FocusSim)

end

-- -----------------------
-- PlayerLockBlend
-- -----------------------
function PlayerLockBlend(Player, FocusSim, CameraType, BlendTime, Type)
	
	if not camera_AllowToSwitch(Player) then
		return
	end
	
	CameraBlend(BlendTime, Type)
	CameraLock(CameraType, FocusSim)
	
end

-- -----------------------
-- BothLock
-- -----------------------
function CutsceneBothLock(Cutscene, FocusSim)
	
	Assert(GetID(Cutscene)~=-1, "!cutscene")		-- MMTODO: testing cutscenes

	local random = GFXRand(3)

	if random == 0 then
		CameraType = "Far_HUpYRight"
	elseif random == 1 then
		CameraType = "Far_HCenterYLeft"
	else
		CameraType = "Far_HCenterYRight"
	end
	
	CutsceneCameraSetRelativePosition(Cutscene, CameraType, FocusSim)
	
end

-- -----------------------
-- BothLock
-- -----------------------
function BothLock(Player, FocusSim)
	
	local random = GFXRand(3)

	if not camera_AllowToSwitch(Player) then
		return
	end
		
	if random == 0 then
		CameraType = "Far_HUpYRight"
	elseif random == 1 then
		CameraType = "Far_HCenterYLeft"
	else
		CameraType = "Far_HCenterYRight"
	end
	
	CameraLock(CameraType, FocusSim)
	
end


-- -----------------------
-- CutsceneBothLockCam
-- -----------------------
function CutsceneBothLockCam(Cutscene, FocusSim, Cam)
	
	Assert(GetID(Cutscene)~=-1, "!cutscene")		-- MMTODO: testing cutscenes

	local random = GFXRand(3)

	CutsceneCameraSetRelativePosition(Cutscene, Cam, FocusSim)
	
end

-- -----------------------
-- AllowToSwitch
-- -----------------------
function AllowToSwitch(Player)

	-- Check if the Player is indoor
	local PlayerIndoor = 1
	local PlayerBuildID = GetInsideBuildingID(Player)
	
	if PlayerBuildID == -1 then
		PlayerIndoor = 0
	end
	
	-- Check if the camera is indoor
	local CamIndoor = 1
	local CamBuildID = 0
	
	if CameraIndoorGetBuilding("CamInBuilding") then
		CamBuildID = GetID("CamInBuilding")
	else
		CamIndoor = 0
	end
	
	-- Return if one of camera or player are indoor and the other outdoor
	if PlayerIndoor ~= CamIndoor then
		return false
	end
	
	-- Return if both are indoor but in different scenes
	if PlayerIndoor == 1 and CamIndoor == 1 then
		if PlayerBuildID ~= CamBuildID then
			return false
		end
	end
	
	-- Return if no object is selected
	if not HudGetSelected("SelObj") then
		return false
	end
	
	-- Return if the selected object is not the player
	if GetID("SelObj") ~= GetID(Player) then
		return false
	end
	
	return true
		
end

