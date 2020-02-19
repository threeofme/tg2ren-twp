function Run()

	MoveStop("")
	GetFleePosition("Owner", "Actor", Rand(50)+150, "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)
	--ShowOverheadSymbol("", false, true, "Data", "*cry*")
	local	Favor = GetFavorToSim("", "Actor")
	Favor = (Favor - 60)/4
	

	local Value = Rand(2)
	if Value==0 then
		PlayAnimation("", "pray_standing")
	elseif Value==1 then
		MoveSetStance("",GL_STANCE_KNEEL)
		Sleep(6)
		PlayAnimation("", "knee_pray")
		MoveSetStance("",GL_STANCE_STAND)
		Sleep(6)
	end
	
	
end

function CleanUp()
	MoveSetStance("",GL_STANCE_STAND)
end


