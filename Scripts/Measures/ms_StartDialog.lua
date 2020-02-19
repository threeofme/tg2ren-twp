-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_StartDialog"
----
----	With this measure the player can start a dialog with another sim
----	or start a flirt with a court lover
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()	
	
	MeasureSetNotRestartable()
	-- case for talk need
	if not(AliasExists("Destination")) then
		return
	end
	
	if not ai_StartInteraction("", "Destination", 350, 100) then
		StopMeasure()
		return
	end
	
	-- Only a player should be able to start a quests
	if IsGUIDriven() and DynastyIsPlayer("") then
		if (QuestTalk("","Destination")) then
			StopMeasure()
			return
		end
	elseif GetState("Destination", STATE_NPC) then
		StopMeasure()
		return
	end
	
	SetAvoidanceGroup("", "Destination")
	
	PlayAnimationNoWait("", "talk")
	Sleep(1.0)
	PlayAnimation("Destination", "talk")
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	ReleaseAvoidanceGroup("")
	MoveSetActivity("")
	StopAnimation("")

	if(AliasExists("Destination")) then
		MoveSetActivity("Destination")
		StopAnimation("Destination")
	end
	
end

