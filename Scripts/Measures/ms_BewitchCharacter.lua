-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_BewitchCharacter"
----
----	with this measure the player can bewitch another character in the tavern
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	if IsStateDriven() then
		if not GetSettlement("","city") then
			StopMeasure()
		end
		if not CityGetNearestBuilding("city", "", -1, GL_BUILDING_TYPE_TAVERN, -1, -1, FILTER_IGNORE, "DestTavern") then
			StopMeasure()
		end
		
		if GetState("DestTavern",STATE_BUILDING) then
			StopMeasure()
		end
		
		if not BuildingHasUpgrade("DestTavern", "Divanbed") then
			StopMeasure()
		end
		
		if not AliasExists("Destination") then
			StopMeasure()
		end
		
		--LogMessage("BewitchCharacter: "..GetID("").." "..GetName("").." wants to flirt with "..GetID("Destination").." "..GetName("Destination").." ")

		if not f_MoveTo("", "DestTavern", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
		
		local DesID = GetID("Destination")
		
		if GetDistance("Destination","DestTavern")<1000 then
			--LogMessage("BewitchCharacter Destination ID: "..DesID.." "..GetName("Destination").." is in range and moves to Tavern")
			if not f_MoveTo("Destination", "DestTavern", GL_MOVESPEED_RUN) then
				--LogMessage("BewitchCharacter Destination ID: "..DesID.." error move")				
				return
			end
			f_MoveTo("Destination","")
		else
			--LogMessage("BewitchCharacter: Destination ID: "..DesID.." "..GetName("Destination").." is ported")
			GetLocatorByName("DestTavern", "Walledge1", "entry")
			SimBeamMeUp("Destination","entry",false)
			f_MoveTo("Destination","DestTavern",GL_MOVESPEED_RUN)
			f_MoveTo("Destination","")
		end
			

		local check = true
		local WaitTime = math.mod(GetGametime(),24)+3
		while check do
			Sleep(2)

			if math.mod(GetGametime(),24)>WaitTime then
				--LogMessage("Bewitching I waited too long, bye")
				StopMeasure()
				break
			end

			if GetInsideBuilding("", "Building1") and GetInsideBuilding("Destination", "Building2") then
				if (GetID("Building1")==GetID("Building2")) and (GetID("Building1")==GetID("DestTavern")) then
					if LocatorStatus("DestTavern","Divanbed1",true)==1 then
						--LogMessage("All set up, lets go bewitching my love")
						check = false
					end
				else
					Sleep(5)
				end
			else
				Sleep(5)
			end
		end
	end
	
	local InteractionDistance = 128
	
	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	local OverallPrice = 300
	SetData("Price", OverallPrice)
	
	-- The minimum favor of the destination sim to success
	local TitleDifference = (GetNobilityTitle("Destination") - GetNobilityTitle(""))*2
	local CharismaSkill = (GetSkillValue("", CHARISMA)*2)
	local MinimumFavor = 60 + TitleDifference - CharismaSkill
	local FavorWon = 10 + (CharismaSkill/2) + Rand(7)
	local FavorLoss = -10 - TitleDifference
	if FavorLoss > -5 then
		FavorLoss = -5
	end
	local FlirtBonus = GetImpactValue("", 52)		-- 52 = FlirtProfi
	FavorWon = FavorWon + FavorWon * FlirtBonus * 0.01
	
	-- the action number for the courting
	local CourtingActionNumber = 5
	
--	if not BlockChar("Destination") then
--		StopMeasure()
--		return
--	end
	
	-- Get the tavern
	if not GetInsideBuilding("", "Tavern") then
		StopMeasure()
		return
	end
	
	if not BuildingHasUpgrade("Tavern", "Divanbed") then
		StopMeasure()
	end
	
	--LogMessage("Start bewitching")
	
	GetOutdoorMovePosition("","Tavern","MovePos")
	
	-- Pay if the tavern does not belong to the owners dynasty
	if GetDynastyID("Tavern") ~= GetDynastyID("") then
		if DynastyIsPlayer("") then
			if not f_SpendMoney("", GetData("Price"), "CostSocial") then
				MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+0", GetID(""), GetData("Price"))
				StopMeasure()
				return
			end
		end
		f_CreditMoney("Tavern",GetData("Price"),"Offering")
		economy_UpdateBalance("Tavern", "Service", GetData("Price"))
	end	
	local AnimType = "bench_talk"
		
	if not GetLocatorByName("Tavern", "Divanbed1", "Bewitcher") then
		MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+1", GetID("Tavern"))
		--LogMessage("Bewitching Error no Locator 1")
		StopMeasure()
		return
	end

	if not GetLocatorByName("Tavern", "Divanbed2", "Bewitched") then
		--LogMessage("Bewitching Error no Locator 2")
		MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+1", GetID("Tavern"))
		StopMeasure()
		return
	end
	
--	else
--		AnimType = "sit_talk"
--		if not GetLocatorByName("Tavern", "DivanbedAlt1", "Bewitcher") then
--			MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+1", GetID("Tavern"))
--			StopMeasure()
--			return
--		end
--		
--		if not GetLocatorByName("Tavern", "DivanbedAlt2", "Bewitched") then
--			MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+1", GetID("Tavern"))
--			StopMeasure()
--			return
--		end
--	
--	end
 	
	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
 		StopMeasure()
 		return
 	end
	 	
	local WasCourtLover = 0
	
	-------------------------
	------ Court Lover ------
	-------------------------
	if SimGetCourtLover("", "CourtLover") then
		if GetID("CourtLover")==GetID("Destination") then
					
			WasCourtLover = 1
			local ModifyFavor = FavorWon
			
			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber)
			if (EnoughVariation == false) then
				
				DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
				Sleep(DestinationAnimationLength * 0.4)
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				
				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)));
				
			else
	
			
				if (CourtingProgress < -5) then
					chr_MultiAnim("", "got_a_slap", "Destination", "give_a_slap", InteractionDistance, 0.4)
					ModifyFavor = FavorLoss
				elseif (CourtingProgress < 1) then
					chr_MultiAnim("", "talk", "Destination", "cheer_01", InteractionDistance, 0.4)
					ModifyFavor = FavorLoss
				else
					
					-- Go to the divanbed
					if GetInsideBuilding("","CurrentBuilding") then
						if GetID("CurrentBuilding") ~= GetID("Tavern") then
							f_ExitCurrentBuilding("")
							f_ExitCurrentBuilding("Destination")
							f_FollowNoWait("Destination","",150)
							f_MoveTo("","MovePos")
						end
					else
						f_FollowNoWait("Destination","",150)
						f_MoveTo("","MovePos")
					end
					--f_MoveToNoWait("", "Bewitcher")
					if not SendCommandNoWait("Destination","MoveToPosition") then
						StopMeasure()
					end
					SetData("BewitchedLocatorInUse", 1)
					if not f_BeginUseLocator("", "Bewitcher", GL_STANCE_SITBENCH, true) then
						StopMeasure()
					end
					SetData("BewitcherLocatorInUse", 1)
					while not HasData("BewitchedLocatorInUse") do
						Sleep(1)
					end
					CreateCutscene("default","cutscene")
					CutsceneAddSim("cutscene","")
					CutsceneAddSim("cutscene","destination")
					CutsceneCameraCreate("cutscene","")				
					camera_CutscenePlayerLockSit("cutscene", "")
					FadeInFE("", "eyelids_up", 0.5, 0.3, 1)
					FadeInFE("", "smile", 0.7, 0.4, 0)
					local TimeAnim = 0
					TimeAnim = PlayAnimationNoWait("", AnimType)
					Sleep(TimeAnim-1.5)
					camera_CutscenePlayerLockSit("cutscene", "Destination")
					FadeInFE("Destination", "eyelids_up", 0.5, 0.3, 1)
					FadeInFE("Destination", "smile", 0.7, 0.4, 0)
					TimeAnim = PlayAnimationNoWait("Destination", AnimType)
					Sleep(TimeAnim-1.5)
				end
				
				if GetID("cutscene")>0 then
					camera_CutscenePlayerLockSit("cutscene", "Destination")
				end
				feedback_OverheadCourtProgress("Destination", CourtingProgress)								
				MsgSay("Destination", chr_AnswerCourtingMeasure("BEWITCH", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress));
				--CutsceneCameraRelease("cutscene")
				
			end
			
			-- Add the archieved progress
			SetMeasureRepeat(TimeUntilRepeat)
			chr_ModifyFavor("Destination", "", ModifyFavor)
			SimAddCourtingProgress("")
			
		end
	end
	
	----------------------------
	------ No Court Lover ------
	----------------------------
	if (WasCourtLover==0) then
	
		-- check if the favor is high enough for bathing
		local success = (GetFavorToSim("Destination", "Owner") > MinimumFavor)
		if success then
			
			if SimGetSpouse("Destination", "Spouse") then
				if (GetID("Spouse")==GetID("")) then
					AddImpact("","LoveLevel",10,24) -- add some love for the next 24 hours
					AddImpact("Destination","LoveLevel",10,24)
					if GetImpactValue("Destination","LoveLevel")>=10 then
						MsgNewsNoWait("","Destination","","schedule",-1,
								"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_HEAD_+0",
								"@L_FAMILY_2_COHIBITATION_FULLOFLOVE_BODY_+0", GetID("Destination"))
					end
				end
			end
			
			-- Go to the divanbed
			if GetInsideBuilding("","CurrentBuilding") then
				if GetID("CurrentBuilding") ~= GetID("Tavern") then
					f_ExitCurrentBuilding("")
					f_ExitCurrentBuilding("Destination")
					f_FollowNoWait("Destination","",200)
					f_MoveTo("","MovePos")
				end
			else
				f_FollowNoWait("Destination","",200)
				f_MoveTo("","MovePos")
			end
			
			--f_MoveToNoWait("", "Bewitcher")
--			if not f_BeginUseLocator("Destination", "Bewitched", GL_STANCE_SIT, true) then
--				StopMeasure()
--			end
			if not SendCommandNoWait("Destination","MoveToPosition") then
				StopMeasure()
			end
			if not f_BeginUseLocator("", "Bewitcher", GL_STANCE_SITBENCH, true) then
				StopMeasure()
			end
			SetData("BewitcherLocatorInUse", 1)
			
			while not HasData("BewitchedLocatorInUse") do
				Sleep(1)
			end
			
			CreateCutscene("default","cutscene")
			CutsceneAddSim("cutscene","")
			CutsceneAddSim("cutscene","destination")
			CutsceneCameraCreate("cutscene","")
			camera_CutscenePlayerLockSit("cutscene", "")
			local TimeAnim = 0					
			FadeInFE("", "eyelids_up", 0.5, 0.3, 1)
			FadeInFE("", "smile", 0.7, 0.4, 0)
			TimeAnim = PlayAnimationNoWait("", AnimType)
			Sleep(TimeAnim-1.5)
			camera_CutscenePlayerLockSit("cutscene", "Destination")
			FadeInFE("Destination", "eyelids_up", 0.5, 0.3, 1)
			FadeInFE("Destination", "smile", 0.7, 0.4, 0)
			TimeAnim = PlayAnimationNoWait("Destination", AnimType)
			Sleep(TimeAnim-1.5)
			SetMeasureRepeat(TimeUntilRepeat)	
			
			-- forget the evidences
			-- for testing purposes always forget the best evidence
			if GetEvidenceAlignmentSum("Destination", "") > 0 then		
				feedback_MessageCharacter("Owner", 
					"@L_GENERAL_MEASURES_BEWITCHCHARACTER_MSG_SUCCESS_HEAD_+0",
					"@L_GENERAL_MEASURES_BEWITCHCHARACTER_MSG_SUCCESS_BODY_+0",
						GetID("Tavern"), GetID("Destination"), GetEvidenceAlignmentSum("Destination", ""), GetID("Owner"))
				RemoveEvidences("Destination", "")
			else
				feedback_MessageCharacter("Owner", 
					"@L_GENERAL_MEASURES_BEWITCHCHARACTER_MSG_NO_EVIDENCE_HEAD_+0",
					"@L_GENERAL_MEASURES_BEWITCHCHARACTER_MSG_NO_EVIDENCE_BODY_+0",
						GetID("Tavern"), GetID("Destination"), GetID("Owner"))
			end
			
		end
	end
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
	
	
end

function MoveToPosition()
	if not f_BeginUseLocator("", "Bewitched", GL_STANCE_SITBENCH, true) then
		StopMeasure()
	end
	SetData("BewitchedLocatorInUse", 1)
	while true do
		Sleep(2)
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	DestroyCutscene("cutscene")	
	FadeOutAllFE("", 0)	
	StopAnimation("")
	
	if HasData("BewitcherLocatorInUse") then
		f_EndUseLocatorNoWait("", "Bewitcher", GL_STANCE_STAND)
	end
	
	if GetData("BewitchedLocatorInUse") == 1 then
		f_EndUseLocator("Destination", "Bewitched", GL_STANCE_STAND)
	end
	
	if AliasExists("Destination") then
		SimLock("Destination", 0.4)
	end

	if IsStateDriven() then
		MeasureRun("", nil, "DynastyIdle")
	end
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",300)
end

