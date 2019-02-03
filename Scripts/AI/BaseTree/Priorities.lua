function Weight()
	if not ReadyToRepeat("dynasty", "AI_Priorities") then
		return 0
	end
	return 50
end

function Execute()
	aitwp_Log("Calculating PRIORITIES", "dynasty")
	SetRepeatTimer("dynasty", "AI_Priorities", 24)
	aitwp_CalculatePriorities("dynasty")
--	CreateScriptcall("CalcAIPriorities", 1, "Library/aitwp.lua", "CalculatePriorities", "dynasty")
end
