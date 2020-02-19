function Run()
	if not SquadGetLeader("", "Leader") then
		return
	end
	
	if not GetSettlement("Leader", "City") then
		return
	end
	
	local Level = CityGetCrimeRate("City")
	local MaxSize = 1.5 + Level / 25
	
	for i=1,MaxSize do
		SquadAddRandom("", i, GL_PROFESSION_ELITEGUARD)
	end
	
	while (true) do
		Sleep(10)
	end
end
