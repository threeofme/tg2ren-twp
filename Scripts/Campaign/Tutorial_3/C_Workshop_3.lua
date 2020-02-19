-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\C_Workshop_1"
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
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_WORKSHOP_UPGRADE_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_WORKSHOP_UPGRADE_QUESTBOOK",true)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_WORKSHOP_UPGRADE_NAME","@L_TUTORIAL_CHAPTER_3_WORKSHOP_UPGRADE_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 700, 450, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_3_WORKSHOP_UPGRADE_NAME",  "@L_TUTORIAL_CHAPTER_3_WORKSHOP_UPGRADE_TASK",  "")

	local Count = CityGetBuildings("#Capital", GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_SMITHY, -1, -1, FILTER_IGNORE, "CitySmithys")
	
	local l
	for l=0,Count-1 do
		Alias	= "CitySmithys"..l
		if BuildingGetOwner(Alias,"BuildingOwner") then
			if GetID("BuildingOwner") == GetID("#Player") then
				if CameraIndoorGetBuilding("CameraBuilding") then
					if GetID(Alias) == GetID("CameraBuilding") then
						SetData("MySmithy",Alias)
					end
				end
			end
		end
	end
	
	SetData("Sheet",0)
end

function CheckEnd()
	if (CameraIndoorGetBuilding("MyBuilding2") == false) or (GetID("MyBuilding2") ~= GetID(GetProperty("#Player","Smithy"))) then
		CameraIndoorSetBuilding(GetProperty("#Player","Smithy"))
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

	local MinMoney = 1500
	if GetMoney("#Player") < MinMoney then
		local GiveMoney = 1500 - GetMoney("#Player")
		CreditMoney("#Player",GiveMoney,"Upgrade Building Credit")
	end
	local UpgradeArray = {17,18,337,340,338,625}
	
	local Upgrades = 6
	local Count
	local HaveUpgrade = 0
	for Count=1,Upgrades do
		if BuildingHasUpgrade(GetProperty("#Player","Smithy"),UpgradeArray[Count]) then
			HaveUpgrade = 1
		end
	end

	if (HaveUpgrade == 1) then
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
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_WORKSHOP_UPGRADE_NAME","@L_TUTORIAL_CHAPTER_3_WORKSHOP_UPGRADE_SUCCESS")
	
	StartQuest("C_Workshop_4","#Player","",false)

	KillQuest()
end




