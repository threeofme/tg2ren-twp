-- -----------------------
-- Run
-- -----------------------
function Run()

	-- get the tavern
	if not GetInsideBuilding("", "Tavern") then
		return
	end

	local MyDynastyID = GetDynastyID("")
	local Money = GetMoney("")
	-- hier muss noch der Preis anhand der Preisangabe des Wirtes errechnen
	local Price = 150
	
--	local Result = MsgNews("","","@P"..
--				"@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
--				"@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
--				ms_158_rentsleepingberth_AIDecision,  --AIFunc
--				"building", --MessageClass
--				2, --TimeOut
--				"@L_MEASURE_RentSleepingBerth_NAME_+0",
--				"@L_GENERAL_MEASURES_158_RENTSLEEPINGBERTH_MSG_BODY_+0",
--				Price)
--	if Result == "C" then
--		StopMeasure()
--	end
	
	-- check both sleeping berths
	if not GetFreeLocatorByName("Tavern", "Berth", 1, 2, "SleepingBerth") then	
		MsgQuick("","@L_TAVERN_158_RENTSLEEPINGBERTH_FAILURES_+1", GetID("Tavern"))
		return
	end

	if GetDynastyID("")~=GetDynastyID("Tavern") then
		if not f_SpendMoney("", Price, "CostSocial") then
			MsgQuick("","@L_TAVERN_158_RENTSLEEPINGBERTH_FAILURES_+0",Price)
			StopMeasure()
		end
		f_CreditMoney("Tavern", Price, "RentABerth")
		economy_UpdateBalance("Tavern", "Service", Price)		
	end

	-- go to the berth
	f_BeginUseLocator("", "SleepingBerth", GL_STANCE_LAY, true)
		
	-- sleep
	
	local	HasToSleep = 6
	if GetImpactValue("","SleepRecoverBonus")>0 then
		HasToSleep = 3
	end
	
	local WasSick = false
	if GetImpactValue("","Sickness")>0 then
		WasSick = true
	end

	local CurrentHP = GetHP("")
	local MaxHP = GetMaxHP("")
	local ToHeal = MaxHP - CurrentHP
	local HealPerTic = ToHeal / (HasToSleep * 10)
	
	local EndTime = GetGametime() + HasToSleep
	-- increase the hp due to the recover factor for the tavern
	while GetGametime() < EndTime do
		
		Sleep(5)
		
		if GetHP("") < MaxHP then
			ModifyHP("", HealPerTic,false)
			PlaySound3DVariation("","measures/gotosleep",0.8)
		end
		
	end
	-- Cure Cold, Sprain and Influenza
	if WasSick == true then
		diseases_Cold("",false)
		diseases_Sprain("",false)
		diseases_Influenza("",false)
	end
	-- end sleeping

	f_EndUseLocator("", "SleepingBerth", GL_STANCE_STAND)
	
	if IsPartyMember() then
		feedback_MessageCharacter("",
			"@L_GENERAL_MEASURES_010_GOTOSLEEP_WAKEUP_HEAD",
			"@L_GENERAL_MEASURES_010_GOTOSLEEP_WAKEUP_BODY", GetID("Owner"))
	end
end

function AIDecision()
	return "O"
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("SleepingBerth") then
		f_EndUseLocator("", "SleepingBerth", GL_STANCE_STAND)
	end
	feedback_OverheadComment("Owner")
end

function GetOSHData(MeasureID)
	
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",150)
end

