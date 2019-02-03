function Weight()
	
	if ScenarioGetTimePlayed() < 1.5 then
		return 0
	end
	
	if SimGetAge("SIM") < 16 then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "AI_Favor") then
		return 0
	end
	
	-- Check for a reason to do favor stuff
	
	local Reason = false
	
	-- check all family members
	local Count = DynastyGetMemberCount("dynasty")
	for i=0, Count-1 do
		if DynastyGetMember("dynasty", i, "CHECKME") then
			if SimGetOfficeLevel("CHECKME") >= 0 then
				Reason = true
				break
			end
			
			if SimIsAppliedForOffice("CHECKME") then
				Reason = true
				break
			end
			
			if GetImpactValue("CHECKME", "TrialTimer") > 0 then
				Reason = true
				break
			end
			
			if f_DynastyGetNumOfAllies("CHECKME") > 0 then
				Reason = true
				break
			end
			
			if DynastyGetBuildingCount2("CHECKME") > 0 then
				Reason = true
				break
			end
		end
	end
	
	if Reason == true then
		return 100
	end
	
	return 0
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	local Timer = 5 - Difficulty
	SetRepeatTimer("SIM", "AI_Favor", Timer)
end