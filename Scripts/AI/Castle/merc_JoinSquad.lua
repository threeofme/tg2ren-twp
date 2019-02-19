function Weight()

	if not SimGetWorkingPlace("SIM", "jq_place") then
		return 0
	end
	
	local Count = BuildingGetWorkerCount("jq_place")
	
	for l=0,Count-1 do
		if BuildingGetWorker("jq_place", l, "jq_quadcheck") then
			if SquadGet("jq_quadcheck", "jq_squad") then
				return -1
			end
		end
	end
	
	return 0
end

function Execute()
	SquadAddMember("jq_squad", -1, "SIM")
end

