function Weight()
	if not dyn_GetIdleMember("dynasty", "SIM") then
		return 0
	end

	if not ReadyToRepeat("dynasty", "AI_DefendRogue") then
		return 0
	end
	
	-- TODO: Check for dangerous rogues in town
	
	return 5
end

function Execute()
	SetRepeatTimer("dynasty", "AI_DefendRogue", 6)
end