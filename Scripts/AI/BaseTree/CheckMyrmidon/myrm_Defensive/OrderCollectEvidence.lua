function Weight()
	if not GetSettlement("SIM", "OCE_HomeCity") then
		return 0
	end
	
	if not CityGetRandomBuilding("OCE_HomeCity", -1, -1, -1, -1, FILTER_IGNORE, "OCE_Random") then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM","OCE_WORBUILDING") then
		return 0
	end
	
	if not BuildingHasUpgrade("OCE_WORBUILDING","Commode") then
		return 0
	end

	return 100
end

function Execute()
	if GetOutdoorMovePosition("Sim", "OCE_Random", "MoveToPosition") then
		f_MoveTo("Sim","MoveToPosition",GL_MOVESPEED_RUN, 500)
	else
		f_MoveTo("Sim","OCE_Random",GL_MOVESPEED_RUN, 500)
	end
	MeasureRun("SIM", 0, "OrderCollectEvidence")
end

