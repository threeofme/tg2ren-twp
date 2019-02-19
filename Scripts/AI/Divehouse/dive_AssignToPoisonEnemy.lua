function Weight()
	
	if not GetSettlement("SIM", "City") then
		return 0
	end

	if SimGetWorkingPlace("SIM","MyWork") then
	    if BuildingGetLevel("MyWork") < 3 then
		    return 0
		end
	else
	    return 0
	end
	
    if not CityGetRandomBuilding("City",-1,30,-1,-1,FILTER_IGNORE,"Sabotage") then
	    return 0
	end

	local OpferSimFilter = "__F( (Object.GetObjectsByRadius(Sim)==1000)AND(Object.HasDynasty())AND NOT(Object.BelongsToMe())AND NOT(Object.GetState(child))AND NOT(Object.GetState(fighting)))"
	local NumEnemySims = Find("SIM", OpferSimFilter,"EnemySim", -1)
	if NumEnemySims < 1 then
		return 0
	end

	GetDynasty("EnemySim","DynEnem")
	GetDynasty("SIM","DynDo")
	if DynastyGetDiplomacyState("DynDo","DynEnem") >= DIP_NAP then
		return 0
	end

    if not GetOutdoorMovePosition("SIM","Sabotage","StartHier") then
	    return 0
	end
	
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", Rand(2)+3)
	MeasureStart("Measure", "SIM", "StartHier", "AssignToPoisonEnemy")
end

