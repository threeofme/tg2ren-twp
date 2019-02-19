function Weight()
	if GetHPRelative("SIM") < 0.75 then
		return 100
	end
	return 0
end

function Execute()
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("GetCured"))
end

