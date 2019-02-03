function Weight()
	aitwp_Log("Weight::BaseIdle", "dynasty")
	if not dyn_GetIdleMember("dynasty", "SIM") or not AliasExists("SIM") then
		return 0
	end 

	return 5
end

function Execute()
	aitwp_Log("Going IDLE right away", "dynasty")
	if Rand(10) < 8 and dyn_GetRandomWorkshopForSim("SIM", "MyWorkshop") then
		f_MoveTo("SIM", "MyWorkshop", GL_MOVESPEED_RUN)
	else
		MeasureRun("SIM", 0, "DynastyIdle")
	end
end