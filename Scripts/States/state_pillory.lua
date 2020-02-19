function Init()
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_charge")
	SetStateImpact("no_arrestable")
	SetStateImpact("no_action")
end

function Run()

	if HasProperty("", "penalty_city") then
		local	CityID = GetProperty("", "penalty_city")
		RemoveProperty("", "penalty_city")
		GetAliasByID(CityID, "City")
	end
	
	if not AliasExists("City") then
		return
	end
	
	local	Time = 4
	if CityGetPenalty("City", "", PENALTY_PILLORY, true, "Penalty") then
		Time = PenaltyGetPrisonTime("Penalty", "")
		if Time <= 0 then
			return
		end
	end
	
	if GetImpactValue("", "Escapee") then
		local NewTime = Rand(6)+6
		if NewTime < Time then
			Time = NewTime
		end
	end
	
	CommitAction("pillory","","")

	feedback_MessageCharacter("",
			"@L_PENALTY_PILLORY_START_HEAD_+0",
			"@L_PENALTY_PILLORY_START_BODY_+0", GetID("Owner"))

	local AnimTime = MoveSetActivity("","pillory")
	Sleep(AnimTime)
	
	SetProcessMaxProgress("",Time)	
	local StartTime = GetGametime()
	local EndTime = StartTime + Time	
	local OldTime = Time
	while GetGametime()<EndTime do
		
		Sleep(10)
		Time = PenaltyGetPrisonTime("Penalty", "")
		SetProcessProgress("",GetGametime()-StartTime)
		if Time ~= OldTime then
			EndTime = StartTime + Time
			SetProcessMaxProgress("",Time)
			OldTime = Time
		end

	end
	
	-- clear the sim from the wanted list
	PenaltyFinish("Penalty")
	--MoveSetStance("",GL_STANCE_STAND)
	StopAction("pillory", "")
	MoveSetActivity("","")
	Sleep(AnimTime)
	feedback_MessageCharacter("",
			"@L_PENALTY_FREE_HEAD_+0",
			"@L_PENALTY_PILLORY_END_BODY_+0", GetID("Owner"))
	Sleep(5)
	if GetHomeBuilding("", "Home") then
		f_MoveToNoWait("", "Home")
	end
	SetState("", STATE_PILLORY, false)
end

function CleanUp()
	SetState("", STATE_CUTSCENE, false)
	MoveSetActivity("","")
	ResetProcessProgress("")
	StopAction("pillory", "")
end

