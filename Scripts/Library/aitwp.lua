---
-- This script bundles the functions used in the reworked AI BaseTree of TradeWarPolitics.
-- That includes the priority calculation for dynasties and current enemy lists.
-- It may also include functions related to AI and game difficulty. 
-- 


-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching (or something...)
end


--- 
-- intended to be called by ScriptCall:
-- Boolean CreateScriptcall(Name, Timer, ScriptFilename, Function, Alias ( of type simobject) pOwner)
-- CreateScriptcall("CalcAIPriorities", 1, "Library/aitwp.lua", "CalculatePriorities", "dynasty")
-- 
function CalculatePriorities(DynAlias)
	-- initialize priorities from dyn properties 
	local Political = GetProperty(DynAlias, "AITWP_Political") or 0
	local Agressive = GetProperty(DynAlias, "AITWP_Agressive") or 0
	local Intrigue = GetProperty(DynAlias, "AITWP_Intrigue") or 0
	
	-- reinitialize enemies
	local MCount, MilitaryEnemies = aitwp_InitEnemies(DynAlias)

	-- get dynasty members
	local MemberCount = DynastyGetMemberCount(DynAlias)
	local MemPolitical, MemAgressive, MemIntrigue
	for i = 0, MemberCount - 1 do
		DynastyGetMember(DynAlias, i, "Member")
		MemPolitical, MemAgressive, MemIntrigue = aitwp_CalculatePrioritiesForMember(DynAlias, "Member", MCount)
		-- factor member result into current values
		Political = aitwp_CalcNewPriority(Political, MemPolitical) 
		Agressive = aitwp_CalcNewPriority(Agressive, MemAgressive) 
		Intrigue = aitwp_CalcNewPriority(Intrigue, MemIntrigue)
	end
	SetProperty(DynAlias, "AITWP_Political", Political)
	SetProperty(DynAlias, "AITWP_Agressive", Agressive)
	SetProperty(DynAlias, "AITWP_Intrigue", Intrigue)
end 

-- result will be <= 100
function CalcNewPriority(CurrentValue, NewValue)
	-- Diff may be positive or negative
	local Diff = math.abs(CurrentValue - NewValue) 
	-- add part of the new value directly
	local Change = math.floor(Diff / 2)
	Change = Change + Rand(Diff - Change)
	Change = math.floor(Change / 2)
	-- add or subtract change
	if NewValue > CurrentValue then
		return math.min(100, CurrentValue + Change)
	else
		return math.min(100, CurrentValue - Change)
	end
end

---
-- Each priority is a value between 0 and 100 that can be used for weighting in AI BaseTree.
function CalculatePrioritiesForMember(DynAlias, SimAlias, MCount)
	local Political = aitwp_CalcPoliticalAmbition(DynAlias, SimAlias)
	local Agressive = aitwp_CalcAgressiveness(DynAlias, SimAlias, MCount)
	local Intrigue = aitwp_CalcIntrigue(DynAlias, SimAlias, Political)
	return Political, Agressive, Intrigue	
end

---
-- Calculates current political ambition of the sim based on:
-- current office level (medium impact)
-- skill values: rhetoric, charisma (low impact)
-- game mode: political (high impact)
function CalcPoliticalAmbition(DynAlias, SimAlias)
	GetSettlement(SimAlias, "City")
	local Political = 0  
	local RhetChar = GetSkillValue(SimAlias, RHETORIC) + GetSkillValue(SimAlias, CHARISMA) -- 2 < n < 20/32
	if RhetChar >= 7 then
		Political = Political + RhetChar 
	end

	local CurrentApplication = SimIsAppliedForOffice(SimAlias) -- Boolean
	local MaxOfficeLevel = math.max(0, SimGetMaxOfficeLevel(SimAlias)) -- 0 < n < 7
	if CurrentApplication then
		Political = Political + 40
	elseif MaxOfficeLevel > 0 then -- no ambition if I can't be elected
		local HighestOfficeLevel = math.max(0, CityGetHighestOfficeLevel("City")) -- 0 < n < 7
		local OfficeLevel = math.max(0, SimGetOfficeLevel(SimAlias)) -- 0 < n < 7
		local Diff = math.min(MaxOfficeLevel, HighestOfficeLevel)
		Political = Political + (Diff * (OfficeLevel + 1))
	end
	-- game mode: political adds up to 40 points
	GetScenario("Scenario")
	local Mission = GetProperty("Scenario", "AITWP_Mission") or 99
	if Mission == 21 then
		local Difficulty = 5 - ScenarioGetDifficulty()
		Political = Political + math.floor(40 / Difficulty) -- 40 on highest, 8 on lowest difficulty
	end
	return math.min(100, Political)
end

--- 
-- Enemies should be a table of dynastyID, i.e. {1, 2, 3}
function CalcAgressiveness(DynAlias, SimAlias, Enemies)
	local Agressive = 0 
	-- more agressive if rogue class
	if GL_CLASS_CHISELER == SimGetClass(SimAlias) then
		Agressive = Agressive + 10
	end 
	-- add skill value (fighting)
	Agressive = Agressive + GetSkillValue(SimAlias, FIGHTING)
	-- more agressive if thugs are available (no more than 20 points
	local ThugCount = DynastyGetWorkerCount(DynAlias, GL_PROFESSION_MYRMIDON)
	Agressive = Agressive + math.min(4, ThugCount)
	-- current character equipment
	if GetArmor(SimAlias) > 14 or BattleGetWeaponName(SimAlias) then
		Agressive = Agressive + 5
	end
	-- current enemies (4 points each, up to 20 points)
	Agressive = Agressive + math.min(20, Enemies*4) 
	-- game mode elimination adds 40
	GetScenario("Scenario")
	local Mission = GetProperty("Scenario", "AITWP_Mission") or 99
	if Mission == 0 then
		local Difficulty = 5 - ScenarioGetDifficulty()
		Agressive = Agressive + math.floor(40 / Difficulty) -- 40 on highest, 8 on lowest difficulty
	end
	return math.min(100, Agressive)
end

function CalcIntrigue(DynAlias, SimAlias, Political)
	local Intrigue = 0
	-- up to 30 points for political ambition
	Intrigue = Intrigue + math.floor(Political * 0.3)
	-- current values of stealth and secret knowledge (up to 20)
	local Skill = GetSkillValue(SimAlias, SHADOW_ARTS) + GetSkillValue(SimAlias, SECRET_KNOWLEDGE)
	Intrigue = Intrigue + math.min(20, Skill)
	
	-- game mode accuser (adds 30)
	GetScenario("Scenario")
	local Mission = GetProperty("Scenario", "AITWP_Mission") or 99
	if Mission == 22 then
		local Difficulty = 5 - ScenarioGetDifficulty()
		Intrigue = Intrigue + math.floor(30 / Difficulty) -- 30 on highest, 6 on lowest difficulty
	end
	return math.min(100, Intrigue)
end

---
-- This will read current enemy selection from properties and return Count and List of the current military enemies
-- It will also initialize the lists if necessary.
function GetCurrentEnemies(DynAlias)
	local Enemies = GetProperty(DynAlias, "AITWP_Enemies") or aitwp_InitEnemies(DynAlias)
	local MCount, ME = helpfuncs_StringToIdList(Enemies)
	return MCount, ME
end

function GetRandomEnemy(DynAlias)
	local Count, Enemies = aitwp_GetCurrentEnemies(DynAlias)
	if Count > 0 then
		return Enemies[Rand(Count)+1]
	end
	return -1
end

---
-- This will initialize the political and military enemies at game start
function InitEnemies(DynAlias)
	local Difficulty = ScenarioGetDifficulty()
	local TimeOfTruce = 5 - Difficulty -- wait 5 rounds on easy, 1 round on hard
	if GetRound() < TimeOfTruce then
		return 0, "" -- no enemies yet
	end
	
	local EnemyCount = 0
	local EnemyIDs = {}
	-- My current rival regarding my workshops
	if HasProperty(DynAlias, "RivalID") then
		EnemyCount = EnemyCount + 1
		EnemyIDs[EnemyCount] = GetProperty(DynAlias, "RivalID")
	end
	
	-- A random victim that we don't like
	-- TODO enbale this only for non-shadows?
	if DynastyGetRandomVictim(DynAlias, 50, "TargetDyn") then
		EnemyCount = EnemyCount + 1
		EnemyIDs[EnemyCount] = GetID("TargetDyn")
	end
	
	-- if we're not shadow, pick another colored dynasty as enemy
	if not DynastyIsShadow(DynAlias) then
		local DynCount = ScenarioGetObjects("cl_Dynasty", 50, "Dyn")
		local DynID, DAli
		for i = 0, 10 do
			DAli = "Dyn"..Rand(DynCount)
			DynID = GetID(DAli)
			if not DynastyIsShadow(DAli) and not DynID == GetID(DynAlias) then
				EnemyCount = EnemyCount + 1
				EnemyIDs[EnemyCount] = DynID
				break
			end
		end
	end
	
	local EnemyProperty = ""
	for i=1, EnemyCount do
		EnemyProperty = EnemyProperty .. EnemyIDs[i]  .. ","
	end
	aitwp_Log("InitEnemies Setting enemies to: "..EnemyProperty, DynAlias)
	SetProperty(DynAlias, "AITWP_Enemies", EnemyProperty)
	return EnemyCount, EnemyIDs
end

---
-- court an existing lover for this sim
function CourtLover(SimAlias)
	local Beloved = "Beloved"
	-- no beloved, find one and start courting
	if not SimGetCourtLover(SimAlias, Beloved) or not AliasExists(Beloved) then
		-- start courting
		MeasureRun(SimAlias, nil, "CourtLover")
		return
	end
	
	-- beloved is dead, alas
	if GetState(Beloved, STATE_DEAD) then
		SimReleaseCourtLover(SimAlias)
		return
	end
	
	-- beloved is not available
	if GetStateImpact(Beloved, "no_control") 
		or SimGetBehavior(Beloved) == "CheckPresession"
		or SimGetBehavior(Beloved) == "CheckTrial"
		or GetState(Beloved, STATE_UNCONSCIOUS)
		or GetHP(Beloved) == 0 then
		return
	end
	
	-- beloved is ready to marry, congratulations!
	if SimGetProgress(SimAlias) > 98 then
		MeasureRun(SimAlias, Beloved, "Marry")
		return
	end
	
	-- find good courting measure and execute it
	local MeasureName = aitwp_GetCourtingMeasure(SimAlias)
	if MeasureName then
		MeasureRun(SimAlias, Beloved, MeasureName)
	end
end

function GetCourtingMeasure(SimAlias)
	local Count
	local M = {}
	Count, M[1], M[2], M[3] = SimGetFavourableCourtingAction(SimAlias)
	local Forbidden0 = GetProperty("", "_ai_cl_0")
	local Forbidden1 = GetProperty("", "_ai_cl_1")
	
	-- check validity of given measure and return first valid measure
	for m = 1, math.max(3, Count) do
		local BestMeasureId = M[m]
		if (BestMeasureId and BestMeasureId > 0) then
			local MeasureName = CourtingId2Measure(BestMeasureId)
			if MeasureName
					and (GetRepeatTimerLeft(SimAlias, GetMeasureRepeatName2(MeasureName)) <= 0)
					and (MeasureName ~= Forbidden0 and MeasureName ~= Forbidden1) then
				-- update properties with last courting measures
				if Forbidden0 then
					SetProperty(SimAlias, "_ai_cl_1", Forbidden0)
				end
				SetProperty("", "_ai_cl_0", MeasureName)
				return MeasureName 
			end
		end
	end
end



-- -----------------------
-- Idle actions of AI 
-- controlled workers
-- -----------------------

--- -----------------------
-- ThiefIdle
-- called from std_idle
-- -----------------------
function ThiefIdle(Workbuilding)
	SimGetWorkingPlace("", "WorkingPlace")
	-- AI controlled thiefs should not go idle
	local Time = math.mod(GetGametime(), 24)
	if BuildingGetAISetting("WorkingPlace", "Enable") > 0 then
		if GetHPRelative("") < 0.7 then
			roguelib_Heal("", "WorkingPlace")
		elseif 5 <= Time and Time <= 21 then
			-- pickpocket or look for sales counters during the day
			if Rand(10) < 7 then
				roguelib_Pickpocket("", "WorkingPlace")
			else
				roguelib_StealFromCounter("", "WorkingPlace")
			end
		else
			roguelib_BurgleBuilding("", "WorkingPlace")
		end 
	end

	local WhatToDo = Rand(5)
	if WhatToDo == 0 then
		if GetFreeLocatorByName("WorkingPlace", "Chair",1,4, "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_SIT, true) then
				RemoveAlias("ChairPos")
				return
			end
			while true do
				local WhatToDo2 = Rand(4)
				if WhatToDo2 == 0 then
					Sleep(12) 
				elseif WhatToDo2 == 1 then
					return
				elseif WhatToDo2 == 2 then
					PlayAnimation("","sit_talk")
				else
					PlayAnimation("","sit_laugh")					
				end
				Sleep(3)
			end
		end
	elseif WhatToDo == 1 then
		if GetLocatorByName("WorkingPlace", "Chair_Cellwatch", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_SIT, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","sit_laugh")
			Sleep(Rand(12)+1)
		end
	elseif WhatToDo == 2 then
		if GetLocatorByName("WorkingPlace", "Fistfight", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","point_at")
			PlayAnimation("","fistfight_in")
			PlayAnimation("","fistfight_punch_01")
			PlayAnimation("","fistfight_punch_05")
			PlayAnimation("","fistfight_punch_02")
			PlayAnimation("","fistfight_punch_06")
			PlayAnimation("","fistfight_punch_03")
			PlayAnimation("","fistfight_punch_07")
			PlayAnimation("","fistfight_punch_04")
			PlayAnimation("","fistfight_punch_08")
			PlayAnimation("","fistfight_out")
		end
	elseif WhatToDo == 3 then
		if GetLocatorByName("WorkingPlace", "Pickpocket", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","pickpocket")
		end
	else
		if GetLocatorByName("WorkingPlace", "Cell_Outside", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","sentinel_idle")
		end
	end
end

function CocotteIdle(Cocotte)
	SimGetWorkingPlace(Cocotte, "Divehouse")
	-- AI controlled cocottes do not go idle
	local Lvl = BuildingGetLevel("Divehouse")
	local GuestCount = BuildingGetSimCount("Divehouse")
	if BuildingGetAISetting("Divehouse", "Enable") > 0 then
		-- offer services if not already offered
		if not HasProperty("Divehouse", "ServiceActive") and not HasProperty("Divehouse", "GoToService") then
			SetProperty("Divehouse","GoToService",1)
			MeasureCreate("Measure")
			MeasureAddData("Measure", "TimeOut", Rand(3)+2)
			MeasureStart("Measure", Cocotte, "Divehouse", "AssignToServiceDivehouse")
		elseif Lvl >= 2 and GuestCount > 4 and not HasProperty("Divehouse", "DanceShow") and not HasProperty("Divehouse", "GoToDance") then
			SetProperty("Divehouse","GoToDance",1)
			MeasureCreate("Measure")
			MeasureAddData("Measure", "TimeOut", Rand(3)+3)
			MeasureStart("Measure", Cocotte, "Divehouse", "AssignToDanceDivehouse")
		else
			MeasureRun(Cocotte,"Divehouse","AssignToLaborOfLove",false)
		end
	end
	return 
end

-- -----------------------
-- MyrmidonIdle
-- -----------------------
function MyrmidonIdle(MyrmAlias)
	LogMessage("::TOM::AI Myrmidon going idle: ".. GetName(MyrmAlias))
	SimGetWorkingPlace(MyrmAlias, "WorkingPlace")
	GetDynasty("WorkingPlace", "DynAlias")
	local IsManageEmployee = GetProperty("", "TWP_ManageEmployee") or 0
	if DynastyIsAI("DynAlias") or IsManageEmployee > 0 then
		if GetHPRelative(MyrmAlias) < 0.7 then
			LogMessage("::TOM::AI Myrmidon healing: ".. GetName(MyrmAlias))
			roguelib_Heal(MyrmAlias, "WorkingPlace")
		end
		-- patrol or escort or gather evidence or check outfit
		local Decision = Rand(11)
		if Decision < 4 then
			-- escort
			local PartyCount = DynastyGetMemberCount("DynAlias")
			DynastyGetFamilyMember("DynAlias", Rand(PartyCount), "ProtectMe")
			LogMessage("::TOM::AI Myrmidon ".. GetName(MyrmAlias).." escorting: ".. GetName("ProtectMe"))
			MeasureRun(MyrmAlias, "ProtectMe", "EscortCharacterOrTransport")
		elseif Decision < 8 then -- 4, 5, 6, 7
			-- patrol
			DynastyGetRandomBuilding("DynAlias", -1, -1, "PatrolPlace")
			LogMessage("::TOM::AI Myrmidon ".. GetName(MyrmAlias).." patroling: ".. GetName("PatrolPlace"))
			MeasureRun(MyrmAlias, "PatrolPlace", "PatrolTheTown")
		elseif Decision < 10 and BuildingHasUpgrade("WorkingPlace", "Commode") then -- 8, 9
			-- gather evidence
			LogMessage("::TOM::AI Myrmidon ".. GetName(MyrmAlias).." gathering evidence...")
			if GetSettlement("WorkingPlace", "City") and f_CityFindCrowdedPlace("City", MyrmAlias, "GatherDestination") > 0 then
				f_ExitCurrentBuilding(MyrmAlias)
				f_MoveTo(MyrmAlias, "GatherDestination", GL_MOVESPEED_RUN, 500)
				MeasureRun(MyrmAlias, 0, "OrderCollectEvidence")
			end
		end -- Decision 10
	elseif GetFreeLocatorByName("WorkingPlace", "backroom_sit_",1,3, "ChairPos") then
		if not f_BeginUseLocator(MyrmAlias, "ChairPos", GL_STANCE_SIT, true) then
			RemoveAlias("ChairPos")
			return
		end
		while true do
			local WhatToDo2 = Rand(4)
			if WhatToDo2 == 0 then
				Sleep(10) 
			elseif WhatToDo2 == 1 then
				Sleep(Rand(20)+4)
			elseif WhatToDo2 == 2 then
				PlayAnimation(MyrmAlias,"sit_talk")
			else
				PlayAnimation(MyrmAlias,"sit_laugh")					
			end
			Sleep(1)
		end
		if DynastyIsAI("DynAlias") then
			-- I'm rested now, check equipment and get going
			MeasureRun(MyrmAlias, nil, "CheckOutfit")
		end
	end
	Sleep(3)
end

SHOW_MSG = false
function Log(Message, Actor, ShowMsg)
	if GL_ENABLE_LOG < 1 then
		return
	end
	ShowMsg = SHOW_MSG and ShowMsg
	Actor = Actor or ""
	LogMessage("::TWP::AI::"..GetName(Actor).." "..Message)
	if ShowMsg then
--		MsgQuick("All", "::TWP::AI::"..GetName(Actor).." "..Message)
	end
end

function GetPoliticalAmbititon(DynAlias)
	return GetProperty(DynAlias, "AITWP_Political") or 0
end
function GetAgressiveness(DynAlias)
	return GetProperty(DynAlias, "AITWP_Agressive") or 0
end
function GetIntrigue(DynAlias)
	return GetProperty(DynAlias, "AITWP_Intrigue") or 0
end


function LogMovementMeasure(SimAlias)
	if GL_ENABLE_LOG > 0 and DynastyIsPlayer(SimAlias) and IsPartyMember(SimAlias) then
		local Measure = GetCurrentMeasureName(SimAlias)
		LogMessage("AITWP::MOVE::"..GetName(SimAlias).." moving in measure: "..Measure)
	end
end

