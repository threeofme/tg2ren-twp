function Init()
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
	SetStateImpact("no_attackable")
	SetState("", STATE_HIDDEN, false)
end

function Run()
	
	while true do
		PlaySound3DVariation("","Animals/Horse/whinny",1)
		Sleep(20)
	end
end

function CleanUp()
	
	SetState("", STATE_RIDING, false)
	PlaySound3DVariation("","Animals/Horse/snort",1)
end

