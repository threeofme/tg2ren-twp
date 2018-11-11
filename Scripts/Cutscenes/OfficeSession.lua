-------------------------------------------------------------------------------
----
----	OVERVIEW "OfficeSession.lua"
----
----	This script is for the council meetings. It has two parts: 
----	Pre-Session and In-Session.
---- 	This script has been totally reworked and rearranged by Fajeth.
----
-------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- Prepare the session    --------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function Start()
	
	-- fos = Frequency of Office Sessions (every round, every 2 or 4 rounds)
	GetScenario("World")
	local fos = GetProperty("World","fos")
	local nextOS = 17
	
	if not HasProperty("World","static") and (GetRound() > 0 or math.mod(GetGametime(),24) > 17) then
		nextOS = nextOS + ((fos * 24) - 24)
	end

	-- set a Date: settlement, event_alias, cutscene_alias,  function, HourOfDay, MinTimeInFuture, text label
	CityScheduleCutsceneEvent("settlement","council_date","","BeginCouncilMeeting",nextOS,6,"@L_SESSION_6_TIMEPLANNERENTRY_CITY_+0")
	
	local EventTime = SettlementEventGetTime("council_date")
	local GameTime = GetGametime()*60	-- in hours
	
	SetData("EventTime",EventTime) -- needed for the tutorial
	
	local WaitTime = (EventTime - (20*60)) - GameTime
	SetData("WaitTime", WaitTime)

	if (WaitTime<0) then
		officesession_SetBuildingInfo()
	else
		CutsceneAddEvent("","SetBuildingInfo",WaitTime)
	end
	
	if HasProperty("councilbuilding","CutsceneAhead") then
		local CutscenesAhead = GetProperty("councilbuilding","CutsceneAhead") + 1
		SetProperty("councilbuilding","CutsceneAhead",CutscenesAhead)
	else
		SetProperty("councilbuilding","CutsceneAhead",1)
	end
	
	--??
	SetData("FirstRun",1)
	SetData("AppList_Count", 0)
end

function SetBuildingInfo()
	SetProperty("councilbuilding","sessioncutszene",GetID(""))
end

------------------------------------------------------------------------------------------------------------------------
-- Invite everyone    ------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function AddApplicant()
	if not AliasExists("InvitedSims") then
		ListNew("InvitedSims")
	end
	
	--Add the Applicant "applicant" to the Applicant-list for the office "office"
	if not CitySetOfficeApplicant("settlement", "applicant", "office") then
		return false
	end

	--Invite the Applicant
	officesession_InviteApplicant("applicant","")

	-- invite the current office holder if he exists and is not already invited. "Holder" is the alias of the current holder
	if(OfficeGetHolder("office","Holder") and not ListContains("InvitedSims","Holder")) then
		officesession_InviteDepositionDefender("Holder","applicant")
		ListAdd("InvitedSims","Holder")
	end

	-- invite the voters
	officesession_InviteAllVoters()

	SetProperty("applicant","cutscene_destination_ID",GetID(""))
	SetProperty("applicant","HaveCutscene",1)
end

------------------------------------------------------------------------------------------------------------------------
-- Prepare the townhall, find seats    -----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function BeginCouncilMeeting()

	-- DataInit
	SetData("PanelShow",0)
	SetData("PanelInit",1)
	SetData("PanelCandidates",0)
	
	SetData("VoteCacheIdx",0)

	-- Get whole office session member list
	CityGetOfficeSessionMemberList("settlement","SimOfficeList",0)
	-- How many sims in that list?
	local SimCnt = ListSize("SimOfficeList")
	
	-- get the office room and call it "Room"
	BuildingGetRoom("councilbuilding","Judge","Room")
	-- Lock the Room
	RoomLockForCutscene("Room","")
	
	-- we no longer need that list
	RemoveAlias("InvitedSims")

	-- Check if we have any voters available, if not then a guard will throw the lot
	local ValidTasks = 0
	-- number of voters
	local NumOfVotes = CityPrepareOfficesToVote("settlement","OfficeList",false)
	
	for i=0, NumOfVotes-1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

		local VoterCnt = officesession_GetVoters("OfficeToCheck","Voter") 
		
		if(VoterCnt > 0) then
			for j=0,VoterCnt-1 do
				local VoterAlias = "Voter"..j
				if officesession_SimIsInTownhall(VoterAlias) then
					ValidTasks = ValidTasks + 1
					-- we found someone, great
					break
				end
			end
		end
	end
	
	SimCnt = ListSize("SimOfficeList")
	GetLocalPlayerDynasty("LocalPlayer")
	
	-- go over all office members and stop those who are to late.
	for i=0, SimCnt-1 do
		ListGetElement("SimOfficeList",i,"Sim")
		
		-- The sim is not at the right place
		if not officesession_SimIsInTownhall("Sim") then
			local Dynasty = GetDynastyID("Sim")
			-- send a message to the player if he fails to come
			if GetID("LocalPlayer") == Dynasty then
				MsgNewsNoWait("Sim",0,"MB_OK","default",1,"@L_SESSION_5_MESSAGES_NOTATPLACE_+0","@L_SESSION_5_MESSAGES_NOTATPLACE_+1",GetID("settlement"))
			end

			if (DynastyIsAI("Sim")) then
				-- give back the behavior and stop the measure for the AI
				AllowAllMeasures("Sim")
				if (HasProperty("Sim","cutscene_destination_ID") == true) then
					RemoveProperty("Sim","cutscene_destination_ID")
				end
				SimStopMeasure("Sim")
			end
			
			SimResetBehavior("Sim")
				
			if (HasProperty("Sim","HaveCutscene") == true) then
				RemoveProperty("Sim","HaveCutscene")
			end
			
			-- remove the sim from the list
			ListRemove("SimOfficeList","Sim")
		end
	end
	
	local TriggerEventCnt = 0
	
	-- Special case go mr. guard
	if (ValidTasks == 0) then
		-- special case
		BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 2,"Chairman")
		SetData("UsherSession",1)
	end
	
	-- move everyone to their place
		
	local TablePlace = 1;
	local BenchPlace = 1;
	SetData("KingTask",0)
		
	-- get the list of all sims in the room. Kick out non-office sims except guards and myrmidons
	RoomGetInsideSimList("Room","SimList")
	SimCnt = ListSize("SimList")

	for i=0,SimCnt - 1 do
		ListGetElement("SimList",i,"Sim")
		if(not ListContains("SimOfficeList","Sim") and HasProperty("Sim","BUILDING_NPC") == false) then
			if SimGetProfession("Sim")~=18 then -- myrmidon 
				SimStopMeasure("Sim")
				officesession_SimLeaveBuilding("Sim")
				TriggerEventCnt = TriggerEventCnt + 1
			end
		end
	end
	
	if ValidTasks>0 then
		-- Get the Chairman, if no one of the office tree is there, use the guard
		local ChairmanExists = officesession_GetChairman("Chairman")
		if(not ChairmanExists)then
			BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 2,"Usher")
			CopyAlias("Usher","Chairman")
		end
	end
	
	-- case for imperial city
	if(CityGetLevel("settlement") == 6) then
		
		for i=0, SimCnt-1 do
			ListGetElement("SimOfficeList",i,"Sim")
			local simOfficeLevel = SimGetOfficeLevel("Sim")
			local simOfficeIndex = SimGetOfficeIndex("Sim")
			if (simOfficeLevel==6) then
				if (simOfficeIndex ==0) then
					SetData("KingTask",1)
					SetData("CardinalID",GetID("Sim"))
					CutsceneCallThread("", "SpecialSimAttend", "Sim", "LeftAssessorChairPos");
					ListRemove("SimOfficeList","Sim")
				else
					SetData("KingTask",1)
					SetData("FeldherrID",GetID("Sim"))
					CutsceneCallThread("", "SpecialSimAttend", "Sim", "RightAssessorChairPos");
					ListRemove("SimOfficeList","Sim")
				end
			elseif (simOfficeLevel ==7) then -- the king
				SetData("KingID",GetID("Sim"))
				CutsceneCallThread("", "SpecialSimAttend", "Sim", "JudgeChairPos");
				SetData("KingTask",1)
				ListRemove("SimOfficeList","Sim")
			end
		end

		-- if the king is there, then he is the chairman
		TablePlace = 0;
		
		TriggerEventCnt = TriggerEventCnt +1

		if (GetData("KingTask") == 0) then
			CutsceneCallThread("", "VoterAttend", "Chairman", 9);
		end
			
	-- normal cities
	else	
		if ValidTasks>0 then
			-- remove the chairman
			ListRemove("SimOfficeList","Chairman")
			TriggerEventCnt = TriggerEventCnt +1
			CutsceneCallThread("", "VoterAttend", "Chairman", 9);
		end
	end
		
	-- Now move remaining officeholders and applicants to their seats
	SimCnt = ListSize("SimOfficeList")
		
	for i=0, SimCnt -1 do
		ListGetElement("SimOfficeList",i,"Sim")
		if(SimGetOffice("Sim","Office")) then
			TriggerEventCnt = TriggerEventCnt + 1
			TablePlace = TablePlace + 1
			CutsceneCallThread("", "VoterAttend", "Sim", (9-TablePlace));
		else
			if SimGetProfession("Sim")~=18 then -- myrmidon 
				TriggerEventCnt = TriggerEventCnt + 1
				BenchPlace = BenchPlace + 1
				CutsceneCallThread("", "ApplicantAttend", "Sim", BenchPlace);
			end
		end
	end
		
	-- Remove the lists
	RemoveAlias("SimList")
	RemoveAlias("SimOfficeList")
		
	-- if everyone reached their place continue (or wait 30 minutes)
	CutsceneAddTriggerEvent("","RunCouncilMeeting", "Reached", TriggerEventCnt,30)
end

------------------------------------------------------------------------------------------------------------------------
-- Run the session    ------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function RunCouncilMeeting()
	if not AliasExists("Chairman") then
		BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 2,"Chairman")
	end
	BuildingGetRoom("councilbuilding", "Judge", "Room")
	
	-- Cutscenes can only be attached to the _main_ room of a building or to a position (or a simobject) - NOT to a room!
	GetLocatorByName("councilbuilding", "TableChair0", "CameraCreatePos")
	CutsceneCameraCreate("","CameraCreatePos")
	officesession_OverviewCam()
	
	local HadValidVotes = true
	
	if HasData("UsherSession") then
		HadValidVotes = false
	end
	
	-- all sims are at their places, let the games begin
	if HasData("UsherSession") then
		officesession_SimCam("Chairman",0,0)
		PlayAnimationNoWait("Chairman", "sit_talk_short")
		MsgSay("Chairman", "@L_SESSION_7_NOJURYEVENT_WELCOME","@L_BUILDING_Quarry_REQUIREMENTS")
	else
		MsgSay("Chairman","@L_SESSION_1_GREETING")
	end

	-- this is to remove the measure bar (bug)
	if CutsceneLocalPlayerIsWatching("") then
		HudClearSelection()
	end

	-- check if there are applicants. If not, stop the session immediatly.
	if(officesession_GetValidApplicantCount("settlement") <1) then
		officesession_SimCam("Chairman",0,0)
		PlayAnimationNoWait("Chairman", "sit_talk_short")
		MsgSay("Chairman","@L_SESSION_ADDON_NO_DECIDERS")
		EndCutscene("")
	end

	-- loop trough all votes, from highest to lowest office
	local NumOfVotes = CityPrepareOfficesToVote("settlement","OfficeList",true)
	if(NumOfVotes == nil or NumOfVotes<0) then
		NumOfVotes = 0
	end
	SetData("VoteCnt",NumOfVotes)

	if(NumOfVotes == 0) then
		officesession_SimCam("Chairman",0,0)
		PlayAnimationNoWait("Chairman", "sit_talk_short")
		MsgSay("Chairman","@L_SESSION_ADDON_NO_DECIDERS") 
		EndCutscene("")
	end
	
	if HasData("UsherSession") then
		for i=0,NumOfVotes-1 do
			ListGetElement("OfficeList",i,"OfficeToCheck")

			if (officesession_CheckForValidOfficeRun("OfficeToCheck") == true) then
				local ApplicantCnt = officesession_OfficeGetApplicants("OfficeToCheck","Applicant")
				local Winner = Rand(ApplicantCnt)

				officesession_SaveVoteResult("OfficeToCheck","Applicant"..Winner)
				
				local OfficeNameLabel = OfficeGetTextLabel("OfficeToCheck",SimGetGender("Applicant"..Winner))

				officesession_SimCam("Chairman",0,0)
				PlayAnimationNoWait("Chairman", "sit_talk_short")
				MsgSay("Chairman", "@L_SESSION_7_NOJURYEVENT_APPLICATION",GetID("Applicant"..Winner),OfficeNameLabel)

				HadValidVotes = true

				if officesession_SimIsInTownhall("Applicant"..Winner) then
					CutsceneCameraBlend("",0,0)
					CutsceneCameraSetRelativePosition("","Mid_HCenterYLeft","Applicant"..Winner)
					PlayAnimationNoWait("Applicant"..Winner, "sit_talk_short")
					MsgSay("Applicant"..Winner, "@L_SESSION_3_ELECT_REACTION")
					StopAnimation("Applicant"..Winner)
				end
			end
		end
	
		if(HadValidVotes) then
			officesession_WriteVotes()
			officesession_SimCam("Chairman",0,0)
			MsgSay("Chairman","@L_SESSION_4_GOODBYE_SUCCESS")
		else
			officesession_SimCam("Chairman",0,0)
			MsgSay("Chairman","@L_SESSION_4_GOODBYE_FAILED")
		end

	else
	
		for i=0, NumOfVotes-1 do
			ListGetElement("OfficeList",i,"Office")
			officesession_VoteForOffice("Office")
			officesession_OverviewCam()
		end

		-- Goodbye
		PlayAnimationNoWait("Chairman", "sit_talk_short")	
		MsgSay("Chairman","@L_SESSION_4_GOODBYE_SUCCESS")

		-- Write the new offices in the OfficeTree
		officesession_WriteVotes()
	end

	 -- All Sims leave the TownHall
	local SimWalkOutCount = officesession_SimLeaveTownhall()
	
	CutsceneAddTriggerEvent("","QuitCutscene", "OutOfBuilding", SimWalkOutCount, 30)
end

------------------------------------------------------------------------------------------------------------------------
-- Talk about every office    ---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function VoteForOffice(Office)
	local Winner = -1 -- saves the alias of the winner, e.g: Applicant1
	local ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant") -- number of applicants for the office
	local VoterCnt = officesession_GetVoters(Office,"Voter") -- number of voters for the office
	local OfficeID = GetID(Office)
	
	-- save the data
	SetData("CurrentOffice",Office)
	SetData("ApplicantCnt",ApplicantCnt)
	SetData("VoterCnt",VoterCnt)
	
	-- if no applicant is there, no vote will be made.
	if(ApplicantCnt == 0) then
		officesession_SimCam("Chairman",0,0)
		PlayAnimationNoWait("Chairman", "sit_talk_short")		
		MsgSay("Chairman","@L_SESSION_ADDON_NO_DECIDERS")
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
		end
		
		return
	end

	local OfficeNameLabel = OfficeGetTextLabel(Office)
	local OfficeName = "@L"..string.sub(OfficeNameLabel, 0, -2)..2

	officesession_SimCam("Chairman",0,0)
	PlayAnimationNoWait("Chairman", "sit_talk_short")
	
	-- lets talk about the position of ...
	if not OfficeGetHolder("Office","OfficeHolder") then
		if Rand(2)==0 then
			MsgSay("Chairman","@L_SESSION_3_ELECT_INTRO_+1")
		else
			MsgSay("Chairman","@L_SESSION_3_ELECT_INTRO_+0")
		end
	else
		MsgSay("Chairman","@L_SESSION_ADDON_INTRO")
	end
	
	if CutsceneLocalPlayerIsWatching("") then
		HudClearSelection()
	end
	
	-- office name
	MsgSay("Chairman",OfficeName)
	
	if CutsceneLocalPlayerIsWatching("") then
		HudClearSelection()
	end
	
	-- Check if the user had won an ellection before. if true, no negative reaction
	local wonEllection = false;
	
	local VoteCacheIdx = GetData("VoteCacheIdx")
	if (VoteCacheIdx == nil) then
		VoteCacheIdx = 0
	end
	
	for i=0, VoteCacheIdx-1 do
		if(OfficeGetHolder("Office","OfficeHolder") and GetData("VoteCacheWinnerID"..i) == GetID("OfficeHolder")) then
			wonEllection = true;
			break;
		end
	end

	if( OfficeGetHolder("Office","OfficeHolder") and officesession_SimIsInTownhall("OfficeHolder") and wonEllection == false) then
		if GetID("OfficeHolder")==GetID("Chairman") then
			officesession_SimCam("OfficeHolder",0,0)
			PlayAnimationNoWait("OfficeHolder", "sit_talk_short")
			MsgSay("OfficeHolder","@L_SESSION_ADDON_REACTION")
			-- what? thats my office!
			if CutsceneLocalPlayerIsWatching("") then
				HudClearSelection()
			end
		else
			officesession_SimCam("OfficeHolder",0,0)
			-- What? I never did something wrong!
			MsgSay("OfficeHolder","@L_SESSION_2_CANCEL_1STINTRO_SUB")
			if CutsceneLocalPlayerIsWatching("") then
				HudClearSelection()
			end
		end
		officesession_SimCam("Chairman",0,0)
	end

	-- Applicants
	
	PlayAnimationNoWait("Chairman", "sit_talk_short")
	if (ApplicantCnt > 1) then
		MsgSay("Chairman","@L_SESSION_ADDON_CANDIDATES_MORE_+1")
	else
		MsgSay("Chairman","@L_SESSION_ADDON_CANDIDATES_ONE_+1")
	end
	
	if CutsceneLocalPlayerIsWatching("") then
		HudClearSelection()
	end
		
	for i=0, ApplicantCnt-1 do
		local SimOfficeID = SimGetOfficeID("Applicant"..i)
		if( SimOfficeID ~= OfficeID ) then
			if (officesession_SimIsInTownhall("Applicant"..i)) then
				officesession_SimCam("Applicant"..i,0,0)
				MsgSay("Chairman","%1SN",GetID("Applicant"..i))
			end
			
			if CutsceneLocalPlayerIsWatching("") then
				HudClearSelection()
			end
		end
	end
	
	-- we have a winner if we have only 1 applicant
	if(ApplicantCnt == 1) then
		Winner = 0
		officesession_OverviewCam()
		MsgSay("Chairman","@L_SESSION_ADDON_ONLY_ONE_CANDIDATE")
		
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
		end
	else
		-- We need to vote
	
		if VoterCnt == nil or VoterCnt<0 then
			VoterCnt = 0
		end
		
		-- no voters, random winner
		if(VoterCnt == 0) then
			officesession_OverviewCam()
			MsgSay("Chairman","@L_SESSION_7_NOJURYEVENT_WELCOME","@L_SESSION_ADDON_ADD_NO_VOTERS")
			if CutsceneLocalPlayerIsWatching("") then
				HudClearSelection()
			end
		
			local WinnerIdx = Rand(ApplicantCnt)
			Winner = WinnerIdx
			MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT2",GetID("Applicant"..Winner))
			if CutsceneLocalPlayerIsWatching("") then
				HudClearSelection()
			end
		else
			officesession_OverviewCam()
			-- Current Officeholder may want to threat the jury if he is there
			if( OfficeGetHolder("Office","OfficeHolder") and officesession_SimIsInTownhall("OfficeHolder") and wonEllection == false ) then
				
				officesession_OverviewCam()
				-- why should you stay?
				MsgSay("Chairman","@L_SESSION_2_CANCEL_REASONTOSTAY_+0",GetID("OfficeHolder"))
				if CutsceneLocalPlayerIsWatching("") then
					HudClearSelection()
				end
			
				-- answer
				local Res = MsgSayInteraction("OfficeHolder","OfficeHolder",0,"@B[A, @L_REPLACEMENTS_BUTTONS_JA]@B[C, @L_REPLACEMENTS_BUTTONS_NEIN]@P",officesession_AIBedrohung,"@L_SESSION_2_CANCEL_REASONTOSTAY_+2")
				-- yes
				if(Res == "A") then
					officesession_SimCam("OfficeHolder",0,0)
					PlayAnimationNoWait("OfficeHolder", "sit_talk_short")
					MsgSay("OfficeHolder", "@L_SESSION_2_CANCEL_REASONTOSTAY_MENACE")
					if CutsceneLocalPlayerIsWatching("") then
						HudClearSelection()
					end
					
					officesession_OverviewCam()
					for i=0, VoterCnt-1 do
						local VoterAlias = "Voter"..i
						if GetInsideBuilding(VoterAlias,"currentbuilding") then
							if GetID("OfficeHolder") ~= GetID(VoterAlias) then
								if (DynastyIsAI(VoterAlias) == true) then
									if GetID("currentbuilding") == GetID("councilbuilding") then
										-- skill check
										if GetSkillValue("OfficeHolder",RHETORIC)>=GetSkillValue(VoterAlias,EMPATHY) then
											PlayAnimationNoWait(VoterAlias, "sit_yes")
											if DynastyIsAI(VoterAlias) then
												SetFavorToSim(VoterAlias,"OfficeHolder",GetFavorToSim(VoterAlias,"OfficeHolder")+10)
											end
											officesession_SimCam(VoterAlias,0,0)
											MsgSay(VoterAlias, "@L_SESSION_2_CANCEL_REASONTOSTAY_REACTION_PRO")
										else
											PlayAnimationNoWait(VoterAlias, "sit_no")
											if DynastyIsAI(VoterAlias) then
												SetFavorToSim(VoterAlias,"OfficeHolder",GetFavorToSim(VoterAlias,"OfficeHolder")-10)
											end
											officesession_SimCam(VoterAlias,0,0)
											MsgSay(VoterAlias, "@L_SESSION_2_CANCEL_REASONTOSTAY_REACTION_CONTRA")
										end
									end
								end
							end
						end
					end
				else
				-- no
					officesession_SimCam("OfficeHolder",0,0)
					PlayAnimationNoWait("OfficeHolder", "sit_talk_short")
					MsgSay("OfficeHolder", "@L_SESSION_2_CANCEL_REASONTOSTAY_NEUTRAL")
					if CutsceneLocalPlayerIsWatching("") then
						HudClearSelection()
					end
				end
			end
	
			-- Do your votes
			officesession_OverviewCam()
			if(OfficeGetHolder("Office","OfficeHolder") and officesession_SimIsInTownhall("OfficeHolder")) then
				MsgSay("Chairman","@L_SESSION_2_CANCEL_2NDINTRO")
			else
				MsgSay("Chairman","@L_SESSION_3_ELECT_INTRO_+2")
			end
			if CutsceneLocalPlayerIsWatching("") then
				HudClearSelection()
			end
	
			ApplicantCnt = GetData("ApplicantCnt")
			local votes = {}
			
			for i=0, ApplicantCnt-1 do
				votes[i] = 0
			end
						
			VoterCnt = GetData("VoterCnt")
			
			for i=0,VoterCnt-1 do
				local Idx = -1
				if(officesession_SimIsInTownhall("Voter"..i)) then
					Idx = officesession_DoVote("Voter"..i,Office,"Applicant",ApplicantCnt)
				end
				
				if( Idx ~= -1 ) then
					local Value = votes[Idx]
					votes[Idx] = Value + 1
				end
			end
		 	
		 	officesession_OverviewCam()
	
			-- Count the votes
			local WinnerArray = {}
			local WinnerArrayCount = 0
			local MaxVote = 0		
			
			for i=0, ApplicantCnt-1 do
				Vote = votes[i]
				if(Vote > MaxVote) then
					WinnerArray = {}
					WinnerArrayCount = 1
					WinnerArray[WinnerArrayCount] = i
					Winner = i
					MaxVote = Vote
				elseif(Vote == MaxVote and Vote ~= 0) then
					WinnerArrayCount = WinnerArrayCount + 1
					WinnerArray[WinnerArrayCount] = i
					Winner = -1
					MaxVote = Vote
				end
			end

			-- We have a winner
			if(Winner > -1) then
				local CurrentWinner = "Applicant"..Winner
				local GenderText
				if SimGetGender(CurrentWinner) == GL_GENDER_FEMALE then
					GenderText = "_+1"
				else
					GenderText = "_+0"
				end		
				
				local OfficeNameLabel = OfficeGetTextLabel("office",SimGetGender(CurrentWinner))
				local OfficeName = "@L"..string.sub(OfficeNameLabel, 0, -4)..GenderText
				-- old office holder is new office holder?
				if( OfficeGetHolder("Office","OfficeHolder") and GetID("OfficeHolder") == GetID(CurrentWinner) ) then
--					MsgSay("Chairman","@L_SESSION_2_CANCEL_ANOUNCEMENT_SPEECH_+1")
				elseif( OfficeGetHolder("Office","OfficeHolder") and wonEllection == false ) then
--					MsgSay("Chairman","@L_SESSION_2_CANCEL_ANOUNCEMENT_SPEECH_+0")
					MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT1"..GenderText,GetID(CurrentWinner),GetID("settlement"),OfficeName)
				else
					MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT1"..GenderText,GetID(CurrentWinner),GetID("settlement"),OfficeName)
				end
				
				if CutsceneLocalPlayerIsWatching("") then
					HudClearSelection()
				end
			else
			-- we have a tie. Random things
				if (WinnerArrayCount == 0) then
					Winner = Rand(ApplicantCnt)
				else
					Winner = WinnerArray[Rand(WinnerArrayCount)+1]
				end
				
				if( OfficeGetHolder("Office","OfficeHolder") and GetID("OfficeHolder") == GetID(CurrentWinner) ) then
--					MsgSay("Chairman","@L_SESSION_2_CANCEL_ANOUNCEMENT_SPEECH_+1")
				elseif( OfficeGetHolder("Office","OfficeHolder") and wonEllection == false ) then
					MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT2",GetID("Applicant"..Winner))
--					MsgSay("Chairman","@L_SESSION_2_CANCEL_ANOUNCEMENT_SPEECH_+0")
				else
					MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT2",GetID("Applicant"..Winner))
				end

				if CutsceneLocalPlayerIsWatching("") then
					HudClearSelection()
				end
			end
		end
	end


	-- Bekanntgabe des Gewinners
	officesession_SaveVoteResult(Office,"Applicant"..Winner)
	
	if( officesession_SimIsInTownhall("Applicant"..Winner)) then
		officesession_SimCam("Applicant"..Winner,0,0)
		PlayAnimationNoWait("Applicant"..Winner, "sit_talk_short")		
		-- old office holder new office holder? Reactions
		if( OfficeGetHolder("Office","OfficeHolder") and GetID("OfficeHolder") == GetID("Applicant"..Winner) ) then
			MsgSay("Applicant"..Winner,"@L_SESSION_3_ELECT_REACTION_+3")
		elseif( OfficeGetHolder("Office","OfficeHolder") and officesession_SimIsInTownhall("OfficeHolder") and wonEllection == false) then
			MsgSay("Applicant"..Winner,"@L_SESSION_3_ELECT_REACTION")
			officesession_SimCam("OfficeHolder",0,0)
			-- some insults before I go
			--if SimGetGender("Applicant"..Winner)==GL_GENDER_FEMALE then
			--	MsgSay("OfficeHolder","@L_SESSION_2_CANCEL_REASONTOGO_INSULT_FEMALE")
			--else
			--	MsgSay("OfficeHolder","@L_SESSION_2_CANCEL_REASONTOGO_INSULT_MALE")
			--end
			MsgSay("OfficeHolder", "@L_SESSION_2_CANCEL_COMMENTS")
		else
			MsgSay("Applicant"..Winner,"@L_SESSION_3_ELECT_REACTION") 
		end
		
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
		end
	end
end

------------------------------------------------------------------------------------------------------------------------
-- Do the actual voting    --------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function DoVote(VoterAlias,OfficeAlias,ApplicantAlias, ApplicantCnt)

	local ApplicantIDArray = {0,0,0,0}
	local ApplicantIDCnt = 0	
	local CommandIdx = 3
	local ButtonLabel = "@B[0,@L%"..CommandIdx.."SN]"
	ApplicantIDArray[ApplicantIDCnt] = GetID(ApplicantAlias..0)
	ApplicantIDCnt = ApplicantIDCnt + 1	
	CommandIdx = CommandIdx + 1	

--	Check if the Voter is maybe an applicant of the current office run, security task
	for CheckApp = 0,ApplicantCnt-1 do
		if (GetID(VoterAlias) == GetID(ApplicantAlias..CheckApp)) then
			return -1
		end
	end

	for App = 1, ApplicantCnt-1 do
		local SimExists = GetAliasByID(GetID(ApplicantAlias..App),"ExistingSim")
			
		if (GetID(VoterAlias) == GetID("ExistingSim")) then
			return -1
		end

		if(SimExists == true) then
			if officesession_SimIsInTownhall(ApplicantAlias..App) == true then
				ButtonLabel = ButtonLabel.."@B["..App..",@L"..GetName(ApplicantAlias..App).."]"
				ApplicantIDArray[ApplicantIDCnt] = GetID(ApplicantAlias..App)
				ApplicantIDCnt = ApplicantIDCnt + 1	
				CommandIdx = CommandIdx + 1				
			end
		end
	end

	ButtonLabel = ButtonLabel.."@B[-1,@L_SESSION_+0]"

	ButtonLabel = ButtonLabel.."@P"

	local Res

	Res = MsgSayInteraction(VoterAlias,VoterAlias,0,ButtonLabel,officesession_AIAbstimmung,"@L_SESSION_3_ELECT_PLAYER", VoterAlias, GetID(VoterAlias),ApplicantIDArray[0],ApplicantIDArray[1],ApplicantIDArray[2],ApplicantIDArray[3])
	if Res == "C" then
		Res = -1
	end
	officesession_SimCam(VoterAlias,0,0)	
	if Res ~= -1 then
--		SetData("votes"..Res, GetData("votes"..Res) + 1)
		PlayAnimationNoWait(VoterAlias, "sit_yes")
		MsgSay(VoterAlias, "@L_SESSION_3_ELECT_CHOISE_+0", GetID(ApplicantAlias..Res))
		ModifyFavorToSim(VoterAlias, ApplicantAlias..Res, 5)
--		SetData("VotedFor_"..GetDynastyID(VoterAlias),GetID("Applicant_"..CurrentOffice.."_"..Res))
	else
		PlayAnimationNoWait(VoterAlias, "sit_no")
		PlayAnimationNoWait(VoterAlias, "sit_talk_short")
		MsgSay(VoterAlias, "@L_SESSION_3_ELECT_CHOISE_+1")
	end
	
	-- bribed, needs to be changed later
	
	if HasProperty(VoterAlias,"BribedBy") then
		GetAliasByID(GetProperty(VoterAlias,"BribedBy"),"BribedBySim")
		if (Res ~= -1) then
			if (GetID(ApplicantAlias..Res) ~= GetProperty(VoterAlias,"BribedBy")) then
				SetFavorToSim(VoterAlias,"BribedBySim",GetFavorToSim(VoterAlias,"BribedBySim")-25)
			end
		else
			SetFavorToSim(VoterAlias,"BribedBySim",GetFavorToSim(VoterAlias,"BribedBySim")-10)
		end
		RemoveProperty(VoterAlias,"BribedBy")
	end
	
	Sleep(0.1)
	return Res
end

------------------------------------------------------------------------------------------------------------------------
-- Functions: Invitation    ------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- invite Applicants
function InviteApplicant(SimAlias)
	local WaitTime = math.floor(GetData("WaitTime") / 60)
	AddImpact(SimAlias, "OfficeTimer", 1, WaitTime)
	SimAddDate(SimAlias,"councilbuilding","Council Meeting", SettlementEventGetTime("council_date")-120,"AttendOfficeMeeting")
	feedback_MessagePolitics(SimAlias, "@L_SESSION_6_TIMEPLANNERENTRY_APPLICANT_+0", "@L_SESSION_6_TIMEPLANNERENTRY_APPLICANT_+1", GetID(SimAlias), GetID("settlement"))
	SimAddDatebookEntry(SimAlias,SettlementEventGetTime("council_date"),"councilbuilding","@L_SESSION_6_TIMEPLANNERENTRY_APPLICANT_+0", "@L_SESSION_6_TIMEPLANNERENTRY_APPLICANT_+1", GetID(SimAlias), GetID("settlement"))
end

-- invite current office holders
function InviteDepositionDefender(SimAlias, RunForOfficeSim)
	local WaitTime = math.floor(GetData("WaitTime") / 60)
	AddImpact(SimAlias, "OfficeTimer", 1, WaitTime)
	SimAddDate(SimAlias,"councilbuilding","Council Meeting", SettlementEventGetTime("council_date")-120,"AttendOfficeMeeting")
	-- only send 1 message if multiple guys run for your office
	if GetImpactValue(SimAlias, "SuppressDefenderMessage")==0 then
		AddImpact(SimAlias, "SuppressDefenderMessage",1,12)
		feedback_MessagePolitics(SimAlias, "@L_SESSION_ADDON_MESSAGE_HEAD_+0", "@L_SESSION_ADDON_MESSAGE_BODY", GetID(RunForOfficeSim),GetID("settlement"))
	end
	SimAddDatebookEntry(SimAlias,SettlementEventGetTime("council_date"),"councilbuilding","@L_SESSION_ADDON_MESSAGE_HEAD_+0","@L_SESSION_ADDON_MESSAGE_BODY_+1", GetID(RunForOfficeSim), GetID("settlement"))
end

-- invite Voters
function InviteAllVoters()
	if not AliasExists("InvitedSims") then
		ListNew("InvitedSims")
	end
	-- get all voters
	-- last parameter: 0 - All (voters and applicants), 1 - only office voters, 2 - only applicants 
	local VoterCnt = OfficePrepareSessionMembers("office","VoterList",1)
	
	--Filter out already invited voters
	for i=0, VoterCnt-1 do
		ListGetElement("VoterList",i,"Voter")
		if(ListContains("InvitedSims","Voter")) then
			ListRemove("VoterList","Voter")
		end
	end

	-- invite all remaining voters
	VoterCnt = ListSize("VoterList")
	for i=0, VoterCnt-1 do
		ListGetElement("VoterList",i,"Voter")
		ListAdd("InvitedSims","Voter")
		
		local WaitTime = math.floor(GetData("WaitTime") / 60)
		AddImpact("Voter", "OfficeTimer", 1, WaitTime)
		SimAddDate("Voter","councilbuilding","Council Meeting", SettlementEventGetTime("council_date")-120,"AttendOfficeMeeting")
		-- only send 1 message if you vote for multiple offices
		if GetImpactValue("Voter", "SuppressVoterMessage")==0 then 
			AddImpact("Voter", "SuppressVoterMessage",1,12)
			feedback_MessagePolitics("Voter", "@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+0", "@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+1", GetID("Voter"), GetID("settlement"))
		end
		SimAddDatebookEntry("Voter",SettlementEventGetTime("council_date"),"councilbuilding","@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+0", "@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+1", GetID("Voter"), GetID("settlement"))

	end
	
	RemoveAlias("Voter")
	RemoveAlias("VoterList")
end

------------------------------------------------------------------------------------------------------------------------
-- Functions: Is the sim valid?    ----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function CheckForValidOfficeRun(Office)
	--Check if the current rask have living applicants
	local Valid = false

	local ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")

	local DeadApplicants = 0
	
	if(ApplicantCnt ~= 0) then
		for i =0, ApplicantCnt, 1 do
			local CurrentApplicant = "Applicant"..i
			if (officesession_IsSimValid(CurrentApplicant) == false) then
				DeadApplicants = DeadApplicants + 1
			end
		end
	end

	if ( (DeadApplicants > 0) or (ApplicantCnt == 0) ) then
		if (DeadApplicants == ApplicantCnt) then
			Valid = false
		else
			Valid = true
		end
	else
		Valid = true
	end

	return Valid
end

-- checks if a sim is valid (alive)
function IsSimValid(SimAlias)
	if(AliasExists(SimAlias)) then
		if(GetState(SimAlias, STATE_DEAD) == false) then
			if(GetState(SimAlias, STATE_CAPTURED) == false) then
				if(GetState(SimAlias, STATE_UNCONSCIOUS) == false) then
					return true
				end
			end
		end
	end
	return false
end

--check if sim is in the offices session townhall
function SimIsInTownhall(SimAlias)
	if AliasExists(SimAlias) then
		if GetInsideBuilding(SimAlias,"currentbuilding") then
			if GetID("currentbuilding")==GetID("councilbuilding") then
				GetInsideRoom(SimAlias,"InsideRoom")
				BuildingGetRoom("councilbuilding","Judge","Room")
				if (GetID("Room") ~= GetID("InsideRoom")) then
					-- sim is in the wrong room
					return false
				else
					return true
				end
			else
				-- sim is in the wrong building
				return false
			end
		else
			-- sim is outside
			return false
		end
	else
		-- Alias error
		return false
	end
end

-- prepares the valid (available for the office meeting) applicants for the given office, returns the number of valid applicants
function OfficeGetApplicants(Office,ApplicantAlias)
	local APPLICANTS = 2
	OfficePrepareSessionMembers(Office,"ApplicantList",APPLICANTS)
	return officesession_BuildValidSimList("ApplicantList",ApplicantAlias)
end

-- prepares the valid (available for the office meeting) voters for the given office, returns the number of valid voters
function GetVoters(Office,VoterAlias)
 	local VOTERS = 1
	OfficePrepareSessionMembers(Office,"VoterList",VOTERS)
	return officesession_BuildValidSimList("VoterList",VoterAlias)
end

-- prepares the current office trees chairman with the given alias. Returns if a chairman exists or not
function GetChairman(ChairmanAlias)
	CityGetChairmanList("settlement","ChairmanList")
	local Size = ListSize("ChairmanList")
	
	for i=0, Size-1 do
		ListGetElement("ChairmanList",i,ChairmanAlias)
		if(officesession_IsSimValid(ChairmanAlias)and officesession_SimIsInTownhall(ChairmanAlias)) then
			-- remove the list
			RemoveAlias("ChairmanList")
			return true
		end
	end
	
	return false
	-- no valid chairman found, use the townclerk.
	--return officesession_XGetTownClerk(ChairmanAlias)
end

-- returns the count of valid applicants for the whole office session
function GetValidApplicantCount()
	local APPLICANTS = 2
 	CityGetOfficeSessionMemberList("settlement","ApplicantList",APPLICANTS)
 	officesession_PrepareValidSimList("ApplicantList")
 	local ApplicantCnt = ListSize("ApplicantList")
 	-- remove the list
 	RemoveAlias("ApplicantList")
 	return ApplicantCnt
end

-- prepares the alias of all valid sims in the given list
function BuildValidSimList(ListAlias,Alias)

	local Size = officesession_PrepareValidSimList(ListAlias)
	
	for i=0, Size-1 do
		ListGetElement(ListAlias,i,Alias..i)
	end

	return Size
end

-- removes all invalid sims from the given list
function PrepareValidSimList(ListAlias)
	-- remove all invalid objects
	local Size = ListSize(ListAlias)

	for i=Size-1,0,-1 do
		ListGetElement(ListAlias, i,"ListSim")
		if(not officesession_IsSimValid("ListSim")) then
			ListRemove(ListAlias,"ListSim")
		end
	end
	-- Remove the list sim alias
	RemoveAlias("ListSim")
	Size = ListSize(ListAlias)
	return Size
end

------------------------------------------------------------------------------------------------------------------------
-- Functions for moving Voters and Applicants to their seats -------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
function VoterAttend(Id)
	
	SimStopMeasure("")
	
	if LocatorStatus("councilbuilding","TableChair"..Id,true)==1 then
		SetData("Office_Sims_"..GetID("").."Seat","TableChair"..Id)
		-- add some extra life for the session to avoid early dieing
		AddImpact("","LifeExpanding",4,8)
		
		-- sit down
		if(GetLocatorByName("councilbuilding", "TableChair"..Id, "TableChair")) then
			if not f_BeginUseLocator("","TableChair", GL_STANCE_SIT, true) then
				-- failed to reach the seat. move to the next one first and try again
				local Id2 = Id+1
				GetLocatorByName("councilbuilding", "TableChair"..Id2, "TableChair2")
				f_MoveTo("","TableChair2")
				f_BeginUseLocator("","TableChair", GL_STANCE_SIT, true)
				CutsceneSendEventTrigger("owner", "Reached")
			else
				CutsceneSendEventTrigger("owner", "Reached")
			end
		end		
	end
end

function ApplicantAttend(Id)

	SimStopMeasure("")

	if LocatorStatus("councilbuilding","BenchChair"..Id,true)==1 then
		SetData("Office_Sims_"..GetID("").."Seat","BenchChair"..Id)
		-- add some extra life for the session to avoid early dieing
		AddImpact("","LifeExpanding",4,8)
		
		-- sit down
		if(GetLocatorByName("councilbuilding", "BenchChair"..Id, "BenchChair")) then
			if not f_BeginUseLocator("","BenchChair", GL_STANCE_SITBENCH, true) then
				-- failed to reach the seat. move to the next one first and try again
				local Id2 = Id+1
				GetLocatorByName("councilbuilding", "BenchChair"..Id2, "BenchChair2")
				f_MoveTo("","BenchChair2")
				f_BeginUseLocator("","BenchChair", GL_STANCE_SITBENCH, true)
				CutsceneSendEventTrigger("owner", "Reached")
			else
				CutsceneSendEventTrigger("owner", "Reached")
			end
		end		
	end
end

function SpecialSimAttend(Locator)

	SimStopMeasure("")
	SetData("Office_Sims_"..GetID("").."Seat",Locator)
	-- add some extra life for the session to avoid early dieing
	AddImpact("","LifeExpanding",4,8)
	
	-- sit down
	if(GetLocatorByName("councilbuilding", Locator, "Locator")) then
		f_BeginUseLocator("","Locator", GL_STANCE_SIT, true)
	end
	CutsceneSendEventTrigger("owner", "Reached")
end

------------------------------------------------------------------------------------------------------------------------
-- Save the Votes ---------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- saves the result of the given vote
function SaveVoteResult(OfficeAlias,WinnerAlias)
 -- sollte der Gewinner ebenfalls in der Amtswahl um sein altes Amt vertreten sein, wird er aus der Wahlliste für dieses Amt gelöscht
	if(SimGetOffice(WinnerAlias,"CurrentOffice") == true) then
		OfficeRemoveApplicant("CurrentOffice",WinnerAlias)
	end

	-- Speichern des Voteergebnisses
	local VoteCacheIdx = GetData("VoteCacheIdx")
	SetData("VoteCacheOfficeID"..VoteCacheIdx,OfficeGetIdx(OfficeAlias))
	SetData("VoteCacheOfficeLevel"..VoteCacheIdx,OfficeGetLevel(OfficeAlias))
	SetData("VoteCacheWinnerID"..VoteCacheIdx,GetID(WinnerAlias))
	VoteCacheIdx = VoteCacheIdx + 1
	SetData("VoteCacheIdx",VoteCacheIdx)

end

-- executes all saved vote results
function WriteVotes()
	local VoteCacheIdx = GetData("VoteCacheIdx")
	
	for i=0,VoteCacheIdx-1 do
		CityGetOffice("Settlement",GetData("VoteCacheOfficeLevel"..i),GetData("VoteCacheOfficeID"..i),"Office")
		GetAliasByID(GetData("VoteCacheWinnerID"..i),"Holder")
		-- setzen des neuen office holders, richtigstellen aller relevanten beziehungen, privilegien etc.
		CityEndOfficeElection("Settlement","Office","Holder")
		xp_RunForAnOffice("Holder", OfficeGetLevel("Office"))	
	end
end

------------------------------------------------------------------------------------------------------------------------
-- Camera Functions -----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function OverviewCam()
	if( GetData("KingTask") == 0 ) then
		officesession_TotalCam(1,0,0)
	else
		officesession_TotalKingCam(1,0,0)
	end
end

function TotalCam(totalnum,blend,duration)
	if blend == 1 then
		officesession_DoBlend(duration,1)
	end
	officesession_Cam("Total"..totalnum.."_start")
	if blend == 1 then
		Sleep(duration + 0.1)
	end
	officesession_DoBlend(15,1)
	officesession_Cam("Total"..totalnum.."_end")
end

function TotalKingCam(totalnum,blend,duration)
	if blend == 1 then
		officesession_DoBlend(duration,1)
	end
	officesession_Cam("ConCamT3")
end

function BlendCamTo(locator,blend,duration)
	if blend > 0 then
		officesession_DoBlend(duration,blend)
	end
	officesession_Cam(locator)
end

function SetTableCam()
	officesession_Cam("ConCamT"..(Rand(4) + 1))
end

function SetBenchCam(Voter)
	officesession_Cam("ConCamClose"..(Rand(2) + 2))
end

function DoBlend(a,b)
	CutsceneCameraBlend("",a,b)
end

function Cam(LocatorName)
	GetLocatorByName("councilbuilding",LocatorName,"DestPos")
	CutsceneCameraSetAbsolutePosition("","DestPos")
end

function SimCam(character, blending, duration)
	if blending then
		if duration then
			CutsceneCameraBlend("",duration,blending)
		else
			CutsceneCameraBlend("",1.0,blending)
		end
	else
		CutsceneCameraBlend("",1.0,2)
	end
	CutsceneCameraSetRelativePosition("","CloseUpSit",character)
end

function OnCameraEnable()
	BuildingGetRoom("councilbuilding","Judge","Room")
	CutsceneHUDShow("","LetterBoxPanel")
	HudClearSelection()

	if GetLocalPlayerDynasty("playerdyn")	then
		for i=0,DynastyGetMemberCount("playerdyn")-1 do
			if DynastyGetMember("playerdyn",i,"member") then
				GetInsideRoom("member","InsideRoom")
				if (GetID("Room") ~= GetID("InsideRoom")) then
					HudAddToSelection("member")
					return true
				end
			end
		end
	end
end

function OnCameraDisable()
	CutsceneHUDShow("","LetterBoxPanel",false)
	CutsceneHUDShow("","OfficeApplicationPanel",false)
	HudCancelUserSelection()
	HudClearSelection()
	HudAddToSelection("councilbuilding")
end

------------------------------------------------------------------------------------------------------------------------
-- AI DECISSION Functions ----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function AIBedrohung()
	if(GetSkillValue("", RHETORIC)>5) or SimGetAlignment("")>65 then
		return "A"
	else
		return "Z"
	end
end

--ai voting for application
function AIAbstimmung(Params)
	local VoterAlias = Params[1]
	local App
	local Best = -1
	local MaxFav = -999
	local ApplicantCnt = officesession_OfficeGetApplicants(GetData("CurrentOffice"),"Applicant")
	
	for App = 0, ApplicantCnt-1 do
	
		local CurrentApplicant = "Applicant"..App
		
		-- basevalue, higher for family
		local BaseValue = 50
		if GetDynastyID(VoterAlias) == GetDynastyID(CurrentApplicant) then
			BaseValue = 150
		end
		
		--favor
		local Favor = GetFavorToSim(VoterAlias,CurrentApplicant)
		
		-- rhetoric of Applicant
		local RhetSkill = GetSkillValue(CurrentApplicant, RHETORIC)
		
		-- title difference. I prefer to vote for people higher than me
		local Title = GetNobilityTitle(CurrentApplicant)-GetNobilityTitle(VoterAlias,false)
		
		-- bribed? 100% Still to do
		
		local Bribery = 1
		
		-- Alliance? 100%
		local AllyBonus = 1
		if DynastyGetDiplomacyState(VoterAlias,CurrentApplicant)==DIP_NAP then
			AllyBonus = 1.1
		elseif DynastyGetDiplomacyState(VoterAlias,CurrentApplicant)==DIP_ALLIANCE then
			AllyBonus = 2
		end
		
		-- current office holder bonus 5%. Only applies if I have at least 50 favor, otherwise -5%
		local CurrentOfficeBonus = 1
		if SimGetOffice(CurrentApplicant,"ExistingSimOffice") then
			if (GetID("ExistingSimOffice") == GetID(GetData("CurrentOffice"))) then
				if GetFavorToSim(VoterAlias,CurrentApplicant)>=50 then
					CurrentOfficeBonus = 1.05
				else
					CurrentOfficeBonus = 0.95
				end
			end
		end
		
		-- political attention perk 10%
		local PoliticalAttention = 1
		if GetImpactValue(CurrentApplicant, "PoliticalAttention")>0 or Title >= 7 then -- title 7 to be sure this works
			PoliticalAttention = 1.1
		end
		
		-- local club president talent 10%
		local TalentBonus = 1
		if GetImpactValue(CurrentApplicant,"CutsceneFavor")>0 then
			TalentBonus = 1.1
		end
		
		-- present?
		local IsPresent = 1
		if not officesession_SimIsInTownhall(CurrentApplicant) then
			IsPresent = 0.1
		end
		
		-- feud?
		local Feud = 1
		if DynastyGetDiplomacyState(VoterAlias,CurrentApplicant)==DIP_FOE then
			Feud = 0
		end
		
		-- Calculation
		local Fav = (((((((BaseValue+(Favor*1.5)+(RhetSkill*1.25)+Title)*Bribery)*AllyBonus)*CurrentOfficeBonus)*PoliticalAttention)*TalentBonus)*IsPresent)*Feud
		if Fav > MaxFav then
			Best = App
			MaxFav = Fav
		elseif Fav == MaxFavor then
			Best = -1
		end
	end
	
	return Best
end

------------------------------------------------------------------------------------------------------------------------
-- Functions for Voters and Applicants to leave bulding ----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function SimLeaveTownhall()
	BuildingGetRoom("councilbuilding","Judge","Room")
	RoomGetInsideSimList("Room","SimList")

	local SimCnt = ListSize("SimList")
	local totalCount = 0
	
	for i=0,SimCnt-1 do
		ListGetElement("SimList",i,"Sim")
		if HasData("UsherSession") then
			if SimGetProfession("Sim") ~= 18 then
				if HasProperty("Sim", "BUILDING_NPC") and GetProperty("Sim", "BUILDING_NPC") == 2 then
					totalCount = totalCount + 1
					CutsceneCallThread("","SimLeave","Sim")
				else
					totalCount = totalCount + 1
					CutsceneCallThread("","SimLeave","Sim")
				end
			end
		else
			if not HasProperty("Sim", "BUILDING_NPC") and SimGetProfession("Sim") ~= 18 then
				totalCount = totalCount + 1
				CutsceneCallThread("","SimLeave","Sim")
			end
		end
	end
	
	return totalCount
end

function SimLeave()
	f_EndUseLocator("",GetData("Office_Sims_"..GetID("").."Seat"))
	CutsceneSendEventTrigger("owner", "OutOfBuilding")
	if HasProperty("", "BUILDING_NPC") then
		if GetProperty("", "BUILDING_NPC") == 2 then
			SimSetBehavior("", "townhallguard1")
			return
		else
			return
		end
	else
		SimResetBehavior("")
		if (DynastyIsAI("")) then
			AllowAllMeasures("")
			if Rand(4) == 1 then
				f_StrollNoWait("", 400, 4)
				return
			end
			if Rand(4) == 0 then
				idlelib_GoHome("")
				return
			end
		end
	end
end

function SimExitBuilding()
	CutsceneSendEventTrigger("owner", "Reached")
	f_ExitCurrentBuilding("")
	CutsceneRemoveSim("owner","")
	SimResetBehavior("Sim")
	if DynastyIsAI("") then
		AllowAllMeasures("Sim")
	end
end

-- kick out sims
function SimLeaveBuilding(SimAlias)
	if officesession_SimIsInTownhall(SimAlias)== true  then
		feedback_MessagePolitics(SimAlias,"@L_TOWNHALL_CLOSED_HEADER_+0","@L_TOWNHALL_CLOSED_TEXT_+0",GetID(SimAlias))
		CutsceneCallThread("", "SimExitBuilding", SimAlias)
		return 1
	end
	return 0
end

------------------------------------------------------------------------------------------------------------------------
-- Clean Up         ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function UnlockAll()
	officesession_DoBlend(0.1,0)
	OfficeSetBlock("office", false)
end

function QuitCutscene()
	officesession_UnlockAll()
	EndCutscene("")
end

function CleanUp()
	RemoveProperty("councilbuilding","CutsceneAhead")
	BuildingGetRoom("councilbuilding","Judge","Room")
	RoomLockForCutscene("Room",0)
	-- entfernen aller Bewerber
	CityEndOfficeElection("settlement","",nil)
	RemoveProperty("councilbuilding","sessioncutszene")
end