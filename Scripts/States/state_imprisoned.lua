function Init()
	-- SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_fire")	
	SetStateImpact("no_control")
	SetStateImpact("no_measure_start")	
	SetStateImpact("no_measure_attach")	
	SetStateImpact("no_charge")
	SetStateImpact("no_arrestable")
	SetStateImpact("no_action")
	SetStateImpact("no_attackable")	
	SetStateImpact("no_cancel_button")
end

function Run()
	if not GetInsideBuilding("", "Prison") then
		return
	end
	
	if not GetSettlement("Prison", "City") then
		return
	end
	
	local	Time = 0

	-- if GetImpactValue("","PrisonTime")>0 then
		-- Time = GetImpactValue("","PrisonTime")
	-- else
		if CityGetPenalty("City", "", PENALTY_PRISON, true, "Penalty") then
			Time = PenaltyGetPrisonTime("Penalty")
			if Time <= 0 then
				return
			end
		elseif CityGetPenalty("City", "", PENALTY_FUGITIVE, true, "Penalty") then
			-- max. 48 hours u haft
			Time = 48
		end
	-- end
	
	if HasProperty("","GettingTortured") then
		RemoveProperty("","GettingTortured")
	end
	
	if GetImpactValue("", "Escapee") then
		local NewTime = Rand(6)+6
		if NewTime < Time then
			Time = NewTime
		end
	end
	
	SimSetBehavior("Owner", "Prison")

	feedback_MessageCharacter("Owner",
		"@L_PENALTY_PRISON_ARRIVED_HEAD_+0",
		"@L_PENALTY_PRISON_ARRIVED_BODY_+0", GetID("Owner"))

	SetProcessMaxProgress("",Time)	
	local StartTime = GetGametime()
	local EndTime = StartTime + Time	
	local OldTime = Time
	while GetGametime()<EndTime do
		
		Sleep(10)
		
		if not AliasExists("Penalty") then
			break
		end
		
		Time = PenaltyGetPrisonTime("Penalty")
		SetProcessProgress("",GetGametime()-StartTime)
		if Time ~= OldTime then
			EndTime = StartTime + Time
			SetProcessMaxProgress("",Time)
			OldTime = Time
		end

		-- AddImpact("","PrisonTime",EndTime-GetGametime(),-1)

	end

	-- clear the sim from the wanted list, because he is imprisoned now
	if CityGetPenalty("City","",PENALTY_UNKNOWN,true,"Penalty") then
		PenaltyFinish("Penalty")

		feedback_MessageCharacter("Owner",
			"@L_PENALTY_FREE_HEAD_+0",
			"@L_PENALTY_PRISON_RELEASED_BODY_+0", GetID("Owner"))

		if GetHomeBuilding("", "Home") then
			MeasureRun("", "Home", "Walk", true)
		end
	end
end

function CleanUp()
	ResetProcessProgress("")
	SimResetBehavior("")
	-- if GetImpactValue("","PrisonTime")<1 then
		-- RemoveImpact("","PrisonTime")
	-- end
	SetState("", STATE_IMPRISONED, false)
	SetState("", STATE_CUTSCENE, false)
end
