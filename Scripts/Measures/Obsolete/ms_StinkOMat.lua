function Run()
	CommitAction("stinkbomb", "", "")
	
	local	RunTime		= 1
	local	Duration	= Gametime2Realtime(RunTime)
	SetProperty("","IsStinkBomb",1)
	SetState("",STATE_CONTAMINATED,true)
	Sleep(Duration)
end

function CleanUp()
	SetState("",STATE_CONTAMINATED,false)
	StopAction("stinkbomb", "")
	-- finally remove the

	if IsTypeExact("", "cl_GuildObject") then
		InternalDie("")
	end
end
