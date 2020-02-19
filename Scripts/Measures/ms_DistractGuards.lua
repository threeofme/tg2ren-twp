-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_DistractGuards"
----
----	With this measure the player can distract the city guards with the cocotte
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	local InteractionDistance = 128
	local ReactionDistance = 650
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	if not f_MoveTo("", "Destination") then
		StopMeasure()
	end
	
	if not SimGetWorkingPlace("","WorkBuilding") then
		StopMeasure()
	end
	
	-- Get data
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if BuildingHasUpgrade("WorkBuilding","SexClothes") then
		duration = duration * 2
	end
	
	-- Progress bar stuff
	local Time = GetGametime()
	local EndTime = Time + duration
	SetData("Time", duration)
	SetData("EndTime", EndTime)
	SetProcessMaxProgress("", duration*10)
	SendCommandNoWait("", "Progress")
	
	-- Time out stuff
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()

	local Counter = 0
	
	-- Loop
	while GetGametime() < EndTime do
		local Guard = Find("", "__F((Object.GetObjectsByRadius(Sim)==2500)AND(Object.GetProfession()==21)OR(Object.GetProfession()==25))", "Guard", -1)
		if Guard > 0 then
			for i=0,Guard-1 do
				if GetCurrentMeasureID("Guard"..i) ~= 2830 then
					if GetCurrentMeasurePriority("Guard"..i) <= 50 then
						CopyAlias("Guard"..i, "DistGuard"..Counter)
						Counter = Counter + 1
						SetData("Counter", Counter)
						SendCommandNoWait("Guard"..i, "BeDistracted")
					end
				end
			end
		end	
		PlayAnimation("", "dance_female_1")
		
	end
	
	StopMeasure()
	
end

-- -----------------------
-- BeDistracted
-- -----------------------
function BeDistracted()
	
	SetState("", STATE_NPC, true)
	SetState("", STATE_SCANNING, false)
	
	f_MoveTo("", "Owner", GL_MOVESPEED_RUN,200)
	
	-- The first guard will go directly to the cocotte
	if not HasData("FirstGuard") then
		SetData("FirstGuard", 1)
		-- ai_StartInteraction("", "Owner", 500, 128)
		-- chr_MultiAnim("", "kiss_male", "Owner", "kiss_female", 128)
	end
	
	local random = 0
	while true do
		random = Rand(5)
		if random == 0 then
			PlayAnimation("", "laud_02")
		elseif random == 1 then
			PlayAnimation("", "nod")
		elseif random == 2 then
			PlayAnimation("", "follow_me")
		elseif random == 3 then
			PlayAnimation("", "proposal_male")
		elseif random == 4 then
			PlayAnimation("", "attack_them")
		end
	end
	
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
		SetProcessProgress("",CurrentTime*10)
		Sleep(3)
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	ResetProcessProgress("")
	
	if HasData("Counter") then
		local Counter = GetData("Counter")
		for i=0, Counter do
			if AliasExists("DistGuard"..i) then
				SetState("DistGuard"..i, STATE_NPC, false)
				SetState("DistGuard"..i, STATE_SCANNING, true)
			end
		end
	end
end

