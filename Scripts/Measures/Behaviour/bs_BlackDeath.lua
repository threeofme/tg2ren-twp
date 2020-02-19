function Run()

	if GetImpactValue("Owner","Blackdeath") == 1 then
		return ""
	end

	SetData("Distance", 1000)
	return "SeeBlackDeath"
	
end

