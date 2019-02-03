function Weight()
	local	Item = "BlackWidowPoison"
	
	if ScenarioGetDifficulty() < 2 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "Use"..Item) > 0 then
		return 0
	end

	local Price = ai_CanBuyItem("SIM", Item)
	
	if Price < 0 then
		return 0
	end
	
	if GetMoney("SIM") < 5000 then
		return 0
	end
	
	if GetInsideBuilding("Victim","Inside") then
		return 0
	end

	return 10
end
function Execute()
	MeasureRun("SIM", "Victim", "UseBlackWidowPoison", false)
end
