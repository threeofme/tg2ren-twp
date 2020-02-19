-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_1\A_CamControl"
----
----
----
----	1. function Bind
----
----	2. Bind / Start the next Quest(s)
----
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
----	1. function Bind
-------------------------------------------------------------------------------
function Bind()
	return true
end

function CheckStart()
	return true
end

function Start()

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_CONTROLS_NAME","@L_TUTORIAL_CHAPTER_1_CONTROLS_QUESTBOOK")
	
	SetMainQuestTitle("Control", "@L_TUTORIAL_CHAPTER_1_CONTROLS_NAME")
	SetMainQuestDescription("Control","@L_TUTORIAL_CHAPTER_1_CONTROLS_QUESTBOOK")	
	
	SetMainQuest("Control")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_1_CONTROLS_CAMERA_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_1_CONTROLS_CAMERA_QUESTBOOK",true)

	MsgQuestNoWait("#Player",0,"@L_TUTORIAL_CHAPTER_1_CONTROLS_CAMERA_NAME","@L_TUTORIAL_CHAPTER_1_CONTROLS_CAMERA_QUESTBOOK")
	
	local CamX
	local CamZ
	local Zoom
	local Rotation

	CamX, CamZ, Zoom, Rotation = GetCameraPosition()

	SetData("startCamX", CamX)
	SetData("startCamZ", CamZ)
	SetData("startZoom", Zoom)
	SetData("startRotation", Rotation)
	SetData("movefin",0)
	SetData("rotfin",0)
	SetData("zoomfin",0)
	
	ShowTutorialBoxNoWait(100, 700, 470, 180, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_1_CONTROLS_CAMERA_NAME",  "@L_TUTORIAL_CHAPTER_1_CONTROLS_CAMERA_TASK",  "")
end

function CheckEnd()
	local oldcamx
	local oldcamz
	local oldzoom

	local CamX
	local CamZ
	local Zoom
	local Rotation

	oldcamx = GetData("startCamX")
	oldcamz = GetData("startCamZ")
	oldzoom = GetData("startZoom")
	oldrotatation = GetData("startRotation")

	CamX, CamZ, Zoom, Rotation = GetCameraPosition()
	
	local RotTol = 5
	local MinRot = oldrotatation - RotTol
	if (MinRot < 0) then
		MinRot = MinRot+360
	end
	local MaxRot = oldrotatation + RotTol
	if (MinRot > 360) then
		MaxRot = MaxRot+360
	end
	
	if (math.abs(oldcamx - CamX) > 10) and (math.abs(oldcamz - CamZ) > 10) then
		SetData("movefin",1)
	end
	if (math.abs(oldzoom - Zoom) > 10) then
		SetData("rotfin",1)
	end
	if (Rotation < MinRot) or (Rotation > MaxRot) then
		SetData("zoomfin",1)
	end
	
	if (GetData("movefin") == 1) and (GetData("rotfin") == 1) and (GetData("zoomfin") == 1) then
		HideTutorialBox()
		return true
	else
		return false
	end
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
	Sleep(1.5)
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_CONTROLS_CAMERA_NAME","@L_TUTORIAL_CHAPTER_1_CONTROLS_CAMERA_SUCCESS")

	KillQuest()

	StartQuest("B_CharControl","#Player","",false)	
end




