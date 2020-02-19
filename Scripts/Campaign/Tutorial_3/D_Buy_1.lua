-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\D_Buy_1"
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

	SetMainQuestTitle("Buy", "@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_NAME")
	SetMainQuestDescription("Buy","@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_QUESTBOOK")

	SetMainQuest("Buy")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_QUESTBOOK",true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_NAME","@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_QUESTBOOK")
	
	ShowTutorialBoxNoWait(90, 690, 450, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_NAME",  "@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_TASK",  "")
	
	local Count = CityGetBuildings("#Capital", GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_TAILORING, -1, -1, FILTER_IGNORE, "CityTailors")

	local TotalBuildings = DynastyGetBuildingCount("#Player",-1,-1)

	SetData("TotalBuildings",TotalBuildings)

	Alias	= "CityTailors"..0
	local TailorID = GetID(Alias)
	GetAliasByID(TailorID,"TailorAlias")

	SetData("Tailor",TailorID)

	ExitBuildingWithCamera()

	CameraTerrainSetPos("TailorAlias",2000)
end

function CheckEnd()
	GetAliasByID(GetData("Tailor"),"TailorAlias")

	if (HudGetSelected("MySelection")) then
		if (GetID("MySelection") == GetData("Tailor")) then
			HideTutorialBox()
			StartQuest("D_Buy_1b","#Player","",false)	
			ResetQuest()			
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
	Sleep(1)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_NAME","@L_TUTORIAL_CHAPTER_3_EXIT")
	
	KillQuest()

	CampaignExit(true)
end




