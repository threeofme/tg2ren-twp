function Weight()
	if not ReadyToRepeat("dynasty", "AI_ChargeCharacter") then
		return 0
	end

	if not AliasExists("Victim") then
		return 0
	end	
	
	if not SimCanBeCharged("Victim") then
		return 0
	end	
	
	return GetEvidenceValues("SIM", "Victim")
end

function Execute()
	SetRepeatTimer("dynasty", "AI_ChargeCharacter", 48)
	MeasureRun("SIM", "Victim", "ChargeCharacter")
end