function Run()
	GetScenario("scenario")
	if not HasProperty("scenario", "static") then
		local	TimeToSleep = Gametime2Realtime(1)
		local	Count
		
		while true do
			
			local currentRound = GetRound()
			if currentRound > 0 then
				if Rand(100)>75 then
					Count = GetData("#GuildEventCount")
					if (not Count) or Count<1 then
						if not GetState("", STATE_GUILD_EVENT) then
							SetState("", STATE_GUILD_EVENT, true)
						end
					end
				end
			end
	
			Sleep(TimeToSleep)
			
		end
	end
end
