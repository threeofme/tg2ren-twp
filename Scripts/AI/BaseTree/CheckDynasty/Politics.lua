function Weight()
	
	if ScenarioGetTimePlayed() < 8 then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "AI_Politics") then
		return 0
	end
	
	local time = math.mod(GetGametime(),24)
	
	if time > 23 or time < 6 then
		return 0
	end
	
	if SimGetAge("SIM") < 16 then
		return 0
	end
	
	if GetNobilityTitle("SIM") < 4 then
		return 0
	end
	
	local RhetSkill = GetSkillValue("SIM", RHETORIC)
	
	if RhetSkill == 1 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_Politics", 1)	
end