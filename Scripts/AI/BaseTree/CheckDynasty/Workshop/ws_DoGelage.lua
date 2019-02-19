function Weight()
	
	if SimGetClass("SIM") ~= 4 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "DoGelage") > 0 then
		return 0
	end
	
	-- rogues dont do parties during night time (= work time)
	local time = math.mod(GetGametime(),24)
	if time < 6 or time >= 20 then
		return 0
	end
	
	if not AliasExists("MyWorkshop") then
		LogMessage("MyWorkshop existiert nicht!")
		return 0
	end
	
	if not BuildingIsWorkingTime("MyWorkshop") then
		return 0
	end
	
	if GetMoney("SIM") < 10000 then
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
	
	if LowestFavor >= 85 then
		return 0
	end
	
	return 100 
end

function Execute()
	MeasureRun("SIM", "MyWorkshop", "DoGelage", false)
end


