-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_051_FollowMe"
----
----	With this measure the player can force another sim to follow him
----	or stop following him
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	-- Check if the sim is already following
	if HasProperty("Destination", "Follows") then
		
		-- Check if the sim is following me
		if GetID("") == GetProperty("Destination", "Follows") then
			SimStopMeasure("Destination")
		else
			-- The sim is following another sim
		end
		
	else
		AlignTo("", "Destination")
		Sleep(0.5)
		PlayAnimationNoWait("", "follow_me")
		
		if GetFavorToSim("Destination","") < 40 then
			PlayAnimationNoWait("Destination","shake_head")
			StopMeasure()
		end

		local label
		local Rhetoric = GetSkillValue("", RHETORIC)
		if (Rhetoric < 3) then
			label = "_WEAK_RHETORIC"
		elseif (Rhetoric < 6) then
			label = "_NORMAL_RHETORIC"
		else
			label = "_GOOD_RHETORIC"
		end	

		MsgSay("", "@L_GENERAL_MEASURES_051_FOLLOWME_STATEMENT"..label)
--		Sleep(1.0)

		MeasureRun("Destination", "", "FollowSim", true)
	end
	
end

