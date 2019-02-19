function Weight()
	if not dyn_GetIdleMember("dynasty", "SIM") then
		return 0
	end
	
	if SimGetSpouse("SIM") then
		-- already married
		return 0
	end
	
	if not ReadyToRepeat("SIM", "AI_CourtLover") then
		return 0
	end
	
	return 50
end

function Execute()
	SetRepeatTimer("SIM", "AI_CourtLover", 2)
	aitwp_CourtLover("SIM")
end