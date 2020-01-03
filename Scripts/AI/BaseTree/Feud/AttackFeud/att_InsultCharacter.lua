function Weight()

	if GetRepeatTimerLeft("SIM", GetMeasureRepeatName2("InsultCharacter")) > 0 then
		return 0
	end
	
	if not ReadyToRepeat("Victim", "Get_Insult") then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "Do_Insult") then
		return 0
	end
	
	if GetNobilityTitle("SIM") < 6 then
		return 0
	end
	
	-- check our combat values
	local MyPower = 0
	local EnemyPower = 0
	
	MyPower = GetSkillValue("SIM", FIGHTING) + (GetSkillValue("SIM", CONSTITUTION))/2 + (GetSkillValue("SIM", DEXTERITY))/2
	EnemyPower = GetSkillValue("Victim", FIGHTING) + (GetSkillValue("Victim", CONSTITUTION))/2 + (GetSkillValue("Victim", DEXTERITY))/2 + 3 -- add 3
	
	-- enemy is too strong
	if EnemyPower > MyPower then
		return 0
	end
	
	if GetInsideBuildingID("Victim") ~= -1 then
		return 0
	end

	return 20
end

function Execute()
	SetRepeatTimer("Victim", "Get_Insult", 72)
	SetRepeatTimer("dynasty", "Do_Insult", 48)
	MeasureRun("SIM", "Victim", "InsultCharacter", false)
end

