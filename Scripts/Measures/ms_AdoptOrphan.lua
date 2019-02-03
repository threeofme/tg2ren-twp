-- -----------------------
-- Run
-- -----------------------
function Run()

	if IsStateDriven() then
		if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
		if GetInsideBuilding("", "WeddingChapel") then
			if not (GetID("Destination")==GetID("WeddingChapel")) then
				StopMeasure()
			end
		else
			StopMeasure()
		end
	end

	if not SimGetSpouse("", "Spouse") then
		return
	end

	local Count = SimGetChildCount("")
	local MaxChilds = 6
	
	if Count > MaxChilds then
		MsgQuick("", "@L_MEASURE_ADOPTORPHAN_FAILURE_+0", GetID(""), GetID("Spouse"), Count)
		StopMeasure()
	end

	if not GetInsideBuilding("", "Church") then
		StopMeasure()
	end
	
	if GetProperty("Church", "Sleeping")==1 then
		MsgQuick("", "@L_MEASURE_ADOPTORPHAN_FAILURE_+2")
		StopMeasure()
	end

	if GetProperty("Church", "Orphan1")==nil then
		weddingchapel_CheckOrphans()
		StopMeasure()
	end
	SetProperty("Church", "Adoption", 1)

	local ChildID = GetProperty("Church", "Orphan1")
	GetAliasByID(ChildID, "Child")

	--get the locators
	if not GetLocatorByName("Church","AdoptOrphanOwner","OwnerPos") then
		StopMeasure()
	end
	if not GetLocatorByName("Church","AdoptOrphanChild","ChildPos") then
		StopMeasure()
	end
	if not GetLocatorByName("Church","FlowerChild1","MarryScenePos") then
		StopMeasure()
	end

	--if locator is blocked
	while true do
		if LocatorStatus("Church","AdoptOrphanOwner",true)==1 then
			break
		end
		Sleep(2)
	end

	if not f_BeginUseLocatorWeak("","OwnerPos",GL_STANCE_STAND,true) then
		StopMeasure()
	end 
	if not f_BeginUseLocatorWeak("Child","ChildPos",GL_STANCE_STAND,true) then
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
	local Cost = (Title * Title) * 150
	local choice
	
	if not IsStateDriven() then
		PlayAnimationNoWait("Child","talk")
		choice = MsgSayInteraction("","Child","",
								"@B[0,@L_MEASURE_ADOPTORPHAN_OPTION_+0]"..
								"@B[1,@L_MEASURE_ADOPTORPHAN_OPTION_+1]"..
								"@B[2,@L_MEASURE_ADOPTORPHAN_OPTION_+2]",
								"@L_MEASURE_ADOPTORPHAN_HEAD_+0",
								"@L_MEASURE_ADOPTORPHAN_QUESTION_+0",Cost)
		StopAnimation("Child")
	else
		choice = 1	
	end

	if (choice==0) or (choice==1) then

		if not GetLocatorByName("Church","OrphanSpawnPoint","OrphanStart") then
			StopMeasure()
		end
		
		if not f_SpendMoney("", Cost, "AdoptOrphan", false) then
			MsgQuick("", "@L_MEASURE_ADOPTORPHAN_FAILURE_+1", GetID(""))
			StopMeasure()
		end

		OrphanGender = 928 + choice
		if not SimCreate(OrphanGender, "Church", "OrphanStart", "Orphan") then
			StopMeasure()
		end

		if SimGetGender("")==GL_GENDER_MALE then
			SimSetFamily("Orphan", "Spouse", "")
		else
			SimSetFamily("Orphan", "", "Spouse")
		end
		
		if GetHomeBuilding("", "Residence") then
			SetHomeBuilding("Orphan", "Residence")
		end
		
		local Age = SimGetAge("Orphan")
		DoNewBornStuff("Orphan")
		SimSetAge("Orphan", Age)
		SimSetBehavior("Orphan", "Childness")
		SetState("Orphan", STATE_CHILD, true)

		if not IsStateDriven() then
			feedback_MessageCharacter("","@L_MEASURE_ADOPTORPHAN_SUCCESS_HEAD_+0","@L_MEASURE_ADOPTORPHAN_SUCCESS_BODY_+0",GetID(""),GetID("Spouse"),GetID("Orphan"))
		end
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
		RemoveProperty("Church","Adoption")
	end

	if IsStateDriven() then
		MeasureRun("", nil, "DynastyIdle")
	end
end
