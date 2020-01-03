
function Weight()
	-- select SIM with upcoming trial
	local Count = DynastyGetMemberCount("dynasty")
	for i=0, Count-1 do
		if DynastyGetMember("dynasty", i, "Member") and dyn_IsIdleMember("Member") then
			if SimIsAppliedForOffice("Member") then
				CopyAlias("Member", "ElectionSIM")
				return 50
			end
		end
	end
	
	-- no trial upcoming
	return 0
end

function Execute()
	CopyAlias("ElectionSIM", "SIM")
	RemoveAlias("ElectionSIM")
end