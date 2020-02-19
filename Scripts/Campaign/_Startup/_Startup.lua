function GetWorld()
	return "charactercreation.wld"
end


function Prepare()
	SetTime(EN_SEASON_SUMMER,1400, 10, 0)
	GetScenario("World")
	SetProperty("World", "static", 1)
	
	SetProperty("World", "StartCam_PosX", 1174.7124)
	SetProperty("World", "StartCam_PosY", 1446.4896)
	SetProperty("World", "StartCam_PosZ", -2002.8715)
	SetProperty("World", "StartCam_RotX", 19.8832)
	SetProperty("World", "StartCam_RotY", 70.1297)
	
	SetProperty("World", "AppearanceCam_PosX", 7040.0)
	SetProperty("World", "AppearanceCam_PosY", 80.0)
	SetProperty("World", "AppearanceCam_PosZ", 45.0)
	SetProperty("World", "AppearanceCam_RotX", 10.0)
	SetProperty("World", "AppearanceCam_RotY", 100.0)
	
	SetProperty("World", "AppearanceFaceCam_PosX", 7300.0)
	SetProperty("World", "AppearanceFaceCam_PosY", 90.0)
	SetProperty("World", "AppearanceFaceCam_PosZ", 75.0)
	SetProperty("World", "AppearanceFaceCam_RotX", 5.0)
	SetProperty("World", "AppearanceFaceCam_RotY", 120.0)

	SetProperty("World", "EditCam_PosX", 6700.0)
	SetProperty("World", "EditCam_PosY", 220.0)
	SetProperty("World", "EditCam_PosZ", 480.0)
	SetProperty("World", "EditCam_RotX", 19.0)
	SetProperty("World", "EditCam_RotY", 130.0)

	SetProperty("World", "CharPos_PosX", 7390.0)
	SetProperty("World", "CharPos_PosY", -80.0)
	SetProperty("World", "CharPos_PosZ", 40.0)
	SetProperty("World", "CharPos_RotX", 0)
	SetProperty("World", "CharPos_RotY", -90.0)
	
	return true
end

function CreatePlayerDynasty()
	return ""
end

function CreateShadowDynasty()
	return ""
end

function CreateComputerDynasty()
	return "no"
end

function Start()
	
	for n=1, 50 do
		if GetOutdoorLocator("Start"..n, 1, "Position" )==0 then
			break	-- return "Unable to locate the locator Start"..n.." in the startup scene"
		end
	
		if not SimCreate(17, "", "Position", "NPC") then
			break -- return "Unable to create NPC number "..n.." for the startup scene"
		end

		SetProperty("NPC", "Point1", "End"..n)
		SetProperty("NPC", "Point2", "Start"..n)
	
		SimSetBehavior("NPC", "Patroille")
		SimStartIdleMeasure("NPC")
		
		if GetOutdoorLocator("Cart"..n, 1, "CartPos" )~=0 then
			ScenarioCreateCart(EN_CT_HORSE, nil, "CartPos", "Cart")
		end

		if GetOutdoorLocator("Dog"..n, 1, "DogPos" )~=0 then
			SimCreate(906, "", "DogPos", "NPC")
			SetState("NPC", STATE_ANIMAL, true)
		end
		if GetOutdoorLocator("Cat"..n, 1, "CatPos" )~=0 then
			SimCreate(908, "", "CatPos", "NPC")
			SetState("NPC", STATE_ANIMAL, true)
		end
	end

	if GetOutdoorLocator("Priest1", 1, "PriestPos" )~=0 then
		SimCreate(20, "", "PriestPos", "NPC")
		LoopAnimation("NPC", "sing_for_peace", -1)
	end
	
	if GetOutdoorLocator("Water"..1, 1, "Position" )~=0 then
		if ScenarioCreateCart(EN_CT_WARSHIP, nil, "Position", "Boat") then
			MeasureRun("Boat", nil, "StartmenuShip")
		end
	end
	
end

