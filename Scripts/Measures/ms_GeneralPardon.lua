-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_GeneralPardon"
----
----	With this measure the player can order a general pardon for a sim
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	if not f_MoveTo("", "Destination") then
		StopMeasure()
	end

end

