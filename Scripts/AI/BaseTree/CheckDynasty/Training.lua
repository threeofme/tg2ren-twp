function Weight()

	if SimGetAge("SIM") < 16 then
		return 0
	end
	
	if not f_SimIsValid("SIM") then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "AI_Training") then
		return 0
	end
	
	if DynastyIsShadow("SIM") then
		if SimGetOfficeLevel("SIM") < 0 then
			return 0
		end
	end
	
	if Rand(2) == 0 then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_Training", 2)
end