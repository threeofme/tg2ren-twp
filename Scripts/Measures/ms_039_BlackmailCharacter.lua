-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_039_BlackmailCharacter"
----
----	with this measure the player character can blackmail his opponents, if
----	he hold at least three evidences
----
-------------------------------------------------------------------------------


function Run()

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand
	local ActionDistance = 80
	--how much favor from destination to owner is decreased
	local ModifyFavor = 10
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	-- check for evidences against the destination
	local Sum = GetEvidenceValues("", "Destination")
	if(Sum < 12) then
		feedback_MessageCharacter("Owner",
			"@L_INTRIGUE_039_BLACKMAILCHARACTER_NO_EVIDENCE_HEAD_+0",
			"@L_INTRIGUE_039_BLACKMAILCHARACTER_NO_EVIDENCE_BODY_+0", GetID("Destination"), Sum)
		--TODO return
	end
	
	-- check if the owner has RattleTheChains impact
	local Chain_factor = 1
	if GetImpactValue("","RattleTheChains")==1 then
		Chain_factor = 2
	end
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	-- check if the destination has BeVenerability impact
	if GetImpactValue("Destination","BeVenerability")==1 then
		MsgQuick("", "@L_PRIVILEGES_121_BEVENERABILITY_FAILURES_+0", GetID("Destination"))
		StopMeasure()
	end	

	CommitAction("blackmail","Owner","Destination","Destination")
	
	-- Discuss the conditions
	PlayAnimationNoWait("", "talk")
	PlayAnimation("Destination", "propel")
	Sleep(1)

	RemoveEvidences("", "Destination")

	-- add Blackmailed impact with dynasty id of blackmailer (used for votings and trials)
	local DynId = GetDynastyID("")
	AddImpact("Destination", "BlackmailVictim", DynId, duration)
	local SimID = GetID("Destination")
	AddImpact("", "BlackmailActor", SimID, duration)
	
	-- grant privileges (own city only)
	GetHomeBuilding("", "MyHome")
	GetSettlement("MyHome", "MyCity")
	GetHomeBuilding("Destination", "VictimHome")  
	GetSettlement("VictimHome", "VictimCity")
	if GetID("MyCity") == GetID("VictimCity") then
		local PrivCount, Privileges = dyn_GetPrivilegeImpactsOfSim("Destination")
		LogMessage("AITWP::Blackmail victim has "..PrivCount.." privileges")
		for i=1, PrivCount do
			LogMessage("AITWP::Blackmail adding impact: BM"..Privileges[i])
			AddImpact("", "BM"..Privileges[i], 1, duration)
		end
	end
	
	-- Decrease the blackmailed favor to you
	ModifyFavor = ModifyFavor / Chain_factor
	chr_ModifyFavor("Destination","",-ModifyFavor)
	
	----	Das Diplomatieverhältnis zwischen den beiden Dynastien wird 
	----	für 8h auf "Blutbande" gestellt.
	
	--force dynasty relations to alliance
	DynastySetMinDiplomacyState("", "Destination", DIP_ALLIANCE, GetID(""), duration)
	DynastyForceCalcDiplomacy("")
	DynastyForceCalcDiplomacy("Destination")
	
	SetMeasureRepeat(TimeOut)
	
	MsgNewsNoWait("","Destination","","intrigue",-1,
		"@L_INTRIGUE_039_BLACKMAILCHARACTER_SUCCESS_ACTOR_HEAD_+0",
		"@L_INTRIGUE_039_BLACKMAILCHARACTER_SUCCESS_ACTOR_BODY_+0", GetID("Destination"))
	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_INTRIGUE_039_BLACKMAILCHARACTER_SUCCESS_VICTIM_HEAD_+0",
		"@L_INTRIGUE_039_BLACKMAILCHARACTER_SUCCESS_VICTIM_BODY_+0", GetID(""))
	
	Sleep(1)
	
	-- Add xp
	xp_BlackmailCharacter("", GetData("BaseXP"), Sum)
	
	StopAction("blackmail", "Owner")
	
	-- The blackmailed wants to get away
	GetFleePosition("Destination", "Owner", 300, "Away")
	f_MoveTo("Destination","Away")

	StopMeasure()
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("Destination") then
		StopAnimation("Destination")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

