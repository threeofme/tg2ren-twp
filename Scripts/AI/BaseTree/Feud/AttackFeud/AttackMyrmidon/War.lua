function Weight()
	
	if ScenarioGetDifficulty() < 2 then
		return 0
	end
	
	if DynastyGetDiplomacyState("dynasty", "VictimDynasty") > DIP_NEUTRAL then
		return 0
	end

	local Count = DynastyGetMemberCount("VictimDynasty")
	
	if not DynastyGetMember("VictimDynasty", Rand(Count), "WAR_SIM") then
		return 0
	end
	
	if not CanBeControlled("WAR_SIM", "VictimDynasty") then
		return 0
	end
	
	return 5
end

function Execute()
	SquadCreate("MYRM", "SquadWar", "WAR_SIM", "SquadWarMember", "SquadWarMember")
end

