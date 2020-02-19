-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_031_GetCured"
----
----	with this measure, the player can cure his robbers
----
-------------------------------------------------------------------------------

function Run()
	SetState("", STATE_ROBBERMEASURE, false)
	SimResetBehavior("")
	local duration = 4
	local CurrentHP = GetHP("")
	local MaxHP = (GetMaxHP(""))*0.96
	local ToHeal = (MaxHP - CurrentHP)
	local HealPerTic = ToHeal / (duration * 12)
	local UseLocator = false

	SimGetWorkingPlace("","APlatz")
	local Offset = Rand(150)
	f_MoveTo("","APlatz",GL_MOVESPEED_RUN,(150+Offset))
	
	local CurrentTime = GetGametime()
	local EndTime = CurrentTime + duration
	local Time = MoveSetStance("",GL_STANCE_SITGROUND)
	Sleep(Time)
	while GetGametime()<EndTime do
		Sleep(5)
		if GetHP("") < MaxHP then
			ModifyHP("", HealPerTic,false)
		else
			break
		end
	end
	Time = MoveSetStance("",GL_STANCE_STAND)
	Sleep(Time)
end

function CleanUp()
	
end
