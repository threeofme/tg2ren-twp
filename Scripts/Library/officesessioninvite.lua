------------------------------------------------------------------------------------------------------------------------
-- NOT NEEDED ANYMORE ------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function SendApplicationInvites()
	return
	--Check Which Levels have to be invited for the Office

	local OLevel = OfficeGetLevel("office")
	local VoterCnt = 0
	local Level, Office
	local MaxOfficeLevel = SettlementGetOfficeLevelCnt("settlement")

	if (OLevel == (MaxOfficeLevel - 1)) then
		-- office is toplevel, all offices vote
		for Level = 1, MaxOfficeLevel - 2, 1 do
			for Office = 0, SettlementGetOfficeCnt("settlement", Level) - 1, 1 do
				if(SettlementGetOfficeHolder("settlement", Level, Office, "Voter_"..Level.."_"..VoterCnt)) then
					SetData("VoterNr_"..VoterCnt,"Voter_"..Level.."_"..VoterCnt)
					SetData("VoterLevel_"..VoterCnt,Level)
					VoterCnt = VoterCnt + 1
				end
			end
		end
	elseif (OLevel == (MaxOfficeLevel - 2)) then
		--office is one level under top level, only top level votes
		for Office = 0, SettlementGetOfficeCnt("settlement", MaxOfficeLevel - 1) - 1, 1 do
			if(SettlementGetOfficeHolder("settlement", MaxOfficeLevel - 1, Office, "Voter_"..(MaxOfficeLevel - 1).."_"..VoterCnt)) then
				SetData("VoterNr_"..VoterCnt,"Voter_"..(MaxOfficeLevel - 1).."_"..VoterCnt)
				SetData("VoterLevel_"..VoterCnt,(MaxOfficeLevel - 1))
				VoterCnt = VoterCnt + 1
			end
		end
	else
		--toplevel office and one level over defender level votes
		for Office = 0, SettlementGetOfficeCnt("settlement", MaxOfficeLevel - 1)  - 1, 1 do
			if(SettlementGetOfficeHolder("settlement", MaxOfficeLevel - 1, Office, "Voter_"..(MaxOfficeLevel - 1).."_"..VoterCnt)) then
				SetData("VoterNr_"..VoterCnt,"Voter_"..(MaxOfficeLevel - 1).."_"..VoterCnt)
				SetData("VoterLevel_"..VoterCnt,(MaxOfficeLevel - 1))
				VoterCnt = VoterCnt + 1
			end
		end
		if (MaxOfficeLevel - 1) ~= (OLevel + 1) then
			for Office = 0, SettlementGetOfficeCnt("settlement", OLevel + 1) - 1 , 1 do
				if(SettlementGetOfficeHolder("settlement", OLevel + 1, Office, "Voter_"..(OLevel).."_"..VoterCnt)) then
					SetData("VoterNr_"..VoterCnt,"Voter_"..(OLevel).."_"..VoterCnt)
					SetData("VoterLevel_"..VoterCnt,(OLevel))
					VoterCnt = VoterCnt + 1
				end
			end
		end
	end

	--Filter out allready invited voters
	local OfficeCounts = GetData("AppList_Count")
	local officeL
	local voterL
	local VoterAllreadyInvited = false
	for officeL = 1, OfficeCounts do
		local CurrentOffice = GetData("AppList_"..officeL.."_ID")
		SetData("AppList_CurrentOffice",CurrentOffice)
		local invitedL
		local invitedCount = GetData("AppList_Inviters_Count")
		if not invitedCount then
			invitedCount = 0
		end
		for invitedL = 0, invitedCount -1, 1 do
			local VoterAllreadyInvited = false
			for voterL = 0, VoterCnt - 1, 1 do
				SetData("OfficeVoteViction",voterL)
				local AllreadyInvited = GetData("AppList_Inviters_"..invitedL)
				local VoterWantJoin = GetData("VoterNr_"..voterL)
				if GetID(AllreadyInvited) == GetID(VoterWantJoin) then
					SetData("CheckVoterNr_"..voterL,999)
					break
				end
			end
			if VoterAllreadyInvited == false then
			else
				SetData("CheckVoterNr_"..GetData("OfficeVoteViction"),999)
			end
		end
	end

	--Filter out allready invited voters for Deposition
	local OfficeCounts = GetData("DepList_Count")
	local officeL
	local voterL
	for officeL = 1, OfficeCounts do
		local CurrentOffice = GetData("DepList_"..officeL.."_ID")
		if officeL == 1 then
			SetData("DepList_CurrentOffice",CurrentOffice)
		end
		local invitedL
		local invitedCount = GetData("DepList_Inviters_Count")
		if not invitedCount then
			invitedCount = 0
		end
		for invitedL = 0, invitedCount -1, 1 do
			local VoterAllreadyInvited = false
			for voterL = 0, VoterCnt - 1, 1 do
				SetData("OfficeVoteViction",voterL)
				local AllreadyInvited = GetData("DepList_Inviters_"..invitedL)
				local VoterWantJoin = GetData("VoterNr_"..voterL)
				if GetID(AllreadyInvited) == GetID(VoterWantJoin) then
					SetData("CheckVoterNr_"..voterL,999)
					break
				end
			end
			if VoterAllreadyInvited == false then
			else
				SetData("CheckVoterNr_"..GetData("OfficeVoteViction"),999)
			end
		end
	end

	-- invite all voters
	local Voter
	for Voter = 0, VoterCnt - 1, 1 do
		local VoterCanJoin = GetData("CheckVoterNr_"..Voter)
		local VoterWantJoin = GetData("VoterNr_"..Voter)
		local VoterCanJoinLevel = GetData("VoterLevel_"..Voter)

		local CurrentVoterCount = GetData("AppList_Inviters_Count")
		if not CurrentVoterCount then
			CurrentVoterCount = 0
		end
		SetData("AppList_Inviters_Count",CurrentVoterCount+1)
		SetData("AppList_Inviters_"..Voter,VoterWantJoin)
		SetData("AppList_Inviters_Office_"..Voter,GetID("office"))
		SetData("AppList_Inviters_Level_"..Voter,VoterCanJoinLevel)

		--dont invite allready invited voters
		if VoterCanJoin ~= 999 then
			local TotalInviters = GetData("Office_Inviters_Count")
			SetData("Office_Inviters_"..TotalInviters,VoterWantJoin)
			SetData("Office_Inviters_InvID_"..TotalInviters,GetID(VoterWantJoin))
			SetData("Office_Inviters_Level_"..Voter,VoterCanJoinLevel)
			SetData("Office_Inviters_Count",TotalInviters+1)
			officesession_InviteVoters(VoterWantJoin,"@L_SESSION_5_MESSAGES_ERROR_+0")
		end
	end
end

function SendDepositionInvites()
	return
	--Check Which Levels have to be invited for the Office
	local OLevel = OfficeGetLevel("office")
	local VoterCnt = 0
	local Level, Office
	local MaxOfficeLevel = SettlementGetOfficeLevelCnt("settlement")

	if (OLevel == (MaxOfficeLevel - 1)) then
		-- office is toplevel, all offices vote
		for Level = 1, MaxOfficeLevel - 2, 1 do
			for Office = 0, SettlementGetOfficeCnt("settlement", Level) - 1, 1 do
				if(SettlementGetOfficeHolder("settlement", Level, Office, "Voter_"..Level.."_"..VoterCnt)) then
					SetData("VoterNr_"..VoterCnt,"Voter_"..Level.."_"..VoterCnt)
					SetData("VoterLevel_"..VoterCnt,Level)
					VoterCnt = VoterCnt + 1
				end
			end
		end
	elseif (OLevel == (MaxOfficeLevel - 2)) then
		--office is one level under top level, only top level votes
		for Office = 0, SettlementGetOfficeCnt("settlement", MaxOfficeLevel - 1) - 1, 1 do
			if(SettlementGetOfficeHolder("settlement", MaxOfficeLevel - 1, Office, "Voter_"..(MaxOfficeLevel - 1).."_"..VoterCnt)) then
				SetData("VoterNr_"..VoterCnt,"Voter_"..(MaxOfficeLevel - 1).."_"..VoterCnt)
				SetData("VoterLevel_"..VoterCnt,(MaxOfficeLevel - 1))
				VoterCnt = VoterCnt + 1
			end
		end
	else
		--toplevel office and one level over defender level votes
		for Office = 0, SettlementGetOfficeCnt("settlement", MaxOfficeLevel - 1)  - 1, 1 do
			if(SettlementGetOfficeHolder("settlement", MaxOfficeLevel - 1, Office, "Voter_"..(MaxOfficeLevel - 1).."_"..VoterCnt)) then
				SetData("VoterNr_"..VoterCnt,"Voter_"..(MaxOfficeLevel - 1).."_"..VoterCnt)
				SetData("VoterLevel_"..VoterCnt,(MaxOfficeLevel - 1))
				VoterCnt = VoterCnt + 1
			end
		end
		if (MaxOfficeLevel - 1) ~= (OLevel + 1) then
			for Office = 0, SettlementGetOfficeCnt("settlement", OLevel + 1) - 1 , 1 do
				if(SettlementGetOfficeHolder("settlement", OLevel + 1, Office, "Voter_"..(OLevel).."_"..VoterCnt)) then
					SetData("VoterNr_"..VoterCnt,"Voter_"..(OLevel).."_"..VoterCnt)
					SetData("VoterLevel_"..VoterCnt,(OLevel))
					VoterCnt = VoterCnt + 1
				end
			end
		end
	end

	-- also invite the deffender into the jury court (cant vote later)
	for Level = 1, MaxOfficeLevel do
		for Office = 0, SettlementGetOfficeCnt("settlement", Level) - 1, 1 do
			if(SettlementGetOfficeHolder("settlement", Level, Office, "TemperVoter")) then
				if GetID("TemperVoter") == GetID(GetData("OfficeSpecialGuest")) then
					SettlementGetOfficeHolder("settlement", Level, Office, "Voter_"..Level.."_"..VoterCnt)
					SetData("VoterNr_"..VoterCnt,"Voter_"..Level.."_"..VoterCnt)
					SetData("VoterLevel_"..VoterCnt,Level)
					VoterCnt = VoterCnt + 1
					break
				end
			end
		end
	end

	--Filter out allready invited voters for Deposition
	local OfficeCounts = GetData("DepList_Count")
	local officeL
	local voterL
	local VoterAllreadyInvited = false
	for officeL = 1, OfficeCounts do
		local CurrentOffice = GetData("DepList_"..officeL.."_ID")
		if officeL == 1 then
			SetData("DepList_CurrentOffice",CurrentOffice)
		end
		local invitedL
		local invitedCount = GetData("DepList_Inviters_Count")
		if not invitedCount then
			invitedCount = 0
		end
		local loopvalue
		if invitedCount > VoterCnt then
			loopvalue = invitedCount
		else
			loopvalue = VoterCnt
		end

		for invitedL = 0, loopvalue -1, 1 do
			for voterL = 0, loopvalue - 1, 1 do
				local AllreadyInvited = GetData("DepList_Inviters_"..invitedL)
				local VoterWantJoin = GetData("VoterNr_"..voterL)
				if GetID(AllreadyInvited) == GetID(VoterWantJoin) then
					SetData("CheckVoterNr_"..voterL,999)
					VoterAllreadyInvited = true
					break
				end
			end
		end
	end

	--Filter out allready invited voters
	local OfficeCounts = GetData("AppList_Count")
	local officeL
	local voterL
	local VoterAllreadyInvited
	local VoterAllreadyInvited = false
	for officeL = 1, OfficeCounts do
		local CurrentOffice = GetData("AppList_"..officeL.."_ID")
		SetData("AppList_CurrentOffice",CurrentOffice)
		local invitedL
		local invitedCount = GetData("AppList_Inviters_Count")
		if not invitedCount then
			invitedCount = 0
		end
		for invitedL = 0, invitedCount -1, 1 do
			local VoterAllreadyInvited = false
			for voterL = 0, VoterCnt - 1, 1 do
				SetData("OfficeVoteViction",voterL)
				local AllreadyInvited = GetData("AppList_Inviters_"..invitedL)
				local VoterWantJoin = GetData("VoterNr_"..voterL)
				if GetID(AllreadyInvited) == GetID(VoterWantJoin) then
					SetData("CheckVoterNr_"..voterL,999)
					VoterAllreadyInvited = true
					break
				end
			end
			if VoterAllreadyInvited == false then
			else
				SetData("CheckVoterNr_"..GetData("OfficeVoteViction"),999)
			end
		end
	end

	-- invite all voters
	local Voter
	for Voter = 0, VoterCnt - 1, 1 do
		local VoterCanJoin = GetData("CheckVoterNr_"..Voter)
		local VoterWantJoin = GetData("VoterNr_"..Voter)
		local VoterCanJoinLevel = GetData("VoterLevel_"..Voter)

		local CurrentVoterCount = GetData("DepList_Inviters_Count")
		if not CurrentVoterCount then
			CurrentVoterCount = 0
		end
		SetData("DepList_Inviters_Count",CurrentVoterCount+1)
		SetData("DepList_Inviters_"..Voter,VoterWantJoin)
		SetData("DepList_Inviters_Office_"..Voter,GetID("office"))
		SetData("DepList_Inviters_Level_"..Voter,VoterCanJoinLevel)

		--dont invite allready invited voters
		if VoterCanJoin ~= 999 then
			SetData("VoterNr_"..Voter,"0")
			SetData("CheckVoterNr_"..Voter,"0")
			local TotalInviters = GetData("Office_Inviters_Count")
			SetData("Office_Inviters_"..TotalInviters,VoterWantJoin)
			SetData("Office_Inviters_InvID_"..TotalInviters,GetID(VoterWantJoin))
			SetData("Office_Inviters_Level_"..Voter,VoterCanJoinLevel)
			SetData("Office_Inviters_Count",TotalInviters+1)
			if GetID(VoterWantJoin) == GetID(GetData("OfficeSpecialGuest")) then
				SetData("Office_Inviters_Look_"..TotalInviters,1)
			end
			officesession_InviteVoters(VoterWantJoin,"@L_SESSION_5_MESSAGES_ERROR_+0")
		end
	end
end




