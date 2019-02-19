---- Decides, whether a new workshop will be build. 
function Weight()
	if not ReadyToRepeat("dynasty", "AI_CheckWorkshops") then
		return 0
	end
	
	local round = GetRound()
	if round < 2 then -- not before round 3
		return 0
	end
	
	if DynastyIsShadow("dynasty") then
		return 0
	end

	if not CanBuildWorkshop("dynasty") then
		-- Missing a title, the new workshop will have to wait.
		return 0
	end
	
	local current = chr_DynastyGetWorkhopCount("dynasty")
	local diff = ScenarioGetDifficulty()
	local max = diff + 1 -- lowest difficulty: max 1 workshop
	-- dynasty may build workshop
	if current < max then
		return 100
	end
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	local Timer = 96 - Difficulty*12
	SetRepeatTimer("dynasty", "AI_CheckWorkshops", Timer)
end
