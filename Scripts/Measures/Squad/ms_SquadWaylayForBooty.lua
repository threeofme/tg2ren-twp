function Run() 

	SquadSetMeetingPlace("", "Destination")
	if not SquadGetLeader("", "Leader") then
		return
	end 
	
	if not GetDynasty("Leader", "dynasty") then
		return
	end

	local Target
	local Count
	while (true) do
		Sleep(4)
		Count = SquadGetMemberCount("", true)
		if Count==0 then
			StopMeasure()
		end
	end
end
	
function CleanUp()
	-- GfxDetachObject("Flag")
	SquadDestroy("")
end

