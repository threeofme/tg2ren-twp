
function Run()

	if GetState("Destination",STATE_NPCFIGHTER) then
		StopMeasure()
	end
	
	if DynastyIsPlayer("Destination") or IsDynastySim("Destination") then
		StopMeasure()
	end
	
	MeasureSetNotRestartable()
	
	-- Display the court lover sheet
	SetProperty("", "LoverID", GetID("Destination"))
	if not (MsgBox("", 0, "CourtLover", 0, 0) == "O") then
		RemoveProperty("", "LoverID")
		StopMeasure()
		return
	end
	
	RemoveProperty("", "LoverID")
	local money = GetMoney("")
	local cost = math.floor(money / 100 * 15)
	
	if SimGetCourtingSim("Destination","blabla") then
		MsgQuick("","%1SN %2l",GetID("Destination"),"@L_FILTER_IS_COURTED")
		StopMeasure()
	end
	
	--MinimumCosts for different levels :  PATCH TODO
		
	local LLevel = SimGetLevel("Destination")
	
	-- idea of fixed prices
	if LLevel == 1 and cost < 1500 then
		cost = 1500
	elseif LLevel == 2 and cost < 2750 then
		cost = 2750
	elseif LLevel == 3 and cost < 4000 then
		cost = 4000
	elseif LLevel == 4 and cost < 5250 then
		cost = 5250
	elseif LLevel == 5 and cost < 6800 then
		cost = 6800
	elseif LLevel == 6 and cost < 8500 then
		cost = 8500
	elseif LLevel == 7 and cost < 10000 then
		cost = 10000
	elseif LLevel == 8 and cost < 12500 then
		cost = 12500
	elseif LLevel == 9 and cost < 14250 then
		cost = 14250
	elseif Llevel == 10 and cost < 16000 then
		cost = 16000
	end
	
	
	
	
	if cost > money then
		MsgBox("", "Destination", "@P@B[A, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+1]"..
							"@B[B, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+2]",
							"@L_MEASURE_ForceMarriage_Proposal_HEAD_+0",
							"@L_MEASURE_ForceMarriage_Proposal_BODY_+0",
							cost, GetID("Destination"))
		StopMeasure()
		return	
	else
		
			local BYesNo = MsgBox("", "Destination", "@P@B[A, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+0]"..
						"@B[B, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+2]",
						"@L_MEASURE_ForceMarriage_Proposal_HEAD_+0",
						"@L_MEASURE_ForceMarriage_Proposal_BODY_+0",
						cost, GetID("Destination"))
								
		if (BYesNo == "A") then
			f_SpendMoney("", cost, "CostForceMarriage")
			SimMarry("", "Destination")
		end
	end
		
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

end
