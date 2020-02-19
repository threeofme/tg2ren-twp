-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_231_MakeACompliment"
----
----	with this measure the player can make a compliment to another sim
----
----
-------------------------------------------------------------------------------

function Run()
	if (GetState("", STATE_CUTSCENE)) then
		SetData("FromCutscene",1)
		ms_231_makeacompliment_Cutscene()
	else
		SetData("FromCutscene",0)
		ms_231_makeacompliment_Normal()
	end
end

function Normal()
	if not AliasExists("Destination") then
		return
	end
	
	local officetime = math.mod(GetGametime(),24)
	if SimGetOfficeLevel("Destination")>=1 then
		if officetime > 16.5 and officetime <= 17 then
		StopMeasure()
		end
	end
	
	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	-- The minimum favor for this action to success
	local TitleDifference = (GetNobilityTitle("Destination") - GetNobilityTitle(""))*2
	local RhetoricSkill = (GetSkillValue("", RHETORIC))*2
	local MinimumFavor = 40 +TitleDifference - RhetoricSkill
	local FavorWon = 5 + (RhetoricSkill/2)
	local FavorLoss = -10 - TitleDifference
	if FavorLoss > -5 then
		FavorLoss = -5
	end
	
	local FlirtBonus = GetImpactValue("", 52)		-- 52 = FlirtProfi
	FavorWon = FavorWon + FavorWon * FlirtBonus * 0.01
		
	-- The action number for the courting
	local CourtingActionNumber = 1

	-- The distance between both sims to interact with each other
	local InteractionDistance=128

	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		StopMeasure()
		return
	end	
	
	SetAvoidanceGroup("", "Destination")
	MoveSetActivity("", "converse")
	MoveSetActivity("Destination", "converse")
	
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","destination")
	CutsceneCameraCreate("cutscene","")			
	
	-- Actually speak out the compliment
	camera_CutscenePlayerLock("cutscene", "")
	PlayAnimationNoWait("", "talk")
	MsgSay("", chr_MakeACompliment(SimGetGender(""), GetSkillValue("", RHETORIC)))
	
	local WasCourtLover = 0
	chr_BlockSocialMeasures("")
	
	-------------------------
	------ Court Lover ------
	-------------------------
	if SimGetCourtLover("", "CourtLover") then
		if GetID("CourtLover")==GetID("Destination") then
		
			WasCourtLover = 1
			
			local ModifyFavor = FavorWon
		
			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber)
			if (EnoughVariation == false) then
				
				camera_CutscenePlayerLock("cutscene", "Destination")
				
				local DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
				Sleep(DestinationAnimationLength * 0.4)
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				
				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)))
				Sleep(DestinationAnimationLength * 0.2)
				
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
				MsgSay("Destination", chr_AnswerCourtingMeasure("COMPLIMENT", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress))
				
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
	
		local IsMale = (SimGetGender("") == GL_GENDER_MALE)
		if (GetFavorToSim("Destination", "") < MinimumFavor) then
			
			-- Set the favor loss prior to the animations so that the player cannot cancel the measure and try it instantly again
			chr_ModifyFavor("Destination", "", FavorLoss)
			SetRepeatTimer("", GetMeasureRepeatName2("MakeACompliment"), TimeUntilRepeat)
			if (IsMale) then				
				camera_CutsceneBothLock("cutscene", "Destination")
				PlayAnimationNoWait("", "got_a_slap")
				PlayAnimationNoWait("Destination", "give_a_slap")
				chr_AlignExact("", "Destination", InteractionDistance)
			else
				camera_CutscenePlayerLock("cutscene", "Destination")
				PlayAnimationNoWait("Destination", "cheer_01")
			end
			MsgSay("Destination", chr_AnswerCourtingMeasure("COMPLIMENT", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), -10))
			
		else
		
			if SimGetSpouse("Destination", "Spouse") then
				if (GetID("Spouse")==GetID("")) then
					AddImpact("","LoveLevel",3,24) -- add some love for the next 24 hours
					AddImpact("Destination","LoveLevel",3,24)
					if GetImpactValue("Destination","LoveLevel")>=10 then
						MsgNewsNoWait("","Destination","","schedule",-1,
								"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_HEAD_+0",
								"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_BODY_+0", GetID("Destination"))
					end
				end
			end
			
			camera_CutscenePlayerLock("cutscene", "Destination")
			SetRepeatTimer("", GetMeasureRepeatName2("MakeACompliment"), TimeUntilRepeat)
			if (IsMale) then
				PlayAnimationNoWait("Destination", "giggle")
			else
				PlayAnimationNoWait("Destination", "bow")
			end
			MsgSay("Destination", chr_AnswerCourtingMeasure("COMPLIMENT", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 10))			
			
			-- Set the favor won after the animation so that the player will not be able to cancel the measure if he recognizes the success in order to save time (cheat)
			chr_ModifyFavor("Destination", "", FavorWon)
			
		end
			
	end
end



function Cutscene()
	if not AliasExists("Destination") then
		return
	end
	
	if SimGetCutscene("","cutscene") then
		CutsceneSetMeasureLockTime("cutscene", 3.0)
	end
	
	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	-- The minimum favor for this action to success
	local TitleDifference = (GetNobilityTitle("Destination") - GetNobilityTitle(""))*2
	local RhetoricSkill = (GetSkillValue("", RHETORIC))*2
	local MinimumFavor = 40 +TitleDifference - RhetoricSkill
	local FavorWon = 5 + (RhetoricSkill/2)
	local FavorLoss = -10 - TitleDifference
	if FavorLoss > -5 then
		FavorLoss = -5
	end
	local FlirtBonus = GetImpactValue("", 52)		-- 52 = FlirtProfi
	FavorWon = FavorWon + FavorWon * FlirtBonus * 0.01
	
	-- The action number for the courting
	local CourtingActionNumber = 1

	-- The distance between both sims to interact with each other
	local InteractionDistance=128

--	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
--		MsgQuick("", "@L_GENERAL_MEASURES_FAILURES_+0", GetID("Destination"), GetID(""))
--		return
--	end	
	
	-- Actually speak out the compliment
	
	local WasCourtLover = 0
	
	--SLeep because of the "Ok i do it Soeech of your char"
	Sleep(1)
	
	-------------------------
	------ Court Lover ------
	-------------------------
	if SimGetCourtLover("", "CourtLover") then
		if GetID("CourtLover")== GetID("Destination") then
		
			WasCourtLover = 1
			local ModifyFavor = FavorWon
		
			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber)
			if (EnoughVariation == false) then
				
				-- camera_CutscenePlayerLock("cutscene", "Destination")
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				
				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)))
				
			else
				
				if (CourtingProgress < -5) then
					ModifyFavor = FavorLoss
				elseif (CourtingProgress < 1) then
					ModifyFavor = FavorLoss
				end
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)	
				MsgSay("Destination", chr_AnswerCourtingMeasure("COMPLIMENT", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress))			
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
	
		local IsMale = (SimGetGender("") == GL_GENDER_MALE)
		if (GetFavorToSim("Destination", "") < MinimumFavor) then
			
			-- Set the repeat timer and the favor loss prior to the animations so that the player cannot cancel the measure and try it instantly again
			SetRepeatTimer("", GetMeasureRepeatName2("MakeACompliment"), TimeUntilRepeat)
			
			chr_ModifyFavor("Destination", "", FavorLoss)
			feedback_OverheadComment("Destination","@L$S[2006] %1n", false, false, FavorLoss)
			
			MsgSay("Destination", chr_AnswerCourtingMeasure("COMPLIMENT", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), -10))
		else
			
			if SimGetSpouse("Destination", "Spouse") then
				if (GetID("Spouse")==GetID("")) then
					AddImpact("","LoveLevel",3,24) -- add some love for the next 24 hours
					AddImpact("Destination","LoveLevel",3,24)
					if GetImpactValue("Destination","LoveLevel")>=10 then
						MsgNewsNoWait("","Destination","","schedule",-1,
								"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_HEAD_+0",
								"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_BODY_+0", GetID("Destination"))
					end
				end
			end
			
			-- Set the repeat timer and the favor won after the animation so that the player will not be able to cancel the measure if he recognizes the success in order to save time (cheat)
			SetRepeatTimer("", GetMeasureRepeatName2("MakeACompliment"), TimeUntilRepeat)
			chr_ModifyFavor("Destination", "", FavorWon)
			feedback_OverheadComment("Destination","@L$S[2007] %1n", false, false, FavorWon)
			
			MsgSay("Destination", chr_AnswerCourtingMeasure("COMPLIMENT", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 10))			
		end
	end
	
	if SimGetCutscene("","cutscene") then
		CutsceneCallUnscheduled("cutscene", "UpdatePanel")
		Sleep(0.1)
	else
		return
	end	
		
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	
	if (GetData("FromCutscene") == 0) then
		DestroyCutscene("cutscene")
		ReleaseAvoidanceGroup("")
		MoveSetActivity("")
		StopAnimation("")
		
		if AliasExists("Destination") then
			MoveSetActivity("Destination")
			SimLock("Destination", 0.4)
		end
	end

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

