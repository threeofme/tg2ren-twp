-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\C_Workshop_4"
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

	SetMainQuest("Workshop")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_WORKSHOP_REPAIR_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_WORKSHOP_REPAIR_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_WORKSHOP_REPAIR_NAME","@L_TUTORIAL_CHAPTER_3_WORKSHOP_REPAIR_QUESTBOOK")
	
	ShowTutorialBoxNoWait(625, 690, 450, 160, 1, RIGHTLOWER, "@L_TUTORIAL_CHAPTER_3_WORKSHOP_REPAIR_NAME",  "@L_TUTORIAL_CHAPTER_3_WORKSHOP_REPAIR_TASK",  "Hud/Buttons/btn_Building_Repair.tga")

	local Count = CityGetBuildings("#Capital", GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_SMITHY, -1, -1, FILTER_IGNORE, "CitySmithys")
	
	local l
	for l=0,Count-1 do
		Alias	= "CitySmithys"..l
		if BuildingGetOwner(Alias,"BuildingOwner") then
			if GetID("BuildingOwner") == GetID("#Player") then
				SetData("MySmithy",Alias)
				local MaxHP = GetMaxHP(Alias)
				ModifyHP(Alias,-MaxHP / 2,false)
				SetData("SmithyHP",GetHP(GetProperty("#Player","Smithy")))
				break
			end
		end
	end
	
	if HudPanelIsVisible("BuildingUpgradeSheet") then
		local object = FindNode("\\application\\game\\Hud")
		object:ShowSheet("BuildingUpgradeSheet",0)	
	end
	
	ExitBuildingWithCamera()
end

function CheckEnd()
	if (not HudGetSelected("SelectedObject")) or (GetID("SelectedObject") ~= GetID(GetProperty("#Player","Smithy"))) then
		HudSelect(GetProperty("#Player","Smithy"))
	end	

	local MinMoney = 1500
	if GetMoney("#Player") < MinMoney then
		local GiveMoney = 1500 - GetMoney("#Player")
		CreditMoney("#Player",GiveMoney,"Buy Building Credit")
	end
	if (GetHP(GetProperty("#Player","Smithy")) > GetData("SmithyHP")) then
		ResetGamespeed()
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
	Sleep(1)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_WORKSHOP_REPAIR_NAME","@L_TUTORIAL_CHAPTER_3_WORKSHOP_REPAIR_SUCCESS")
	
	StartQuest("D_Buy_1","#Player","",false)

	KillQuest()
end




