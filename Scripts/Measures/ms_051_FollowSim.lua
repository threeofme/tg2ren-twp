-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_051_FollowSim"
----
----	With this measure a sim will start following another sim
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	if DynastyGetDiplomacyState("", "Destination") ~= DIP_FOE then
		SetProperty("", "Follows", GetID("Destination"))
		if GetImpactValue("", "MoveSpeed")<1.25 then
			AddImpact("", "MoveSpeed", 1.25, 6)
		end
		while true do
			if GetDistance("", "Destination")<500 then
				f_Follow("", "Destination", GL_MOVESPEED_WALK, 150, true)
			else
				f_Follow("", "Destination", GL_MOVESPEED_RUN, 150, true)
			end
			Sleep(1.5)
		end		
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopFollow("")
end

