-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_057_KissCharacter"
----
----	with this measure the player can kiss a character of the other gender
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	local MeasureID = GetCurrentMeasureID("")
	-- The time in hours until the measure can be repeated
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)	
	
	-- The minimum favor for this action to success
	local TitleDifference = (GetNobilityTitle("Destination") - GetNobilityTitle(""))*2
	local EmpathySkill = GetSkillValue("", EMPATHY)*2
	local MinimumFavor = 60 + TitleDifference - EmpathySkill
	local FavorWon = 10 + (EmpathySkill * 0.5)
	local FavorLoss = -10 - TitleDifference
	if FavorLoss > -5 then
		FavorLoss = -5
	end
	
	local	time1 = 0
	local time2 = 0	
	
	local FlirtBonus = GetImpactValue("", 52)		-- 52 = FlirtProfi
	FavorWon = FavorWon + FavorWon * FlirtBonus * 0.01	
	
	-- The action number for the courting
	local CourtingActionNumber = 6
	
	-- The distance between both sims to interact with each other
	local InteractionDistance = 128

	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		StopMeasure()
		return
	end

	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","destination")
	CutsceneCameraCreate("cutscene","")			
	
	SetAvoidanceGroup("", "Destination")
	MoveSetActivity("", "converse")
	MoveSetActivity("Destination", "converse")
	
	camera_CutsceneBothLock("cutscene", "")
	
	chr_MultiAnim("", "kiss_male", "Destination", "kiss_female", InteractionDistance)
	
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
				
				time1 = PlayAnimationNoWait("Destination", "cheer_01")
				Sleep(time1 * 0.4)
				
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
				MsgSay("Destination", chr_AnswerCourtingMeasure("KISS", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress))
				
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
			chr_ModifyFavor("Destination","",FavorLoss)

			SetMeasureRepeat(TimeUntilRepeat)
			
			chr_MultiAnim("", "got_a_slap", "Destination", "give_a_slap", InteractionDistance, 1.0, true)
			MsgSay("Destination", chr_SocialMeasureFailedBeforeStart(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC), "Slap"))
					
		elseif outraged then
			
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the defeat (cheat)
			chr_ModifyFavor("Destination","",FavorLoss)
			SetMeasureRepeat(TimeUntilRepeat)
			
			chr_MultiAnim("", "devotion", "Destination", "propel", InteractionDistance, 1.0, true)
			MsgSay("Destination", chr_SocialMeasureFailedBeforeStart(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC), "Outraged"))
			
		else
			
			chr_MultiAnim("", "bow", "Destination", "curtsy", InteractionDistance, 1.0, true)
			MsgSay("Destination", chr_AnswerCourtingMeasure("KISS", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 6))
			
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the success in order to save time (cheat)
			chr_ModifyFavor("Destination","",FavorWon)
			SetMeasureRepeat(TimeUntilRepeat)
			
		end
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
		SimLock("Destination", 0.4)
	end	
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

