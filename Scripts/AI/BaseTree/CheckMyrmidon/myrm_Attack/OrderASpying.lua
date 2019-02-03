function Weight()
--	if GetFavorToDynasty("dynasty", "VictimDynasty") > gameplayformulas_GetMaxFavByDiffForAttack() then
--		return 0
--	end

--	if not DynastyGetMemberRandom("VictimDynasty", "member") then
--		return 0
--	end
	return 0
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", 8, false)
	MeasureStart("Measure", "SIM", "member", "OrderASpying")
end

