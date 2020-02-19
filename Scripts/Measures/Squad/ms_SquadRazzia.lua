function Run()

	SquadSetMeetingPlace("", "Destination")
	if not SquadGetLeader("", "Leader") then
		return
	end
	
	if not GetDynasty("Leader", "dynasty") then
		return
	end
	
	local TimeOut
	if DynastyIsAI("Leader") then
		TimeOut = GetGametime() + 6
	end
	
	if not AliasExists("Destination") then
		return
	end
	
	SetProperty("","Victim",GetID("Destination"))
	while (true) do
	
		if TimeOut and TimeOut<GetGametime() then
			break
		end
		Sleep(2)
	end
end

function CleanUp()
	SquadDestroy("")
end

