-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_FindCourtLover"
----
----	With this measure the court lover of the player sim is focused
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	SimGetCourtLover("", "CourtLover")
	HudSelect("CourtLover")
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
end

