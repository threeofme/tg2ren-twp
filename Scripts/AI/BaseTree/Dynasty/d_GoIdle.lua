function Weight()
	if not dyn_GetIdleMember("dynasty", "SIM") or not AliasExists("SIM") then
		return 0
	end

	return 0
end

function Execute()
	if Rand(10) < 8 and dyn_GetRandomWorkshopForSim("SIM", "MyWorkshop") then
		f_MoveTo("SIM", "MyWorkshop", GL_MOVESPEED_RUN)
	else
		MeasureRun("SIM", 0, "DynastyIdle")
	end
end