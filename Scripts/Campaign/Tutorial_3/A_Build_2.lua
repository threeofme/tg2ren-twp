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

	SetMainQuest("Build")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILDING_LIST_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILDING_LIST_QUESTBOOK",true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILDING_LIST_NAME","@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILDING_LIST_QUESTBOOK")
	
	ShowTutorialBoxNoWait(400, 125, 450, 150, 2, LEFTUPPER, "@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILDING_LIST_NAME",  "@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILDING_LIST_TASK",  "")
end

function CheckEnd()
	if HudPanelIsVisible("BuildBuildingArtisan") then
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

	StartQuest("A_Build_3","#Player","",false)

	KillQuest()
end




