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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_6_OFFICE_BRIBERY_NAME","@L_TUTORIAL_CHAPTER_6_OFFICE_BRIBERY_QUESTBOOK2")

	ShowTutorialBoxNoWait(100, 640, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_6_OFFICE_BRIBERY_NAME",  "@L_TUTORIAL_CHAPTER_6_OFFICE_BRIBERY_TASK2",  "Hud/Buttons/btn_041_bribeCharacter.tga",GetID("#TutNPC1"))

	SetExclusiveMeasure("#Player", "BribeCharacter", EN_BOTH)
	
	AddImpact("#TutNPC1","FinnishQuest",1,-1)	

	while true do
		if HasProperty("#CouncilBuilding","sessioncutszene") then
			local CutsceneID = GetProperty("#CouncilBuilding","sessioncutszene")
			GetAliasByID(CutsceneID,"CutsceneAlias")

			local EventTime = b_office_3_GetDataFromCutscene("CutsceneAlias","EventTime")

			if (GetGametime() >= ((EventTime/60)-0.25)) then
--Workaround for TG2Ren 4.2
--				ResetGamespeed()
--				if (GetInsideBuildingID("#Player") ~= GetID("#CouncilBuilding")) then
--					GetLocatorByName("#CouncilBuilding","Stroll3","Stroll3")
--					StopAllAnimations("#Player")
--					SimBeamMeUp("#Player","Stroll3")
--				end
--				CameraIndoorGetBuilding("CameraBuilding")
--				if (GetID("CameraBuilding") ~= GetID("#CouncilBuilding")) then
--					CameraIndoorSetBuilding("#CouncilBuilding")
--				end
--				StartQuest("B_Office_4b","#Player","",false)
				HideTutorialBox()
				StartQuest("End6","#Player","",false)
---------------------------
				KillQuest()
			end
		end		
		
		if GetFavorToSim("#TutNPC1","#Player") > 50 then
			ForbidMeasure("#Player", "BribeCharacter", EN_BOTH)
--			ShowTutorialBoxNoWait(100, 690, 850, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_6_NAME",  "@L_TUTORIAL_CHAPTER_6_FAVOR_BAR",  "")
			RemoveImpact("#TutNPC1","FinnishQuest")	
			break
		end
		if (GetRepeatTimerLeft("","CourtLover") > 0) then
			SetRepeatTimer("", GetMeasureRepeatName2("CourtLover"), 0)
		end
		Sleep(1)
	end
	
--Workaround for TG2Ren 4.2
--	StartQuest("B_Office_4","#Player","",false)
	HideTutorialBox()
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_6_NAME","@L_TUTORIAL_CHAPTER_6_EXIT")
	CampaignExit(true)
---------------------------
	
	KillQuest("B_Office_2")
	KillQuest()
end

function CheckEnd()
	return false
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
end


function GetDataFromCutscene(CutsceneAlias,Data)
	CutsceneGetData("CutsceneAlias",Data)
	local returnData = GetData(Data)
	return returnData
end


