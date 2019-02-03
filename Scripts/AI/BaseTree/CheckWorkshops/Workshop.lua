function Weight()
	aitwp_Log("Weight::Workshop", "dynasty")
	if not dyn_GetRandomWorkshopForSim("SIM", "MyWorkshop") then
		return 0
	end
	
	aitwp_Log("Weight::Workshop returns 20", "dynasty")
	return 40
end

function Execute()
	aitwp_Log("Execute::Workshop", "dynasty")
	aitwp_Log("Execute::Workshop for SIM", "SIM")
end