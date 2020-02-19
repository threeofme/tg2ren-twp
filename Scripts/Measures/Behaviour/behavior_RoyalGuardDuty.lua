-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_RoyalGuard.lua"
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	-- Avert the guard from anything else but his duty !
	-- SetState("", STATE_LOCKED, true)
	
	GetAliasByID(GetProperty("", "DynID"), "Dynasty")
	
	SetProperty("", "NotAffectable", 1)
	
	-- Get the guard a weapon
	if not HasProperty("", "Equiped") then
		AddItems("", "Platemail", 1, INVENTORY_EQUIPMENT)
		AddItems("", "FullHelmet", 1, INVENTORY_EQUIPMENT)
		AddItems("", "IronBrachelet", 1, INVENTORY_EQUIPMENT)
		AddItems("", "Longsword", 1, INVENTORY_EQUIPMENT)
		AddImpact("", "Elite", 5, 0)
		SetProperty("", "Equiped", 1)
	end

	CarryObject("", "Handheld_Device/ANIM_Shield2.nif", true)
	
	-- Get the destination position
	if not ScenarioCreatePosition(GetProperty("", "DestX"), GetProperty("", "DestZ"), "DestPos") then
		StopMeasure()
	end

	f_MoveTo("", "DestPos", GL_MOVESPEED_RUN)
	GfxRotateToAngle("", 0, Rand(360), 0, 1, true)
	
	-- Check if the guard is here the first time
	if not HasProperty("", "EndTime") then
		local duration = 1
		local CurrentTime = GetGametime()
		local EndTime = CurrentTime + duration
		SetProperty("", "EndTime", EndTime)
	end
	
	-- SetData("Time", duration)
	-- SetData("EndTime", EndTime)	
	-- SetProcessMaxProgress("", duration*10)
	-- SendCommandNoWait("", "Progress")

	local Range = 1500
	if HasData("CurMeasID") then
		local MeasureID = GetProperty("", "CurMeasID")
		Range = GetDatabaseValue("Measures", MeasureID, "rangeradius") * 100
	end
	
	-- Do the timer loop
	local EndTime = GetProperty("", "EndTime")
	while GetGametime() < EndTime do
		
		local Enemy = Find("", "__F((Object.GetObjectsByRadius(Sim)=="..Range..")AND(Object.IsHostile())AND(Object.GetState(fighting))AND(Object.IsOfficeLevelLower(6)))", "Enemy", -1)
		if Enemy > 0 then
			gameplayformulas_SimAttackWithRangeWeapon("", "Enemy")
			BattleJoin("", "Enemy", false)
		end
		
		-- Fight until the fight is over even if the measure is over
		while GetState("", STATE_FIGHTING) do
			Sleep(2)
		end
		
		NextAnim = Rand(2)
		if NextAnim == 0 then
			PlayAnimation("", "watch_for_guard")
		elseif NextAnim == 1 then
			PlayAnimation("", "sentinal_idle")
		else
			Sleep(2.0)		
		end

		f_MoveTo("", "DestPos", GL_MOVESPEED_RUN)
		GfxRotateToAngle("", 0, Rand(360), 0, 1, true)
		Sleep(1)
	end
	
	-- Move out
	GetHomeBuilding("", "HomeBuilding")
	f_MoveTo("", "HomeBuilding")
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
		ResetProcessProgress("")
		CarryObject("", "", true)
		InternalDie("")
		InternalRemove("")		
	end
	
end

