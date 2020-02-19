-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\B_BuildingInfo_1"
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

	SetMainQuestTitle("BuildingInfo", "@L_TUTORIAL_CHAPTER_3_BUILDING_GENERAL_NAME")
	SetMainQuestDescription("BuildingInfo","@L_TUTORIAL_CHAPTER_3_BUILDING_GENERAL_QUESTBOOK")	
	
	SetMainQuest("BuildingInfo")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_RESIDENCE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_RESIDENCE_QUESTBOOK",true)
	
	HideTutorialBox()
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_RESIDENCE_NAME","@L_TUTORIAL_CHAPTER_3_RESIDENCE_SUCCESS")
	ShowTutorialBoxNoWait(850, 690, 350, 135, 1, RIGHTLOWER, "@L_TUTORIAL_CHAPTER_3_RESIDENCE_NAME",  "@L_TUTORIAL_CHAPTER_3_RESIDENCE_TASK2",  "")
	
end

function CheckEnd()
	if (not HudGetSelected("SelectedObject")) or (GetID("SelectedObject") ~= GetID("#Residence")) then
		HudSelect("#Residence")
	end
	
	if CameraIndoorGetBuilding("IndoorBuilding") then
		if GetID("IndoorBuilding") == GetID("#Residence") then
			HideTutorialBox()
			return true
		end
	end
	return false
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
	StartQuest("B_BuildingInfo_2","#Player","",false)

	KillQuest()
end




