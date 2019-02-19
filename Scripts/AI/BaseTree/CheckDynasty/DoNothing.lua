function Weight()
	return 1
end

function Execute()
	if GetImpactValue("SIM", "banned")==0 then
		MeasureRun("SIM", nil, "DynastyIdle")
	else
		MeasureRun("SIM", nil, "DynastyBanned")
	end
end
