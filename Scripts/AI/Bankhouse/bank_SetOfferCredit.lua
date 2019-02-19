function Weight()

	if IsDynastySim("SIM") then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM","MyBank") then
		return 0
	end
	
	local Producer = BuildingGetProducerCount("MyBank", PT_MEASURE, "OfferCredit")
	if Producer>0 then
		return 0
	end
	
	if GetCurrentMeasureName("SIM")=="CollectDebts" then
		return 0
	end

	if GetInsideBuildingID("SIM") ~= GetID("MyBank") then
		return 0
	end
	
	if not HasProperty("MyBank", "BankAccount") then
		return 0
	end
	
	if GetProperty("MyBank","BankAccount")<100 then
		return 0
	end

	local Hour = math.mod(GetGametime(), 24)
	if (Hour<6) or (Hour>=22) then
		return 0
	end
	
	local CreditSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000) AND (Object.HasProperty(WaitForCredit)))"
	local NumCreditSims = Find("SIM", CreditSimFilter,"CreditSim", -1)
	if NumCreditSims < 1 then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureRun("SIM", "MyBank", "OfferCredit", false)
end
