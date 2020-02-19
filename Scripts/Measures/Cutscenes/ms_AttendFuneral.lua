function Run()
	SimSetProduceItemID("", -1, -1)
	if GetState("", STATE_ROBBERMEASURE) then
		SetState("", STATE_ROBBERMEASURE, false)
	end
	f_MoveTo("", "destination", GL_MOVESPEED_RUN)
	f_Stroll("", 100, 1)
	
	Sleep(100000)
end

