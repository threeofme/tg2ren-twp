function Weight()

	if not ReadyToRepeat("SIM", "AI_FavorAll") then
		return 0
	end
	
	-- a bit late for that now...
	if GetImpactValue("SIM", "OfficeTimer") < 4 then
		return 0
	end
	
	return 10
end

function Execute()
	SetRepeatTimer("SIM", "AI_FavorAll", 6)
end