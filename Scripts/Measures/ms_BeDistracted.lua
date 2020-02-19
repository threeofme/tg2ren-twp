-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_BeDistracted"
----
----	With this measure the owner will be distracted by a cocotte
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	f_MoveTo("", "Destination", GL_MOVESPEED_RUN)
	
	PlayAnimation("", "talk")
	
end

