function Run()
	SimSetProduceItemID("", -1, -1)
	SetState("", STATE_WORKING, false)
	if GetState("", STATE_ROBBERMEASURE) then
		SetState("", STATE_ROBBERMEASURE, false)
	end
	if not GetState("", STATE_FIGHTING) then
		GetOutdoorMovePosition("","destination","MovePos")
		f_MoveTo("","MovePos",GL_MOVESPEED_RUN)
	
		Sleep(100000)
	end
end
