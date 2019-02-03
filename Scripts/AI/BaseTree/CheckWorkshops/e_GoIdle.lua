function Weight()
	aitwp_Log("Weight::Economy::GoIdle", "dynasty")
	return 50
end

function Execute()
	aitwp_Log("Execute::GoIdle", "dynasty")
	aitwp_Log("Execute::GoIdle for SIM", "SIM")
	if Rand(10) < 8 and dyn_GetRandomWorkshopForSim("SIM", "MyWorkshop") then
		f_MoveTo("SIM", "MyWorkshop", GL_MOVESPEED_RUN)
	else
		MeasureRun("SIM", 0, "DynastyIdle")
	end
end