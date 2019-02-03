-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\B_BuildingInfo_1"
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
	
	HudEnableElement("BuildBuilding", false)
	
	SetMainQuestTitle("BuildingInfo", "@L_TUTORIAL_CHAPTER_3_BUILDING_GENERAL_NAME")
	SetMainQuestDescription("BuildingInfo","@L_TUTORIAL_CHAPTER_3_BUILDING_GENERAL_QUESTBOOK")	
	
	SetMainQuest("BuildingInfo")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_RESIDENCE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_RESIDENCE_QUESTBOOK",true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_RESIDENCE_NAME","@L_TUTORIAL_CHAPTER_3_RESIDENCE_QUESTBOOK")
	ShowTutorialBoxNoWait(100, 690, 450, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_3_RESIDENCE_NAME",  "@L_TUTORIAL_CHAPTER_3_RESIDENCE_TASK",  "")
		
	SetState("#Player", STATE_CUTSCENE, false)
	SetState("#Residence", STATE_LOCKED, false)
end

function CheckEnd()
	if (HudGetSelected("MySelection")) then 
		if (GetID("MySelection") == GetID("#Residence")) then
			StartQuest("B_BuildingInfo_1b","#Player","",false)	
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
	StartQuest("B_BuildingInfo_2","#Player","",false)

	KillQuest()
end




