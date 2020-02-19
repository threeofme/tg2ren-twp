function Run()
end


function OnLevelUp()
	-- SetState("", STATE_MOVING_BUILDING, true)
end


function Setup()
    
end


function PingHour()
	if not GetState("", STATE_MOVING_BUILDING) and not GetState("", STATE_BUILDING) and not GetState("", STATE_LEVELINGUP) then
		SetState("", STATE_MOVING_BUILDING, true)
	end
	if not GetState("", STATE_GLOBAL_EVENT) then
		SetState("", STATE_GLOBAL_EVENT, true)
	end
end
