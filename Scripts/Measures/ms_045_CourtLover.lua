-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_045_CourtLover"
----
----	with this measure the player can court a lover for his character
----
-------------------------------------------------------------------------------

-- -----------------------
-- AIInit
-- -----------------------
function AIInit()

	local	Selection
	local BestValue = -1
	local Partners = Find("", "__F((Object.GetObjectsFromCity(Sim))AND(Object.CanBeCourted())AND(Object.CanBeInterrupted(CourtLover)))","Partner", -1)

--	GetLocalPlayerDynasty("LocDyn")
	if Partners>0 then
		local Lauf
		local	Value
		local	Alias
		for Lauf=0,Partners-1 do
			Alias = "Partner"..Lauf

-- Hack damit player umworben wird			
-- if GetDynastyID(Alias) == GetDynastyID("LocDyn") then
-- 	Selection = Alias
-- end

			-- Impact 303 means wait for 4 hours
			if not GetDynasty(Alias, "DestDyn") or GetImpactValue("DestDyn", 303) == 0 then
				if GetFavorToSim(Alias, "")>=GL_COURT_LOVER_MINFAVOR  then
					Value = GetMoney(Alias) + SimGetMaxOfficeLevel(Alias)*1000 + math.mod(GetID(Alias), 31)
					
					local AgeDiff = SimGetAge(Alias) - SimGetAge("")
					if AgeDiff<0 then
						AgeDiff = -AgeDiff
					end
					
					if AgeDiff > 20 then
						Value = Value / 5
					elseif AgeDiff > 10 then
						Value = Value / 3
					elseif AgeDiff < 5 then
						Value = Value * 1.5
					end
					
					if not Selection or Value > BestValue then
						Selection = Alias
						BestValue = Value
					end
				end
			end
		end
	end
	
	if not Selection then
		return false
	end
		
	CopyAlias(Selection, "Destination")	
	return true
end

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	MeasureSetNotRestartable()
	if not AliasExists("Destination") then
		if not ms_045_courtlover_AIInit() then
			return
		end
	end
	
    if HasProperty("Destination","NoMarry") then    
        if GetProperty("Destination","NoMarryTime") < GetGametime() then -- if time is over, remove property
            RemoveProperty("Destination","NoMarryTime")
            RemoveProperty("Destination","NoMarry")
        elseif GetDynastyID("") == GetProperty("Destination","NoMarry") then -- if our dynasty recently fired the destination Sim, stop measure.
            MsgQuick("","@L_COURTLOVER_MSG_FAILED_QUICK")
            StopMeasure()
            return
        end
    end
	
	-- Calculate the difficulty which will be set as property to the destination and used in the following MsgBox
	-- There are four locations where this property will be removed:
	-- At the CleanUp() in this measure if it is canceled before the SetCourtLover()
	-- at the "BreakUp" measure
	-- at the "ArrangeLiaison" measure or
	-- at the "Marry" measure
	-- The reason why the property must live that long is that the xp points which are spent at the ArrangeLiaison- or Marry measue
	-- have to know the difficulty
	CalculateCourtingDifficulty("", "Destination")
	
	-- Display the court lover sheet
	SetProperty("", "LoverID", GetID("Destination"))
	if not (MsgBox("", 0, "CourtLover", 0, 0) == "O") then
		RemoveProperty("", "LoverID")
		StopMeasure()
		return
	end
	
	RemoveProperty("", "LoverID")
	
	local CharismaSkill = GetSkillValue("",CHARISMA)
	local RhetoricSkill = GetSkillValue("",RHETORIC)
	local TotalSkill = CharismaSkill + RhetoricSkill	
	
	local MinimumFavor = GL_COURT_LOVER_MINFAVOR - TotalSkill
	local InteractionDistance = 128
	local TimeUntilRepeat = 3
	
	if GetInsideBuilding("Destination","DestBuilding") then
		GetOutdoorMovePosition("","DestBuilding","MovePos")
		if not f_MoveTo("","MovePos",GL_MOVESPEED_RUN,800) then
			StopMeasure()
		end
		BlockChar("Destination")
		f_ExitCurrentBuilding("Destination")
		Sleep(1)
		f_MoveTo("Destination","Owner",GL_MOVESPEED_RUN,400)
	end
	
	if SimGetCourtingSim("Destination","blabla") then
		MsgQuick("","%1SN %2l",GetID("Destination"),"@L_FILTER_IS_COURTED")
		StopMeasure()
	end
	
	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		StopMeasure("")
	end
	
	-- Ask the player for allowance
	if DynastyIsPlayer("Destination") then
		local Allow = 0			
		if not IsOnlyPartyMember("Destination") then
			if IsPartyMember("Destination") then
				local result = MsgNews("Destination", "", "MB_YESNO", ms_045_courtlover_AIInitCourt, "default", 0.5, "@L_INTERFACE_DIALOG_TO_NEWS_HEADER", "@L_FAMILY_7_DYNCOURT_COURT_PARTY_MEMBER_BODY", GetID("Destination"), GetID(""))
				if result == "O" then
					DynastyRemoveMember("Destination")
					Allow = 1
				end
			else
				local result = MsgNews("Destination", "", "MB_YESNO", ms_045_courtlover_AIInitCourt, "default", 0.5, "@L_INTERFACE_DIALOG_TO_NEWS_HEADER", "@L_FAMILY_7_DYNCOURT_COURT_DYN_MEMBER_BODY", GetID("Destination"), GetID(""))
				if result == "O" then
					Allow = 1
				end
			end
		else
			-- This is the last party-member. Do not allow this otherwise the dynasty will be guideless				
			StopMeasure()
			return
		end
		
		-- If it was allowed by the player don´t do the whole animation thing
		if Allow == 1 then
			SetProperty("Destination","courted",1)
			SimSetCourtLover("", "Destination")
			StopMeasure()
			return
		else
			-- Dont ask this sim on and on again
			if GetDynasty("Destination", "DestDyn") then
				AddImpact("DestDyn", 303, 1, GL_AI_WAIT_FOR_COURTING_PLAYER)
				StopMeasure() 
				return  
			end
		end 
	end

	SetAvoidanceGroup("", "Destination")
	MoveSetActivity("", "converse")
	MoveSetActivity("Destination", "converse")

	feedback_OverheadActionName("Destination")

	-- get the gender of the owner
	local IsMale = (SimGetGender("")==GL_GENDER_MALE)
	
	-- animation timings
	local time1 = 0
	local time2 = 0
	
	-- check if the favor is high enough for courting
	local success = (GetFavorToSim("Destination", "") > MinimumFavor)
	
	-- Proposal
	PlayAnimationNoWait("", "talk")

	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","destination")
	CutsceneCameraCreate("cutscene","")			
	camera_CutscenePlayerLock("cutscene", "")

	-- Get the gender of the acting character		
	local label = "@L_COURTLOVER_BEGIN_QUESTION"
	if IsMale then
		label = label.."_TOFEMALE"
	else
		label = label.."_TOMALE"
	end

	local label2
	local Rhetoric = GetSkillValue("", RHETORIC)
	if (Rhetoric < 3) then
		label2 = "_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label2 = "_NORMAL_RHETORIC"
	else
		label2 = "_GOOD_RHETORIC"
	end	

	CutsceneShowCharacterPanel("",true)
	MsgSay("", label.."_1ST"..label2)
	MsgSay("", label.."_2ND"..label2)
	CutsceneShowCharacterPanel("",false)
	
	-- Check if it was successfull
	if success then
		
		-- Check the sex
		if IsMale then
			
			-- Show the appropriate Animation	and save the animation lenghts
			local DestinationAnimationLength = PlayAnimationNoWait("Destination", "curtsy")
			
			Sleep(DestinationAnimationLength*0.15)

			camera_CutscenePlayerLock("cutscene", "Destination")				
			
			local Rhetoric2 = GetSkillValue("Destination", RHETORIC)
			if (Rhetoric2 < 3) then
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_SUCCESS_FEMALE_WEAK_RHETORIC")
			elseif (Rhetoric2 < 6) then
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_SUCCESS_FEMALE_NORMAL_RHETORIC")
			else
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_SUCCESS_FEMALE_GOOD_RHETORIC")
			end	

			StopAnimation("")
			PlayAnimationNoWait("", "bow")
			
			Sleep(DestinationAnimationLength*0.3)
			
		else

			-- Show the appropriate Animation	and save the animation lenghts
			local DestinationAnimationLength = PlayAnimationNoWait("Destination", "bow")
			
			Sleep(DestinationAnimationLength*0.15)
			
			camera_CutscenePlayerLock("cutscene", "Destination")
			
			local Rhetoric2 = GetSkillValue("Destination", RHETORIC)
			if (Rhetoric2 < 3) then
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_SUCCESS_MALE_WEAK_RHETORIC")
			elseif (Rhetoric2 < 6) then
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_SUCCESS_MALE_NORMAL_RHETORIC")
			else
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_SUCCESS_MALE_GOOD_RHETORIC")
			end	

			StopAnimation("")
			PlayAnimationNoWait("", "curtsy")
			
			Sleep(DestinationAnimationLength*0.3)
			
		end
		-- PATCH TODO -- adds property so that CourtLover cannot be hired
		SetProperty("Destination", "courted", 1)
		SimSetCourtLover("", "Destination")
		SetData("CourtLoverSet", 1)
		
		DestroyCutscene("cutscene")

		feedback_MessageCharacter("", 
			"@L_COURTLOVER_MSG_SUCCESS_HEAD_+0",
			"@L_COURTLOVER_MSG_SUCCESS_BODY_+0", GetID("Destination"), GetID("Owner"))
			
	else
		
		-- Set the repeat timer and the favor loss prior to the animations so that the player cannot cancel the measure and try it instantly again
		SetMeasureRepeat(TimeUntilRepeat, "Destination")
		
		camera_CutscenePlayerLock("cutscene", "Destination")		
		
		chr_ModifyFavor("Destination", "", -5)
		
		local Time1 = PlayAnimationNoWait("Destination", "propel")

		if IsMale then
			local Rhetoric2 = GetSkillValue("Destination", RHETORIC)
			if (Rhetoric2 < 3) then
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_FAILED_FEMALE_WEAK_RHETORIC")
			elseif (Rhetoric2 < 6) then
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_FAILED_FEMALE_NORMAL_RHETORIC")
			else
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_FAILED_FEMALE_GOOD_RHETORIC")
			end	
		else
			local Rhetoric2 = GetSkillValue("Destination", RHETORIC)
			if (Rhetoric2 < 3) then
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_FAILED_MALE_WEAK_RHETORIC")
			elseif (Rhetoric2 < 6) then
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_FAILED_MALE_NORMAL_RHETORIC")
			else
				MsgSay("Destination", "@L_COURTLOVER_BEGIN_ANSWER_FAILED_MALE_GOOD_RHETORIC")
			end	
		end
		
		Sleep(Time1)
		
		feedback_MessageCharacter("", 
			"@L_COURTLOVER_MSG_FAILED_HEAD_+0",
			"@L_COURTLOVER_MSG_FAILED_BODY_+0", GetID("Destination"), GetID("Owner"))

	end
	
end

-- -----------------------
-- AIInitCourt
-- -----------------------
function AIInitCourt()
	return "O"
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	DestroyCutscene("cutscene")
	ReleaseAvoidanceGroup("")
	MoveSetActivity("")
	StopAnimation("")
	
	-- Remove the difficulty which was set in the court lover panel and used und the setcourtlover-function
	if AliasExists("Destination") then
		if not HasData("CourtLoverSet") then			
			RemoveProperty("Destination", "CourtDiff")
		end
		MoveSetActivity("Destination")
		feedback_OverheadActionName("Destination")
		SimLock("Destination", 0.25)
	end
	
end

