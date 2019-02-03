-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_Marry"
----
----	with this measure the player can marry a courted sim
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
		
	-- Get the court lover and call it "Destination" because the older version of the measure worked with a selection
	if not SimGetCourtLover("", "Destination") then
		StopMeasure()
		return
	end
	
	if SimGetProfession("Destination")>0 then -- don't marry workers please
		if SimGetWorkingPlace("Destination", "MyWork") then
			if BuildingGetOwner("MyWork", "MyBoss") then
				MsgBoxNoWait("", "Destination",  "@L_GENERAL_MEASURES_MARRY_FAILURES_HEAD_+0", "@L_GENERAL_MEASURES_MARRY_FAILURES_+1", GetID("Destination"), GetID("MyWork"), GetID("MyBoss"), GetID(""))
				SimReleaseCourtLover("")
				chr_GainXP("", 250)
				StopMeasure()
				return
			end
		end
		
		-- something missing, send alternative message
		MsgBoxNoWait("", "Destination",  "@L_GENERAL_MEASURES_MARRY_FAILURES_HEAD_+0", "@L_GENERAL_MEASURES_MARRY_FAILURES_+2", GetID("Destination"), GetID(""))
		SimReleaseCourtLover("")
		chr_GainXP("", 250)
		StopMeasure()
		return
	end
	
	if not(IsGUIDriven()) then
		SimSetBehavior("Destination", "")
		if not SimMarry("", "Destination") then
			SimReleaseCourtLover("")
		end
		StopMeasure()
		return
	end
	
	if SimGetSpouse("Destination","Spouse") then
		SimReleaseCourtLover("")
		StopMeasure()
	end
	
	local InteractionDistance = 128
	local ProposeInteractionDistance = 116
	
	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		MsgQuick("", "@L_GENERAL_MEASURES_MARRY_FAILURES_+0", GetID("Destination"))
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
	

	-------------
	-- Propose --
	-------------
	camera_CutsceneBothLock("cutscene", "")
	
	chr_MultiAnim("", "proposal_male", "Destination", "proposal_female", ProposeInteractionDistance, 0.4)
	
	MsgSay("", feedback_AskMarriage(GetSkillValue("", RHETORIC), SimGetGender("")));
	
	camera_CutscenePlayerLock("cutscene", "Destination")
	MsgSay("Destination", feedback_AnswerMarriage(GetSkillValue("Destination", RHETORIC), SimGetGender("Destination")));
	
	ReleaseAvoidanceGroup("")
	CutsceneCameraRelease("cutscene")

	
	--------------------------------
	-- Ask for the place to marry --
	--------------------------------

	local Title = GetNobilityTitle("")
	local Cost = (Title * Title) * 100
	local choice

	FindNearestBuilding("", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, false, "Weddingchapel")
	if AliasExists("Weddingchapel") then
		choice = MsgBox("", "", 
								"@B[0,@L_MEASURE_WEDDING_OPTION_+0]"..
								"@B[1,@L_MEASURE_WEDDING_OPTION_+1]"..
								"@B[2,@L_MEASURE_WEDDING_OPTION_+2]",
								"@L_FAMILY_1_MARRIAGE_MESSAGE_HEAD_LEAVE_+0",
								"@L_MEASURE_WEDDING_QUESTION_+0",
								GetID(""), GetID("Destination"), Cost)
	else
		choice = MsgBox("", "", 
								"@B[0,@L_MEASURE_WEDDING_OPTION_+0]"..
								"@B[2,@L_MEASURE_WEDDING_OPTION_+2]",
								"@L_FAMILY_1_MARRIAGE_MESSAGE_HEAD_LEAVE_+0",
								"@L_MEASURE_WEDDING_QUESTION_+0",
								GetID(""), GetID("Destination"))
	end

	-- at this place and nowhere else...
	if choice == 0 then
		if ai_StartInteraction("", "Destination", 500, InteractionDistance) then
			
			if AliasExists("Weddingchapel") then
				PlaySound3D("Weddingchapel", "locations/bell_stroke_cathedral_loop+0.wav", 1.0)
			end
			
			gameplayformulas_StartHighPriorMusic(MUSIC_MARRIAGE)

			SetAvoidanceGroup("", "Destination")
			CutsceneCameraCreate("cutscene","")
			camera_CutsceneBothLock("cutscene", "")

			ShowOverheadSymbol("", false, true, 0, "@L$S[2001]")
			ShowOverheadSymbol("Destination", false, true, 0, "@L$S[2001]")
			
			AnimLength = chr_MultiAnim("", "kiss_male", "Destination", "kiss_female", InteractionDistance, 1.0, true)
			
			Sleep(AnimLength * 0.5)
			ShowOverheadSymbol("Destination", false, true, 0, "@L$S[2001]")
			ShowOverheadSymbol("", false, true, 0, "@L$S[2001]")
			
			Sleep(AnimLength * 0.5)
			ShowOverheadSymbol("Destination", false, true, 0, "@L$S[2001]")
			ShowOverheadSymbol("", false, true, 0, "@L$S[2001]")
			
			if not HasProperty("Destination", "CourtDiff") then			
				CalculateCourtingDifficulty("", "Destination")
			end
			
			local Difficulty = (GetProperty("Destination", "CourtDiff") / 2)
			xp_CourttingSuccess("Owner", Difficulty)
			xp_CourttingSuccess("Destination", Difficulty)
			RemoveProperty("Destination", "CourtDiff")
	
			MeasureSetNotRestartable()
			RemoveProperty("Destination", "courted")
			if IsDynastySim("Destination") then
				DynastySetDiplomacyState("","Destination",DIP_ALLIANCE)
				ModifyFavorToDynasty("","Destination",100)
				-- add the new property
				f_DynastyAddAlly("","Destination")
				f_DynastyAddAlly("Destination","")
			end
			AddImpact("","LoveLevel",10,24) -- add some love for the next 24 hours
			AddImpact("Destination","LoveLevel",10,24)
			if GetImpactValue("Destination","LoveLevel")>=10 then
				MsgNewsNoWait("","Destination","","schedule",-1,
							"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_HEAD_+0",
							"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_BODY_+0", GetID("Destination"))
			end
			SimSetBehavior("Destination", "")
			SimMarry("", "Destination")	-- the destination is removed through this function

		else
		
			MsgQuick("","@L_MEASURE_WEDDING_FAILURE_+0",GetID(""), GetID("Destination"))

		end

	-- church
	elseif choice == 1 then
	
		ms_marry_GotoChurch("Weddingchapel")
		
		if not f_SpendMoney("dynasty", Cost, "Wedding") then
			if not HasProperty("", "Tutorial") then
				MsgQuick("","@L_MEASURE_WEDDING_FAILURE_+1",GetID(""))
				StopMeasure()
			end
		end

		if ai_StartInteraction("", "Destination", 500, InteractionDistance) then
			
			gameplayformulas_StartHighPriorMusic(MUSIC_MARRIAGE)
			
			BuildingFindSimByProperty("Weddingchapel", "BUILDING_NPC", 11, "Priest")			
			GetLocatorByName("Weddingchapel","WeddingPriest","PriestPos")
			
			f_MoveTo("Priest","PriestPos")
			Sleep(1)

			SetAvoidanceGroup("", "Destination")

			AlignTo("", "Priest")
			AlignTo("Destination", "Priest")
			Sleep(1)

			if SimGetGender("")==GL_GENDER_MALE then
				AlignTo("Priest", "")
				Sleep(1)
				
				MsgSay("Priest","_FAMILY_1_MARRIAGE_CEREMONY_PRIEST_HUSBAND_+0", GetID(""), GetID("Destination"))
				Sleep(1)
				MsgSay("Priest","_FAMILY_1_MARRIAGE_CEREMONY_PRIEST_HUSBAND_+1", GetID(""), GetID("Destination"))
	
				MsgSay("","_FAMILY_1_MARRIAGE_CEREMONY_ANSWER_+0")
	
				AlignTo("Priest", "Destination")
				Sleep(1)
	
				MsgSay("Priest","_FAMILY_1_MARRIAGE_CEREMONY_PRIEST_WIFE_+0", GetID("Destination"), GetID(""))
	
				MsgSay("Destination","_FAMILY_1_MARRIAGE_CEREMONY_ANSWER_+0")
				Sleep(1)

				-- kiss your wife good man...
				AlignTo("Priest", "")
				MsgSay("Priest","_FAMILY_1_MARRIAGE_CEREMONY_PRIEST_FINALE_+0", GetID(""))
	
				AlignTo("", "Destination")
				AlignTo("Destination", "")
				Sleep(1)
				
				ShowOverheadSymbol("", false, true, 0, "@L$S[2001]")
				ShowOverheadSymbol("Destination", false, true, 0, "@L$S[2001]")
				
				AnimLength = chr_MultiAnim("", "kiss_male", "Destination", "kiss_female", InteractionDistance, 1.0, true)
				
				Sleep(AnimLength * 0.5)
			else
				AlignTo("Priest", "Destination")
				Sleep(1)
				
				MsgSay("Priest","_FAMILY_1_MARRIAGE_CEREMONY_PRIEST_HUSBAND_+0", GetID("Destination"), GetID(""))
				Sleep(1)
				MsgSay("Priest","_FAMILY_1_MARRIAGE_CEREMONY_PRIEST_HUSBAND_+1", GetID("Destination"), GetID(""))
	
				MsgSay("Destination","_FAMILY_1_MARRIAGE_CEREMONY_ANSWER_+0")
	
				AlignTo("Priest", "")
				Sleep(1)
	
				MsgSay("Priest","_FAMILY_1_MARRIAGE_CEREMONY_PRIEST_WIFE_+0", GetID("Destination"), GetID(""))
	
				MsgSay("","_FAMILY_1_MARRIAGE_CEREMONY_ANSWER_+0")
				Sleep(1)

				-- kiss your wife good man...
				AlignTo("Priest", "Destination")
				MsgSay("Priest","_FAMILY_1_MARRIAGE_CEREMONY_PRIEST_FINALE_+0", GetID("Destination"))
	
				AlignTo("", "Destination")
				AlignTo("Destination", "")
				Sleep(1)
				
				ShowOverheadSymbol("", false, true, 0, "@L$S[2001]")
				ShowOverheadSymbol("Destination", false, true, 0, "@L$S[2001]")
				
				AnimLength = chr_MultiAnim("Destination", "kiss_male", "", "kiss_female", InteractionDistance, 1.0, true)
				
				Sleep(AnimLength * 0.5)
			end

			ShowOverheadSymbol("Destination", false, true, 0, "@L$S[2001]")
			ShowOverheadSymbol("", false, true, 0, "@L$S[2001]")
			
			Sleep(AnimLength * 0.5)
			ShowOverheadSymbol("Destination", false, true, 0, "@L$S[2001]")
			ShowOverheadSymbol("", false, true, 0, "@L$S[2001]")
			
			if not HasProperty("Destination", "CourtDiff") then			
				CalculateCourtingDifficulty("", "Destination")
			end
			
			local Difficulty = GetProperty("Destination", "CourtDiff")
			xp_CourttingSuccess("Owner", Difficulty, 1)
			xp_CourttingSuccess("Destination", Difficulty, 1)
			RemoveProperty("Destination", "CourtDiff")
	
			MeasureSetNotRestartable()
			PlaySound3D("Weddingchapel", "locations/bell_stroke_cathedral_loop+0.wav", 1.0)
			RemoveProperty("Destination", "courted")
			if IsDynastySim("Destination") then
				DynastySetDiplomacyState("","Destination",DIP_ALLIANCE)
				ModifyFavorToDynasty("","Destination",100)
				-- add the new property
				f_DynastyAddAlly("","Destination")
				f_DynastyAddAlly("Destination","")
			end
			AddImpact("","LoveLevel",10,24) -- add some love for the next 24 hours
			AddImpact("Destination","LoveLevel",10,24)
			if GetImpactValue("Destination","LoveLevel")>=10 then
				MsgNewsNoWait("","Destination","","schedule",-1,
							"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_HEAD_+0",
							"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_BODY_+0", GetID("Destination"))
			end
			SimSetBehavior("Destination", "")			
			SimMarry("", "Destination")	-- the destination is removed through this function
		end
	end

	StopMeasure()
end

function GotoChurch(Church)

	  f_MoveToNoWait("", "Weddingchapel", GL_MOVESPEED_WALK)
	  f_MoveTo("Destination", "Weddingchapel", GL_MOVESPEED_WALK)
	 --f_FollowNoWait("", "Destination", GL_MOVESPEED_WALK, 250, true)		
	-------------------
	-- Go to the church
	-------------------
	if not f_MoveTo("","Weddingchapel") then
		StopMeasure()
	end
	
	if not f_MoveTo("Destination", "Weddingchapel") then
		StopMeasure()
	end
	
	--get the locators
	if not GetLocatorByName(Church,"Front1","MarryPos1") then
		StopMeasure()
	end
	if not GetLocatorByName(Church,"Front2","MarryPos2") then
		StopMeasure()
	end

	--if another marriage is running
	while true do
		if LocatorStatus(Church,"Front1",true)==1 then
			break
		end
		Sleep(2)
	end

	--move the sims
	if not SendCommandNoWait("Destination","GoToMarryPos") then
		StopMeasure()
	end
	if not f_BeginUseLocator("","MarryPos1",GL_STANCE_STAND,true) then
		StopMeasure()
	end
	--wait until both have arrived
	while not HasData("There") do
		Sleep(1)
	end
end

function GoToMarryPos()	
	if not f_BeginUseLocator("", "MarryPos2", GL_STANCE_STAND, true) then
		StopMeasure()
	end
	SetData("There", 1)
	while true do
		Sleep(2)
	end
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	EndCutscene("")
	DestroyCutscene("cutscene")
	MoveSetActivity("")
	MoveSetActivity("Destination")
	SetState("", STATE_LOCKED, false)	
	SimStopMeasure("Destination")	
	ReleaseAvoidanceGroup("")
	
	-- courting helpers, see CourtLover
	RemoveProperty("", "_ai_cl_0")
	RemoveProperty("", "_ai_cl_1")
end

