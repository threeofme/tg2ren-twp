function Weight()
	-- TODO implement threatening
	if true then 
		return 0
	end
	
	if ScenarioGetDifficulty() == 0 then 
		return 0
	end

	if SimGetAge("SIM")<16 then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "ThreatCharacter") then
		return 0
	end
	
	if DynastyGetDiplomacyState("SIM", "Actor") >= DIP_NAP then
		return 0
	end
	
	local EvidenceValue = GetEvidenceValues("SIM", "Actor")
	
	if EvidenceValue > GL_EVIDENCE_SUM_LOW_THREAT_SUCCESS then

		if SimGetClass("Actor") == GL_CLASS_FIGHTER then
			return 50
		else
			return 40
		end
	end
	
	return 0
end

function Execute()
--	MeasureRun("SIM", "Actor", "ThreatCharacter")
end