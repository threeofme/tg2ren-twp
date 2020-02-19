function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
	-- check if is cityguard or gardist or eliteguard
	if SimGetProfession("Owner")==GL_PROFESSION_CITYGUARD or SimGetProfession("Owner")==54 or SimGetProfession("Owner")==25 then
		CopyAlias("Actor", "Destination")
		return "InspectArea"
	end
	
	if SimGetProfession("Owner")==GL_PROFESSION_MYRMIDON then

		-- it's a mercenary, so check if this a mercenary from a friend dynasty

		if GetDynasty("Actor", "ActorDynasty") and GetDynasty("Owner", "OwnerDynasty") then
			if DynastyGetDiplomacyState("ActorDynasty","OwnerDynasty") == DIP_ALLIANCE then
				CopyAlias("Actor", "Destination")
				return "InspectArea"
			end
		end
	end

	return ""
end
