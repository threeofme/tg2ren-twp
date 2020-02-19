-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_7\Tutorial_7"
----
----	Initiates map for Tutorial - Chapter6
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
--	SimSetMortal("#Player", false)

	--------------------------------------------------------------------------
	----	CREATE SPOOSE
	--------------------------------------------------------------------------

--	if not SimCreate(543, "#Residence", "#Market", "#Spoose") then
--		return "unable to create the npc 'Gwendolyne '"
--	end


	if not DynastyCreate(4, true, "#Residence", "#PlayerDynasty") then
		return "cannot create the dynasty '"..Surname.."'"
	end
	
	SetProperty("#PlayerDynasty","NoDeath",1)

	DynastyAddMember("#PlayerDynasty","#Player")

	SetNobilityTitle("#Player", 3, true)

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
--	ForbidMeasure("#Player", "AttendUniversity", EN_BOTH)
--	ForbidMeasure("#Player", "BewitchCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "BlackmailCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "BuyNobilityTitle", EN_BOTH)
--	ForbidMeasure("#Player", "RunForAnOffice", EN_BOTH)
--	ForbidMeasure("#Player", "ChangeFaith", EN_BOTH)
--	ForbidMeasure("#Player", "BribeCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "ChargeCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "InsultCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "StartDialog", EN_PASSIVE)
--	ForbidMeasure("#Player", "TakeABathAlone", EN_BOTH)
--	ForbidMeasure("#Player", "ThreatCharacter", EN_BOTH)
--	ForbidMeasure("#Player", "AttackEnemy", EN_BOTH)
--	ForbidMeasure("#Player", "Rob", EN_BOTH)
--	ForbidMeasure("#Player", "Kill", EN_BOTH)	
	SetExclusiveMeasure("#Player", "Walk", EN_BOTH)
	SetExclusiveMeasure("#Player", "run", EN_BOTH)

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

	CityGetRandomBuilding("#Capital",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_TOWNHALL,-1,-1,FILTER_IGNORE,"#CouncilBuilding")

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

	while true do
		if not SimCreate(719, "#TutNPCHome1", "#Market", "#TutNPC1") then
			return "unable to create the npc 'TutNPC1'"
		end
		if SimGetGender("#TutNPC1") == GL_GENDER_MALE then
			break
		end
		Sleep(0.5)
	end

	SetState("#TutNPC1", STATE_NPC, true)
	SetProperty("#TutNPC1","NoBard",1)
	DynastyAddMember("#TutNPCDynastie1","#TutNPC1")
	SimSetMortal("#TutNPC1", false)
	SetFavorToSim("#TutNPC1","#Player",40)

	if (ScenarioGetObjectByName("Building", "NPC1Workshop", "#Robbercamp"))  then
	elseif not Find("#Market", "__F( (Object.GetObjectsByRadius(Building)=="..Radius..")AND(Object.IsBuyable())AND(Object.IsType(22)))","#Robbercamp", -1) then
		return "no Robbercamp found in "..Capital
	end

	if not BuildingBuy("#Robbercamp", "#TutNPC1", BM_STARTUP) then
		return "unable to buy the ThievesGuild for the player dynasty"
	end
	SetProperty("#Robbercamp", "NOT_ATTACKABLE", 1)
	
	CopyAlias("#TutNPC1","#Victim")

	ScenarioCreatePosition(-29476, 14869,"EnemyPos")
	
	BuildingGetWorker("#Robbercamp",0,"#Victim")
	
	SimBeamMeUp("#Victim","EnemyPos")
	
	local MaxHP = GetMaxHP("#Victim")
	ModifyHP("#Victim",-MaxHP / 2,false)
	
	SimSetBehavior("#Victim","")
	
	DynastySetDiplomacyState("#Player","#TutNPC1",DIP_FOE)
	-- add the new property
	f_DynastyAddEnemy("#Player","#TutNPC1")
	f_DynastyAddEnemy("#TutNPC1","#Player")

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

	StartQuest("Intro7","#Player","",false)
end

