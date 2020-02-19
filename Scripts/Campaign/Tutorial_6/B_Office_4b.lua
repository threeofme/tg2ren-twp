-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\B_Office_2"
----
----	OPEN CHAR OVERVIEW
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
	while true do
		if (BuildingGetCutscene("#CouncilBuilding","TheCutscene") == true) then
			RemoveImpact("#TutNPC1","FinnishQuest")	
			HideTutorialBox();
			SetExclusiveMeasure("#Player", "BribeCharacter", EN_BOTH)
			break
		end
		Sleep(1)
	end	
end

function CheckEnd()
	if (BuildingGetCutscene("#CouncilBuilding","TheCutscene") == false) then
		if SimGetOffice("#Player","HisOffice") then
			return true
		end
		HideTutorialBox()
		StartQuest("End6","#Player","",false)
		KillQuest()
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_6_NAME","@L_TUTORIAL_CHAPTER_6_EXIT")

	CampaignExit(true)
end
