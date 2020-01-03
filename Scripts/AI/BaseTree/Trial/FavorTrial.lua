function Weight()

	if not ReadyToRepeat("SIM", "AI_FavorTrial") then
		return 0
	end
	
	if GetImpactValue("SIM", "TrialTimer") < 1 then
		return 0
	end
	
	if not HasProperty("SIM", "TrialJudge") then
		return 0
	end
	
	local JudgeID = GetProperty("SIM", "TrialJudge")
	if not GetAliasByID(JudgeID, "TrialJudge") then
		return 0
	end
	local FavorToJudge = GetFavorToSim("SIM", "TrialJudge")
	
	local Assessor1ID = GetProperty("SIM", "TrialAssessor1")
	if not GetAliasByID(JudgeID, "TrialAssessor1") then
		return 0
	end
	local FavorToAssessor1 = GetFavorToSim("SIM", "TrialAssessor1")
	
	local Assessor2ID = GetProperty("SIM", "TrialAssessor2")
	if not GetAliasByID(JudgeID, "TrialAssessor2") then
		return 0
	end
	local FavorToAssessor2 = GetFavorToSim("SIM", "TrialAssessor2")
	
	-- select who to favor
	local FavorTarget = { "TrialJudge", "TrialAssessor1", "TrialAssessor2" }
	local Check
	local BestTarget = -1
	local BestValue = 0
	for i=1, 3 do
		Check = FavorTarget[i]
		if f_SimIsValid(Check) then
			local Favor = GetFavorToSim("SIM", Check)
			if Favor > BestValue and Favor >= 30 and Favor <= 95 then
				BestValue = Favor
				BestTarget = Check
			end
		end
	end
	
	if BestTarget == -1 then
		return 0
	end
	
	CopyAlias(BestTarget, "Target")
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_FavorTrial", 2.5)
end