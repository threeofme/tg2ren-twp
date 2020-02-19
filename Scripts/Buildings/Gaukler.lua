function Run()
end

function OnLevelUp()
	bld_HandleOnLevelUp("")
end

function Setup()
	bld_HandleSetup("")
	-- create ambient animals
	if Rand(2)==0 then
		worldambient_CreateAnimal("Cat", "" ,1)
	else
		worldambient_CreateAnimal("Dog", "" ,1)
	end
end

function PingHour()
	
	if not GetState("", STATE_MOVING_BUILDING) and not GetState("", STATE_BUILDING) and not GetState("", STATE_LEVELINGUP) then
		SetState("", STATE_MOVING_BUILDING, true)
	end
	
	bld_HandlePingHour("")
end
