function Weight()
	if DynastyGetBuildingCount("dynasty", -1, -1) < 1 then
		return 0
	end
	
	if DynastyGetFamilyMemberCount("dynasty")<1 then
	    return 0
	end
	
	local numDynSims = DynastyGetFamilyMemberCount("dynasty")
	local j = Rand(numDynSims)
	if not DynastyGetFamilyMember("dynasty",j,"ProtectMe") then
	    return 0
	end
	
	if not IsPartyMember("ProtectMe") then
	    return 0
	end

	if SimIsInside("ProtectMe") then
	    return 0
	end
	
	if GetState("ProtectMe", STATE_IMPRISONED) or GetState("ProtectMe", STATE_CAPTURED) then
		return 0
	end
	
	if GetState("ProtectMe", STATE_DEAD) or GetState("ProtectMe", STATE_DYING) then
		return 0
	end
	
	if GetState("ProtectMe", STATE_HIJACKED) then
		return 0
	end
	
	if GetState("ProtectMe", STATE_HIDDEN) then
		return 0
	end
	
	if HasProperty("ProtectMe","InvitedBy") then
		return 0
	end
	
	if HasProperty("ProtectMe","KIbodyguard") then
	    if SimGetLevel("ProtectMe")<5 then
		    return 0
		end
	    if GetProperty("ProtectMe","KIbodyguard")>1 then
		    return 0
		end
	end
		
	return 100
end

function Execute()
    if HasProperty("ProtectMe","KIbodyguard") then
        SetProperty("ProtectMe","KIbodyguard",2)
	else
	    SetProperty("ProtectMe","KIbodyguard",1)
	end
	MeasureRun("SIM", "ProtectMe", "EscortCharacterOrTransport")
end
