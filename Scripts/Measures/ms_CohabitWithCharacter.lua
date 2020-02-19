-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_CohabitWithCharacter"
----
----	With this measure the player can beget new blood with his spouse
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local InteractionDistance = 80
	
	-- Get the spouse and call it "Destination" because the older version of the measure worked with a selection
	if not SimGetSpouse("", "Destination") then
		StopMeasure()
		return
	end 

	if not GetHomeBuilding("", "HomeBuilding") then
		StopMeasure()
		return
	end
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	if not CanBeInterruptetBy("Destination", "", "CohabitWithCharacter") then
		StopMeasure()
	end
	
	GetScenario("World")
	if not HasProperty("World", "static") or GetProperty("World", "static") == 0 then
		if not f_SimIsValid("Destination") then
			StopMeasure()
		end
	end
	
	if not f_MoveToNoWait("", "HomeBuilding", GL_MOVESPEED_RUN) then
		StopMeasure()
	end
	
	if GetDistance("Destination","HomeBuilding") < 2000 or DynastyIsPlayer("Destination") then
		if not f_MoveTo("Destination", "HomeBuilding", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
	else
		GetLocatorByName("HomeBuilding", "Walledge1", "entry")
		SimBeamMeUp("Destination","entry",false)
		f_MoveTo("Destination","HomeBuilding",GL_MOVESPEED_RUN)
	end

	local WaitTime = math.mod(GetGametime(),24)+3
	local check = true
	while check do
		Sleep(2)
		
		if math.mod(GetGametime(),24)>WaitTime then
			StopMeasure()
			break
		end

		if GetInsideBuilding("", "Building1") and GetInsideBuilding("Destination", "Building2") then
			if (GetID("Building1")==GetID("Building2")) then
				check = false
			else
				if CanBeInterruptetBy("Destination", "", "CohabitWithCharacter") then
					if GetDistance("Destination","HomeBuilding") < 2000 or DynastyIsPlayer("Destination") then
						if not f_MoveTo("Destination", "HomeBuilding", GL_MOVESPEED_RUN) then
							StopMeasure()
						end
					else
						GetLocatorByName("HomeBuilding", "Walledge1", "entry")
						SimBeamMeUp("Destination","entry",false)
						f_MoveTo("Destination","HomeBuilding",GL_MOVESPEED_RUN)
					end
				end
				Sleep(5)
			end
		else
			if CanBeInterruptetBy("Destination", "", "CohabitWithCharacter") then
				if GetDistance("Destination","HomeBuilding") < 2000 or DynastyIsPlayer("Destination") then
					if not f_MoveTo("Destination", "HomeBuilding", GL_MOVESPEED_RUN) then
						StopMeasure()
					end
				else
					GetLocatorByName("HomeBuilding", "Walledge1", "entry")
					SimBeamMeUp("Destination","entry",false)
					f_MoveTo("Destination","HomeBuilding",GL_MOVESPEED_RUN)
				end
			end
			Sleep(5)
		end
	end

	if ai_StartInteraction("", "Destination", 120, InteractionDistance) then
		

		-- Ask the question
		MsgSay("", chr_AskCohabit(GetSkillValue("", RHETORIC), SimGetGender("")));
		
		-- chr_AlignExact("", "Destination", InteractionDistance)
		
		-- Hug the spouse
		-- local OwnerAnimLength = PlayAnimationNoWait("", "hug_male")
		-- local DestinationAnimLength = PlayAnimationNoWait("Destination", "hug_female")
		-- Sleep(math.max(OwnerAnimLength, DestinationAnimLength)
					
		-- Check the success
		local Success = 0
		local Favor = 0
		if GetImpactValue("Destination","LoveLevel")>0 then
			Favor = GetImpactValue("Destination","LoveLevel")
		end
		-- not for AI
		if not DynastyIsPlayer("") then
			Favor = 10
		end
		
		local Chance = Rand(10)
		SetRepeatTimer("Dynasty", GetMeasureRepeatName(), TimeOut)
		if (Favor > Chance) then
			MsgSay("Destination", chr_AnswerCohabit(GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 1));
			Success = 1
		else 
			if Favor > 2 then
				MsgSay("Destination", chr_AnswerCohabit(GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 2));
				OwnerAnimLength = PlayAnimationNoWait("", "talk")
				DestinationAnimLength = PlayAnimationNoWait("Destination", "shake_head")
			else
				MsgSay("Destination", chr_AnswerCohabit(GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 3));
				OwnerAnimLength = PlayAnimationNoWait("", "got_a_slap")
				DestinationAnimLength = PlayAnimationNoWait("Destination", "give_a_slap")
			end
		end
		
		if (Success == 1) then
			
			if (SimGetGender("") == GL_GENDER_MALE) then
				CopyAlias("Owner", "male")
				CopyAlias("Destination", "female")
			else
				CopyAlias("Owner", "female")
				CopyAlias("Destination", "male")
			end
			
			if not GetInsideBuilding("", "Residence") then
				MsgQuick("", "@L_FAMILY_2_COHABITATION_FAILURES_+0", GetID("Building"))
				StopMeasure()
				return
			end
			
			if not GetLocatorByName("Residence", "Cohabit1", "CohabitPos1") then
				MsgQuick("", "@L_FAMILY_2_COHABITATION_FAILURES_+1", GetID("Building"))
				StopMeasure()
				return
			end
			
			if not GetLocatorByName("Residence", "Cohabit2", "CohabitPos2") then
				MsgQuick("", "@L_FAMILY_2_COHABITATION_FAILURES_+1", GetID("Building"))
				StopMeasure()
				return
			end
			-----------------------------
			------ Go to the bed ------
			-----------------------------
			f_MoveToNoWait("male", "CohabitPos1")
			f_BeginUseLocator("female", "CohabitPos2", GL_STANCE_STAND, true)
			f_BeginUseLocator("male", "CohabitPos1", GL_STANCE_STAND, true)
			if GetLocatorByName("Residence","Curtain","CurtainPos") then
				GfxAttachObject("Curtain","Locations/Residence/Curtain_Residence.nif")
				GfxSetPositionTo("Curtain","CurtainPos")
				GfxSetRotation("Curtain",0,0,0,true)
			end
			SetData("Cohabit1LocatorInUse", 1)
			
			
			Sleep(7)
			
			-----------------------------
			------ Pregnant chance ------
			-----------------------------
			local Age = (SimGetAge("male") + SimGetAge("female")) * 0.5
			local PregnantChance = 100
			if SimGetAge("female")>=30 then
				PregnantChance = 75
			end
			if SimGetAge("female")>=40 then
				PregnantChance = 25
			end
			if SimGetAge("female")>=50 then
				PregnantChance = 0
			end
			if SimGetAge("male")>=40 then
				PregnantChance = PregnantChance - 25
			end
			
			-- ImpactValue 42 -> CreateChild
			PregnantChance = PregnantChance + GetImpactValue("male", 42) + GetImpactValue("female", 42)
			
			-- If any of the cahrs is sterile then PregnantChance = 0 (Made for Campaign)
			if(HasProperty("male","sterile") or HasProperty("female","sterile")) then
				PregnantChance = 0
			end
			
			-- If maximum number of childs is reached, PregnantChance = 0
			local Count = SimGetChildCount("")
			local MaxChilds = 6
			if Count >= MaxChilds then
				PregnantChance = 0
			end
			
			--------------------------------
			------ Initiate Pregnancy ------
			--------------------------------
			if (PregnantChance>Rand(100)) then
				
				f_EndUseLocator("female", nil, GL_STANCE_LAY)
				MsgSay("", feedback_PregnancySuccess(SimGetGender(""), 1));
				SimGetPregnant("female")
				
				-- Add xp
				xp_CohabitWithCharacter("male", SimGetChildCount("male"))
				xp_CohabitWithCharacter("female", SimGetChildCount("female"))
				
			else				
				MsgSay("", feedback_PregnancySuccess(SimGetGender(""), 0));				
			end

			f_EndUseLocator("male", "CohabitPos1", GL_STANCE_STAND)
			SetData("Cohabit1LocatorInUse", 0)
			GfxDetachObject("Curtain")
			
		else
			MsgBoxNoWait("","Destination","@L_FAMILY_2_COHABITATION_FAIL_HEAD_+0",
					"@L_FAMILY_2_COHABITATION_FAIL_BODY_+0",GetID(""),GetID("Destination"))
		end
	end
	StopMeasure()
end

function CleanUp()
	if AliasExists("Curtain") then
		GfxDetachObject("Curtain")
	end
	GfxDetachAllObjects()
	
	if IsStateDriven() then
		MeasureRun("", nil, "DynastyIdle")
		MeasureRun("Destination", nil, "DynastyIdle")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

