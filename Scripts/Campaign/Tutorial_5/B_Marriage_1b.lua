-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Favor_4"
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
	SetExclusiveMeasure("#Player", "CourtLover", EN_BOTH)
	
	SetExclusiveMeasure("#Spoose", "CourtLover", EN_PASSIVE)

	while true do
		if HudPanelIsVisible("MessageBoxPanel") then
			HideTutorialBox()
		end
		if SimGetCourtLover("#Player","LoverAlias") then
			if (GetID("LoverAlias") == GetID("#Spoose")) then
				RemoveImpact("#Spoose","FinnishQuest")	
				ForbidMeasure("#Spoose", "CourtLover", EN_BOTH)
				ForbidMeasure("#Player", "CourtLover", EN_BOTH)
				HideTutorialBox()
				break
			else
				MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_5_MARRIAGE_NAME","@L_TUTORIAL_CHAPTER_5_MARRIAGE_FAILED")
				if (GetRepeatTimerLeft("","BribeCharacter") > 0) then
					SetRepeatTimer("", GetMeasureRepeatName2("BribeCharacter"), 0)
				end			
				SimReleaseCourtLover("#Player")
			end
		end
		Sleep(1)
	end
	StartQuest("B_Marriage_2","#Player","",false)

	KillQuest("B_Marriage_1")
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
	StartQuest("B_Marriage_2","#Player","",false)

	KillQuest()
end




