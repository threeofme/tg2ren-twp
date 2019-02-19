function Weight()
	
	if ScenarioGetDifficulty() < 2 then
		return 0
	end
	
	if GetImpactValue("SIM", "BanCharacter")==0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "BanCharacter")>0 then
		return 0
	end
	
	if SimGetOffice("Victim","Office") then
		if OfficeGetLevel("Office")>=6 then
			return 0
		end
	end
	
	if DynastyIsShadow("Victim") then
		return 0
	end
	
	if GetDistance("SIM", "Victim") > 7000 then
		return 0
	end
	
	return 5
end

function Execute()
	MeasureRun("SIM", "Victim", "BanCharacter")
end

