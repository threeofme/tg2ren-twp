function Run()
	if GetImpactValue("","InfectedByDisease")==1 then
		return
	end
	if GetDynastyID("") < 0 then
		if SimGetWorkingPlaceID("") == -1 then
			if not GetState("",STATE_BLACKDEATH) then
				diseases_Fever("",true)
			end
		end
	end	
end

