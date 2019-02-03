function Weight()
	aitwp_Log("Weight::NobilityTitle", "dynasty")
	if not dyn_GetIdleMember("dynasty", "SIM") then
		return 0
	end
	
	-- If you are available for high offices, get that titles you need
	if (GetNobilityTitle("SIM") <= 4) and (SimGetOfficeLevel("SIM") > 0) then
		return 20
	end
	
	if not ReadyToRepeat("dynasty", "AI_NobilityTitle") then
		return 0
	end
	
	local currenttitle = GetNobilityTitle("SIM")
	local cost = GetDatabaseValue("NobilityTitle", currenttitle+1, "price")
	local famelvl = GetDatabaseValue("NobilityTitle", currenttitle+1, "minimperialfame")
	
	if not DynastyIsShadow("SIM") then
		ai_CalcItemBudget("dynasty")
	
		if (chr_DynastyGetImperialFameLevel("dynasty") < famelvl) then
			if famelvl <= 2 then
				-- XXX temporary workaround to enable AI to reach title 8 and 9 and advance to imperial offices
				chr_SimAddImperialFame("SIM",1)
			else
				return 0
			end
		end
	end
	
	if cost == nil or cost == "" then
		return 0
	end
	
	if DynastyIsShadow("SIM") or GetMoney("SIM") > (cost+5000) then
		return 10
	end

	return 0
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	local Repeat = 48 - Difficulty*6 
	SetRepeatTimer("dynasty", "AI_NobilityTitle", Repeat)
	
	MeasureRun("SIM", nil, "BuyNobilityTitle", false)
	return
end

