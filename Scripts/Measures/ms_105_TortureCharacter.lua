function Run()  
	--how far the Destination can be to start this action
	local MaxDistance = 400
	--how far from the destination, the owner should stand
	local ActionDistance = 60
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not AliasExists("Destination") then
		-- no destination found (should never happen)
		return 
	end

	-- pregnant women cannot be tortured
	if (GetState("Destination", STATE_PREGNANT)==true) then
		StopMeasure()
	end
	
	if not GetSettlement("", "CityAlias") then
		-- no city found (should never happen for a city guard)
		return
	end

	if not CityGetRandomBuilding("CityAlias", -1, GL_BUILDING_TYPE_PRISON, -1, -1, FILTER_IGNORE, "Prison") then
		-- no prison found
		return
	end
	
	--check if destination is too far from city
	GetPosition("CityAlias","CityPos")
	if GetInsideBuilding("Destination","CurrentBuilding") then
		GetPosition("CurrentBuilding","BuildingPos")
		if GetDistance("BuildingPos","CityPos") > 10000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure()
		end
	else
		GetPosition("Destination","DestPos")
		if GetDistance("CityPos","DestPos") > 10000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure()
		end
	end
	
	local BossID = dyn_GetValidMember("dynasty")
	GetAliasByID(BossID, "MrTorture")
	SimGetWorkingPlace("","Workbuilding")
	
	SetRepeatTimer("Workbuilding", GetMeasureRepeatName(), TimeOut)
	
	if not GetState("Destination",STATE_IMPRISONED) then
	
		--run to destination and start action at MaxDistance
		if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance,  "Captured") then
			StopMeasure()
		end
		AlignTo("", "Destination")
		Sleep(0.7)
		MsgNewsNoWait("Destination","MrTorture","","intrigue",-1,
			"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_HEAD_+0",
			"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_BODY_+0",GetID("MrTorture"),GetID("Destination"))
		SetData("MessageDone",1)
		Time = PlayAnimationNoWait("", "propel")
		local ActivityTime = MoveSetActivity("Destination","arrested")
		
		Sleep(Time)
		
		--move to jail
		f_FollowNoWait("", "Destination", GL_MOVESPEED_WALK, 130)
		if GetOutdoorMovePosition(nil, "Prison", "MovePos") then
			if not (f_MoveTo("Destination", "MovePos", GL_MOVESPEED_WALK)) then
				StopMeasure()
				return
			end	
		else
			if not (f_MoveTo("Destination", "Prison", GL_MOVESPEED_WALK)) then
				StopMeasure()
				return
			end		
		end
		ActivityTime = MoveSetActivity("Destination","")
		Sleep(ActivityTime)
		f_MoveTo("", "Prison", GL_MOVESPEED_WALK, "MoveResult")
	else
		if not GetInsideBuilding("","CurrentBuilding") then
			if not f_MoveTo("","Prison") then
				StopMeasure()
			end
			GetLocatorByName("Prison","Stroll2","ThereYouGo")
			f_MoveTo("","ThereYouGo")
		end
		AlignTo("","Destination")
		Sleep(1)
		PlayAnimationNoWait("","propel")
		SetProperty("Destination","GettingTortured",1)
		SetData("WasImprisoned",1)
		SetState("Destination",STATE_IMPRISONED,false)
		SimSetBehavior("Destination","")
		RemoveProperty("Destination","Imprisoned")
		Sleep(1)
		StopAnimation("Destination")
	end
	
	BlockChar("Destination")
	
	MsgMeasure("","")
	GetInsideBuilding("","Prison")
	
	if not HasData("MessageDone") then
		MsgNewsNoWait("Destination","MrTorture","","intrigue",-1,
			"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_HEAD_+0",
			"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_BODY_+0",GetID("MrTorture"),GetID("Destination"))
	end
	
	if GetLocatorByName("Prison", "TortureVictim", "VictimPosition") then
		if not f_MoveTo("Destination","VictimPosition",GL_MOVESPEED_WALK,1) then
			StopMeasure()
		end
	end
	if GetLocatorByName("Prison", "Torture", "TorturePosition") then
		if not f_MoveTo("","TorturePosition") then
			StopMeasure()
		end
	end
	SetData("FinallyReached",1)
	SetData("PositionModified",1)
	PositionModify("VictimPosition",0,70,0)
	CarryObject("","weapons/club_01.nif",false)
	for i=1,10 do
		PlayAnimationNoWait("Destination","torture_victim")
		PlayAnimation("","torture")
--		for k=1,3 do
--			Sleep(1.5)
--			PlaySound3DVariation("","Effects/combat_strike_mace")
--			Sleep(0.5)
--			StartSingleShotParticle("particles/bloodsplash.nif", "VictimPosition", 1,4)
--			PlaySound3D("Destination","combat/pain/Hurt_s_03.wav",1)
--			
--		end
--		Sleep(3)
		
	end
	CarryObject("","",false)	
	PositionModify("VictimPosition",0, -70,0)	
	SetData("PositionModified",0)
	
	local Random = Rand(11)
	if Random == 0 then
		Evidence = 1
	elseif Random == 1 then
		Evidence = 4
	elseif Random == 2 then
		Evidence = 7
	elseif Random == 3 then
		Evidence = 10
	elseif Random == 4 then
		Evidence = 11
	elseif Random == 5 then
		Evidence = 12
	elseif Random == 6 then
		Evidence = 13
	elseif Random == 7 then
		Evidence = 14
	elseif Random == 8 then
		Evidence = 15
	elseif Random == 9 then
		Evidence = 16
	else
		Evidence = 18
	end
	
	local ActualHP = GetHP("Destination")
	log_death(DestAlias, " is being tortured. (ms_105_TortureCharacter)")
	ModifyHP("Destination",-(ActualHP/3),true)
	Sleep(0.5)
	chr_ModifyFavor("Destination","MrTorture",-10)
	if CheckSkill("Destination",1,5) then
		chr_GainXP("MrTorture",GetData("BaseXP"))
		while true do
			ScenarioGetRandomObject("cl_Sim","CurrentRandomSim")
			if not GetDynasty("CurrentRandomSim","CDynasty") then
				CopyAlias("CurrentRandomSim","EvidenceVictim")
				break
			end
			Sleep(3)
		end
		
		AddEvidence("MrTorture","Destination","EvidenceVictim",Evidence)
		MsgNewsNoWait("Destination","MrTorture","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_SUCCESS_HEAD_+0",
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_SUCCESS_BODY_+0",GetID("MrTorture"),GetID("Destination"))
		MsgNewsNoWait("MrTorture","Destination","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_OWNER_SUCCESS_HEAD_+0",
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_OWNER_SUCCESS_BODY_+0",GetID("Destination"))
	else
		MsgNewsNoWait("Destination","MrTorture","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_FAILED_HEAD_+0",
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_FAILED_BODY_+0",GetID("MrTorture"),GetID("Destination"))
		MsgNewsNoWait("MrTorture","Destination","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_OWNER_FAILED_HEAD_+0",
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_OWNER_FAILED_BODY_+0",GetID("Destination"))
		
	end
	Sleep(2)
	StopMeasure()
end

function CleanUp()
	if not HasData("FinallyReached") then
		if AliasExists("Workbuilding") then
			SetRepeatTimer("Workbuilding", GetMeasureRepeatName(), 0)
		end
	end
	StopAnimation("")
	if AliasExists("Destination") then
		MoveSetActivity("Destination","")
		StopAnimation("Destination")
		if HasData("WasImprisoned") then
			SetState("Destination",STATE_IMPRISONED,true)
		end
		
		
		if HasProperty("Destination","NoEscape") then
			RemoveProperty("Destination","NoEscape")
		end
		SetState("Destination", STATE_CAPTURED, false)
		SimResetBehavior("Destination")
	end
		
	if HasData("PositionModified")==1 then
		PositionModify("VictimPosition",0, -70,0)
	end
	
	CarryObject("","",false)
end

function Captured()
	
	MoveStop("")
	SetProperty("","NoEscape",1)
	SetState("", STATE_CAPTURED, true)
	AlignTo("", "Owner")
	Sleep(0.7)

	
	while true do
		Sleep(100)
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

