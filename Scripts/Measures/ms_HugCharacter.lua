-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_HugCharacter"
----
----	with this measure the player can bribe an other character to increase
----	the favour of his victim
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	-- The minimum favor for this action to success
	local TitleDifference = (GetNobilityTitle("Destination") - GetNobilityTitle(""))*2
	local CharismaSkill = (GetSkillValue("", CHARISMA))*2
	local MinimumFavor = 55 + TitleDifference - CharismaSkill
	local FavorWon = 8 + (CharismaSkill/2)
	local FavorLoss = -10 - TitleDifference
	if FavorLoss > -5 then
		FavorLoss = -5
	end
	
	local FlirtBonus = GetImpactValue("", 52)		-- 52 = FlirtProfi
	FavorWon = FavorWon + FavorWon * FlirtBonus * 0.01
	
	-- The action number for the courting
	local CourtingActionNumber = 4
	
	-- The distance between both sims to interact with each other
	local InteractionDistance = 128
	
	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		MsgQuick("", "@L_GENERAL_MEASURES_HUGCHARACTER_FAILURES_+0", GetID("Destination"))
		StopMeasure()
		return
	end

	SetAvoidanceGroup("", "Destination")
	MoveSetActivity("", "converse")
	MoveSetActivity("Destination", "converse")
	
	feedback_OverheadActionName("Destination")
	Sleep(0.5)
	
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","destination")
	CutsceneCameraCreate("cutscene","")			
	camera_CutsceneBothLock("cutscene", "")	
	chr_MultiAnim("", "hug_male", "Destination", "hug_female", InteractionDistance, 0.7)
	
	local WasCourtLover = 0
	chr_BlockSocialMeasures("")
	
	-------------------------
	------ Court Lover ------
	-------------------------
	if (SimGetCourtLover("", "CourtLover")) then
		if GetID("CourtLover")==GetID("Destination") then
			
			WasCourtLover = 1
			local ModifyFavor = FavorWon
			
			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber)
			if (EnoughVariation == false) then
				
				camera_CutscenePlayerLock("cutscene", "Destination")
				DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
				Sleep(DestinationAnimationLength * 0.4)
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				
				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)))
				
			else
				
				if (CourtingProgress < -5) then
					camera_CutsceneBothLock("cutscene", "Destination")
					chr_MultiAnim("", "got_a_slap", "Destination", "give_a_slap", InteractionDistance, 0.4)
					ModifyFavor = FavorLoss
				elseif (CourtingProgress < 1) then
					camera_CutscenePlayerLock("cutscene", "Destination")
					chr_MultiAnim("", "talk", "Destination", "cheer_01", InteractionDistance, 0.4)
					ModifyFavor = FavorLoss
				else
					camera_CutscenePlayerLock("cutscene", "Destination")
				end
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				
				MsgSay("Destination", chr_AnswerCourtingMeasure("HUG", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress))
				
			end
			
			-- Add the archieved progress
			chr_ModifyFavor("Destination", "", ModifyFavor)
			SimAddCourtingProgress("")
			
		end
	end
	
	----------------------------
	------ No Court Lover ------
	----------------------------
	if (WasCourtLover==0) then
		
		local slap = false
		local outraged = false
		
		-- React negativ if the destination married or if the favor is not high enough
		if SimGetSpouse("Destination", "Spouse") then
			if (GetID("Spouse")~=GetID("")) then
				outraged = true
			else
				AddImpact("","LoveLevel",3,24) -- add some love for the next 24 hours
				AddImpact("Destination","LoveLevel",3,24)
				if GetImpactValue("Destination","LoveLevel")>=10 then
					MsgNewsNoWait("","Destination","","schedule",-1,
								"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_HEAD_+0",
								"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_BODY_+0", GetID("Destination"))
				end
			end
		elseif GetFavorToSim("Destination", "") < MinimumFavor then
			if Rand(20) > 14 then
				slap = true
			end
		elseif Rand(10) == 5 then
			outraged = true
		end
		
		camera_CutsceneBothLock("cutscene", "Destination")
		
		if slap then
			
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the defeat (cheat)
			chr_ModifyFavor("Destination", "", FavorLoss)
			
			chr_MultiAnim("", "got_a_slap", "Destination", "give_a_slap", InteractionDistance, 1.0, true)
			MsgSay("Destination", chr_SocialMeasureFailedBeforeStart(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC), "Slap"))
			
					
		elseif outraged then
			
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the defeat (cheat)
			chr_ModifyFavor("Destination", "", FavorLoss)
			
			chr_MultiAnim("", "devotion", "Destination", "propel", InteractionDistance, 1.0, true)
			MsgSay("Destination", chr_SocialMeasureFailedBeforeStart(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC), "Outraged"))
			
			
		else
			
			chr_MultiAnim("", "bow", "Destination", "curtsy", InteractionDistance, 1.0, true)
			--MsgSay("Destination", chr_SocialMeasureSucceeded(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC), "HUG"))
			MsgSay("Destination", chr_AnswerCourtingMeasure("HUG", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 6))
			
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the success in order to save time (cheat)
			chr_ModifyFavor("Destination", "", FavorWon)
			
		end
		
		SetMeasureRepeat(TimeUntilRepeat)
		
	end
	
	StopMeasure()
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	DestroyCutscene("cutscene")
	ReleaseAvoidanceGroup("")
	MoveSetActivity("")
	StopAnimation("")
	
	if AliasExists("Destination") then
		MoveSetActivity("Destination")
		SimLock("Destination", 0.25)
	end	
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

