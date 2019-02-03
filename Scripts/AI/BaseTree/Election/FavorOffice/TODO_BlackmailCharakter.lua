function Weight()
	-- TODO implement blackmail
	if true then 
		return 0
	end

	if ScenarioGetDifficulty() == 0 then 
		return 0
	end

	if SimGetAge("SIM")<16 then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "BlackmailCharacter") then
		return 0
	end
	
	if DynastyGetDiplomacyState("SIM", "Actor") >= DIP_NAP then
		return 0
	end
	
	if SimGetOfficeLevel("Actor") <=0 or SimGetOfficeLevel("Actor") < SimGetOfficeLevel("SIM") then
		return 0
	end
	
	local EvidenceValue = GetEvidenceAlignmentSum("SIM", "Actor")
	
	if EvidenceValue > 3 then
		return 65
	end
	
	return 0
end

function Execute()
	MeasureRun("SIM", "Actor", "BlackmailCharacter")
end