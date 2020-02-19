-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\B_BuildingInfo_3"
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
	SetMainQuest("BuildingInfo")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_QUESTBOOK",true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_NAME","@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 690, 450, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_NAME",  "@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_TASK",  "")

	CameraIndoorGetBuilding("MyBuilding")
	SetData("Building",GetID("MyBuilding"))
	
	SetData("Sheet",0)
end

function CheckEnd()
	if (CameraIndoorGetBuilding("MyBuilding2") == false) or (GetID("MyBuilding2") ~= GetData("Building")) then
		GetAliasByID(GetData("Building"),"Smithy")
		CameraIndoorSetBuilding("Smithy")
	end
	
	if not HudPanelIsVisible("BuildingUpgradeSheet") then
		ShowTutorialBoxNoWait(275, 690, 450, 160, 1, LEFTLOWER, "@L_TUTORIAL_CHAPTER_3_RESIDENCE_INDOOR_NAME",  "@L_TUTORIAL_CHAPTER_3_RESIDENCE_INDOOR_TASK",  "Hud/Buttons/btn_showUpgrade.tga")
		SetData("Sheet",1)
	else
		if GetData("Sheet") == 1 then
			SetData("Sheet",0)
			ShowTutorialBoxNoWait(100, 690, 450, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_NAME",  "@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_TASK",  "")
		end
	end
	
	if (not HudGetSelected("SelectedObject")) or (GetID("SelectedObject") ~= GetID("#Residence")) then
		HudSelect("#Residence")
	end		
	
	local MinMoney = 1500
	if GetMoney("#Player") < MinMoney then
		local GiveMoney = 1500 - GetMoney("#Player")
		CreditMoney("#Player",GiveMoney,"Buy Building Credit")
	end
	local UpgradeArray = {294,293,589,512,511}
	local Upgrades = 5
	local Count
	local HaveUpgrade = 0
	for Count=1,Upgrades do
		if BuildingHasUpgrade("#Residence",UpgradeArray[Count]) then
			HaveUpgrade = 1
		end
	end

	if (HaveUpgrade == 1) then
		HideTutorialBox()
		HaveUpgrade = 2
		local Money = GetMoney("#Player")
		f_SpendMoney("#Player",Money,"Tutorial")		
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_NAME","@L_TUTORIAL_CHAPTER_3_RESIDENCE_UPGRADE_SUCCESS")
	
	StartQuest("B_BuildingInfo_4","#Player","",false)

	KillQuest()
end




