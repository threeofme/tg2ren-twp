function Weight()
	if not dyn_GetIdleMember("dynasty", "SIM") then
		return 0
	end

	local CurrentEnemy = aitwp_GetRandomEnemy("dynasty")
	aitwp_Log("AI::Feud Current enemy ID = "..CurrentEnemy, "dynasty")
	if not CurrentEnemy or CurrentEnemy <= 0 then
		return 0
	end

	GetAliasByID(CurrentEnemy, "VictimDynasty")
	if not AliasExists("") then
		return 0
	end
	local SimID = dyn_GetValidMember("VictimDynasty")
	if SimID and SimID > 0 and GetAliasByID(SimID, "Victim") and AliasExists("Victim") then
		return 30
	end
	
	return 0
end

function Execute()
end