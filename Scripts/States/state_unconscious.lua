function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_move")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")	
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")	
	SetStateImpact("no_cancel_button")
	
	SetState("", STATE_IDLE, false);
	SetState("", STATE_FIGHTING, false);
	SetState("", STATE_CAPTURED, false)
	StopMeasure()
end

function Run()
	-- do visual stuff
	MoveStop("")
	
	-- Try sample
	if SimGetGender("") == GL_GENDER_MALE then
		PlaySound3DVariation("", "CharacterFX/male_pain_long", 1)
	else
		PlaySound3DVariation("", "CharacterFX/female_pain_long", 1)
	end
	
	if IsType("", "Sim") then
		StopAllAnimations("")		
		--PlayAnimation("", "fight_die")
		local ActivityTime = MoveSetActivity("","unconscious")
		Sleep(ActivityTime)
		--Pause 3 hours gametime
--		local SleepTime = Gametime2Realtime(3)
--		Sleep(SleepTime)
		
		local duration = 3
		SetData("Time",duration)
		local EndTime = GetGametime() + duration
		SetData("EndTime",EndTime)
		SetProcessMaxProgress("",duration*10)
		--SendCommandNoWait("","Progress")
		local CurrentTime = GetGametime()
		while GetGametime() < EndTime do
			CurrentTime = GetGametime()
			CurrentTime = EndTime - CurrentTime
			CurrentTime = duration - CurrentTime
			SetProcessProgress("",CurrentTime*10)
			Sleep(4)
		end
		ResetProcessProgress("")	
		while GetImpactValue("","Hidden")~=0 do
			Sleep(3)
		end
		
	end
	
	StopMeasure()
end

function Progress()
	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime")
		local CurrentTime = GetGametime()
		CurrentTime = EndTime - CurrentTime
		CurrentTime = Time - CurrentTime
		SetProcessProgress("",CurrentTime*10)
		Sleep(4)
	end
end

function CleanUp()
	ResetProcessProgress("")
	if not (GetState("", STATE_DEAD)) then
		local maxhealth = GetMaxHP("")
		local currenthealth = GetHP("")
		local targethealth = maxhealth * 0.11
		if (currenthealth < targethealth) then
			log_death("", " has recovered consciousness (state_unconcious)")
			ModifyHP("", targethealth-currenthealth)
		end				
		--PlayAnimation("","crouch_up")
		MoveSetActivity("","")
	end
end


