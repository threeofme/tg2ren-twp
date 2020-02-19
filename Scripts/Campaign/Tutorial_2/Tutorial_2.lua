-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_2\Tutorial_2"
----
----	Initiates map for Tutorial - Chapter2
----
----	1. function GetWorld
----	2. function Prepare
----	3. function CreatePlayerDynasty
----		3.1. Set main data
----		3.2. Create the player's character
----	4. function CreateComputerDynasty
----		NONE
----	5. function Start
----		NONE
----	6. Bind / Start Quest(s)
----		6.1. Set the start camera
----
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
----	1. function GetWorld
----		load the world for the campaign
-------------------------------------------------------------------------------
function GetWorld()
	return "tutorial.wld"
end

function CreateComputerDynasty(Number, SpawnPoint)
end

function CreateShadowDynasty(Number, City, NewDynastyAlias)
end


-------------------------------------------------------------------------------
----	2. function Prepare
----		this function is called directly after the world is loaded
----		use this function for creating dynasties and sim's
----		on success return nothing or a empty string
----		on error return the error message
-------------------------------------------------------------------------------
function Prepare()
	ScenarioSetYearsPerRound(1)
	SetTime(EN_SEASON_SPRING,1404, 7, 0)

	GetScenario("World")
	SetProperty("World", "static", 1)

	return true
end


-------------------------------------------------------------------------------
----	3. function CreatePlayerDynasty
----		3.1. Set main data
----			Locate the capital of the map. Then find the residence and the
----			workbuilding for the player's character
-------------------------------------------------------------------------------
function CreatePlayerDynasty()

	--------------------------------------------------------------------------------
	---- set the distance of the camera to the dialog partners
	--------------------------------------------------------------------------------
	local DialogCam = 900
	SetData("#DialogCam", DialogCam)

	local Capital = "Hucknall"
	SetData("#Capital", Capital)

	if not ScenarioGetObjectByName("Settlement", Capital, "#Capital") then
		return "error - no settlement named "..Capital.." found"
	end

	-------------------------------------------------------------------------------
	----	Get the market of Nottingham
	-------------------------------------------------------------------------------
	if (ScenarioGetObjectByName("Building", "Market", "#Market"))  then
	elseif not CityGetRandomBuilding("#Capital", GL_BUILDING_CLASS_MARKET, -1, -1, -1, false, "#Market") then
		return "no market found in "..Capital
	end

	local Radius = 8000

-------------------------------------------------------------------------------
----	3.2. Create the player's character
----		Create the Player's main character, set his surname, create
----		his dynasty named with the surname, give the main character a
----		budget, set the names of the residence and the workshop and
----		make the main character own both buildings.
-------------------------------------------------------------------------------
	if (ScenarioGetObjectByName("Building", "PlayerHome", "#Residence"))  then
	elseif not Find("#Market", "__F( (Object.GetObjectsByRadius(Building)=="..Radius..")AND(Object.IsBuyable())AND(Object.IsType(2)))","#Residence", -1) then
		return "no residence found in "..Capital
	end

	-------------------------------------------------------------------------------
	----	Get the smithy for the player character in the radius of the market
	-------------------------------------------------------------------------------
	if not ScenarioCreatePosition(-26382, 7885, "PlayerStartPosition") then
		return "unable to move Duncan to new 'PlayerStartPosition'"
	end

	if not SimCreate(499, "#Residence", "PlayerStartPosition", "#Player") then
		return "unable to create the boss for the dynasty '"..Surname.."'"
	end

	SimSetFirstname("#Player", "@L_TUTORIAL_FIRSTNAME_+0")
	SimSetLastname("#Player", "@L_TUTORIAL_LASTNAME_+0")
	SimSetReligion("#Player", 0)
	SetProperty("#Player","NoBard",1)
	SimSetMortal("#Player", false)

	--------------------------------------------------------------------------
	----	CREATE SPOOSE
	--------------------------------------------------------------------------

	if not ScenarioCreatePosition(-26382, 8000, "SpooseStartPosition") then
		return "unable to move Spoose to new 'SpooseStartPosition'"
	end

	if not SimCreate(543, "#Residence", "SpooseStartPosition", "#Spoose") then
		return "unable to create the npc 'Gwendolyne '"
	end


	SimSetFirstname("#Spoose", "@L_TUTORIAL_FIRSTNAME_+1")
	SimSetLastname("#Spoose", "@L_TUTORIAL_LASTNAME_+0")
	SimSetReligion("#Spoose", 0)
	SimSetMortal("#Spoose", false)
	SimSetBehavior("#Spoose","")
	SetState("#Spoose", STATE_CUTSCENE, true)

	-------------------------------------------------------------------------------
	----	Forbid measures for the character
	-------------------------------------------------------------------------------
--	ForbidMeasure("#Spoose", "AdministrateDiplomacy", EN_BOTH)
--	ForbidMeasure("#Spoose", "ApplyDeposition", EN_BOTH)
--	ForbidMeasure("#Spoose", "ArrangeLiaison", EN_BOTH)
--	ForbidMeasure("#Spoose", "AttendUniversity", EN_BOTH)
--	ForbidMeasure("#Spoose", "BewitchCharacter", EN_BOTH)
--	ForbidMeasure("#Spoose", "BlackmailCharacter", EN_BOTH)
--	ForbidMeasure("#Spoose", "BribeCharacter", EN_BOTH)
--	ForbidMeasure("#Spoose", "BuyNobilityTitle", EN_BOTH)
--	ForbidMeasure("#Spoose", "ChangeFaith", EN_BOTH)
--	ForbidMeasure("#Spoose", "ChargeCharacter", EN_BOTH)
--	ForbidMeasure("#Spoose", "CourtLover", EN_BOTH)
--	ForbidMeasure("#Spoose", "InsultCharacter", EN_BOTH)
--	ForbidMeasure("#Spoose", "RunForAnOffice", EN_BOTH)
--	ForbidMeasure("#Spoose", "StartDialog", EN_PASSIVE)
--	ForbidMeasure("#Spoose", "TakeABath", EN_BOTH)
--	ForbidMeasure("#Spoose", "TakeABathAlone", EN_BOTH)
--	ForbidMeasure("#Spoose", "ThreatCharacter", EN_BOTH)
--	ForbidMeasure("#Spoose", "Rob", EN_BOTH)
--	ForbidMeasure("#Spoose", "Kill", EN_BOTH)
	SetExclusiveMeasure("#Spoose","Walk",EN_BOTH)
	SetExclusiveMeasure("#Spoose","run",EN_BOTH)
	SetExclusiveMeasure("#Spoose","StartDialog",EN_BOTH)

	if not DynastyCreate(4, true, "#Residence", "#PlayerDynasty") then
		return "cannot create the dynasty '"..Surname.."'"
	end
	
	SetProperty("#PlayerDynasty","NoDeath",1)

	DynastyAddMember("#PlayerDynasty","#Player")

	SimMarry("#Player","#Spoose")
	
	Sleep(2)
	
	DynastyRemoveMember("#Spoose","#Spoose")

	SetNobilityTitle("#Player", 1, true)

	SetName("#Residence", "@L_TUTORIAL_RESIDENCE_+0")

	if not BuildingBuy("#Residence", "#Player", BM_STARTUP) then
		return "unable to buy the residence for the player dynasty"
	end
	SetProperty("#Residence", "NOT_ATTACKABLE", 1)

	-------------------------------------------------------------------------------
	----	Forbid measures for the character
	-------------------------------------------------------------------------------
--	ForbidMeasure("#Player", "AdministrateDiplomacy", EN_BOTH)
--	ForbidMeasure("#Player", "ApplyDeposition", EN_BOTH)
--	ForbidMeasure("#Player", "ArrangeLiaison", EN_BOTH)
--	ForbidMeasure("#Player", "AttendUniversity", EN_BOTH)
--	ForbidMeasure("#Player", "BewitchCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "BlackmailCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "BribeCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "BuyNobilityTitle", EN_BOTH)
--	ForbidMeasure("#Player", "ChangeFaith", EN_BOTH)
--	ForbidMeasure("#Player", "ChargeCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "CourtLover", EN_BOTH)
--	ForbidMeasure("#Player", "InsultCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "RunForAnOffice", EN_BOTH)
--	ForbidMeasure("#Player", "StartDialog", EN_PASSIVE)
--	ForbidMeasure("#Player", "TakeABath", EN_BOTH)
--	ForbidMeasure("#Player", "TakeABathAlone", EN_BOTH)
--	ForbidMeasure("#Player", "ThreatCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "Rob", EN_BOTH)
--	ForbidMeasure("#Player", "Kill", EN_BOTH)
	SetExclusiveMeasure("#Player","Walk",EN_BOTH)
	SetExclusiveMeasure("#Player","run",EN_BOTH)
	SetExclusiveMeasure("#Player","StartDialog",EN_BOTH)

	-------------------------------------------------------------------------------
	----	Forbid building measures in bound with the players buildings
	-------------------------------------------------------------------------------
	ForbidMeasure("#Residence", "SellBuilding", EN_BOTH)
	ForbidMeasure("#Residence", "ShowBuildingLevels", EN_BOTH)
	ForbidMeasure("#Residence", "TearDownBuilding", EN_BOTH)
	SetState("#Residence", STATE_LOCKED, true)

end


-------------------------------------------------------------------------------
----	4. function CreateComputerDynasty
----		Creates for all free workshops in the world a npc dynasty
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
----	5. function Start
----		this function is called, after the init of the scenario is finished
-------------------------------------------------------------------------------
function Start()
	ScenarioPauseAI(true)
	local Capital
	Capital = GetData("#Capital")


-------------------------------------------------------------------------------
----	5.10. Set NotifyOnStateChange for the important characters
-------------------------------------------------------------------------------

NotifyOnStateChange("#Player", STATE_DEAD, "_Tutorial_Chapter1/_Tutorial_Chapter1/Lost1.lua", "OnStateChange")

-------------------------------------------------------------------------------
----	5.10. Create TutorialNPC Classes Sims
-------------------------------------------------------------------------------

	local Radius = 10000
	if (ScenarioGetObjectByName("Building", "TutNPCHome1", "#TutNPCHome1"))  then
	elseif not Find("#Market", "__F( (Object.GetObjectsByRadius(Building)=="..Radius..")AND(Object.IsType(1)))","#TutNPCHome1", -1) then
		return "no worker housing found for 'TutNPCs'"
	end
	SetProperty("#TutNPCHome1", "NOT_ATTACKABLE", 1)

	DynastyCreate(1, false, "#TutNPCHome1", "#TutNPCDynastie1")
	
	SetProperty("#TutNPCDynastie1","NoDeath",1)

	if (ScenarioGetObjectByName("Building", "TutNPCHome2", "#TutNPCHome2"))  then
	elseif not Find("#Market", "__F( (Object.GetObjectsByRadius(Building)=="..Radius..")AND(Object.IsType(1)))","#TutNPCHome2", -1) then
		return "no worker housing found for 'TutNPCs'"
	end
	SetProperty("#TutNPCHome2", "NOT_ATTACKABLE", 1)

	DynastyCreate(2, false, "#TutNPCHome2", "#TutNPCDynastie2")
	
	SetProperty("#TutNPCDynastie2","NoDeath",1)

	if not SimCreate(716, "#TutNPCHome1", "#Market", "#TutNPC1") then
		return "unable to create the npc 'TutNPC1'"
	end

	SetState("#TutNPC1", STATE_NPC, true)
	SetProperty("#TutNPC1","NoBard",1)
	DynastyAddMember("#TutNPCDynastie1","#TutNPC1")
	SimSetBehavior("#TutNPC1", "QuestNPCStrollMarket")
	SimSetMortal("#TutNPC1", false)

	if not SimCreate(717, "#TutNPCHome1", "#Market", "#TutNPC2") then
		return "unable to create the npc 'TutNPC2'"
	end

	SetState("#TutNPC2", STATE_NPC, true)
	SetProperty("#TutNPC2","NoBard",1)
	DynastyAddMember("#TutNPCDynastie1","#TutNPC2")
	SimSetBehavior("#TutNPC2", "QuestNPCStrollMarket")
	SimSetMortal("#TutNPC2", false)

	if not SimCreate(718, "#TutNPCHome2", "#Market", "#TutNPC3") then
		return "unable to create the npc 'TutNPC3'"
	end

	SetState("#TutNPC3", STATE_NPC, true)
	SetProperty("#TutNPC3","NoBard",1)
	DynastyAddMember("#TutNPCDynastie2","#TutNPC3")
	SimSetBehavior("#TutNPC3", "QuestNPCStrollMarket")
	SimSetMortal("#TutNPC3", false)

	if not SimCreate(719, "#TutNPCHome2", "#Market", "#TutNPC4") then
		return "unable to create the npc 'TutNPC4'"
	end

	SetState("#TutNPC4", STATE_NPC, true)
	SetProperty("#TutNPC4","NoBard",1)
	DynastyAddMember("#TutNPCDynastie2","#TutNPC4")
--	SimSetBehavior("#TutNPC4", "QuestNPCStrollMarket")
	SimSetMortal("#TutNPC4", false)


-------------------------------------------------------------------------------
----	6. Bind / Start Quest(s)
----		6.1. Set the start camera
-------------------------------------------------------------------------------
--	if GetOutdoorLocator("StartCamPos", -1 ,"StartCamPos") then
--		GetOutdoorLocator("StartCamDir", -1, "StartCamDir")
--		local Rotation = GetRotation("StartCamPos", "StartCamDir")
--		CameraTerrainSetPos("StartCamPos", 2000, Rotation)
--	else
		local Rotation = GetRotation("#Market", "#Residence")
		CameraTerrainSetPos("#Market", 2000, Rotation)
--	end


-------------------------------------------------------------------------------
----		6.2. Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------

	SetProperty("#Capital","InfectedSims",999)

	StartQuest("Intro2","#Player","",false)
end

