function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_enter")
	SetStateImpact("no_measure_attach")
	SetStateImpact("NoCameraJump")
end

function Run()
--	if not FindNearestBuilding("", GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_DUELPLACE, -1, false, "InvisContainer") then
--		StopMeasure()
--	end

--	SimBeamMeUp("","InvisContainer",false)
	SetInvisible("", true)
	AddImpact("", "Hidden", 1 , -1)
	while true do
		Sleep(Rand(15)+2)
	end
	SetInvisible("", false)
	RemoveImpact("","Hidden")
	
end

function CleanUp()
	SetInvisible("", false)
	RemoveImpact("","Hidden")
end

