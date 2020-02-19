function Run()
	local targetX = 18333
	local targetZ = 11085
	local tolleranz = 2000
	local found = false
	
	GetPosition("","ShipPos")
	local tx,ty,tz = PositionGetVector("ShipPos")

	if (SimGetChildCount("#Player") < 2) then
		MsgQuick("#Player", "@L_MEASURE_QuestDiveForTreasure_FAILURE_+0")
		StopMeasure("")
	end

	if ((targetX > (tx - tolleranz)) and (targetX < (tx + tolleranz))) then
		if ((targetZ > (tz - tolleranz)) and (targetZ < (tz + tolleranz))) then
			found = true
			MsgQuestIntro("hanse_1_OUTRO")
			CampaignExit(true)
		end
	end

	MsgQuick("#Player", "@L_MEASURE_QuestDiveForTreasure_FAILURE_+1")
	StopMeasure("")
end

function CleanUp()
	
end


