-- ******** THANKS TO KINVER ********
function Weight()
	if SimGetWorkingPlace("SIM","Divehouse") then
		if BuildingGetLevel("Divehouse") < 2 then
			return 0
		end
	else
	    return 0
	end

	if SimGetGender("SIM") == GL_GENDER_MALE then
		return 0
	end

	if not SimCanWorkHere("SIM", "Divehouse") then
		return 0
	end

	if HasProperty("Divehouse", "DanceShow") then
		return 0
	end

	if HasProperty("Divehouse", "GoToDance") then
		return 0
	end

	local NumGuests = BuildingGetSimCount("Divehouse")
	if NumGuests < 4 then
		return 0
	end

	local Distance = GetDistance("SIM","Divehouse")
	if Distance > 4000 then
		return 0		
	end

	local TryTime
	if HasProperty("Divehouse", "DanceStartTime") then
		TryTime = GetProperty("Divehouse", "DanceStartTime") + 4
		if TryTime < GetGametime() then
			return 0
		end
	end

	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", Rand(3)+3)
	MeasureStart("Measure", "SIM", "Divehouse", "AssignToDanceDivehouse")
end

