function Run()

	MeasureSetNotRestartable()
	Sleep(0.5)
	
	while true do

		SquadSetReady("Destination", 0, false)
		if SquadGetMeetingPlace("Destination", "MeetingPlace") then
			if not f_MoveTo("", "MeetingPlace") then
				return
			end
			SquadSetReady("Destination", Member, true)
			SquadWaitSim("")
		else
			Sleep(2)
		end
	end
end

function CleanUp()
	SquadSetReady("Destination", 0, false)
end

