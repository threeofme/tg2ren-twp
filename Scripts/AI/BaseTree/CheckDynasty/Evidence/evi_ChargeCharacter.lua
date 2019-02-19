function Weight()
	
	local MyRhetoric = GetSkillValue("SIM", RHETORIC)
	local EnemyRhetoric = GetSkillValue("Actor", RHETORIC)
	local Value = 45 + MyRhetoric*5 - EnemyRhetoric*5
	
	return Value
end

function Execute()
	MeasureRun("SIM", "Actor", "ChargeCharacter", true)
end