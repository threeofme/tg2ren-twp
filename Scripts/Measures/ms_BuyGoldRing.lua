-- -----------------------
-- Run
-- -----------------------
function Run()

	GetInsideBuilding("", "Church")
	if GetProperty("Church", "Sleeping")==1 then
		MsgQuick("", "@L_MEASURE_BUYGOLDRING_FAILURE_+2")
		StopMeasure()
	end

	if GetProperty("Church", "Orphan2")==nil then
		weddingchapel_CheckOrphans()
		StopMeasure()
	end
	
	if GetRemainingInventorySpace("","JanesRing") < 1 then
		MsgQuick("", "@L_MEASURE_BUYGOLDRING_FAILURE_+1", GetID(""))
		StopMeasure()
	end
	SetProperty("Church", "GoldRing", 1)

	local ChildID = GetProperty("Church", "Orphan2")
	GetAliasByID(ChildID, "Child")
	
	--get the locators
	if not GetLocatorByName("Church","BuyGoldRingOwner","OwnerPos") then
		StopMeasure()
	end
	if not GetLocatorByName("Church","BuyGoldRingChild","ChildPos") then
		StopMeasure()
	end
	if not GetLocatorByName("Church","FlowerChild2","MarryScenePos") then
		StopMeasure()
	end
	
	--if locator is blocked
	while true do
		if LocatorStatus("Church","BuyGoldRingOwner",true)==1 then
			break
		end
		Sleep(2)
	end

	if not f_BeginUseLocator("","OwnerPos",GL_STANCE_STAND,true) then
		StopMeasure()
	end
	if not f_BeginUseLocator("Child","ChildPos",GL_STANCE_STAND,true) then
		StopMeasure()
	end
	Sleep(1)

	AlignTo("", "Child")
	AlignTo("Child", "")

	SetAvoidanceGroup("", "Child")
	MoveSetActivity("", "converse")
	MoveSetActivity("Child", "converse")
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Child")
	CutsceneCameraCreate("cutscene","")
	camera_CutsceneBothLock("cutscene", "Child")

	Sleep(1)

	local Title = GetNobilityTitle("")
	local Cost = (Title * Title) * 50
	local choice
	
	if IsStateDriven() then
		PlayAnimationNoWait("Child","talk")
		MsgSay("Child","@L_MEASURE_BUYGOLDRING_QUESTION_+0","", Cost)
		StopAnimation("Child")
		Sleep(1)
		PlayAnimationNoWait("","talk")
		MsgSay("","@L_MEASURE_BUYGOLDRING_AI_OPTION_+0")
		StopAnimation("")
		choice = 0
	else
		PlayAnimationNoWait("Child","talk")
		choice = MsgSayInteraction("","Child","",
								"@B[0,@L_MEASURE_BUYGOLDRING_OPTION_+0]"..
								"@B[1,@L_MEASURE_BUYGOLDRING_OPTION_+1]",
								"@L_MEASURE_BUYGOLDRING_HEAD_+0",
								"@L_MEASURE_BUYGOLDRING_QUESTION_+0",
								GetID(""), Cost)
		StopAnimation("Child")
	end

	if (choice==0) then

		if GetRemainingInventorySpace("","JanesRing") < 1 then
			MsgQuick("", "@L_MEASURE_BUYGOLDRING_FAILURE_+1", GetID(""))
			StopMeasure()
		elseif not f_SpendMoney("", Cost, "BuyGoldRing", false) then
			MsgQuick("", "@L_MEASURE_BUYGOLDRING_FAILURE_+0", GetID(""))
			StopMeasure()
		end

		local time1
		local time2
		time1 = PlayAnimationNoWait("Child", "use_object_standing")
		time2 = PlayAnimationNoWait("","cogitate")
		Sleep(1)
		PlaySound3D("Child","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("Child","Handheld_Device/ANIM_Smallsack.nif",false)
		
		Sleep(1)
		CarryObject("Child","",false)
		CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
		time2 = PlayAnimationNoWait("","fetch_store_obj_R")
		Sleep(1)	
		StopAnimation("Child")
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)	

		AddItems("","JanesRing",1)
	
	end
end

function CleanUp()
	EndCutscene("")
	DestroyCutscene("cutscene")
	MoveSetActivity("")
	if AliasExists("Child") then
		MoveSetActivity("Child")
	end
	SetState("", STATE_LOCKED, false)
	ReleaseAvoidanceGroup("")
	if AliasExists("Church") then
		RemoveProperty("Church","GoldRing")
	end
end
