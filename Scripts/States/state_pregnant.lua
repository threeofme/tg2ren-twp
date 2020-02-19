-------------------------------------------------------------------------------
----
----	OVERVIEW "state_pregnant.lua"
----
----	This state is set while a sim is pregnant
----
-------------------------------------------------------------------------------

-- -----------------------
-- Init
-- -----------------------

function Init()
	SetStateImpact("no_charge")
	SetStateImpact("no_arrestable")
	SetStateImpact("no_attackable")
	SetStateImpact("no_cancel_button")
end

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	if not GetInsideBuilding("", "Residence") then
		SetState("", STATE_PREGNANT, false)
		return
    	end	

	StopAllAnimations("")

	if not GetLocatorByName("Residence", "Cohabit2", "CohabitPos2") then
		return false
	end
	
	local MaxProgress = 520
	SetProcessMaxProgress("",MaxProgress)
	SetProcessProgress("",0)
	f_BeginUseLocator("", "CohabitPos2", GL_STANCE_LAY)
	PlayAnimation("","sickinbed_idle_in")
	LoopAnimation("","sickinbed_idle_01",5)
	PlayAnimation("","sickinbed_idle_out")
	StopAllAnimations("")
	f_EndUseLocator("", "CohabitPos2", GL_STANCE_STAND)
	local SleepTime = 0
	
	while SleepTime < MaxProgress do
		Sleep(5)
		SleepTime = SleepTime + 5
		SetProcessProgress("",SleepTime)
	end
	ResetProcessProgress("")
	SimGetSpouse("", "Father")
	
	MeasureCreate("Measure")
	
	if( HasProperty("","ForceChildGender") )then
		chr_CreateChild("Residence", "", "Father", 0, "NewBorn", GetProperty("","ForceChildGender"))
		RemoveProperty("","ForceChildGender")
		SimSetFirstname("NewBorn", GetProperty("","ForceChildName"))
		RemoveProperty("","ForceChildName")
		MeasureAddAlias("Measure","SetName","", false)
	else
		chr_CreateChild("Residence", "", "Father", 0, "NewBorn")	
	end
	
	MeasureStart("Measure", "NewBorn", "", "SetChildName")	
	SetData("GetUp",1)
	gameplayformulas_StartHighPriorMusic(MUSIC_BIRTH)
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	ResetProcessProgress("")
end