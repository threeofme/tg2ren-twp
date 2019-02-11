-------------------------------------------------------------------------------
----
----	OVERVIEW "dyn"
----
----	Script functions library for dynasty issues
----
-------------------------------------------------------------------------------

-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

-- -----------------------
-- IsLocalPlayer
-- -----------------------
function IsLocalPlayer(Object)
	GetLocalPlayerDynasty("LocPlayDyn")
	if GetID("LocPlayDyn") == GetDynastyID(Object) then
		return true
	else
		return false
	end
end

-- -----------------------
-- BlockEvilMeasures
-- -----------------------
function BlockEvilMeasures(BlockerDynAlias, BlockerDynID, Duration)

		if HasProperty(BlockerDynAlias, "NoEvilFrom"..BlockerDynID) then
			local ref = GetProperty(BlockerDynAlias, "NoEvilFrom"..BlockerDynID)
			SetProperty(BlockerDynAlias, "NoEvilFrom"..BlockerDynID, ref+1)
		else
			SetProperty(BlockerDynAlias, "NoEvilFrom"..BlockerDynID, 1)
		end
		
		-- This scriptcall will reset the effect
		
		CreateScriptcall("RemoveBlockEvilMeasures", Duration, "Library/dyn.lua", "RemoveBlockEvilMeasures", BlockerDynAlias, nil, BlockerDynID)
			
end

-- -----------------------
-- RemoveBlockEvilMeasures
-- -----------------------
function RemoveBlockEvilMeasures(BlockerDynID)

		if HasProperty("", "NoEvilFrom"..BlockerDynID) then
		
			local ref = GetProperty("", "NoEvilFrom"..BlockerDynID)
			
			if (ref == 1) then
				RemoveProperty("", "NoEvilFrom"..BlockerDynID)
			else
				SetProperty("", "NoEvilFrom"..BlockerDynID, ref-1)
				return true
			end
		end
		
		return false
end

-- -----------------------
-- EvilMeasuresBlocked
-- -----------------------
function EvilMeasuresBlocked(Blocked, Blocker)

		GetDynasty(Blocker, "DestDyn")
		if HasProperty("DestDyn", "NoEvilFrom"..GetDynastyID(Blocked)) then			
			GetDynasty(Blocked, "DestDyn")
			MsgBoxNoWait(Blocked, Blocker, "_GENERAL_ERROR_HEAD_+0", "@L_GENERAL_MEASURES_FAILURES_+17", GetID("DestDyn"))
			return true
		else
			return false
		end
						
end

function GetValidMember(Dynasty)
	local Count = DynastyGetMemberCount(Dynasty)
	for i=0, Count-1 do
		if DynastyGetMember(Dynasty, i, "Member") then
			if not GetState("Member", STATE_DYING) then
				if not GetState("Member", STATE_DEAD) then
					CopyAlias("Member", "DynastyBoss")
					break
				end
			end
		end
	end
	
	if not AliasExists("DynastyBoss") and AliasExists("Member") then
		CopyAlias("Member", "DynastyBoss")
	end
	
	local BossID = GetID("DynastyBoss")
	
	return BossID
end

function GetIdleMember(Dynasty, MemberAlias)
	local Count = DynastyGetMemberCount(Dynasty)
	for i=0, Count-1 do
		if DynastyGetMember(Dynasty, i, "Member") then
			if AliasExists("Member") and dyn_IsIdleMember("Member") then
				CopyAlias("Member", MemberAlias)
				return GetID("Member")
			end
		end
	end
	return false
end

function IsIdleMember(MemberAlias)
	--aitwp_Log("Checking idle state for ", MemberAlias) 
	if GetState(MemberAlias, STATE_DYING) or GetState(MemberAlias, STATE_DEAD) then
		return false
	end
	GetDynasty(MemberAlias, "dyn")
	if not CanBeControlled(MemberAlias, "dyn") then
		return false
	end
	-- no measures while waiting for trial or office session
	if SimGetBehavior(MemberAlias)=="CheckPresession" or SimGetBehavior(MemberAlias)=="CheckTrial" then
		-- TODO also check Presession?
		return false
	end
	-- no measures just before duel
	if GetImpactValue(MemberAlias, "DuelTimer") >= 1 and ImpactGetMaxTimeleft(MemberAlias, "DuelTimer") <= 3 then
		return false
	end
	
	local CurMeasureID = GetCurrentMeasureID(MemberAlias)
	if CurMeasureID == 0 or CurMeasureID == 3202 or CurMeasureID == 3200 -- idle measures
			or (CurMeasureID == 220 and Rand(10) < 3) then -- chance of 30% to interrupt production
		return true
	end
	return false
end

function GetIdleMyrmidon(Dynasty, MyrmAlias) 
	local Count = DynastyGetWorkerCount(Dynasty, GL_PROFESSION_MYRMIDON)
	for i=0,Count-1 do
		if DynastyGetWorker(Dynasty, GL_PROFESSION_MYRMIDON, i, "CHECKME") then
			if GetState("CHECKME", STATE_IDLE) 
					or GetCurrentMeasureName("CHECKME") == "EscortCharacterOrTransport" 
					or GetCurrentMeasureName("CHECKME") == "PatrolTheTown" 
					or GetCurrentMeasureName("CHECKME") == "OrderCollectEvidence" then
				CopyAlias("CHECKME", MyrmAlias)
				return GetID(MyrmAlias)
			end
		end
	end
	return false
end

function GetRandomWorkshopForSim(SimAlias, WorkshopAlias)
	local BldCount = DynastyGetBuildingCount(SimAlias, GL_BUILDING_CLASS_WORKSHOP, -1)
	
	for i = 1, BldCount do
		DynastyGetRandomBuilding(SimAlias, GL_BUILDING_CLASS_WORKSHOP, -1, "RandBuild")
		if BuildingGetOwner("RandBuild", "BldOwner") and GetID(SimAlias) == GetID("BldOwner") then
			CopyAlias("RandBuild", WorkshopAlias)
			return true
		end
	end
	-- none found, return
	return false
end
