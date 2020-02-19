function Run()
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	local	Distance = Rand(400)+100
	if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN, Distance) then
		StopMeasure()
	end

	local DanegeldFilter	= "__F((Object.GetObjectsByRadius(Sim)== 1500)AND (Object.BelongsToMe())AND(Object.GetProfession()==17))"
	local NumRobbers = Find("Destination",DanegeldFilter,"Mercenaries", -1)
	
	for i=0,NumRobbers-1 do
		if SquadGet("Mercenaries"..i, "Squad") then
			SquadAddMember("Squad", -1, "")
			return
		end
	end
	
	SquadCreate("", "SquadDanegeld", "Destination", "SquadDanegeldMember", "SquadDanegeldMember")
end
