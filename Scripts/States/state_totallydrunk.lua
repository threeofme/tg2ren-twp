function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
	SetStateImpact("no_cancel_button")
	StopMeasure()
end

function Run()
	MeasureRun("","","TryToWalkHome",true)
	while GetImpactValue("","totallydrunk")>0 do
		Sleep(Rand(2)+5)
	end
end

function CleanUp()
	MoveSetActivity("","")
end

