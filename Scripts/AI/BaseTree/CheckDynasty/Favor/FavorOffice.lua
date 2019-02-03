function Weight()
	
	if not ReadyToRepeat("SIM", "AI_FavorOffice") then
		return 0
	end
	
	-- check if sim is outside of the council at the moment
	if SimGetOfficeLevel("SIM")<0 then
		if not SimIsAppliedForOffice("SIM") then
			-- get the most important seat
			if GetSettlement("SIM", "MyCity") then
				local MaxOffice = CityGetHighestOfficeLevel("MyCity")
				SettlementGetOffice("MyCity", MaxOffice, 0, "Target")
				if GetDynastyID("Target") ~= GetDynastyID("SIM") then
					return 100
				end
			end
		end
	end
	
	-- Now get our voters
	if GetOfficeByApplicant("SIM", "MyOffice") then
			
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
			return 100
		else
			return 0
		end
	else
		-- check family members
		local Count = DynastyGetMemberCount("dynasty")
		for i=0, Count-1 do
			if DynastyGetMember("dynasty", i, "CHECKME") and GetID("CHECKME") ~= GetID("SIM") then
				if GetOfficeByApplicant("CHECKME", "MyOffice") then
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
				end
			end
		end
		
		if AliasExists("Target") then
			return 100
		else
			return 0
		end
	end
	
	return 0
end

function Execute()
	SetRepeatTimer("SIM", "AI_FavorOffice", 1)	
end