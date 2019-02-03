function Weight()
	if DynastyIsShadow("SIM") then
		return 0
	end 
	
	if not GetHomeBuilding("SIM", "home") then
		return 0
	end
	
	if not BuildingGetCity("home", "city") then
		return 0
	end
	
	CopyAlias("city", "HomeCity")
	
	return 5
end

function Execute()
end