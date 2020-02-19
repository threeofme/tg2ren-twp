function Run()

	Sleep(0.5)
	MeasureSetNotRestartable()
	local	Member = GetData("Member")
	if not Member or Member==-1 then
		return
	end
		
	while true do

		SquadSetReady("Destination", Member, false)
		
		SquadGetLeader("Destination", "Leader")
		if not f_Follow("", "Leader",GL_MOVESPEED_RUN, 150, true) then
			return
		end
		f_FollowNoWait("", "Leader", GL_MOVESPEED_RUN, 150)
		SquadSetReady("Destination", Member, true)
		SquadWaitSim("")
	end
end

function CleanUp()
	local	Member = GetData("Member")
	Assert(Member~=nil, "no member defined")
	if Member then
		SetData("Member", -1)
		if Member>=0 then
			SquadSetReady("Destination", Member, false)
		end
	end
end

