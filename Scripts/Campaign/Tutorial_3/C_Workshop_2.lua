-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\C_Workshop_1"
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
	
	local Money = GetMoney("#Player")
	f_SpendMoney("#Player",Money,"Tutorial")
	
	CameraIndoorGetBuilding("MyBuilding")
	SetData("Building",GetID("MyBuilding"))

	SetMainQuest("Workshop")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_WORKSHOP_INDOOR_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_WORKSHOP_INDOOR_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_WORKSHOP_INDOOR_NAME","@L_TUTORIAL_CHAPTER_3_WORKSHOP_INDOOR_QUESTBOOK")
	
	ShowTutorialBoxNoWait(275, 690, 450, 160, 1, LEFTLOWER, "@L_TUTORIAL_CHAPTER_3_WORKSHOP_INDOOR_NAME",  "@L_TUTORIAL_CHAPTER_3_WORKSHOP_INDOOR_TASK",  "Hud/Buttons/btn_showUpgrade.tga")
end

function CheckEnd()
	GetAliasByID(GetData("Building"),"Smithy")
	if (CameraIndoorGetBuilding("MyBuilding2") == false) or (GetID("MyBuilding2") ~= GetData("Building")) then
		CameraIndoorSetBuilding("Smithy")
	end
	
	if (not HudGetSelected("SelectedObject")) or (GetID("SelectedObject") ~= GetID("Smithy")) then
		HudSelect("Smithy")
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
	StartQuest("C_Workshop_3","#Player","",false)

	KillQuest()
end




