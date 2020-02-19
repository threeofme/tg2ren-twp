-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_MineGuardsDuty.lua"
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	GetAliasByID(GetProperty("", "DynID"), "Dynasty")
	
	SetProperty("", "NotAffectable", 1)
		
	-- Check if the guard is here the first time
	if not HasProperty("", "EndTime") then
		local duration = 24
		local CurrentTime = GetGametime()
		local EndTime = CurrentTime + duration
		SetProperty("", "EndTime", EndTime)
	end
	
	-- Do the timer loop
	local EndTime = GetProperty("", "EndTime")
	while GetGametime() < EndTime do
		
		CarryObject("", "Handheld_Device/ANIM_Shield3.nif", true)
		--Detect enemy and fighting Sims
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim)==1500)AND(Object.IsHostile())AND(Object.GetState(fighting))AND NOT(Object.CanBeControlled())AND NOT(Object.BelongsToMe()))"
		local NumOfSims = Find("", SimFilter,"HostileSim", -1) 
		if NumOfSims > 0 then
			local EnemyID = GetDynastyID("HostileSim")
			local BossID = GetProperty("", "DynID")
			if EnemyID ~= GetDynastyID("") and EnemyID ~= BossID then
				gameplayformulas_SimAttackWithRangeWeapon("", "HostileSim")
				BattleJoin("","HostileSim", false)
			end
			return
		end
		
		--Detect robbers
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim)==1000)AND(Object.GetProfession()==15)OR(Object.GetProfession()==26)AND NOT(Object.CanBeControlled())AND NOT(Object.BelongsToMe())AND NOT(Object.HasProperty(Guarding)))"
		local NumOfSims = Find("", SimFilter,"RobberSim", -1) 
		if NumOfSims > 0 then
			local EnemyID = GetDynastyID("RobberSim")
			local BossID = GetProperty("", "DynID")
			if EnemyID ~= GetDynastyID("") and EnemyID ~= BossID then
				if GetCurrentMeasureName("RobberSim")=="PlunderBuilding" then
					gameplayformulas_SimAttackWithRangeWeapon("", "RobberSim")
					BattleJoin("","RobberSim", false)
				elseif GetCurrentMeasureName("RobberSim")=="SquadWaylayMember"  and SimGetProfession("RobberSim")==GL_PROFESSION_ROBBER then
					gameplayformulas_SimAttackWithRangeWeapon("", "RobberSim")
					BattleJoin("","RobberSim", false)
				elseif GetCurrentMeasureName("RobberSim")=="BurgleAHouse" then
					gameplayformulas_SimAttackWithRangeWeapon("", "RobberSim")
					BattleJoin("","RobberSim", false)
				end
			end
			return
		end	
		-- Fight until the fight is over even if the measure is over
		while GetState("", STATE_FIGHTING) do
			Sleep(4)
		end
		
		NextAnim = Rand(3)
		if NextAnim == 0 then
			PlayAnimation("", "watch_for_guard")
			LoopAnimation("", "sentinal_idle", 12)
		elseif NextAnim == 1 then
			LoopAnimation("", "sentinal_idle", 12)
		else
			Sleep(10)		
		end
	end
	
	-- Move out
	FindNearestBuilding("", -1, GL_BUILDING_TYPE_SOLDIERPLACE, -1, false, "Soldierplace")
	f_MoveTo("", "Soldierplace")
	StopMeasure()
	
end

-- -----------------------
-- Progress
-- -----------------------
function Progress()

	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime") 
		local CurrentTime = GetGametime() 
		CurrentTime = EndTime - CurrentTime 
		CurrentTime = Time - CurrentTime 
		SetProcessProgress("", CurrentTime*10)
		Sleep(3)
	end

end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	local EndTime = GetProperty("", "EndTime")
	if not (GetState("", STATE_FIGHTING)) and (GetGametime() > EndTime) then	
		SetState("", STATE_NPCFIGHTER, false)
		ResetProcessProgress("")
		CarryObject("", "", true)
		InternalDie("")
		InternalRemove("")		
	end
	
end

