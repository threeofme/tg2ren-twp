-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_presession.lua"
----
----	Behavior of all Sims which are attended to a current Office Session
----	Talk about Application/Deposition.
----	AI Interactions
----
-------------------------------------------------------------------------------

Include("Cutscenes/OfficeSession.lua")

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	if SimGetCutscene("","cutscene") then
		SimResetBehavior("")
		return
	end
	if DynastyIsAI("") then
		SimSetProduceItemID("", -1, -1)
		BlockChar("")
		AllowMeasure("","StartDialog",EN_PASSIVE)
		AllowMeasure("","BribeCharacter",EN_BOTH)
		AllowMeasure("","MakeACompliment",EN_BOTH)
		AllowMeasure("","Flirt",EN_BOTH)
		AllowMeasure("","UsePoem",EN_BOTH)
		AllowMeasure("","UseCake",EN_PASSIVE)
		AllowMeasure("","MakeAPresent",EN_PASSIVE)
	end
	
	-- session is over or did not happen, leave building
	local currentGameTime = math.mod(GetGametime(),24)
	if currentGameTime >19 then
		if DynastyIsAI("") then
			f_ExitCurrentBuilding("")
			SimSetBehavior("","idle")
			return
		end
	end

	if not GetProperty("","destination_ID") then
		OutputDebugString("no destination presession")
		SimResetBehavior("")
		return
	end
	GetSettlement("","Settlement")
	CityGetBuildings("Settlement", -1, 23, -1, -1, FILTER_IGNORE, "destination_tmp")
	BuildingGetRoom("destination_tmp0", "Judge", "destination")
	--CopyAlias("destination_tmp0","destination")	

	local WhoAmI = behavior_presession_GetCutscenePossition()

	while true do

		if math.mod(GetGametime(),24)>=17 then
			SimResetBehavior("")
			return
		end

		local IsAtPlace = 0
		local DistanceToDestination = GetDistance("", "destination")
		local MoveSpeed = GL_MOVESPEED_WALK
		
		if GetInsideRoom("","InsideRoom")==true then
			if (GetID("destination") == GetID("InsideRoom")) then
				if (HasProperty("","HaveCutscene") == true) then
					RemoveProperty("","HaveCutscene")
				end
				IsAtPlace = 1
--		Check who the Sim is in the Session, in fact that he can be in the jury and/or run for an office and/or be deselected. 1/2/4 System

		--		if you are an deposist do this
				if ((WhoAmI == 2) or (WhoAmI == 3) or (WhoAmI == 6) or (WhoAmI == 7)) then
					behavior_presession_ActionsForDeposition()
				end

		--		if you are an applicant do this
				if ((WhoAmI >= 4) and (WhoAmI <= 7)) then
					behavior_presession_ActionsForApplication()
				end

		--		if you are in the jury do this
				if ((WhoAmI == 1) or (WhoAmI == 3) or (WhoAmI == 5) or (WhoAmI == 7)) then
					behavior_presession_ActionsForJury()
				end

			else
	
				if DistanceToDestination > 3000 or DistanceToDestination == -1 then
				MoveSpeed = GL_MOVESPEED_RUN
				end
				f_WeakMoveTo("","destination",MoveSpeed)
			end
		else 
				if DistanceToDestination > 3000 or DistanceToDestination == -1 then
				MoveSpeed = GL_MOVESPEED_RUN
				end
				f_WeakMoveTo("","destination",MoveSpeed)
		end

		if IsAtPlace == 0 then
			
			if DistanceToDestination > 3000 or DistanceToDestination == -1 then
				MoveSpeed = GL_MOVESPEED_RUN
			end
--			f_ExitCurrentBuilding("")
			f_WeakMoveTo("","destination",MoveSpeed)
			return
		end
		Sleep(1.0)
	end
end

-----------------------
--      ACTIONS
-----------------------

function ActionsForJury()
	local action = Rand(4)
--	local action = 0

	if DynastyIsPlayer("") then
		action = -1
	end

	if (action == 0) then --Talk to a deplicant ask about his deposition
		behavior_presession_TalkToDeposition()
	end

	if (action == 1) then --Talk to any Sim that attends to the meeting
		behavior_presession_TalkToAnySim()
	end

	if (action == 2) then --Talk about the office application
		behavior_presession_TalkAboutTheApplication()
	end

	if (action == 3) then -- Einfach nur am Kopf kratzen
		behavior_presession_Cogitate()
	end

	Sleep(Rand(5)+10)
end

function ActionsForDeposition()
	local action = Rand(4)
--	local action = 0

	if DynastyIsPlayer("") then
		action = -1
	end

--	if (action ~= -1) then --always try to corrupt the frsy first
--		behavior_presession_CorruptTheJurry()
--	end

	if (action == 0) then --Talk to a deplicant ask about his deposition
		behavior_presession_TalkToDeposition()
	end

	if (action == 1) then --Talk to any Sim that attends to the meeting
		behavior_presession_TalkToAnySim()
	end

	if (action == 2) then --Talk about the office application
		behavior_presession_TalkAboutTheApplication()
	end

	if (action == 3) then -- Einfach nur am Kopf kratzen
		behavior_presession_Cogitate()
	end

	Sleep(Rand(5)+10)
end

function ActionsForApplication()
	local action = Rand(4)
--	local action = 0

	if DynastyIsPlayer("") then
		action = -1
	end

--	if (action ~= -1) then --always try to corrupt the jury first
--		behavior_presession_CorruptTheJurry()
--	end

	if (action == 0) then --Talk to a deplicant ask about his deposition
		behavior_presession_TalkToDeposition()
	end

	if (action == 1) then --Talk to any Sim that attends to the meeting
		behavior_presession_TalkToAnySim()
	end

	if (action == 2) then --Talk about the office application
		behavior_presession_TalkAboutTheApplication()
	end

	if (action == 3) then -- Einfach nur am Kopf kratzen
		behavior_presession_Cogitate()
	end

	Sleep(Rand(5)+10)
end

-----------------------
--      FUNCTIONS
-----------------------

function TalkToDeposition()
	GetSettlement("","Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("Settlement","OfficeList",false)	
	
--	Get all sims which office is on the tasklist

	local DepArray = {}
	local DepArrayCount = 0	
	
	for i=0,NumOfVotes - 1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local ApplicantCntCnt = officesession_OfficeGetApplicants("OfficeToCheck","Applicant")
	    if(ApplicantCntCnt > 0) then
	    	for j=0,ApplicantCntCnt - 1 do
	    		local ApplicantAlias = "Applicant"..j
				if GetID(ApplicantAlias) ~= GetID("") then
					if SimGetOffice(ApplicantAlias,"SimOfficeAlias") and GetID("SimOfficeAlias") == GetID("OfficeToCheck") then
						DepArray[DepArrayCount] = GetID(ApplicantAlias)
						DepArrayCount = DepArrayCount + 1
						break
					end
				end
	    	end
	    end
	end
	 
--	Pick a random SIM from the Array list and make some if stuff to check if he exists, is in the building and can be interrupted and he is not the curretn SIM that want to interrupt him (owner), and if he is AI
		
	if (DepArrayCount > 0) then
		local CurrentDeplicant = DepArray[Rand(DepArrayCount)]

		local SimExist = GetAliasByID(CurrentDeplicant,"DepAlias")

		if (SimExist == true) then
			if GetState("DepAlias", STATE_DEAD) == false then
				if GetInsideRoom("DepAlias","InsideRoom") then
					if CanBeInterruptetBy("","DepAlias","BribeCharacter") == true then
						if (GetID("destination") == GetID("InsideRoom")) then
							if (GetID("") ~= GetID("DepAlias") and DynastyIsAI("DepAlias")) then
								
	--							This Property sets an "Use" Variable for the SIM, so that other sims that have this behavior cannot Talk to him too
	
								if not HasProperty("DepAlias","OffUse") then
									SetProperty("DepAlias","OffUse",0)
								end
								
								if (GetProperty("DepAlias","OffUse") <= 0) then
									
									SetProperty("DepAlias","OffUse",GetID(""))
									SetProperty("","OffUse",1)
									
									if SimGetCutscene("","cutscene") then
									--	SimSetBehavior("","")
										return
									else									
										f_WeakMoveTo("","DepAlias",GL_MOVESPEED_WALK,128)
									end
									
									if (GetProperty("DepAlias","OffUse") == GetID("")) then
										
										AlignTo("","DepAlias")
										AlignTo("DepAlias","")
	
										LoopAnimation("", "talk", -1)
										MsgSay("", "@L_SESSION_ADDON_COMMENTS_NEUTRAL")
										StopAnimation("")
	
										LoopAnimation("DepAlias", "talk", -1)
										MsgSay("DepAlias", "@L_ATTENDOFFICE_TEXT1_ANSWER")
										StopAnimation("DepAlias")
	
										AlignTo("DepAlias")
										
										RemoveProperty("DepAlias","OffUse")
										
										GetFleePosition("","DepAlias",Rand(100)+300,"MyPoss")
										if SimGetCutscene("","cutscene") then
										--	SimSetBehavior("","")
											return
										else
											f_WeakMoveTo("","MyPoss")
										end
										RemoveProperty("","OffUse",0)
									else
										RemoveProperty("","OffUse",0)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function TalkToAnySim()

--	Get All SIMS that are involved in the current Office Session, pikc a random one and make some if stuff
	GetSettlement("","Settlement")
	CityGetOfficeSessionMemberList("Settlement","SimOfficeList",0)
	
	local SimCnt = ListSize("SimOfficeList")
	
	ListGetElement("SimOfficeList",Rand(SimCnt),"VoterAlias")
	
	if GetState("VoterAlias", STATE_DEAD) == false then
		if GetInsideRoom("VoterAlias","InsideRoom") then
			if CanBeInterruptetBy("","VoterAlias","BribeCharacter") == true then
				if (GetID("destination") == GetID("InsideRoom")) then
					if (GetID("") ~= GetID("VoterAlias") and DynastyIsAI("VoterAlias")) then
						
						if not HasProperty("VoterAlias","OffUse") then
							SetProperty("VoterAlias","OffUse",0)
						end
						
						if (GetProperty("VoterAlias","OffUse") <= 0) then
							
							SetProperty("VoterAlias","OffUse",GetID(""))
							SetProperty("","OffUse",1)
							
							if SimGetCutscene("","cutscene") then
							--	SimSetBehavior("","")
								return
							else
								f_WeakMoveTo("","VoterAlias",GL_MOVESPEED_WALK,128)
							end							
							
							if (GetProperty("VoterAlias","OffUse") == GetID("")) then
								AlignTo("","VoterAlias")
								AlignTo("VoterAlias","")
	
								LoopAnimation("", "talk", -1)
								MsgSay("", "@L_ATTENDOFFICE_TEXT2_QUESTION")
								StopAnimation("")
	
								LoopAnimation("VoterAlias", "talk", -1)
								MsgSay("VoterAlias", "@L_ATTENDOFFICE_TEXT2_ANSWER")
								StopAnimation("VoterAlias")
	
								AlignTo("VoterAlias")
								RemoveProperty("VoterAlias","OffUse")
								
								GetFleePosition("","VoterAlias",Rand(100)+300,"MyPoss")
								
								if SimGetCutscene("","cutscene") then
							--		SimSetBehavior("","")
									return
								else									
									f_WeakMoveTo("","MyPoss")
								end
								
								RemoveProperty("","OffUse")
							else
								RemoveProperty("","OffUse")
							end
						end
					end
				end
			end
		end
	end
end

function TalkAboutTheApplication()

--	Get All SIMS that are involved in the current Office Session, pikc a random one and make some if stuff
	GetSettlement("","Settlement")
	CityGetOfficeSessionMemberList("Settlement","SimOfficeList",0)
	
	local SimCnt = ListSize("SimOfficeList")
	
--	Voteralias == The Sim that i Talk to about the sim "AppAlias"	
	ListGetElement("SimOfficeList",Rand(SimCnt),"VoterAlias")
	
	CityGetOfficeSessionMemberList("Settlement","SimAppList",2)
	local SimAppCnt = ListSize("SimAppList")
	
	ListGetElement("SimAppList",Rand(SimAppCnt),"AppAlias")

	if GetInsideRoom("VoterAlias","InsideRoom") then
		if CanBeInterruptetBy("","VoterAlias","BribeCharacter") == true then
			if (GetID("destination") == GetID("InsideRoom")) then
				if (GetID("") ~= GetID("VoterAlias") and (GetID("") ~= GetID("AppAlias")) and DynastyIsAI("VoterAlias")) then
					
					if not HasProperty("VoterAlias","OffUse") then
						SetProperty("VoterAlias","OffUse",0)
					end
					
					if (GetProperty("VoterAlias","OffUse") <= 0) then
						
						SetProperty("VoterAlias","OffUse",GetID(""))
						SetProperty("","OffUse",GetID(""))
						
						if SimGetCutscene("","cutscene") then
					--		SimSetBehavior("","")
							return
						else						
							f_WeakMoveTo("","VoterAlias",GL_MOVESPEED_WALK,128)
						end
						
						if (GetProperty("VoterAlias","OffUse") == GetID("")) then
							AlignTo("","VoterAlias")
							AlignTo("VoterAlias","")

							LoopAnimation("", "talk", -1)
							MsgSay("", "@L_ATTENDOFFICE_TEXT3_QUESTION",GetID("AppAlias"))
							StopAnimation("")

							LoopAnimation("VoterAlias", "talk", -1)
							MsgSay("VoterAlias", "@L_ATTENDOFFICE_TEXT3_ANSWER")
							StopAnimation("VoterAlias")

							AlignTo("VoterAlias")
							RemoveProperty("VoterAlias","OffUse")
							GetFleePosition("","VoterAlias",Rand(100)+300,"MyPoss")
							
							if SimGetCutscene("","cutscene") then
							--	SimSetBehavior("","")
								return
							else									
								f_WeakMoveTo("","MyPoss")
							end
								
							RemoveProperty("","OffUse")
						else
							RemoveProperty("","OffUse")
						end
					end
				end
			end
		end
	end
end


function CorruptTheJurry()
	GetSettlement("","Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("Settlement","OfficeList",false)

--	Put all Voters into one Array

	local JuryArray = {}
	local JuryArrayCount = 0	
	
	for i=0,NumOfVotes - 1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local VoterCnt = officesession_GetVoters("OfficeToCheck","Voter")
	    if(VoterCnt > 0) then
	    	for j=0,VoterCnt - 1 do
	    		local VoterAliasID = GetID("Voter"..j)
	    		local ExistsInList = false
	    		for k=0,JuryArrayCount - 1 do
	    			if JuryArray[k] == VoterAliasID then
	    				ExistsInList = true
	    				break
	    			end
	    		end
	    		if ExistsInList == false then
	    			JuryArray[JuryArrayCount] = VoterAliasID
	    			JuryArrayCount = JuryArrayCount + 1
	    		end
	    	end
	    end
	end
	
--	Find the Best Jury member that can be easy bribed
	
	local MinFavor = 51
	local MinVoterID = -1
	local LowFavorFactor = 20
	local LowFavor = 0
	local LowVoterID = -1
	for CurrentVoter = 0, JuryArrayCount - 1 do
		local Jury = JuryArray[CurrentVoter]
		GetAliasByID(Jury,"JuryAlias")
		local Favor = GetFavorToSim("JuryAlias","")
		if (Favor < MinFavor) then
			if (Favor > LowFavorFactor) then
				MinFavor = Favor
				MinVoterID = Jury
			else
				if (Favor > LowFavor) then
					LowFavor = Favor
					LowVoterID = Jury
				end
			end
		end
	end

	local TargetJury = -1

	if (MinVoterID > -1) then
		TargetJury = MinVoterID
	elseif (LowVoterID > -1) then
		TargetJury = LowVoterID
	end
	
	if (TargetJury ~= -1) then
		local SimExist = GetAliasByID(TargetJury,"VoterAlias")
	
		if (SimExist == true) then
			if GetInsideRoom("VoterAlias","InsideRoom") then
				if CanBeInterruptetBy("","VoterAlias","BribeCharacter") == true then
					if (GetID("destination") == GetID("InsideRoom")) then
						if (GetID("") ~= GetID("VoterAlias") and DynastyIsAI("VoterAlias")) then
							
							if not HasProperty("VoterAlias","OffUse") then
								SetProperty("VoterAlias","OffUse",0)
							end
							
							if (GetProperty("VoterAlias","OffUse") <= 0) then
								--AIExecutePlan("", "OfficeSession", "SIM", "","Office_Destination","destination")
								Sleep(1)
							end
							
						end
					end
				end
			end
		end
	end
end


function GetCutscenePossition()
	GetSettlement("","Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("Settlement","OfficeList",false)

	local Iam = 0
	
	
--	Check if the SIM is in the Jury to Vote
	local Found = false
	
	for i=0,NumOfVotes - 1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local VoterCnt = officesession_GetVoters("OfficeToCheck","Voter")
	    if(VoterCnt > 0) then
	    	for j=0,VoterCnt - 1 do
	    		local VoterAlias = "Voter"..j
				if GetID(VoterAlias) == GetID("") then
					Found = true
					Iam = Iam + 1
					break
				end
	    	end
	    end
	    if Found then break end
	end

--	Check if the SIM is an Applicant for the Office that he allready own
	local Found = false
	
	for i=0,NumOfVotes - 1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local ApplicantCntCnt = officesession_OfficeGetApplicants("OfficeToCheck","Applicant")
	    if(ApplicantCntCnt > 0) then
	    	for j=0,ApplicantCntCnt - 1 do
	    		local ApplicantAlias = "Applicant"..j
				if GetID(ApplicantAlias) == GetID("") then
					if SimGetOfficeID("") == GetID("OfficeToCheck") then
						Found = true
						Iam = Iam + 2
						break
					end
				end
	    	end
	    end
	    if Found then break end
	end
	
--	Check if the SIM is an Applicant for an Office
	local Found = false
	
	for i=0,NumOfVotes - 1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local ApplicantCntCnt = officesession_OfficeGetApplicants("OfficeToCheck","Applicant")
	    if(ApplicantCntCnt > 0) then
	    	for j=0,ApplicantCntCnt - 1 do
	    		local ApplicantAlias = "Applicant"..j
				if GetID(ApplicantAlias) == GetID("") then
					if SimGetOfficeID("") ~= GetID("OfficeToCheck") then
						Found = true
						Iam = Iam + 4
						break
					end
				end
	    	end
	    end
	    if Found then break end
	end	
	
	return 	Iam
end


function Cogitate()
	PlayAnimation("","cogitate")
end

