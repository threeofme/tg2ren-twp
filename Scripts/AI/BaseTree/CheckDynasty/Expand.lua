function Weight()

	if ScenarioGetTimePlayed() < 1 then
		return 0
	end

	if SimGetAge("SIM")<16 then
		return 0
	end
	
	if GetDynastyID("SIM") < 1 then
		return 0
	end
	
	if not f_SimIsValid("SIM") then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "AI_Expand") then
		return 0
	end

	return 100
end

function Execute()
	SetRepeatTimer("dynasty", "AI_Expand", 3)
end