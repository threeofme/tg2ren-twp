-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\A_Build_1"
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
	
	HudEnableElement("BuildBuilding", true)
	
	SetMainQuestTitle("Build", "@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_NAME")
	SetMainQuestDescription("Build","@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_QUESTBOOK")	
	
	SetMainQuest("Build")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_QUESTBOOK",true)
	
	SetState("#Player", STATE_CUTSCENE, true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_NAME","@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 650, 450, 160, 1, LEFTLOWER, "@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_NAME",  "@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_TASK",  "Hud/NoCompression/btn_build.tga")
end

function CheckEnd()
	if HudPanelIsVisible("BuildBuildingPatron") or HudPanelIsVisible("BuildBuildingArtisan") or HudPanelIsVisible("BuildBuildingScholar") or HudPanelIsVisible("BuildBuildingChiseler") or HudPanelIsVisible("BuildBuildingMisc") then
		local object = FindNode("\\application\\game\\Hud")
		object:ShowSheet("BuildBuildingArtisan","BuildBuilding")
		object:ShowSheet("BuildBuildingPatron","BuildBuilding")
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

	StartQuest("A_Build_2","#Player","",false)

	KillQuest()
end




