function Weight()
	aitwp_Log("Weight::Duel", "dynasty")
	-- select SIM with upcoming duel
	local Count = DynastyGetMemberCount("dynasty")
	for i=0, Count-1 do
		if DynastyGetMember("dynasty", i, "Member") then
			if GetImpactValue("Member", "DuelTimer") >= 1 and ImpactGetMaxTimeleft("Member", "DuelTimer") <= 10 then
				CopyAlias("Member", "DuelSIM")
				return 50
			end
		end
	end
	
	-- no duel upcoming
	return 0
end

function Execute()
	aitwp_Log("Going into DUEL measures", "dynasty")
	CopyAlias("DuelSIM", "SIM")
	RemoveAlias("DuelSIM")
end