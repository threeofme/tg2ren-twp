function Weight() 

	if not DynastyGetRandomVictim("dynasty", 55, "victimrazzia") then
		if not GetSettlement("SIM","City") then
			return 0
		end
		if not CityGetRandomBuilding("City",2,-1,-1,-1,FILTER_IGNORE,"RazziaHouse") then
			return 0
		end
	end 
	
	if DynastyGetDiplomacyState("dynasty", "victimrazzia") > DIP_NEUTRAL then
		return 0
	end
	
	if not DynastyGetRandomBuilding("victimrazzia", 2, -1, "RazziaHouse") then
		return 0
	end
	
	if GetImpactValue("RazziaHouse","buildingburgledtoday")==1 then	
		return 0
	end
	
	if GetEvidenceValues("", "RazziaHouse") < 35 then
		return 0
	end

	return 100
end

function Execute()
	SquadCreate("SIM", "SquadRazzia", "RazziaHouse", "SquadRazziaMember", "SquadRazziaMember")
end

