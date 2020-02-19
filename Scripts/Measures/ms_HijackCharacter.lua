function Run()
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	--debug
	--TimeOut = 2
	local DistanceToJoinBattle = gameplayformulas_CalcSightRange("Destination")
	
	
	
	if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,DistanceToJoinBattle) then
		StopMeasure() 
		return
	end

	local ThiefFilter = "__F((Object.GetObjectsByRadius(Sim)== 3000)AND (Object.BelongsToMe())AND(Object.GetProfession()==26))"
	local NumThieves = Find("Destination",ThiefFilter,"Thief", -1)
	
	for i=0,NumThieves-1 do
		if SquadGet("Thief"..i, "Squad") then
			SquadAddMember("Squad", -1, "")
			return
		end
	end
	
	SquadCreate("", "SquadHijackCharacter", "Destination", "SquadHijackMember", "SquadHijackMember")
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

