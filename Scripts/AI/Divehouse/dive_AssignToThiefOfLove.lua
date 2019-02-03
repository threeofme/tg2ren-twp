function Weight()
	
	if not GetSettlement("SIM", "City") then
		return 0
	end

	if SimGetWorkingPlace("SIM","MyWork") then
		if BuildingGetLevel("MyWork") < 2 then
		    return 0
		end
	else
	    return 0
	end
	
	if not BuildingHasUpgrade("MyWork","SexyClothes") then
	    return 0
	end

	if IsDynastySim("SIM") then
		return 0
	end

	local ThiefLevel = SimGetLevel("SIM")
	if ThiefLevel < 3 then
		return 0
	end

	if CityFindCrowdedPlace("City", "SIM", "pick_pos")==0 then
		return 0
	end

	if not HasProperty("MyWork", "ServiceActive") then
		return 0			
	end	

	if BuildingGetLevel("Divehouse") > 1 then
		if not HasProperty("MyWork", "DanceShow") then
			return 33
		end	
	end

	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", Rand(6)+2)
	MeasureStart("Measure", "SIM", "pick_pos", "AssignToThiefOfLove")
end

