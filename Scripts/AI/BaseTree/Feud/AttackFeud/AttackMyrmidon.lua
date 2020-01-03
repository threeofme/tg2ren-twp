function Weight()
	if not dyn_GetIdleMyrmidon("dynasty", "MYRM") then
		return 0
	end
	return aitwp_GetAgressiveness("dynasty")
end

function Execute()
end
