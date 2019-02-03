function Weight()
	if GetImpactValue("SIM", "LeadCrusade")==0 then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "LeadCrusade")>0 then
		return 0
	end
	
	if not GetNearestSettlement("SIM", "privcc_city") then
		return 0
	end
	
	if CityFindCrowdedPlace("privcc_city", "SIM", "privcc_dest")==0 then
		return 0
	end

	return 100
end

function Execute()
	MeasureRun("SIM", "privcc_dest", "LeadCrusade")
end
