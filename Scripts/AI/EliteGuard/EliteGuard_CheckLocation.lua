function Weight()

	local Time = math.mod(GetGametime(),24)
	
	if Time < 5 or Time > 22 then
		if Rand(4) > 0 then
			return 0
		end
	end
	
	return 100
end

function Execute()
	SquadCreate("SIM", "SquadCheckLocation", nil, "CheckLocation")
end

