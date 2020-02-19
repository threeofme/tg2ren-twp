function Run()
	--do the init stuff
	--how far the Destination can be to start this action
	local MaxDistance = 400
	--how far from the destination, the owner should stand
	local ActionDistance = 60
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	if not GetSettlement("","OwnCity") then
		StopMeasure()
	end
	if not GetSettlement("Destination","DestCity") then
		StopMeasure()
	end
	
	if not CityGetRandomBuilding("DestCity",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_EXECUTIONS_PLACE,-1,-1,FILTER_IGNORE,"DestExecPlace") then
		StopMeasure()
	end
	
	if not GetOutdoorMovePosition("","DestExecPlace","MovePos") then
		StopMeasure()
	end
	CarryObject("", "Handheld_Device/Anim_Cross.nif", false)
	if not f_MoveTo("","MovePos",GL_MOVESPEED_RUN,500) then
		StopMeasure()
	end
	
	CopyAlias("Owner","Inquisitor")
	
	--get the office holder
	CityGetOffice("OwnCity",6,0,"Office")
	OfficeGetHolder("Office","MrInquisition")
	
	local TitleNumber = GetNobilityTitle("MrInquisition")
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local ExecutionTime = math.ceil(GetGametime() + duration)
	duration = ExecutionTime - GetGametime()
	--send the warning message to the city
	local ID = "Event"..GetID("")

	MsgNewsNoWait("DestCity","","@C[@L_PRIVILEGES_RUNINQUISITION_MSG_ALL_HEAD_+0,%4i,%5l]","politics",-1,
					"@L_PRIVILEGES_RUNINQUISITION_MSG_ALL_HEAD_+0",
					"@L_PRIVILEGES_RUNINQUISITION_MSG_ALL_BODY_+0",
					GetID("MrInquisition"),GetID("DestCity"),GetNobilityTitleLabel(TitleNumber),ExecutionTime,ID)
	
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	
	--prevent faith changing while running the inquisition because of exploitation
	SetProperty("MrInquisition","InquisitionRunning",1)
	
	--start the timer
	SetData("Time",duration)
	SetData("EndTime",ExecutionTime)
		
	local ExecID = 0
	local NumExecutioners = 4
	SetData("NumExecutioners",NumExecutioners)
	if FindNearestBuilding("", -1, GL_BUILDING_TYPE_TOWNHALL, -1, false, "TownHall") then
		GetLocatorByName("TownHall", "Entry1", "ExecutionerSpawnPos")
		for i=0,NumExecutioners do	
			if SimCreate(723, "TownHall", "ExecutionerSpawnPos", "SimExecutioner"..i) then
				AddItems("SimExecutioner"..i,"Chainmail",1,INVENTORY_EQUIPMENT)
				CarryObject("SimExecutioner"..i,"weapons/axe_02.nif",false)
				ExecID = GetID("SimExecutioner"..i)
				SetData("SimExecutioner"..i, ExecID)
				
				-- Avert the executioner from anything else but his duty !
				SetState("SimExecutioner"..i, STATE_LOCKED, true)
				CarryObject("SimExecutioner"..i,"weapons/axe_02.nif",false)
				f_FollowNoWait("SimExecutioner"..i,"Inquisitor",GL_MOVESPEED_WALK,Rand(200)+100)
			end
		end
	end
	
	--wait duration
	SetProcessMaxProgress("",duration*10)
	SendCommandNoWait("","Progress")
	
	local InquisitionReligion = SimGetReligion("MrInquisition")
	
	while true do
		SetState("",STATE_TOWNNPC,true)
		SetProperty("DestCity","InquisitionOnTheRun",InquisitionReligion)
		while GetGametime() < ExecutionTime do
			Sleep(2)
		end
		
		RemoveProperty("DestCity","InquisitionOnTheRun")
		ResetProcessProgress("")
		if ai_StartInteraction("", "Destination", MaxDistance, ActionDistance,  "Captured") then
			break
		end
		Sleep(2)
	end
	
	--check for religion
	local InquisitionReligion = SimGetReligion("MrInquisition")
	local DestinationReligion = SimGetReligion("Destination")
	
	--lucky victim. same religion.
	if InquisitionReligion == DestinationReligion then
		feedback_MessagePolitics("All",
			"@L_PRIVILEGES_RUNINQUISITION_MSG_VICTIM_SUCCESS_HEAD_+0",
			"@L_PRIVILEGES_RUNINQUISITION_MSG_VICTIM_SUCCESS_BODY_+0", GetID("Destination"))
		StopMeasure()	
	end
	PlayAnimationNoWait("", "propel")
	local Time = MoveSetActivity("Destination","arrested") 
	Sleep(Time+4)
	--do the bad stuff
	GetLocatorByName("DestExecPlace","executionPlace","ExecPos")
	f_MoveToNoWait("", "DestExecPlace", GL_MOVESPEED_WALK, 500)
	Sleep(4)
	BlockChar("Destination")
	if not f_BeginUseLocator("Destination","ExecPos",GL_STANCE_STAND,true) then
		SimBeamMeUp("Destination","ExecPos",false)
	end
	f_MoveTo("","Destination",GL_MOVESPEED_WALK,300)
	CommitAction("pillory","Destination","Destination")
	SetData("Action_Started", "Pillory")
	SetProperty("Destination","NoEscape",1)
	gameplayformulas_StartHighPriorMusic(MUSIC_EXECUTION)
	
--	CreateCutscene("default","cutscene")
--	CutsceneAddSim("cutscene","")
--	CutsceneAddSim("cutscene","Destination")
--	CutsceneCameraCreate("cutscene","")
--	camera_CutscenePlayerLock("cutscene","","Far_HUpYLeft")
--	CutsceneCameraBlend("cutscene",6,1)
--	camera_CutscenePlayerLockSit("cutscene", "Destination","ExecutionView")
	
	local ActivityTime = MoveSetActivity("Destination","execute")
	PlayAnimationNoWait("","sentinel_idle")
	Sleep(ActivityTime)
	
	CarryObject("SimExecutioner0","weapons/axe_02.nif",false)
	GetLocatorByName("DestExecPlace","executioner","ExecutionerPos")
	if not f_MoveTo("SimExecutioner0", "ExecutionerPos", GL_MOVESPEED_WALK, 0) then
		BlockChar("SimExecutioner0")
		SimBeamMeUp("SimExecutioner0","ExecutionerPos",false)
	end
	GetPosition("Destination", "ParticleSpawnPos")
	SetData("locked",0)
	CarryObject("SimExecutioner0","weapons/axe_02.nif",false)
	Sleep(2)
	
	PlayAnimationNoWait("SimExecutioner0","finishing_move_02")
	Sleep(1)
	PlaySound3DVariation("Destination","Effects/combat_strike_metal",1)
	PlaySound3DVariation("Destination","combat/pain",1)
	SetProperty("Destination","Executed",1)
	
	Sleep(0.5)
	StopAction("Pillory", "Destination")

	feedback_MessagePolitics("Destination",
			"@L_PRIVILEGES_RUNINQUISITION_MSG_VICTIM_FAILED_HEAD_+0",
			"@L_PRIVILEGES_RUNINQUISITION_MSG_VICTIM_FAILED_BODY_+0", GetID("Destination"))
	
	--Kill("Destination")
	SetState("",STATE_TOWNNPC,false)
	Kill("Destination")
	Sleep(2)
	chr_GainXP("",GetData("BaseXP"))
	DestroyCutscene("cutscene")
	for i=0,NumExecutioners do
		ExecID = GetData("SimExecutioner"..i)
		ms_runinquisition_Terminate(ExecID)
	end
	RemoveData("NumExecutioners")
	StopMeasure()
	
end

function Progress()
	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime")
		local CurrentTime = GetGametime()
		CurrentTime = EndTime - CurrentTime
		CurrentTime = Time - CurrentTime
		SetProcessProgress("",CurrentTime*10)
		Sleep(3)
	end
end

-- -----------------------
-- Terminate
-- -----------------------
function Terminate(ExecID)
	
	-- Get rid of the Executioner
	GetAliasByID(ExecID,"SimExec")
	if AliasExists("SimExec") then
		-- Let the executioner go to the next townhall and disapear
		if FindNearestBuilding("SimExec", -1, GL_BUILDING_TYPE_TOWNHALL, -1, false, "Townhall") then
			f_MoveToNoWait("SimExec", "Townhall")
		end
	
		InternalDie("SimExec")
		InternalRemove("SimExec")
	end	
end

-- -----------------------
-- Captured
-- -----------------------
function Captured()
	SetData("locked",1)
	MoveStop("")
	SetProperty("","NoEscape",1)
	SetState("", STATE_CAPTURED, true)
	AlignTo("", "Owner")
	Sleep(0.7)

	while GetData("locked") == 1 do
		Sleep(2.8)
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	DestroyCutscene("cutscene")
	SetState("",STATE_TOWNNPC,false)
	if AliasExists("DestCity") then
		RemoveProperty("DestCity","InquisitionOnTheRun")
	end

	ResetProcessProgress("")
	local ID = "Event"..GetID("")
	HudRemoveCountdown(ID,false)
	local Action_Name = GetData("Action_Started")
	if Action_Name then
		StopAction(Action_Name, "Destination")
	end
	RemoveProperty("Dynasty","InquisitionRunning")
	if HasData("NumExecutioners") then
		NumExecutioners = GetData("NumExecutioners")
		for i=0,NumExecutioners do
			ExecID = GetData("SimExecutioner"..i)
			ms_runinquisition_Terminate(ExecID)
		end
	end
	StopAnimation("")
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


