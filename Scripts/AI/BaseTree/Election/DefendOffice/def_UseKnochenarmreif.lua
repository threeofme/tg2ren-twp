function Weight()
	local	Item = "Knochenarmreif"
	local Money = GetMoney("SIM")*0.10 
	local Difficulty = ScenarioGetDifficulty()
	
	if not GetSettlement("SIM","City") then
		return 0
	end
	
	if Difficulty <2 then
		return 0
	end
	
	if GetImpactValue("SIM","Knochenarmreif")>0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end
	
	if not(GetOfficeByApplicant("SIM","office")) then
		if SimGetOfficeLevel("SIM")<0 then
			return 0
		end
	end
	
	if ItemGetBasePrice(Item) > Money then
		return 0
	end
	
	if GetItemCount("", Item,INVENTORY_STD)>0 then
		return 100
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price<0 then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureRun("SIM", nil, "UseKnochenarmreif")
end
