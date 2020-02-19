function Run()

	CopyAlias("","Hospital")

	local TotalIncome = 0
	local RoundIncome = 0
	local LastIncome = 0
	local SoapIncome = 0
	local LastSoapIncome = 0
	local MedicalIncome = 0
	local LastMedicalIncome = 0
	local QuackIncome = 0
	local LastQuackIncome = 0
	local Wages = 0

	if HasProperty("Hospital","TotalIncome") then
		TotalIncome = GetProperty("Hospital","TotalIncome")
	end
	
	if HasProperty("Hospital","RoundIncome") then
		RoundIncome = GetProperty("Hospital","RoundIncome")
	end
	
	if HasProperty("Hospital","LastIncome") then
		LastIncome = GetProperty("Hospital","LastIncome")
	end
	
	if HasProperty("Hospital","SoapIncome") then
		SoapIncome = GetProperty("Hospital","SoapIncome")
	end
	
	if HasProperty("Hospital","LastSoapIncome") then
		LastSoapIncome = GetProperty("Hospital","LastSoapIncome")
	end
	
	if HasProperty("Hospital","MedicalIncome") then
		MedicalIncome = GetProperty("Hospital","MedicalIncome")
	end
	
	if HasProperty("Hospital","LastMedicalIncome") then
		LastMedicalIncome = GetProperty("Hospital","LastMedicalIncome")
	end
	
	if HasProperty("Hospital","QuackIncome") then
		QuackIncome = GetProperty("Hospital","QuackIncome")
	end
	
	if HasProperty("Hospital","LastQuackIncome") then
		LastQuackIncome = GetProperty("Hospital","LastQuackIncome")
	end
	
	-- wages
	local numFound = 0
	local	Alias
	local count = BuildingGetWorkerCount("Hospital")
	
	for number=0, count-1 do
		Alias = "Worker"..numFound
		if BuildingGetWorker("Hospital", number, Alias) then
			numFound = numFound + 1
		end
	end
	
	if numFound > 0 then
		for loop_var=0, numFound-1 do
			Alias = "Worker"..loop_var
			Wages = Wages + SimGetWage(Alias,"Hospital")
		end
	end

	MsgBoxNoWait("dynasty", "Hospital", "@L_MEASURE_ShowBalanceHospital_HEAD_+0",
						"@L_MEASURE_ShowBalanceHospital_BODY_+0",GetID("Hospital"), 
						MedicalIncome, SoapIncome, QuackIncome, RoundIncome, LastIncome,
						TotalIncome, Wages, LastMedicalIncome, LastSoapIncome, LastQuackIncome)

end
