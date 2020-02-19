function Init()
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
	SetStateImpact("no_idle")

	StopMeasure()
end

function Run()

	if not GetInsideBuilding("", "Inside") then
		return
	end
	
	if not GetOutdoorMovePosition("", "Inside", "EvacuatePos") then
		return
	end

	local TimeOut = GetGametime() + 0.75
	while true do
		if not GetInsideBuilding("", "Inside") then
			break
		end
		
		if GetGametime() > TimeOut then
			SimBeamMeUp("", "EvacuatePos", false) -- false added
			break
		end
		
		if not f_ExitCurrentBuilding("") then 
			Sleep(2)
		else
			Sleep(0.5)
		end
	end
end
