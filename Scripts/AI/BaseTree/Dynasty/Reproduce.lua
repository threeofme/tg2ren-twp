function Weight()
	aitwp_Log("Weight::Reproduce", "dynasty")
	
	if not ReadyToRepeat("dynasty", "AI_Reproduce") then
		return 0
	end

	-- choose married party member
	local PartyCount = DynastyGetMemberCount("dynasty")
	for i=0, PartyCount-1 do
		DynastyGetMember("dynasty", i, "Member")
		
		if SimGetAge("Member") >= 18 
				and SimGetSpouse("Member", "Spouse") 
				and SimGetChildCount("Member") < 4 
				and dyn_IsIdleMember("Member")
				and dyn_IsIdleMember("Spouse") then
			CopyAlias("Member", "SIM")
			return 10
		end
	end
	return 0
end

function Execute()
	SetRepeatTimer("dynasty", "AI_Reproduce", 24)
end

