function Run()

	local Number = SimFindSquad("", "Squad")
	if Number>=0 then
		SquadAddMember("Squad", Number, "")
	end
end

