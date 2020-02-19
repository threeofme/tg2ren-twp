function Run()
	local Distance = GetData("Distance")
	if not Distance then
		Distance = 2000
	end
	
	if GetFleePosition("Owner", "Actor", Rand(Distance/10)+Distance, "Away") then
		f_MoveTo("Owner", "Away", GL_MOVESPEED_RUN)
		AlignTo("Owner", "Actor")
	end
	Sleep(1)
end
