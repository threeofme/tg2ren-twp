function Weight()

	if not ReadyToRepeat("SIM", "AI_DefendFeud") then
		return 0
	end
	
	local EnemyCount = f_DynastyGetNumOfEnemies("SIM")
	if EnemyCount < 1 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_DefendFeud", 3)
end