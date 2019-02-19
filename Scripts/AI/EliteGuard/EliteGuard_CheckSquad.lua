function Weight()
	GetSettlement("SIM", "City")

	local Number = CityFindSquad("City", nil, "Squad")
	if Number<0 then
		return 0
	end

	SetData("SquadPosition", Number)
	return -1
end

function Execute()
	local Number = GetData("SquadPosition")
	SquadAddMember("Squad", Number, "SIM")
end

