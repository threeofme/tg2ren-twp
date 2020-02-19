function AIReturnO()
	return "O"
end

function InitAttend(Sim)
	if GetState(Sim, STATE_CUTSCENE) then
		return false
	end
	
	local CurrentMeasure = GetCurrentMeasureName(Sim)
	
	if CurrentMeasure == "AttendTrialMeeting" then
		return false
	elseif CurrentMeasure == "AttendOfficeMeeting" then
		return false
	elseif CurrentMeasure == "AttendDuel" then
		return false
	elseif CurrentMeasure == "AttendFestivity" then
		return false
	end
	
	if GetImpactValue(Sim, 369) > 0 then -- SuppressAttendMessage
		return false
	end
	
	if GetImpactValue(Sim, 360) > 0 then -- totallydrunk
		return false
	end
	
	if f_SimIsValid(Sim) == false then -- check for states
		return false
	end
	
	return true
end

function AttendTrialMeeting(DestinationID)
	
	-- Init
	if queries_InitAttend("Sim") == false then
		DestroyCutscene("")
		return
	end

	AddImpact("Sim", 369, 1, 3) -- Suppress AttendMessage

	local bRun = true
	if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
		GetInsideBuilding("Sim","InsideBuilding")
		if (GetID("destination") ~= GetID("InsideBuilding")) then
			if MsgNews("Sim","destination",
					"@P@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
					queries_AIReturnO,"politics",1,"@L_LAWSUIT_DIARY_REMEMBER_+0","@L_LAWSUIT_DIARY_REMEMBER_+1",GetID("Sim"),GetSettlementID("destination"))=="C" then
				bRun = false
			end
		end
	end 

	if bRun==true then
		MeasureRun("Sim", "Destination", "AttendTrialMeeting", true)
	end
		
	DestroyCutscene("")
end	

function AttendOfficeMeeting(DestinationID)

	-- Init
	if queries_InitAttend("Sim") == false then
		DestroyCutscene("")
		return
	end
	
	if math.mod(GetGametime(),24)>17 or math.mod(GetGametime(),24) <12 then
		DestroyCutscene("")
		return
	end

	AddImpact("Sim", 369, 1, 3)
	
	local bRun = true
	if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
		GetInsideBuilding("Sim","InsideBuilding")
		if (GetID("destination") ~= GetID("InsideBuilding")) then
			if MsgNews("Sim","destination",
					"@P@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
					queries_AIReturnO,"politics",1,"@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+0","@L_LAWSUIT_DIARY_REMEMBER_+1",GetID("Sim"),GetSettlementID("destination"))=="C" then
				bRun = false
			end
		end
	end
	
	if bRun==true then
		MeasureRun("Sim", "Destination", "AttendOfficeMeeting", true)
	end

	DestroyCutscene("")
end	

function AttendFuneral(DestinationID)
	MeasureRun("Sim", "Destination", "AttendFuneral", true)
	DestroyCutscene("")
end

function AttendDuel(DestinationID)
	
	-- Init
	if queries_InitAttend("Sim") == false then
		DestroyCutscene("")
		return
	end
	
	AddImpact("Sim", 369, 1, 3)

	local bRun = true
	if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
		if MsgNews("Sim","destination",
				"@P"..
				"@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]"..
				"@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
				queries_AIReturnO,"intrigue",1,
				"@L_DUELL_6_TIMEPLANNERENTRY_REMEMBER_+0",
				"@L_DUELL_6_TIMEPLANNERENTRY_REMEMBER_+1",GetID("Sim"))=="C" then
					
				bRun = false
		end
	end

	if bRun==true then
		MeasureRun("Sim", "Destination", "AttendDuel", true)
	end

	DestroyCutscene("")
end	


function AttendFestivity(DestinationID)
	
	-- Init
	if queries_InitAttend("Sim") == false then
		DestroyCutscene("")
		return
	end
	
	AddImpact("Sim", 369, 1, 3)
	
	local bRun = true
	local message = 0
	if GetInsideBuilding("Sim","Currentbuilding") then
		if GetID("CurrentBuilding") == GetID("Destination") then
			--is schon da
		else
			message = 1
		end
	else
		message = 1
	end
	if message == 1 then
		if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
			if MsgNews("Sim","destination",
					"@P"..
					"@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]"..
					"@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
					queries_AIReturnO,"schedule",1,
					"@L_FEAST_5_TIMEPLANNERENTRY_REMEMBER_+0",
					"@L_FEAST_5_TIMEPLANNERENTRY_REMEMBER_+1",GetID("Sim"))=="C" then
						bRun = false
			end
		end
	end

	if bRun==true then
		MeasureRun("Sim", "Destination", "AttendFestivity", true)
	end

	DestroyCutscene("")
end	


function Attend(DestinationID)
	local bRun = true
	if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
		if MsgNews("Sim","destination",
					"@P@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
					queries_AIReturnO,"politics",1,"@L_LAWSUIT_DIARY_REMEMBER_+0","@L_LAWSUIT_DIARY_REMEMBER_+1",GetID("Sim"),GetSettlementID("destination"))=="C" then
			bRun = false
		end
	end

	if (bRun==true) then
		MeasureRun("Sim", "Destination", "Attend", true)
	end

	DestroyCutscene("")
end	

function DecideFugitive()
	local Decision = 0
	local Fee = GetData("RawPenalty") * 500
	
	if Fee <= 500 then
		Fee = 500
	end
	local FugitiveYears = GetData("FugitiveYears")
	local HoursInPrison = GetData("RawPenalty")*3
	local CanPayFee = true
	GetSettlement("Sim","City")
	if Fee>GetMoney("Sim") then
		CanPayFee = false
	end

	if DynastyIsPlayer("Sim") and IsPartyMember("") then
		-- user decision
		local Result = "C"
		if Fee>GetMoney("Sim") then	-- cannot pay fee, omit option pay_fee
			Result = MsgNews("Sim","Sim",
								"@P@B[I,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+7]"..
								"@B[P,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+8]",
								-1,"politics",1.0,
								"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+9",
								"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+5",GetID("Sim"),Fee,FugitiveYears)
		else -- can pay fee
			Result = MsgNews("Sim","Sim",
								"@P@B[O,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+6]"..
								"@B[I,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+7]"..
								"@B[P,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+8]",
								-1,"politics",1.0,
								"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+9",
								"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+5",GetID("Sim"),Fee,FugitiveYears)
		end

		if Result=="C" or Result=="I" then
			Decision = 0
		elseif Result=="O" then
			Decision = 2
		elseif Result=="P" then
			Decision = 1
		end
	else
		-- AI decision
		if SimGetClass("Sim")==4 then	-- if is chiseler
			if Fee*2<GetMoney("Sim") then
				if Rand(4) == 0 then
					Decision = 2
				else
					Decision = 0
				end
			else
				Decision = 0		-- ignore
			end
		elseif Fee*2<GetMoney("Sim") then
			Decision = 2		-- ich zahle
		else 
			Decision = 1		-- ich gehe freiwillig ins Gefängnis
		end
	end

	if (Decision==0) then
		-- ignore
		local Options = FindNode("\\Settings\\Options")
		local YearsPerRound = Options:GetValueInt("YearsPerRound")
		local FugitiveHours = FugitiveYears * 24 / YearsPerRound

		CityAddPenalty("City","Sim",PENALTY_FUGITIVE,FugitiveYears)
		AddImpact("Sim","REVOLT",1,FugitiveHours)
		SetState("Sim",STATE_REVOLT,true)
		
		MsgBoxNoWait("Sim", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+0",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+1",GetID("Sim"),FugitiveYears)
		MsgBoxNoWait("accuser", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("Sim"),FugitiveYears)
		MsgBoxNoWait("judge", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("Sim"),FugitiveYears)
		MsgBoxNoWait("assessor1", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("Sim"),FugitiveYears)
		MsgBoxNoWait("assessor2", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("Sim"),FugitiveYears)

	elseif (Decision==1) then
		-- prison
		CityAddPenalty("City","Sim",PENALTY_PRISON, HoursInPrison )

		MsgBoxNoWait("Accuser", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+12",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+13",GetID("Sim"),HoursInPrison,GetID("City"))
		MsgBoxNoWait("Assessor1", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+12",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+13",GetID("Sim"),HoursInPrison,GetID("City"))
		MsgBoxNoWait("Assessor2", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+12",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+13",GetID("Sim"),HoursInPrison,GetID("City"))
		MsgBoxNoWait("Judge", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+12",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+13",GetID("Sim"),HoursInPrison,GetID("City"))
	elseif (Decision==2) then
		-- fee
		CityAddPenalty("City","Sim",PENALTY_MONEY, Fee )

		MsgBoxNoWait("Accuser", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+10",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+11",GetID("Sim"),Fee)
		MsgBoxNoWait("Assessor1", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+10",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+11",GetID("Sim"),Fee)
		MsgBoxNoWait("Assessor2", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+10",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+11",GetID("Sim"),Fee)
		MsgBoxNoWait("Judge", "Sim", "@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+10",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+11",GetID("Sim"),Fee)
	end
	DestroyCutscene("")
end

function CleanUp()
end
