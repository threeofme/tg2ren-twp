function Weight()
	
	local Shadow = false
	
	-- only important shadows attack enemies
	if DynastyIsShadow("SIM") then
		if SimGetOfficeLevel("SIM")<0 then
			if DynastyGetBuildingCount2("SIM") == 0 then
				return 0
			end
		end
		
		Shadow = true
	end
	
	local Difficulty = ScenarioGetDifficulty()
	
	if Difficulty == 0 then
		return 0
	end
	
	if not SimIsAppliedForOffice("SIM") then
		return 0
	end
	
	if GetImpactValue("SIM", "OfficeTimer") < 1 then
		return 0
	end
	
	-- it's too soon for an attack
	if ImpactGetMaxTimeleft("SIM", "OfficeTimer") > 12 then
		return 0
	end
	
	-- Am I an applicant?
	if GetOfficeByApplicant("SIM","office") then
		-- attack the applicants
		local MemberID = GetID("SIM")
		local ApplicantCnt = OfficePrepareSessionMembers("office","applicantlist",2)
		for i=0, ApplicantCnt -1 do
			ListGetElement("applicantlist", i, "applicant")
			local ID = GetID("applicant")
			if not (ID == MemberID) then
				if f_SimIsValid("applicant") then
					if GetInsideBuildingID("applicant") == -1 then -- outside
						if DynastyGetDiplomacyState("SIM","applicant") < DIP_NAP then
							if GetFavorToSim("SIM", "applicant") < 40 then
								if Shadow == true then -- shadows don't attack other shadows
									if not DynastyIsShadow("applicant") then
										CopyAlias("applicant", "Victim")
										break
									end
								else
									CopyAlias("applicant", "Victim")
									break
								end
							end
						end
					end
				end
			end
		end
			
		if not AliasExists("Victim") then
		-- attack the voters who hate us instead 
			local VoterCnt = OfficePrepareSessionMembers("office","voterlist",1)
			for i=0, VoterCnt -1 do
				ListGetElement("voterlist", i, "voter")
				if f_SimIsValid("voter") then
					if GetInsideBuildingID("voter") == -1 then -- outside
						if DynastyGetDiplomacyState("SIM","voter") < DIP_NAP then
							if GetFavorToSim("SIM", "voter") < 30 then
								if Shadow == true then -- shadows don't attack other shadows
									if not DynastyIsShadow("voter") then
										CopyAlias("voter", "Victim")
										break
									end
								else
									CopyAlias("voter", "Victim")
									break
								end
							end
						end
					end
				end
			end
		end
	else
		return 0
	end
	
	if not AliasExists("Victim") then
		return 0
	end
	
	if GetDynasty("Victim", "VictimDyn") then
		local BestState = ai_DynastyGetBestDiplomacyState("dynasty", "VictimDyn")
		if BestState == "NAP" or BestState == "ALLIANCE" then -- actualy we want to be friends
			return 0
		end
	end
	
	if GetDistance("SIM", "Victim") > 8000 then
		return 0
	end
	
	if GetInsideBuildingID("Victim") ~= -1 then
		return 0
	end
	
	if DynastyIsShadow("SIM") and DynastyIsShadow("Victim") then
		return 0
	end
	
	return 100
end

function Execute()
end