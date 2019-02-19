function Weight()

	if not ReadyToRepeat("dynasty", "AI_DefendRogue") then
		return 0
	end
	
	-- TODO: Check for dangerous rogues in town
	
	return 100
end

function Execute()
	SetRepeatTimer("dynasty", "AI_DefendRogue", 6)
end