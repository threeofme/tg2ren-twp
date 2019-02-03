function Weight()

	if not HasProperty("SIM", "TrialOpponent") then
		return 0
	end
	
	local	Item = "FragranceOfHoliness"
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end
	
	if GetImpactValue("SIM", "TrialTimer") < 1 then
		return 0
	end
	
	-- it's too soon
	if ImpactGetMaxTimeleft("SIM", "TrialTimer") > 6 then
		return 0
	end
	
	if GetItemCount("SIM", Item, INVENTORY_STD) > 0 then
		return 100
	end

	local Price = ai_CanBuyItem("SIM", Item)
	if Price<0 then
		return 0
	end

	return 10
end

function Execute()
	MeasureRun("SIM", nil, "UseFragranceOfHoliness", false)
end
