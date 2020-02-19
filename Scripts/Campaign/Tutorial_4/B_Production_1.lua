-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\B_Production_1"
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
	SetMainQuestTitle("Production", "@L_TUTORIAL_CHAPTER_4_PRODUCTION_NAME")
	SetMainQuestDescription("Production","@L_TUTORIAL_CHAPTER_4_PRODUCTION_QUESTBOOK")	
	
	SetMainQuest("Production")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_4_PRODUCTION_ASSIGN_TO_WORK_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_4_PRODUCTION_ASSIGN_TO_WORK_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_PRODUCTION_ASSIGN_TO_WORK_NAME","@L_TUTORIAL_CHAPTER_4_PRODUCTION_ASSIGN_TO_WORK_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 690, 500, 150, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_4_PRODUCTION_ASSIGN_TO_WORK_NAME",  "@L_TUTORIAL_CHAPTER_4_PRODUCTION_ASSIGN_TO_WORK_TASK",  "Hud/Items/Item_Tool.tga")
	
	SetState("#Player", STATE_CUTSCENE, false)
end

function CheckEnd()
	if (GetItemCount("#Smithy","Iron") < 2) then
		AddItems("#Smithy","Iron",2 - GetItemCount("#Smithy","Iron"))
	end
	
	if (GetItemCount("#Smithy","Pinewood") < 2) then
		AddItems("#Smithy","Pinewood",2 - GetItemCount("#Smithy","Pinewood"))
	end	

	local WorkerCount = BuildingGetWorkerCount("#Smithy")
	
	for Count=0,WorkerCount-1 do
		BuildingGetWorker("#Smithy",Count,"MyWorker")
		local HisMeasure = GetCurrentMeasureName("MyWorker")
		local MyMeasure = GetCurrentMeasureName("#Player")
		if (HisMeasure == "BaseProduce") or (MyMeasure == "BaseProduce")then
			HideTutorialBox()
			return true
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_PRODUCTION_ASSIGN_TO_WORK_NAME","@L_TUTORIAL_CHAPTER_4_PRODUCTION_ASSIGN_TO_WORK_SUCCESS")
	
	local object = FindNode("\\application\\game\\Hud")
	object:ShowInventoryPanel("ProductionSheet",false)
	object:ShowInventoryPanel("StoreSheet",false)
	object:ShowInventoryPanel("TransportSheet",false)

	StartQuest("C_Sell_1","#Player","",false)

	KillQuest()
end




