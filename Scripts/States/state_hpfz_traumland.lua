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

	MoveStop("")
	StopAllAnimations("")		
	local ActivityTime = MoveSetActivity("","unconscious")
	Sleep(ActivityTime)
	local duration = 6
	SetData("Time",duration)
	local EndTime = GetGametime() + duration
	SetData("EndTime",EndTime)
	SetProcessMaxProgress("",duration*10)
	local CurrentTime = GetGametime()
		while GetGametime() < EndTime do
			CurrentTime = GetGametime()
			CurrentTime = EndTime - CurrentTime
			CurrentTime = duration - CurrentTime
			SetProcessProgress("",CurrentTime*10)
            PlaySound3DVariation("", "CharacterFX/snore", 1)
			Sleep(3)
		end
	ResetProcessProgress("")
	StopMeasure()
end

function CleanUp()
	ResetProcessProgress("")
	if not (GetState("", STATE_DEAD)) then
		local maxhealth = GetMaxHP("")
		local currenthealth = GetHP("")
		local targethealth = maxhealth * 0.11
		if (currenthealth < targethealth) then
			log_death(DestAlias, " is returning from dreams (state_hpfz_traumland)")
			ModifyHP("", targethealth-currenthealth)
		end				
		MoveSetActivity("","")
	    if SimGetGender("") == GL_GENDER_MALE then
		    PlaySound3DVariation("", "CharacterFX/gaehn/male_gaehn+0.ogg", 1)
	    else
		    PlaySound3DVariation("", "CharacterFX/gaehn/female_gaehn+0.ogg", 1)
        end
	end
end
