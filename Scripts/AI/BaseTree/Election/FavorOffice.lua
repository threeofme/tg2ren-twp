function Weight()
	
	if not ReadyToRepeat("SIM", "AI_FavorOffice") then
		return 0
	end
	
	-- unable to get application
	if not GetOfficeByApplicant("SIM", "MyOffice") then
		return 0
	end
			
	local VoterCnt = OfficePrepareSessionMembers("MyOffice", "VoterList", 1)
	for i=0, VoterCnt-1 do
		ListGetElement("VoterList", i, "Voter")
		if f_SimIsValid("Voter") then
			if GetFavorToSim("SIM", "Voter") >= 30 then
				CopyAlias("Voter", "Target")
				break
			end
		end
	end
	
	if AliasExists("Target") then
		return 20
	end

	return 0
end

function Execute()
	SetRepeatTimer("SIM", "AI_FavorOffice", 1)	
end