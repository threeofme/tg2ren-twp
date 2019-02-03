function Weight()
	aitwp_Log("Weight::Workshop::Propel", "dynasty")
	aitwp_Log("Weight::Workshop::Propel for SIM", "SIM")
	
	if SimGetClass("SIM") == 4 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "PropelEmployees") > 0 then
		return 0
	end
	
	if not AliasExists("MyWorkshop") then
		return 0
	end
	
	if not BuildingIsWorkingTime("MyWorkshop") then
		return 0
	end
	
	local time = math.mod(GetGametime(),24)
	
	if time > 16 then
		return 0
	end
	
	local numFound = 0
	local Alias
	local count = BuildingGetWorkerCount("MyWorkshop")
	local LowestFavor = 100
	
	for number=0, count-1 do
		Alias = "Worker"..numFound
		if BuildingGetWorker("MyWorkshop", number, Alias) then
			if SimIsWorkingTime(Alias) then
				numFound = numFound + 1
				if GetFavorToSim("SIM", Alias) < LowestFavor then
					LowestFavor = GetFavorToSim("SIM", Alias)
				end
			end
		end
	end
	
	if numFound == 0 then
		return 0
	end
	
	if LowestFavor <= 35 then
		return 0
	end
	
	return 5 
end

function Execute()
	MeasureRun("SIM", "MyWorkshop", "PropelEmployees", false)
end


