-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\B_BuildingInfo_2"
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
	if HasProperty("#Player","Reset") then
		RemoveProperty("#Player","Reset")
		KillQuest()
	end
	HudEnableElement("BuildBuilding", false)

	SetMainQuest("BuildingInfo")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_RESIDENCE_INDOOR_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_RESIDENCE_INDOOR_QUESTBOOK",true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_RESIDENCE_INDOOR_NAME","@L_TUTORIAL_CHAPTER_3_RESIDENCE_INDOOR_QUESTBOOK")

	ShowTutorialBoxNoWait(275, 690, 450, 160, 1, LEFTLOWER, "@L_TUTORIAL_CHAPTER_3_RESIDENCE_INDOOR_NAME",  "@L_TUTORIAL_CHAPTER_3_RESIDENCE_INDOOR_TASK",  "Hud/Buttons/btn_showUpgrade.tga")

	SetState("#Player", STATE_CUTSCENE, true)

	CameraIndoorGetBuilding("MyBuilding")
	SetData("Building",GetID("MyBuilding"))
	
	AllowMeasure("#Residence", "ShowBuildingUpgradeTree", EN_BOTH)
end

function CheckEnd()
	if (CameraIndoorGetBuilding("MyBuilding2") == false) or (GetID("MyBuilding2") ~= GetData("Building")) then
		GetAliasByID(GetData("Building"),"Smithy")
		CameraIndoorSetBuilding("Smithy")
	end

	if (not HudGetSelected("SelectedObject")) or (GetID("SelectedObject") ~= GetID("#Residence")) then
		HudSelect("#Residence")
	end

	if HudPanelIsVisible("BuildingUpgradeSheet") then
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
	StartQuest("B_BuildingInfo_3","#Player","",false)

	KillQuest()
end




