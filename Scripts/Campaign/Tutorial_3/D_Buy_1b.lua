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
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_NAME","@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_SUCCESS")
	ShowTutorialBoxNoWait(270, 690, 450, 150, 1, LEFTLOWER, "@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_NAME",  "@L_TUTORIAL_CHAPTER_3_BUY_BUILDING_TASK2",  "Hud/Buttons/btn_Building_Buy.tga")
	
	local Count = CityGetBuildings("#Capital", GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_TAILORING, -1, -1, FILTER_IGNORE, "CityTailors")

	local TotalBuildings = DynastyGetBuildingCount("#Player",-1,-1)

	SetData("TotalBuildings",TotalBuildings)

	Alias	= "CityTailors"..0
	local TailorID = GetID(Alias)
	GetAliasByID(TailorID,"TailorAlias")

	SetData("Tailor",TailorID)

	AllowMeasure("TailorAlias", "BuyBuilding", EN_BOTH)	
end

function CheckEnd()
	local MinMoney = 2000
	if GetMoney("#Player") < MinMoney then
		local GiveMoney = MinMoney - GetMoney("#Player")
		CreditMoney("#Player",GiveMoney,"Buy Building Credit")
	end

	local Count = CityGetBuildings("#Capital", GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_TAILORING, -1, -1, FILTER_IGNORE, "CityTailors")
	
	local l
	for l=0,Count-1 do
		Alias	= "CityTailors"..l
		if BuildingGetOwner(Alias,"BuildingOwner") then
			if GetID("BuildingOwner") == GetID("#Player") then
				HideTutorialBox()
				return true
			end
		end
	end
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_NAME","@L_TUTORIAL_CHAPTER_3_EXIT")
	
	KillQuest()

	CampaignExit(true)
end




