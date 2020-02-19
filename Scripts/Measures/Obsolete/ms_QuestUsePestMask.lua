function Run()
	local targetX = -40168
	local targetZ = 15797
	local tolleranz = 1000
	local found = false

	GetPosition("","KappellePos")
	local tx,ty,tz = PositionGetVector("KappellePos")

	if ((targetX > (tx - tolleranz)) and (targetX < (tx + tolleranz))) then
		if ((targetZ > (tz - tolleranz)) and (targetZ < (tz + tolleranz))) then
			found = true
			MsgQuestIntro("hanse_2_OUTRO")
			CampaignExit(true)
		end
	end

	MsgQuick("#Player", "@L_MEASURE_QuestUsePestMask_FAILURE_+0")
	StopMeasure("")
end

function CleanUp()
	
end


