-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\A_Build_1"
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

	SetMainQuest("Build")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_QUESTBOOK",true)

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_NAME","@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_QUESTBOOK")
	
	ShowTutorialBoxNoWait(100, 700, 600, 225, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_NAME",  "@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_TASK",  "Hud/Renderings/Smithy_low_01.tga")
	
	local TotalBuildings = DynastyGetBuildingCount("#Player",-1,-1)
	
	SetData("TotalBuildings",TotalBuildings)
	
	HudEnableElement("BuildBuilding", true)
	
	CreditMoney("#Player",2000,"Buy Building Credit")
end

function CheckEnd()
	local object = FindNode("\\application\\game\\Hud")
	local SwitchTo = 0
	if HudPanelIsVisible("BuildBuildingPatron") then
		object:ShowSheet("BuildBuildingPatron","BuildBuilding")
		SwitchTo = 1
	end
	if HudPanelIsVisible("BuildBuildingScholar") then
		object:ShowSheet("BuildBuildingScholar","BuildBuilding")
		SwitchTo = 1
	end
	if HudPanelIsVisible("BuildBuildingChiseler") then
		object:ShowSheet("BuildBuildingChiseler","BuildBuilding")
		SwitchTo = 1
	end
	if HudPanelIsVisible("BuildBuildingMisc") then
		object:ShowSheet("BuildBuildingMisc","BuildBuilding")
		SwitchTo = 1
	end
	
	if (SwitchTo == 1) then
		object:ShowSheet("BuildBuildingArtisan","BuildBuilding")
	end

	local MinMoney = 2000
	if GetMoney("#Player") < MinMoney then
		local GiveMoney = MinMoney - GetMoney("#Player")
		CreditMoney("#Player",GiveMoney,"Buy Building Credit")
	end
	local TotalBuildings = DynastyGetBuildingCount("#Player",-1,-1)
	if (TotalBuildings ~= GetData("TotalBuildings")) then
		SetData("TotalBuildings",TotalBuildings)
		local TotalSmiddys = DynastyGetBuildingCount("#Player",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_SMITHY)
		if (TotalSmiddys ~= 1) then
			MsgQuestNoWait("#Player",0,"@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_NAME","@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_FAILED")
		end
	end
	local TotalSmiddys = DynastyGetBuildingCount("#Player",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_SMITHY)
	if (TotalSmiddys == 1) then

		local Count = CityGetBuildings("#Capital", GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_SMITHY, -1, -1, FILTER_IGNORE, "CitySmithys")
		
		local l
		for l=0,Count-1 do
			Alias	= "CitySmithys"..l
			if BuildingGetOwner(Alias,"BuildingOwner") then
				if GetID("BuildingOwner") == GetID("#Player") then
					HudEnableElement("BuildBuilding", false)
					ShowTutorialBoxNoWait(100, 690, 450, 145, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_NAME",  "@L_TUTORIAL_CHAPTER_3_BUILD_BUILDING_BUILD_A_SHOP_PROGRESS",  "")
					if CanBeControlled(Alias,"#PlayerDynasty") then
						ResetGamespeed()
						ForbidMeasure(Alias, "SellBuilding", EN_BOTH)
						ForbidMeasure(Alias, "TearDownBuilding", EN_BOTH)
						HideTutorialBox()
						return true
					end
				end
			end
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

	StartQuest("B_BuildingInfo_1","#Player","",false)

	KillQuest()
end




