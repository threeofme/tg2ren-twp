-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_pretirl.lua"
----
----	Behavior of all Sims which are attended to a current Trial
----	AI Interactions
----	
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	if SimGetCutscene("","cutscene") then
		LogMessage("AITWP::PRETRIAL cutscene is active "..GetName(""))
		SimResetBehavior("")
		return
	end
	if not GetProperty("","trial_destination_ID") then
		LogMessage("no destination pretrial")
		SimResetBehavior("")
		return
	end	
	GetAliasByID(GetProperty("","trial_destination_ID"),"destination")
	BuildingGetRoom("destination","Judge","judgeroom")
	if not GetProperty("judgeroom","NextTrialCutsceneID") then
		LogMessage("no trial_destination_ID for pretrial")
		SimResetBehavior("")
		return
	end
	

	local CutsceneID = GetProperty("judgeroom","NextTrialCutsceneID")
	GetAliasByID(CutsceneID,"CutsceneAlias")

	if DynastyIsPlayer("") then
		return
	end
	
	if DynastyIsAI("") then
		--LogMessage("AITWP::PRETRIAL Blocking AI: "..GetName(""))
		SimSetProduceItemID("", -1, -1)
		AllowMeasure("","StartDialog",EN_PASSIVE)
		AllowMeasure("","BribeCharacter",EN_BOTH)
		AllowMeasure("","MakeACompliment",EN_BOTH)
		AllowMeasure("","Flirt",EN_BOTH)
		AllowMeasure("","UsePoem",EN_BOTH)
		AllowMeasure("","UseCake",EN_PASSIVE)
		AllowMeasure("","MakeAPresent",EN_PASSIVE)
	end

	local judge = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","judge")
	local accuser = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","accuser")
	local accused = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","accused")
	local assessor1 = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","assessor1")
	local assessor2 = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","assessor2")
	
	if (HasProperty("","HaveCutscene") == true) then
		RemoveProperty("","HaveCutscene")
	end
	
	while true do
		local IsAtPlace = 0
		if GetInsideRoom("","InsideRoom") then
			if (GetID("judgeroom") == GetID("InsideRoom")) then
				IsAtPlace = 1
		--		if you are the judge do this
				if (GetID("") == judge) then
					behavior_pretrial_ActionsForJudge()
				end
		
		--		if you are the accuser do this
				if (GetID("") == accuser) then
					behavior_pretrial_ActionsForAccuser()
				end
		
		--		if you are the accused do this
				if (GetID("") == accused) then
					behavior_pretrial_ActionsForAccused()
				end
		
		--		if you are the assessor1 do this
				if (GetID("") == assessor1) then
					behavior_pretrial_ActionsForAssessor()
				end
		
		--		if you are the assessor2 do this
				if (GetID("") == assessor2) then
					behavior_pretrial_ActionsForAssessor()
				end
			end
		end
		
		if IsAtPlace == 0 then
			local DistanceToDestination
			local MoveSpeed = GL_MOVESPEED_WALK
			if (GetInsideBuilding("","InsideBuilding")) then
				f_ExitCurrentBuilding("")
			end
			DistanceToDestination = GetDistance("", "judgeroom")
			if DistanceToDestination > 3000 or DistanceToDestination == -1 then
				MoveSpeed = GL_MOVESPEED_RUN
			end
			f_WeakMoveTo("","judgeroom",MoveSpeed)
		end		

		Sleep(Rand(5)+3)
	end
--	Sleep(1000000)
end

function GetDataFromCutscene(CutsceneAlias,Data)
	CutsceneGetData(CutsceneAlias,Data)
	local returnData = GetData(Data)
	return returnData
end


function ActionsForJudge()
	BuildingGetRoom("destination","Judge","judgeroom")
	local action = Rand(3)

	if (action == 0) then
		action = 1
--		PlayAnimation("","cogitate")
	end

	if (action == 1) then

		RoomGetInsideSimList("judgeroom","visitor_list")

		local skip = 0

		local i
		local num = ListSize("visitor_list")
		ListGetElement("visitor_list",Rand(num),"TalkToAlias")

		if (HasProperty("TalkToAlias","BUILDING_NPC")) then
			skip = 1
		end

		if (skip == 0) then  -- Talk to anyone in the counting hall, neutral talk
			if (GetID("") ~= GetID("TalkToAlias") and not DynastyIsPlayer("TalkToAlias")) then
				if CanBeInterruptetBy("","TalkToAlias","BribeCharacter") == true then
					if not HasProperty("TalkToAlias","TrialUse") then
						SetProperty("TalkToAlias","TrialUse",0)
					end
					if (GetProperty("TalkToAlias","TrialUse") > 0) then
					else
						SetProperty("TalkToAlias","TrialUse",GetID(""))
						SetProperty("","TrialUse",GetID(""))
						f_WeakMoveTo("","TalkToAlias",GL_MOVESPEED_WALK,128)
						if (GetProperty("TalkToAlias","TrialUse") == GetID("")) then
							AlignTo("","TalkToAlias")
							AlignTo("TalkToAlias","")
							Sleep(0.5)
	
							LoopAnimation("", "talk", -1)
							MsgSay("", "@L_ATTENDTRIAL_JUDGE_TEXT1_QUESTION",GetID("AppAlias"))
							StopAnimation("")
	
							PlayAnimationNoWait ("TalkToAlias", "nod")
							MsgSay("TalkToAlias", "@L_ATTENDTRIAL_JUDGE_TEXT1_ANSWER")
							StopAnimation("TalkToAlias")
	
							AlignTo("TalkToAlias")
							SetProperty("TalkToAlias","TrialUse",0)
							GetFleePosition("","TalkToAlias",Rand(100)+300,"MyPoss")
							
							if GetState("", STATE_CUTSCENE) == false then										
								f_WeakMoveTo("","MyPoss")
							end
							
							SetProperty("","TrialUse",0)
						else
							SetProperty("","TrialUse",0)
						end
					end
				end
			end
		end
	end

	if (action == 2) then -- talk to the accused sim

		local accused = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","accused")

		local SimExists = GetAliasByID(accused,"accusedAlias")
		
		if (SimExists == true) then
			CopyAlias("accusedAlias","TalkToAlias")
	
			if GetInsideRoom("TalkToAlias","InsideRoom") then
				if CanBeInterruptetBy("","TalkToAlias","BribeCharacter") == true then
					if (GetID("judgeroom") == GetID("InsideRoom")) then
						if (GetID("") ~= GetID("TalkToAlias") and not DynastyIsPlayer("TalkToAlias")) then
							if not HasProperty("TalkToAlias","TrialUse") then
								SetProperty("TalkToAlias","TrialUse",0)
							end
							if (GetProperty("TalkToAlias","TrialUse") > 0) then
							else
								SetProperty("TalkToAlias","TrialUse",GetID(""))
								SetProperty("","TrialUse",GetID(""))
								f_WeakMoveTo("","TalkToAlias",GL_MOVESPEED_WALK,128)
								if (GetProperty("TalkToAlias","TrialUse") == GetID("")) then
									AlignTo("","TalkToAlias")
									AlignTo("TalkToAlias","")
									Sleep(0.5)
			
									LoopAnimation("", "talk", -1)
									MsgSay("", "@L_ATTENDTRIAL_JUDGE_TEXT2_QUESTION",GetID("AppAlias"))
									StopAnimation("")
			
									local time = PlayAnimationNoWait("TalkToAlias", "devotion")
									MsgSay("TalkToAlias", "@L_ATTENDTRIAL_JUDGE_TEXT2_ANSWER")
									StopAnimation("TalkToAlias")
			
									AlignTo("TalkToAlias")
									SetProperty("TalkToAlias","TrialUse",0)
									GetFleePosition("","TalkToAlias",Rand(100)+300,"MyPoss")
									
									if GetState("", STATE_CUTSCENE) == false then										
										f_WeakMoveTo("","MyPoss")
									end
									
									SetProperty("","TrialUse",0)
								else
									SetProperty("","TrialUse",0)
								end
							end
						end
					end
				end
			end
		end
	end
end


function ActionsForAccused()
--	local action = 3
	local action = Rand(3)

	if (action == 0) then
		action = 1
--		PlayAnimation("","cogitate")
	end
	
	-- try first du bribe the judge
	local judge = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","judge")
	local SimExists = GetAliasByID(judge,"JudgeAlias")
	if (SimExists == true) then
--		AIExecutePlan("", "Trial", "SIM", "","Trial_Destination","JudgeAlias")
		Sleep(1)
	end
	
	if (action == 1) then -- the accused sim talk to anyone (but not the judge or the accuser) that he is not guilty

		RoomGetInsideSimList("judgeroom","visitor_list")

		local skip = 0

		local i
		local num = ListSize("visitor_list")
		ListGetElement("visitor_list",Rand(num),"TalkToAlias")

		local accuser = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","accuser")
		local judge = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","judge")

		if (HasProperty("TalkToAlias","BUILDING_NPC")) then
			skip = 1
		end

		if((accuser == GetID("TalkToAlias")) or (judge == GetID("TalkToAlias"))) then
			skip = 1
		end

		if (skip == 0) then
			if (GetID("") ~= GetID("TalkToAlias") and not DynastyIsPlayer("TalkToAlias")) then
				if CanBeInterruptetBy("","TalkToAlias","BribeCharacter") == true then
					if not HasProperty("TalkToAlias","TrialUse") then
						SetProperty("TalkToAlias","TrialUse",0)
					end
					if (GetProperty("TalkToAlias","TrialUse") > 0) then
					else
						SetProperty("TalkToAlias","TrialUse",GetID(""))
						SetProperty("","TrialUse",GetID(""))
						f_WeakMoveTo("","TalkToAlias",GL_MOVESPEED_WALK,128)
						if (GetProperty("TalkToAlias","TrialUse") == GetID("")) then
							AlignTo("","TalkToAlias")
							AlignTo("TalkToAlias","")
							Sleep(0.5)
	
							LoopAnimation("", "talk", -1)
							MsgSay("", "@L_ATTENDTRIAL_ACCUSED_TEXT1_QUESTION",GetID("AppAlias"))
							StopAnimation("")
	
							local Favor = GetFavorToSim("","TalkToAlias")
	
							if (Favor < 50) then
								PlayAnimationNoWait ("TalkToAlias", "shake_head")
								MsgSay("TalkToAlias", "@L_ATTENDTRIAL_ACCUSED_TEXT1_ANSWER_NEG")
							else
								PlayAnimationNoWait ("TalkToAlias", "nod")
								MsgSay("TalkToAlias", "@L_ATTENDTRIAL_ACCUSED_TEXT1_ANSWER_POS")
							end
	
							StopAnimation("TalkToAlias")
	
							AlignTo("TalkToAlias")
							SetProperty("TalkToAlias","TrialUse",0)
							GetFleePosition("","TalkToAlias",Rand(100)+300,"MyPoss")
							
							if GetState("", STATE_CUTSCENE) == false then										
								f_WeakMoveTo("","MyPoss")
							end
							
							SetProperty("","TrialUse",0)
						else
							SetProperty("","TrialUse",0)
						end
					end
				end
			end
		end
	end

	if (action == 2) then -- talk to the accuser that he hates him .. and so
		local accuser = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","accuser")

		local SimExists = GetAliasByID(accuser,"accuserAlias")
		
		if (SimExists == true) then
			CopyAlias("accuserAlias","TalkToAlias")
	
			if GetInsideRoom("TalkToAlias","InsideRoom") then
				if CanBeInterruptetBy("","TalkToAlias","BribeCharacter") == true then
					if (GetID("judgeroom") == GetID("InsideRoom")) then
						if (GetID("") ~= GetID("TalkToAlias") and not DynastyIsPlayer("TalkToAlias")) then
							if not HasProperty("TalkToAlias","TrialUse") then
								SetProperty("TalkToAlias","TrialUse",0)
							end
							if (GetProperty("TalkToAlias","TrialUse") > 0) then
							else
								SetProperty("TalkToAlias","TrialUse",GetID(""))
								SetProperty("","TrialUse",GetID(""))
								f_WeakMoveTo("","TalkToAlias",GL_MOVESPEED_WALK,128)
								if (GetProperty("TalkToAlias","TrialUse") == GetID("")) then
									AlignTo("","TalkToAlias")
									AlignTo("TalkToAlias","")
									Sleep(0.5)
			
									PlayAnimationNoWait ("", "threat")
									MsgSay("", "@L_ATTENDTRIAL_ACCUSED_TEXT2_QUESTION",GetID("AppAlias"))
									StopAnimation("")
			
									local time = PlayAnimationNoWait("TalkToAlias", "talk")
									MsgSay("TalkToAlias", "@L_ATTENDTRIAL_ACCUSED_TEXT2_ANSWER")
									StopAnimation("TalkToAlias")
			
									AlignTo("TalkToAlias")
									SetProperty("TalkToAlias","TrialUse",0)
									GetFleePosition("","TalkToAlias",Rand(100)+300,"MyPoss")
									
									if GetState("", STATE_CUTSCENE) == false then										
										f_WeakMoveTo("","MyPoss")
									end
									
									SetProperty("","TrialUse",0)
								else
									SetProperty("","TrialUse",0)
								end
							end
						end
					end
				end
			end
		end
	end
end


function ActionsForAccuser()
	BuildingGetRoom("destination","Judge","judgeroom")
	local action = Rand(3)

	if (action == 0) then
		action = 1
--		PlayAnimation("","cogitate")
	end
	
	-- try first du bribe the judge
	local judge = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","judge")
	local SimExists = GetAliasByID(judge,"JudgeAlias")
	if (SimExists == true) then
--		AIExecutePlan("", "Trial", "SIM", "","Trial_Destination","JudgeAlias")
		Sleep(1)
	end	

	if (action == 1) then -- talk to anyone in the counting ahll, neutral talk

		RoomGetInsideSimList("judgeroom","visitor_list")

		local skip = 0

		local i
		local num = ListSize("visitor_list")
		ListGetElement("visitor_list",Rand(num),"TalkToAlias")

		local accused = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","accused")

		if (HasProperty("TalkToAlias","BUILDING_NPC")) then
			skip = 1
		end

		if((accused == GetID("TalkToAlias"))) then
			skip = 1
		end

		if (skip == 0) then
			if (GetID("") ~= GetID("TalkToAlias") and not DynastyIsPlayer("TalkToAlias")) then
				if CanBeInterruptetBy("","TalkToAlias","BribeCharacter") == true then
					if not HasProperty("TalkToAlias","TrialUse") then
						SetProperty("TalkToAlias","TrialUse",0)
					end
					if (GetProperty("TalkToAlias","TrialUse") > 0) then
					else
						SetProperty("TalkToAlias","TrialUse",GetID(""))
						SetProperty("","TrialUse",GetID(""))
						f_WeakMoveTo("","TalkToAlias",GL_MOVESPEED_WALK,128)
						if (GetProperty("TalkToAlias","TrialUse") == GetID("")) then
							AlignTo("","TalkToAlias")
							AlignTo("TalkToAlias","")
							Sleep(0.5)
	
							LoopAnimation("", "talk", -1)
							MsgSay("", "@L_ATTENDTRIAL_ACCUSER_TEXT1_QUESTION",accused)
							StopAnimation("")
	
							local Positive = Rand(2)
	
							LoopAnimation("TalkToAlias", "talk", -1)
							MsgSay("TalkToAlias", "@L_ATTENDTRIAL_ACCUSER_TEXT1_ANSWER")
							StopAnimation("TalkToAlias")
	
							AlignTo("TalkToAlias")
							SetProperty("TalkToAlias","TrialUse",0)
							GetFleePosition("","TalkToAlias",Rand(100)+300,"MyPoss")
							
							if GetState("", STATE_CUTSCENE) == false then										
								f_WeakMoveTo("","MyPoss")
							end
							
							SetProperty("","TrialUse",0)
						else
							SetProperty("","TrialUse",0)
						end
					end
				end
			end
		end
	end

	if (action == 2) then -- talk to the accused sim, ironic talk

		local accused = behavior_pretrial_GetDataFromCutscene("CutsceneAlias","accused")

		local SimExists = GetAliasByID(accused,"accusedAlias")

		if (SimExists == true) then
			CopyAlias("accusedAlias","TalkToAlias")
	
			if GetInsideRoom("TalkToAlias","InsideRoom") then
				if CanBeInterruptetBy("","TalkToAlias","BribeCharacter") == true then
					if (GetID("judgeroom") == GetID("InsideRoom")) then
						if (GetID("") ~= GetID("TalkToAlias") and not DynastyIsPlayer("TalkToAlias")) then
							if not HasProperty("TalkToAlias","TrialUse") then
								SetProperty("TalkToAlias","TrialUse",0)
							end
							if (GetProperty("TalkToAlias","TrialUse") > 0) then
							else
								SetProperty("TalkToAlias","TrialUse",GetID(""))
								SetProperty("","TrialUse",GetID(""))
								f_WeakMoveTo("","TalkToAlias",GL_MOVESPEED_WALK,128)
								if (GetProperty("TalkToAlias","TrialUse") == GetID("")) then
									AlignTo("","TalkToAlias")
									AlignTo("TalkToAlias","")
									Sleep(0.5)
			
									LoopAnimation("", "talk", -1)
									MsgSay("", "@L_ATTENDTRIAL_ACCUSER_TEXT2_QUESTION",GetID("AppAlias"))
									StopAnimation("")
			
									PlayAnimationNoWait ("TalkToAlias", "threat")
									MsgSay("TalkToAlias", "@L_ATTENDTRIAL_ACCUSER_TEXT2_ANSWER")
									StopAnimation("TalkToAlias")
			
									AlignTo("TalkToAlias")
									SetProperty("TalkToAlias","TrialUse",0)
									GetFleePosition("","TalkToAlias",Rand(100)+300,"MyPoss")
									
									if GetState("", STATE_CUTSCENE) == false then										
										f_WeakMoveTo("","MyPoss")
									end
									
									SetProperty("","TrialUse",0)
								else
									SetProperty("","TrialUse",0)
								end
							end
						end
					end
				end
			end
		end
	end
end


function ActionsForAssessor()
	BuildingGetRoom("destination","Judge","judgeroom")
	local action = Rand(2)

	if GetInsideRoom("","InsideRoom") then
		if (GetID("judgeroom") ~= GetID("InsideRoom")) then
			action = -1
		end
	
		if (action == 0) then
			action = 1
--			PlayAnimation("","cogitate")
		end
	
		if (action == 1) then -- just neutral talk
	
			RoomGetInsideSimList("judgeroom","visitor_list")
	
			local skip = 0
	
			local i
			local num = ListSize("visitor_list")
			ListGetElement("visitor_list",Rand(num),"TalkToAlias")
	
			if (HasProperty("TalkToAlias","BUILDING_NPC")) then
				skip = 1
			end
	
			if (skip == 0) then
				if CanBeInterruptetBy("","TalkToAlias","BribeCharacter") == true then
					if (GetID("") ~= GetID("TalkToAlias") and not DynastyIsPlayer("TalkToAlias")) then
						if not HasProperty("TalkToAlias","TrialUse") then
							SetProperty("TalkToAlias","TrialUse",0)
						end
						if (GetProperty("TalkToAlias","TrialUse") > 0) then
						else
							SetProperty("TalkToAlias","TrialUse",GetID(""))
							SetProperty("","TrialUse",GetID(""))
							f_WeakMoveTo("","TalkToAlias",GL_MOVESPEED_WALK,128)
							if (GetProperty("TalkToAlias","TrialUse") == GetID("")) then
								AlignTo("","TalkToAlias")
								AlignTo("TalkToAlias","")
								Sleep(0.5)
		
								LoopAnimation("", "talk", -1)
								MsgSay("", "@L_ATTENDTRIAL_ASSESSOR_TEXT1_QUESTION",GetID("AppAlias"))
								StopAnimation("")
		
								LoopAnimation("", "talk", -1)
								MsgSay("TalkToAlias", "@L_ATTENDTRIAL_ASSESSOR_TEXT1_ANSWER")
								StopAnimation("TalkToAlias")
		
								AlignTo("TalkToAlias")
								SetProperty("TalkToAlias","TrialUse",0)
								GetFleePosition("","TalkToAlias",Rand(100)+300,"MyPoss")
								
								if GetState("", STATE_CUTSCENE) == false then										
									f_WeakMoveTo("","MyPoss")
								end
								
								SetProperty("","TrialUse",0)
							else
								SetProperty("","TrialUse",0)
							end
						end
					end
				end
			end
		end
	end
end




