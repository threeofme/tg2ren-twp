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
	ShowTutorialBoxNoWait(100, 640, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_6_NAME",  "@L_TUTORIAL_CHAPTER_6_OFFICE_BRIBERY_TASK3",  "")

	local showedhint = 0

	while true do
		if HasProperty("#CouncilBuilding","sessioncutszene") then
			local CutsceneID = GetProperty("#CouncilBuilding","sessioncutszene")
			GetAliasByID(CutsceneID,"CutsceneAlias")

			local EventTime = b_office_4_GetDataFromCutscene("CutsceneAlias","EventTime")

			if (GetGametime() >= ((EventTime/60)-1.5) and showedhint == 0) then
				showedhint = 1
--				ShowTutorialBoxNoWait(100, 690, 800, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_6_NAME",  "@L_TUTORIAL_CHAPTER_6_FAVOR_BAR",  "")
			end

			if (GetGametime() >= ((EventTime/60)-0.3)) then
				ResetGamespeed()
				if (GetInsideBuildingID("#Player") ~= GetID("#CouncilBuilding")) then
					GetLocatorByName("#CouncilBuilding","Stroll3","Stroll3")
					StopAllAnimations("#Player")
					SimBeamMeUp("#Player","Stroll3")
				end
				CameraIndoorGetBuilding("CameraBuilding")
				if (GetID("CameraBuilding") ~= GetID("#CouncilBuilding")) then
					CameraIndoorSetBuilding("#CouncilBuilding")
				end
				break
			end
		end
		Sleep(1)
	end

	while true do
		if (BuildingGetCutscene("#CouncilBuilding","TheCutscene") == true) then
			HideTutorialBox()
			MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_6_NAME","@L_TUTORIAL_CHAPTER_6_OFFICE_MEETING")
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

function GetDataFromCutscene(CutsceneAlias,Data)
	CutsceneGetData("CutsceneAlias",Data)
	local returnData = GetData(Data)
	return returnData
end
