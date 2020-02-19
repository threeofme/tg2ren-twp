function Run()

	if not AliasExists("Destination") then
		return
	end

	if not SquadGetLeader("", "Leader") then
		return
	end
	
	if not GetDynasty("Leader", "dynasty") then
		return
	end
	
	SetProperty("", "Phase", 0)
	SetProperty("", "VictimID", GetID("Destination"))
	
	local	Phase
	local TimeOut = GetGametime()+12

	while true do
		Phase = GetProperty("", "Phase")
		if Phase>=100 then
			break
		end
		
		if TimeOut<GetGametime() then
			break
		end
		Sleep(2)
	end

end

function CleanUp()
	SquadDestroy("")
end

