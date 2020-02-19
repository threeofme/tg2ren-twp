function Run()

	SquadAddRandom("", 1, GL_PROFESSION_MYRMIDON)
	SquadAddRandom("", 2, GL_PROFESSION_THIEF)
	SquadAddRandom("", 2, 17)
	
	if not SquadGetMeetingPlace("Destination", "MeetingPlace") then
		-- calculate the meeting place
		if not SimGetWorkingPlace("", "Place") then
			if not SimGetHome("", "Place") then
				SetData("Error", 1)
				return
			end
		end
	
		if not GetOutdoorMovePosition("", "Place", "MeetingPlace") then
			SetData("Error", 2)
			return
		end

		SquadSetMeetingPlace("Destination", "MeetingPlace")
	end
	
	
	while (true) do
	
		local State = SquadGetState("")
		
		if (State==SQUAD_INITIALISING) then
			SquadWait("")
		elseif (State==SQUAD_EXECUTING) then
			
			-- move to attacking position
			SquadGetLeader("", "Leader")
			MeasureRun("Leader", "Destination", "FollowOnce")
			
			Sleep(0.5)
			while GetCurrentMeasureName("Leader")=="FollowOnce" do
				Sleep(1)
			end
		
			local Distance = GetDistance("Leader", "Destination")
			if Distance>=0 and Distance < 500 then
		
				MeasureRun("Leader", "Destination", "AttackEnemy")
				Sleep(0.5)
				while GetCurrentMeasureName("Leader")=="AttackEnemy" do
					Sleep(1)
				end
				
				while true do
					if GetState("Destination", STATE_UNCONSCIOUS) then
						SquadGetMember("", 2, "Member2")
						MeasureRun("Member2", "Destination", "rob")
						return
					end
		
					if not GetState("Leader", STATE_FIGHTING) then
						return
					end
					Sleep(1)
				end
			end
		end
	end
end

function CleanUp()
	SquadDestroy("")
end
