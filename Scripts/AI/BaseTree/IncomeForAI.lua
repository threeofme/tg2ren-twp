function Weight()
	if not ReadyToRepeat("dynasty", "AI_Income") then
		return 0
	end
	return 60
end


function Execute()
	SetRepeatTimer("dynasty", "AI_Income", 5)
	CreateScriptcall("GiveAIMoney", 1, "Library/f.lua", "GiveMoney", "dynasty")
end

