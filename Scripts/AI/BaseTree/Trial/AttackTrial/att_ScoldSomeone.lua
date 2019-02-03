function Weight()
	if not DynastyGetRandomBuilding("SIM", 2, GL_BUILDING_TYPE_CHURCH_EV, "Church") then
		if not DynastyGetRandomBuilding("SIM", 2, GL_BUILDING_TYPE_CHURCH_CATH, "Church") then
			return 0
		end
	end
		
	if not ReadyToRepeat("dynasty", "AI_Worship") then
		return 0
	end
	
	return 100
end

function Execute()
	local TargetID = GetID("Victim")
	SetRepeatTimer("dynasty", "AI_Worship", 12)
	if AliasExists("Church") then
		SetProperty("Church", "ScoldSomeone", TargetID)
	end
end
