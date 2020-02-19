function Run()

    -- local plage = GetImpactValue("", 379)
	-- if plage and plage>0.1 then
	    -- return
	-- end
	
	if GetImpactValue("", "recentlycaptured")>0 then
		MsgBoxNoWait("","","@L_SELLBUILDING_FAIL_HEAD_+0",
					"@L_SELLBUILDING_FAIL_BODY_+0",GetID(""))
		StopMeasure()
		return
	end
		
	if BuildingGetForSale("") then
		BuildingSetForSale("", false)
		SetState("", STATE_SELLFLAG, false)
		return
	end
	
	if not chr_CheckSell() then
		return
	end
	
	local Result = MsgNews("","","@P"..
			"@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
			"@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
			ms_075_sellbuilding_AIDecision,  --AIFunc
			"building", --MessageClass
			2, --TimeOut
			"@L_INTERFACE_SELLBUILDING_MSG_HEAD_+0",
			"@L_INTERFACE_SELLBUILDING_MSG_BODY_+0",
			GetID(""),Cost)
			
	if Result == "C" then
		BuildingSetForSale("", false)
		SetState("", STATE_SELLFLAG, false)
		return
	end
	
	BuildingSetForSale("", true)
	SetState("", STATE_SELLFLAG, true)
end

function AIDecision()
	return 1
end

