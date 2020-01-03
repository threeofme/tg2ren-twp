function Weight()

	if not GetSettlement("SIM", "cg_City") then
		return 0
	end
	
	local Hour = math.mod(GetGametime(), 24)
	if Hour < 8 or Hour > 20 then
		return 0
	end
	
	local CityLevel = CityGetLevel("cg_City")
	if CityLevel == 2 then -- small village
		if not SettlementGetOfficeHolder("cg_City", 1,1, "cg_BodyGuardDest") then
			return 0
		end
	elseif CityLevel == 3 then -- village
		if not SettlementGetOfficeHolder("cg_City", 2,1, "cg_BodyGuardDest") then
			return 0
		end
	elseif CityLevel ==4 then -- small Town
		if not SettlementGetOfficeHolder("cg_City", 3,1, "cg_BodyGuardDest") then
			return 0
		end
	elseif CityLevel >4 then -- Town/Capital
		if not SettlementGetOfficeHolder("cg_City", 4,1, "cg_BodyGuardDest") then
			return 0
		end
	end

	if HasProperty("cg_BodyGuardDest","CityBodyguard") then
		if GetProperty("cg_BodyGuardDest","CityBodyguard")>1 then
			return 0
		end
	end

	if SimIsInside("cg_BodyGuardDest") then
		return 0
	end
	
	if GetState("cg_BodyGuardDest", STATE_IMPRISONED) or GetState("cg_BodyGuardDest", STATE_CAPTURED) then
		return 0
	end
	
	if GetState("cg_BodyGuardDest", STATE_DEAD) or GetState("cg_BodyGuardDest", STATE_DYING) then
		return 0
	end
	
	if GetState("cg_BodyGuardDest", STATE_HIJACKED) then
		return 0
	end
	
	if GetState("cg_BodyGuardDest", STATE_HIDDEN) then
		return 0
	end
	
	if HasProperty("cg_BodyGuardDest","InvitedBy") then
		return 0
	end
	
	return 100
end

function Execute()
	local CurrentGuards = 0
	if HasProperty("cg_BodyGuardDest", "CityBodyguard") then
		CurrentGuards = GetProperty("cg_BodyGuardDest","CityBodyguard")
	end
	SetProperty("cg_BodyGuardDest","CityBodyguard",CurrentGuards+1)
	MeasureRun("SIM", "cg_BodyGuardDest", "EscortCharacterOrTransport")
end

