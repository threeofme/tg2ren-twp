function Weight()

	if not ReadyToRepeat("dynasty", "AI_CheckPartyMember") then
		return 0
	end	

	local DynastyCount = DynastyGetMemberCount("dynasty")
	if DynastyCount > 2 then
		SetRepeatTimer("dynasty", "AI_CheckPartyMember", 6)
		return 0
	end
	
	local FamilyCount = DynastyGetFamilyMemberCount("dynasty")
	local BestWeight = -1
	
	if FamilyCount == DynastyCount then
		SetRepeatTimer("dynasty", "AI_CheckPartyMember", 16)
		return 0
	end
	
	for idx=0, FamilyCount-1 do
		if DynastyGetFamilyMember("dynasty", idx, "member") then
			if GetDynastyID("dynasty") == GetDynastyID("member") then
				local Weight =  checkparty_CheckMember("member")
				if Weight > BestWeight then
					BestWeight = Weight
					CopyAlias("member", "SIM")
				end
			end
		end
	end
	
	if not AliasExists("SIM") then
		SetRepeatTimer("dynasty", "AI_CheckPartyMember", 12)
		return 0
	end
	
	return 100
end

function CheckMember(SimAlias)
	if GetState(SimAlias, STATE_DEAD) or GetState(SimAlias, STATE_DYING) then
		return -1
	end
	
	if GetHomeBuilding(SimAlias, "Home") then
		if DynastyIsPlayer("Home") then
			return -1
		end
	end
	
	if DynastyIsPlayer(SimAlias) then
		return -1
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

function Execute()
	DynastyAddMember("dynasty", "SIM")
end

