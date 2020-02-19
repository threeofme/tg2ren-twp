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
	ShowTutorialBoxNoWait(100, 690, 500, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_6_OFFICE_NAME",  "@L_TUTORIAL_CHAPTER_6_OFFICE_BRIBERY_TASK",  "")
	while true do
		if HasProperty("#CouncilBuilding","sessioncutszene") then
			local CutsceneID = GetProperty("#CouncilBuilding","sessioncutszene")
			GetAliasByID(CutsceneID,"CutsceneAlias")

			local EventTime = b_office_2_GetDataFromCutscene("CutsceneAlias","EventTime")

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
				
		if not GetInsideBuilding("#Player","InsideBuilding") and not CameraIsIndoor() then
			HideTutorialBox()
			break
		end
		Sleep(1)
	end
	StartQuest("B_Office_3","#Player","",false)
	
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



