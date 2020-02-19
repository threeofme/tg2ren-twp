function Run()
	local	Time
	if HasData("Time") then
		Time = GetData("Time")
	else
		if IsDynastySim("") then
			return
		end
		Time = 0.5
	end
	
	Time = Gametime2Realtime(Time)
	
	local SleepTime
	while Time>0 do
		SleepTime= math.min(5, Time)
		Sleep(SleepTime)
		Time = Time - SleepTime
	end
end

function CleanUp()
	SimResetBehavior("")
end

