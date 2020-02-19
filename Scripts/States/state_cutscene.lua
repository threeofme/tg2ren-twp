function Init()
	StopMeasure()
	SetStateImpact("no_idle")
	SetStateImpact("no_control")
	SetStateImpact("no_hire")
	SetStateImpact("no_fire")	
	SetStateImpact("no_enter")
	-- SetStateImpact("no_measure_attach")
	-- SetStateImpact("no_measure_start")
end

function Run()
	local	TimeOut = Gametime2Realtime(12)
	while TimeOut>0 do
		Sleep(10)
		TimeOut = TimeOut - 10
	end
end
