-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\B_BuildingInfo_3"
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

	SetMainQuest("BuildingInfo")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_RESIDENCE_LEAVE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_RESIDENCE_LEAVE_QUESTBOOK",true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_RESIDENCE_LEAVE_NAME","@L_TUTORIAL_CHAPTER_3_RESIDENCE_LEAVE_QUESTBOOK")
	
	ShowTutorialBoxNoWait(850, 690, 350, 135, 1, RIGHTLOWER, "@L_TUTORIAL_CHAPTER_3_RESIDENCE_LEAVE_NAME",  "@L_TUTORIAL_CHAPTER_3_RESIDENCE_LEAVE_TASK",  "")
		
	if HudPanelIsVisible("BuildingUpgradeSheet") then
		local object = FindNode("\\application\\game\\Hud")
		object:ShowSheet("BuildingUpgradeSheet",0)
	end
end

function CheckEnd()
	if (CameraIsIndoor() == false) then
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
	Sleep(1)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_RESIDENCE_LEAVE_NAME","@L_TUTORIAL_CHAPTER_3_RESIDENCE_LEAVE_SUCCESS")
	
	StartQuest("C_Workshop_1","#Player","",false)

	KillQuest()
end




