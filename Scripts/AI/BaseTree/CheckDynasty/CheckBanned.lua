function Weight()
	if GetImpactValue("SIM", "banned")==0 then
		return 0
	else
		return 100
	end
end

function Execute()
	MeasureRun("SIM", nil, "DynastyBanned")
end
