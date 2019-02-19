function Weight()
	
	local Item = "SmallBeer"
	if SimGetRank("SIM")==3 then
		Item = "WheatBeer"
	elseif SimGetRank("SIM")>3 then
		Item = "Wein"
	end
	
	if not ReadyToRepeat("SIM", "AI_DrinkAlc") then
		return 0
	end
	
	if GetImpactValue("SIM","alc") > 0 then
		return 0
	end
	
	if GetMoney("SIM") < 5000 then
		return 0
	end
	
	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price<0 then
		return 0
	end
	
	return 10
end

function Execute()
	
	SetRepeatTimer("SIM", "AI_DrinkAlc", 6)
	
	if SimGetRank("SIM")<3 then
		MeasureRun("SIM", nil, "DriSmallBeer")
	elseif SimGetRank("SIM")==3 then
		MeasureRun("SIM", nil, "DriWheatBeer")
	elseif SimGetRank("SIM")>3 then
		MeasureRun("SIM", nil, "DriWein")
	end
end
