function Weight()
	
	local Diff = ScenarioGetDifficulty()
	local Value = 0
	
	if not DynastyGetRandomVictim("SIM", 30, "VictimDynasty") then
		return 0
	end

	if DynastyIsShadow("VictimDynasty") then
		return 0
	end
	
	local Count = DynastyGetMemberCount("VictimDynasty")
	local VictimNo = Rand(Count)

	if not (DynastyGetMember("VictimDynasty", VictimNo, "Victim")) then
		return 0
	end		
	
	Value = 10*Diff
	
	if GetFavorToDynasty("SIM","Victim")<30 then
		Value = Value+10
		if GetFavorToDynasty("SIM","Victim")<20 then
			Value = Value+10
			if GetFavorToDynasty("SIM","Victim")<10 then
				Value = Value+10
			end
		end
	end

	if ai_AICheckAction()==true then
		return Value
	else
		return 0
	end
end

function Execute()
end
