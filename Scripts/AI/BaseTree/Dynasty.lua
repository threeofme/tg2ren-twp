--- Dynasty (weight more or less static)
    -- Economic Expansion, build/buy workshops DONE
    -- Manage party, includes finding spouses
    -- Nobility
function Weight()
	local PartyCount = DynastyGetMemberCount("dynasty")
	if PartyCount < 2 then
		return 30
	end
	if PartyCount < 3 then
		return 20
	end
	return 10
end

function Execute()
end
