-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_ThreatCharacter"
----
----	With this measure the player can threat another dynasty with evidences
----	to avoid the dynasty from doing bad actions against yourselfe
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------

function Run()

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	local EvidenceValueSum = GetEvidenceValues("", "Destination")
	
	-- The distance between both sims to interact with each other
	local InteractionDistance = 128
	
	-- Go to the sim
	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		StopMeasure()
		return
	end
	local DynID = GetDynastyID("Destination")
	local rhetoric = GetSkillValue("", RHETORIC)
	
	-- set the rhetoric against the duration here
	SetRepeatTimer("", GetMeasureRepeatName2("ThreatCharacter"), TimeOut)
	MsgSay("", talk_ThreatCharacter(rhetoric));
	PlayAnimation("", "threat")
	
	-- Remove the evidences here so that the player cannot cancel the measure when he recognizes a possible failure and keep the evidences this way
	RemoveEvidences("", "Destination")
	
	-- The duration of the effect of the treat
	local DurationHours = 0
	
	if EvidenceValueSum < GL_EVIDENCE_SUM_LOW_THREAT_SUCCESS then
		MsgSay("Destination", "@L_INTRIGUE_THREAT_CHARACTER_FAILURE");
		PlayAnimation("Destination", "cheer_01")

		MsgQuick("", "@L_INTRIGUE_THREAT_CHARACTER_FAILURES_+0", DynID)

		StopMeasure()
		return
	elseif EvidenceValueSum < GL_EVIDENCE_SUM_MIDDLE_THREAT_SUCCESS then
		DurationHours = GL_DURATION_OF_THREAT_EFFECT_LOW_SUCCESS
	elseif EvidenceValueSum < GL_EVIDENCE_SUM_HIGH_THREAT_SUCCESS then
		DurationHours = GL_DURATION_OF_THREAT_EFFECT
	else
		DurationHours = GL_DURATION_OF_THREAT_EFFECT_HIGH_SUCCESS
	end
	
	PlayAnimationNoWait("Destination", "devotion")
	
	if IsDynastySim("Destination") then
		
		if DynID ~= -1 then
		
			GetDynasty("", "Dyn")
			dyn_BlockEvilMeasures("Dyn", DynID, DurationHours)
			chr_GainXP("",GetData("BaseXP"))
			MsgNewsNoWait("","Destination","","intrigue",-1,
				"@L_INTRIGUE_THREAT_CHARACTER_MSG_SUCCESS_HEAD", 
				"@L_INTRIGUE_THREAT_CHARACTER_MSG_SUCCESS_BODY", DynID, Gametime2Total(GetGametime()+DurationHours))
			MsgNewsNoWait("Destination","","","intrigue",-1,
				"@L_INTRIGUE_THREAT_CHARACTER_MSG_THREATENED_HEAD", 
				"@L_INTRIGUE_THREAT_CHARACTER_MSG_THREATENED_BODY", GetDynastyID(""), Gametime2Total(GetGametime()+DurationHours))
			
			CreateScriptcall("ThreatCharacter", DurationHours, "Measures/ms_ThreatCharacter.lua", "ThreatOver", "", "Destination")
			
		end
	end
	StopMeasure()
end

-- -----------------------
-- ThreatOver
-- -----------------------
function ThreatOver()

	local FavorLossPercent = GL_PERCENT_FAVOR_LOSS_AFTER_THREAT
	local CurrentFavor = GetFavorToSim("Destination", "")
	local Factor = (100 - FavorLossPercent) * 0.01
	SetFavorToSim("Destination", "", Factor * CurrentFavor)

	MsgNewsNoWait("","Destination","","intrigue",-1,
		"@L_INTRIGUE_THREAT_CHARACTER_MSG_OVERACTIVE_HEAD", 
		"@L_INTRIGUE_THREAT_CHARACTER_MSG_OVERACTIVE_BODY", GetID("Destination"), FavorLossPercent)

	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_INTRIGUE_THREAT_CHARACTER_MSG_OVERPASSIV_HEAD", 
		"@L_INTRIGUE_THREAT_CHARACTER_MSG_OVERPASSIV_BODY", GetID(""))
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+4",Gametime2Total(mdata_GetDuration(MeasureID)))
end

