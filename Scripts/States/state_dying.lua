-------------------------------------------------------------------------------
----
----	OVERVIEW "state_dying"
----
----	With this state the player will go home for dying.
----
-------------------------------------------------------------------------------

-- -----------------------
-- init
-- -----------------------
function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_upgrades")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_charge")
	SetStateImpact("no_arrestable")
	SetStateImpact("no_action")	
	SetStateImpact("no_cancel_button")
	
	SetState("", STATE_FIGHTING, false);
	SetState("", STATE_HIJACKED, false);
	SetState("", STATE_CAPTURED, false);
	SetState("", STATE_IMPRISONED, false);
	SetState("", STATE_WORKING, false);

	StopMeasure()
end

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	-- Block the sim for further actions
	SetState("", STATE_LOCKED, true)
	SimSetBehavior("", "DoNothing")
	local DynastyID = GetID("dynasty")
	if DynastyID and GetAliasByID(DynastyID, "Dynasty") then
		if DynastyIsPlayer("Dynasty") then
			if HasProperty("", "WasDynastySim") then

				-- A dynasty sim is about to die
				if SimGetGender("") == GL_GENDER_MALE then
					feedback_MessageCharacter("", "@L_FAMILY_6_DEATH_MSG_NEAR_DEATH_HEAD", "@L_FAMILY_6_DEATH_MSG_NEAR_DEATH_BODY_MALE", GetID(""))
				else
					feedback_MessageCharacter("", "@L_FAMILY_6_DEATH_MSG_NEAR_DEATH_HEAD", "@L_FAMILY_6_DEATH_MSG_NEAR_DEATH_BODY_FEMALE", GetID(""))
				end
			
			else

				-- A worker from a player dynasty is about to die
				if SimGetGender("") == GL_GENDER_MALE then
					feedback_MessageCharacter("", "@L_FAMILY_6_DEATH_MSG_NEAR_DEATH_WORKER_HEAD", "@L_FAMILY_6_DEATH_MSG_NEAR_DEATH_WORKER_BODY_MALE", GetID(""))
				else
					feedback_MessageCharacter("", "@L_FAMILY_6_DEATH_MSG_NEAR_DEATH_WORKER_HEAD", "@L_FAMILY_6_DEATH_MSG_NEAR_DEATH_WORKER_BODY_FEMALE", GetID(""))
				end
				
			end
		end
	end
	
	-- Let the sim go home	
	SetProperty("", "SenilDecay", 1)
	if GetHomeBuilding("", "Home") then
		local	Tries=20
		for Tries=0,20 do
			if GetInsideBuildingID("")==GetID("Home") then
				break
			end
			f_MoveTo("", "Home")
			Sleep(1)
		end
	end
	
	-- Let the sim go to his bed if it is a dynasty sim
	if HasProperty("", "WasDynastySim") then
		if GetHomeBuilding("", "Home") then
			if GetLocatorByName("Home", "PreLayoutPos", "PreLayOutPos") then
				f_MoveTo("", "PreLayOutPos")
				CommitAction("dying","","")
				f_BeginUseLocatorNoWait("", "PreLayOutPos", GL_STANCE_LAY, false) 				
				Sleep(3)
				GfxMoveToPosition("", 40, 0, 0, 4, false)
			end
		end
	end	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	SetState("", STATE_DEAD, true)
end



