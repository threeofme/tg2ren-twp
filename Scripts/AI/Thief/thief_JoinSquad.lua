function Weight()

	if not SimGetWorkingPlace("SIM", "tjq_place") then
		return 0
	end
	
	if SimGetAge("SIM")<16 then
		return 0
	end
	
	local Count = BuildingGetWorkerCount("tjq_place")
	
	for l=0,Count-1 do
		if BuildingGetWorker("tjq_place", l, "tjq_quadcheck") then
			if SquadGet("tjq_quadcheck", "tjq_squad") then
				return -1
			end
		end
	end
	
	return 0
end

function Execute()
	SquadAddMember("tjq_squad", -1, "SIM")
end

