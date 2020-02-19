-------------------------------------------------------------------------------
----
----	OVERVIEW "state_child.lua"
----
----	This state is set while a sim is a child
----
-------------------------------------------------------------------------------

-- -----------------------
-- Init
-- -----------------------
function Init()
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	StopMeasure()
end

-- -----------------------
-- Run
-- -----------------------
function Run()
	while true do
		Sleep(100)
	end
end

