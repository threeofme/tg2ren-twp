-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_152_TakeABath"
----
----	with this measure the player can invite an other character to a bath
----	in the tavern
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	local OverallPrice = 500
	SetData("Price", OverallPrice)
	
	-- The minimum favor of the destination sim to success
	local TitleDifference = (GetNobilityTitle("Destination") - GetNobilityTitle(""))*2
	local CharismaSkill = GetSkillValue("", CHARISMA)*2
	local MinimumFavor = 65 + TitleDifference - CharismaSkill
	local FavorWon = 15 + (CharismaSkill * 0.5)+ Rand(6)
	local FavorLoss = -10 - TitleDifference
	if FavorLoss > -5 then
		FavorLoss = -5
	end
	
	local FlirtBonus = GetImpactValue("", 52)		-- 52 = FlirtProfi
	FavorWon = FavorWon + FavorWon * FlirtBonus * 0.01
	
	-- the action number for the courting
	local CourtingActionNumber = 7

	if IsStateDriven() then
		if not GetSettlement("","city") then
			StopMeasure()
		end
		
		if not CityGetNearestBuilding("city", "", -1, GL_BUILDING_TYPE_TAVERN, -1, -1, FILTER_HASBATHINGROOM, "DestTavern") then
			StopMeasure()
		end
		
		if GetState("DestTavern",STATE_BUILDING) then
			StopMeasure()
		end
		
		if BuildingGetLevel("DestTavern")<2 then
			StopMeasure()
		end
		
		if not AliasExists("Destination") then
			StopMeasure()
		end
	
		if not f_MoveTo("", "DestTavern", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
		
		local DesID = GetID("Destination")
		
		if GetDistance("Destination","DestTavern")<1000 then
			if not f_MoveTo("Destination", "DestTavern", GL_MOVESPEED_RUN) then
				return
			end
			f_MoveTo("Destination","")
		else
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
				StopMeasure()
				break
			end

			if GetInsideBuilding("", "Building1") and GetInsideBuilding("Destination", "Building2") then
				if (GetID("Building1")==GetID("Building2")) and (GetID("Building1")==GetID("DestTavern")) then
					if not HasProperty("Building1", "BathInUse") then
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

	SetData("BathpartnerBlocked", 1)
	
	-- Get the tavern
	GetInsideBuilding("", "Tavern")
	GetInsideBuilding("Destination", "Tavern")
	if not GetInsideBuilding("", "Tavern") then
		StopMeasure()
	end
	
	if GetDynastyID("Tavern") ~= GetDynastyID("") then
		local Money = GetMoney("")
		if Money < OverallPrice then
			MsgQuick("", "@L_TAVERN_152_TAKEABATH_FAILURES_+1", OverallPrice)
			StopMeasure()
		end
	end
	
	-----------------------------------------
	------ Check bath free and reserve ------
	-----------------------------------------
	
	if not GetLocatorByName("Tavern", "Bath1", "BathPosition1") then
		MsgQuick("", "@L_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
		StopMeasure()
		return
	end

	if not GetLocatorByName("Tavern", "Bath2", "BathPosition2") then
		MsgQuick("", "@L_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
		StopMeasure()
		return
	end
	
	if HasProperty("Tavern", "BathInUse") then
		MsgQuick("", "@L_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
		StopMeasure()
		return
	else
		SetProperty("Tavern", "BathInUse", 1)
	end
	
	
	feedback_OverheadActionName("Destination")
	AlignTo("", "Destination")
	Sleep(0.5)
	
	local WasCourtLover = 0
	
	-------------------------
	------ Court Lover ------
	-------------------------
	
	if SimGetCourtLover("", "CourtLover") then
		if GetID("CourtLover")==GetID("Destination") then
			
			f_MoveToNoWait("Destination", "Tavern", GL_MOVESPEED_RUN)
			GetInsideBuilding("Destination", "Tavern")
			SetState("Destination", STATE_LOCKED, true)
		
			WasCourtLover = 1
			local ModifyFavor = FavorWon
			
			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber)
			if (EnoughVariation == false) and (GetFavorToSim("Destination", "") > MinimumFavor)  then
				
				DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
				Sleep(DestinationAnimationLength * 0.4)
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				
				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)));
				
			else
				
				if (CourtingProgress < -5) or (GetFavorToSim("Destination", "") < MinimumFavor) then
					PlayAnimationNoWait("", "got_a_slap")
					DestinationAnimationLength = PlayAnimationNoWait("Destination", "give_a_slap")
					Sleep(DestinationAnimationLength * 0.4)
					ModifyFavor = FavorLoss
				elseif (CourtingProgress < 1) then
					PlayAnimationNoWait("", "talk")
					DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
					Sleep(DestinationAnimationLength * 0.4)
					ModifyFavor = FavorLoss
				else
					-- Pay if the tavern does not belong to the owners dynasty
					if GetDynastyID("Tavern") ~= GetDynastyID("") then
						if DynastyIsPlayer("") then
							if not SpendMoney("", GetData("Price"), "CostSocial") then
								MsgQuick("", "@L_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
								StopMeasure()
								return
							end
						end
						CreditMoney("Tavern",GetData("Price"),"Offering")
						economy_UpdateBalance("Tavern", "Service", GetData("Price"))
					end
					
					-- player goes to his position after his partner went to his one
						if f_MoveToNoWait("Destination", "BathPosition2", GL_WALKSPEED_RUN) then
							f_MoveTo("", "BathPosition1")
						
							SetProperty("", "Ready")
							SetProperty("Destination", "Ready")
						end
					
					if HasProperty("Destination", "Ready") then
						f_BeginUseLocator("Destination", "BathPosition2", GL_STANCE_STAND, true)
						SetData("BathPosition2InUse", 1)
						if f_BeginUseLocator("Destination", "BathPosition2", GL_STANCE_STAND, true) then
							RemoveProperty("Destination", "Ready")
							SetProperty("", "YourTurn")
							SetProperty("Destination", "Here")
						end
					end
					
					if HasProperty("", "Ready") and HasProperty("", "YourTurn") then
						f_BeginUseLocator("", "BathPosition1", GL_STANCE_STAND, true)
						SetData("BathPosition1InUse", 1)
						SetState("", STATE_LOCKED, true)
						if f_BeginUseLocator("", "BathPosition1", GL_STANCE_STAND, true) then
							RemoveProperty("", "Ready")
							RemoveProperty("", "YourTurn")
							SetProperty("", "Here")
						end
					end

					if HasProperty("", "Here") and HasProperty("Destination", "Here") then				
						GfxStartParticle("Steam", "particles/bath_steam.nif", "BathPosition1", 2.5)
						local iCount = 0
						for iCount=0, 8 do
							PlaySound3DVariation("", "measures/takeabath", 2)
							if Rand(10) > 5 then
								PlaySound3DVariation("", "CharacterFX/female_joy_loop", 1)
							end
							Sleep(4)
						end
						GfxStopParticle("Steam")
						RemoveProperty("", "Here")
						RemoveProperty("Destination", "Here")
						SetProperty("", "PreBath")
						SetProperty("Destination", "PreBath")
					end
					
					---------------------
					------ PreBath ------
					---------------------
					
					if HasProperty("", "PreBath") and HasProperty("Destination", "PreBath") then
						if GetLocatorByName("Tavern", "PreBathSit", "PreBathPosSit") then
							if GetLocatorByName("Tavern", "PreBathStand", "PreBathPosStand") then

								if SimGetGender("") == GL_GENDER_MALE then
									f_MoveToNoWait("", "PreBathPosStand")
									f_BeginUseLocator("Destination", "PreBathPosSit", GL_STANCE_SIT, true)
									SetData("PreBathPosSitInUse", 1)
									SetData("WhoUsesPreBathPosSit", GetID("Destination"))
									f_BeginUseLocator("", "PreBathPosStand", GL_STANCE_STAND, true)
									SetData("PreBathPosStandInUse", 1)
									SetData("WhoUsesPreBathPosStand", GetID(""))
								else
									f_MoveToNoWait("", "PreBathPosSit")
									f_BeginUseLocator("Destination", "PreBathPosStand", GL_STANCE_STAND, true)
									SetData("PreBathPosStandInUse", 1)
									SetData("WhoUsesPreBathPosStand", GetID("Destination"))
									f_BeginUseLocator("", "PreBathPosSit", GL_STANCE_SIT, true)
									SetData("PreBathPosSitInUse", 1)
									SetData("WhoUsesPreBathPosSit", GetID(""))
								end
							end
						end
					end
					
					RemoveProperty("", "PreBath")
					RemoveProperty("Destination", "PreBath")
				end
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)					
				MsgSay("Destination", chr_AnswerCourtingMeasure("TAKE_A_BATH", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress));
			end
			-- Add the achieved progress
			chr_ModifyFavor("Destination", "", ModifyFavor)
			SimAddCourtingProgress("")
			SetMeasureRepeat(TimeUntilRepeat)
		end
	end
	
	----------------------------
	------ No Court Lover ------
	----------------------------
	if (WasCourtLover==0) then
		
		-- Check if the favor is high enough for bathing
		local success = (GetFavorToSim("Destination", "") > MinimumFavor)
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
			
			-- Pay if the tavern does not belong to the owners dynasty
				if GetDynastyID("Tavern") ~= GetDynastyID("") then
					if DynastyIsPlayer("") then
						if not SpendMoney("", GetData("Price"), "CostSocial") then
							MsgQuick("", "@L_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
							StopMeasure()
							return
						end
					end
					CreditMoney("Tavern",GetData("Price"),"Offering")
					economy_UpdateBalance("Tavern", "Service", GetData("Price"))
				end
			
			-- go to the bath
			if not GetLocatorByName("Tavern", "Bath1", "BathPosition1") then
				MsgQuick("", "@L_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
				StopMeasure()
				return
			end
			
			if not GetLocatorByName("Tavern", "Bath2", "BathPosition2") then
				MsgQuick("", "@L_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
				StopMeasure()
				return
			end
			
			if f_MoveToNoWait("Destination", "BathPosition2", GL_WALKSPEED_RUN) then
				f_MoveTo("", "BathPosition1")
				SetState("Destination", STATE_LOCKED, true)						
				SetProperty("", "Ready")
				SetProperty("Destination", "Ready")
			end
			
		
			if HasProperty("Destination", "Ready") then
				f_BeginUseLocator("Destination", "BathPosition2", GL_STANCE_STAND, true)
				SetData("BathPosition2InUse", 1)
				if f_BeginUseLocator("Destination", "BathPosition2", GL_STANCE_STAND, true) then
					RemoveProperty("Destination", "Ready")
					SetProperty("", "YourTurn")
					SetProperty("Destination", "Here")
				end
			end
					
			if HasProperty("", "Ready") and HasProperty("", "YourTurn") then
				f_BeginUseLocator("", "BathPosition1", GL_STANCE_STAND, true)
				SetData("BathPosition1InUse", 1)
				SetState("", STATE_LOCKED, true)
				if f_BeginUseLocator("", "BathPosition1", GL_STANCE_STAND, true) then
					RemoveProperty("", "Ready")
					RemoveProperty("", "YourTurn")
					SetProperty("", "Here")
				end
			end

			if HasProperty("", "Here") and HasProperty("Destination", "Here") then				
				GfxStartParticle("Steam", "particles/bath_steam.nif", "BathPosition1", 2.5)
				local iCount = 0
				for iCount=0, 8 do
					PlaySound3DVariation("", "measures/takeabath", 2)
					if Rand(10) > 5 then
						PlaySound3DVariation("", "CharacterFX/female_joy_loop", 1)
					end
					Sleep(4)
				end
				GfxStopParticle("Steam")
				RemoveProperty("", "Here")
				RemoveProperty("Destination", "Here")
				SetProperty("", "PreBath")
				SetProperty("Destination", "PreBath")
			end
			
			---------------------
			------ PreBath ------
			---------------------
			if HasProperty("", "PreBath") and HasProperty("Destination", "PreBath") then
				if GetLocatorByName("Tavern", "PreBathSit", "PreBathPosSit") then
					if GetLocatorByName("Tavern", "PreBathStand", "PreBathPosStand") then

						if SimGetGender("") == GL_GENDER_MALE then
							f_MoveToNoWait("", "PreBathPosStand")
							f_BeginUseLocator("Destination", "PreBathPosSit", GL_STANCE_SIT, true)
							SetData("PreBathPosSitInUse", 1)
							SetData("WhoUsesPreBathPosSit", GetID("Destination"))
							f_BeginUseLocator("", "PreBathPosStand", GL_STANCE_STAND, true)
							SetData("PreBathPosStandInUse", 1)
							SetData("WhoUsesPreBathPosStand", GetID(""))
						else
							f_MoveToNoWait("", "PreBathPosSit")
							f_BeginUseLocator("Destination", "PreBathPosStand", GL_STANCE_STAND, true)
							SetData("PreBathPosStandInUse", 1)
							SetData("WhoUsesPreBathPosStand", GetID("Destination"))
							f_BeginUseLocator("", "PreBathPosSit", GL_STANCE_SIT, true)
							SetData("PreBathPosSitInUse", 1)
							SetData("WhoUsesPreBathPosSit", GetID(""))
						end
					
					end
				end
				RemoveProperty("", "PreBath")
				RemoveProperty("Destination", "PreBath")
			end
			
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the success in order to save time (cheat)
			chr_ModifyFavor("Destination", "", FavorWon)
			ModifyHP("",5,true)
			ModifyHP("Destination",5,true)
			
			MsgSay("Destination", chr_AnswerBathing(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC), true))
			feedback_MessageCharacter("",
				"@L_TAVERN_152_TAKEABATH_MSG_SUCCESS_HEAD_+0",
				"@L_TAVERN_152_TAKEABATH_MSG_SUCCESS_BODY_+0", GetID("Destination"))
			
			StopMeasure()
			
		else
		
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the defeat (cheat)
			chr_ModifyFavor("Destination", "", FavorLoss)
			ModifyHP("",5,true)
			ModifyHP("Destination",5,true)
			
			MsgSay("Destination", chr_AnswerBathing(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC), false))
			feedback_MessageCharacter("",
				"@L_TAVERN_152_TAKEABATH_MSG_FAILED_HEAD_+0",
				"@L_TAVERN_152_TAKEABATH_MSG_FAILED_BODY_+0", GetID("Destination"))

			Sleep(3.0)
			
		end
		SetMeasureRepeat(TimeUntilRepeat)
	end

	if GetFreeLocatorByName("Tavern", "Stroll", 1, 5, "EndPos") then
		f_FollowNoWait("Destination", "", GL_MOVESPEED_WALK, 100, true)
		f_MoveTo("", "EndPos")
	end	
	StopMeasure()
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("Tavern") then	
		RemoveProperty("Tavern", "BathInUse")
	end
	StopAnimation("")
	
	if HasData("BathpartnerBlocked") then
		StopAnimation("Destination")
	end
	
	-- Free Locators
	if (GetData("BathPosition2InUse") == 1) then
		f_EndUseLocator("Destination", "BathPosition2")
	end
	
	if (GetData("BathPosition1InUse") == 1) then
		f_EndUseLocator("", "BathPosition1")
	end
	
	if (GetData("PreBathPosSitInUse") == 1) then
		GetAliasByID(GetData("WhoUsesPreBathPosSit"), "SitUser")
		f_EndUseLocator("SitUser", "PreBathPosSit")
	end
	
	if (GetData("PreBathPosStandInUse") == 1) then
		GetAliasByID(GetData("WhoUsesPreBathPosStand"), "StandUser")
		f_EndUseLocator("StandUser", "PreBathPosStand")
	end

	if IsStateDriven() then
		MeasureRun("", nil, "DynastyIdle")
	end
	
	if AliasExists("Steam") then
		GfxStopParticle("Steam")
	end
	
	SetState("", STATE_LOCKED, false)
	SetState("Destination", STATE_LOCKED, false)

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",500)
end

