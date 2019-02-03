function Weight()
	aitwp_Log("Weight::ManageParty", "dynasty")
	local PartyCount = DynastyGetMemberCount("dynasty")
	local FamilyCount = DynastyGetFamilyMemberCount("dynasty")
	if PartyCount < 3 and FamilyCount > PartyCount then
		return 10	
	end
	return 0
end

function Execute()
	local PartyCount = DynastyGetMemberCount("dynasty")
	local FamilyCount = DynastyGetFamilyMemberCount("dynasty")
	local Choice = -1
	local BestWeight = -1
	for idx=0, FamilyCount-1 do
		if DynastyGetFamilyMember("dynasty", idx, "member") then
			if GetDynastyID("dynasty") == GetDynastyID("member") then
				local Weight =  manageparty_CheckMember("member")
				if Weight > BestWeight then
					Choice = idx
					BestWeight = Weight
				end
			end
		end
	end
	
	if Choice >= 0 then
		DynastyGetFamilyMember("dynasty", Choice, "SIM")
		DynastyAddMember("dynasty", "SIM")
		if DynastyGetRandomBuilding("dynasty", GL_BUILDING_CLASS_LIVINGROOM, GL_BUILDING_TYPE_RESIDENCE, "home") then
			SetHomeBuilding("SIM", "home")
		end
	end
end

function CheckMember(SimAlias)
	if GetState(SimAlias, STATE_DEAD) or GetState(SimAlias, STATE_DYING) then
		return -1
	end

	if DynastyIsPlayer(SimAlias) then
		return -1
	end
	
	if GetHomeBuilding(SimAlias, "Home") then
		if DynastyIsPlayer("Home") then
			return -1
		end
	end
	
	if IsPartyMember(SimAlias) then
		return -1
	end
	
	local Age = SimGetAge(SimAlias)
	
	if Age>72 or Age<16 then
		return -1
	end
	
	local Weight
	Weight = 2*(72 - (Age - 16)) + SimGetLevel(SimAlias) * 10
	
	return Weight
end