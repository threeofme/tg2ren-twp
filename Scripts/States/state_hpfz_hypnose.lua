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
	MeasureRun("", "", "HPFZhypnose" ,true)
	while GetImpactValue("", "pendel") > 0 do
		Sleep(6)
	end
end

function CleanUp()
	MoveSetActivity("","")
end
