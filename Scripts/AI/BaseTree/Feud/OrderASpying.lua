function Weight()
	if not dyn_GetIdleMyrmidon("dynasty", "MYRM") then
		return 0
	end

	if GetFavorToDynasty("dynasty", "VictimDynasty") > gameplayformulas_GetMaxFavByDiffForAttack() then
		return 0
	end

	if not DynastyGetMemberRandom("VictimDynasty", "member") then
		return 0
	end
	
	return 20
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", 8, false)
	MeasureStart("Measure", "MYRM", "member", "OrderASpying")
end

