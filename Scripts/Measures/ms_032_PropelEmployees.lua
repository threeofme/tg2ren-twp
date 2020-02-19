-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_032_PropelEmployees"
----
----	with this measure the player can propel the employees in one of his
----	workshops. The employee's productivity is increased while their loyalty
----	is lowed.
----
-------------------------------------------------------------------------------

function Run()

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not GetInsideBuilding("", "Building") then
		if AliasExists("Destination") then
			if f_MoveTo("", "Destination", GL_MOVESPEED_RUN, false) then
				CopyAlias("Destination", "Building")
			else
				return
			end
		else
			return
		end
	end
	
	MeasureSetStopMode(STOP_CANCEL)
	
	local	Count = BuildingGetWorkerCount("Building")
	local	Found = 0
	
	-- change the check from GetInsideBuilding to SimIsWorkingTime to make it possible to use this measure on outside workers at farms/mines/etc.
	
	if BuildingIsWorkingTime("Building") then
		for number=0, Count-1 do
			Alias = "Worker"..Found
			if BuildingGetWorker("Building", number, Alias) then
				if SimIsWorkingTime(Alias) then
					Found = Found + 1
				end
			end
		end
	end
	
	if Found == 0 then
		MsgQuick("", "@L_GENERAL_MEASURES_032_PROPELEMPLOYEES_FAILURES_+0", GetID("Building"))
		return
	end

	-- move player character to propel position
	if GetLocatorByName("Building", "Propel", "PropelPosition") then
		f_MoveTo("","PropelPosition")
	else
		f_Stroll("", 400, 3)
	end
	MeasureSetNotRestartable()
	
	local LoyaltyLoss
	local	Rhetoric = GetSkillValue("", RHETORIC)
	if (Rhetoric < 2) then
		LoyaltyLoss = -15
	elseif (Rhetoric < 4) then
		LoyaltyLoss = -12
	elseif (Rhetoric < 6) then
		LoyaltyLoss = -9
	elseif (Rhetoric < 8) then
		LoyaltyLoss = -6
	else
		LoyaltyLoss = -3
	end
	
	for number=0, Found-1 do
		Alias = "Worker"..number
		if SimPauseWorking(Alias) then
			SendCommandNoWait(Alias,"Listen")
		end
	end
	
	AlignTo("","Worker0")
	Sleep(1)
	
	-- play the speech sample as a 3DSample	
	if dyn_IsLocalPlayer("") then
		PlaySound3D("", "Measures/Measure_PropelEmployees", 1.0)
	end

	-- play the animation for the player character
	PlayAnimationNoWait("", "propel")

	-- get the loss of the employees favor based on the character's skill RHETORIC
	
-------------------------------------------------------------------
--		Text = "@L%>Listen dunderheads, there is no rest for you before work is done!%<"
--		Text = "@L%>Go to work you lazy bastards, before I forget my decent education!%<"
--		Text = "@L%>Come on you lazy dogs!%<"
--		Text = "@L%>Work faster! The job is done when it is done!%<"
--		Text = "@L%>You can sleep when you are laying in bed, but not in my workshop!%<"
-------------------------------------------------------------------
--	if (Rhetoric < 2) then
		MsgSay("", "@L_GENERAL_MEASURES_032_PROPELEMPLOYEES_STATEMENT")
--		LoyaltyLoss = -15
--	elseif (Rhetoric < 4) then
--		MsgSay("", "@L_GENERAL_MEASURES_032_PROPELEMPLOYEES_STATEMENT_+1")
--		LoyaltyLoss = -12
--	elseif (Rhetoric < 6) then
--		MsgSay("", "@L_GENERAL_MEASURES_032_PROPELEMPLOYEES_STATEMENT_+2")
--		LoyaltyLoss = -9
--	elseif (Rhetoric < 8) then
--		MsgSay("", "@L_GENERAL_MEASURES_032_PROPELEMPLOYEES_STATEMENT_+3")
--		LoyaltyLoss = -6
--	else
--		MsgSay("", "@L_GENERAL_MEASURES_032_PROPELEMPLOYEES_STATEMENT_+4")
--		LoyaltyLoss = -3
--	end

	-- get the skill, which is necessary for this workshop	
	local	Skill = CRAFTSMANSHIP
	
	if SimGetClass("")==GL_CLASS_SCHOLAR then
		Skill = SECRET_KNOWLEDGE
	end

	-- player character's skill value, nessecary for the employees skill boost
	local	Talent = GetSkillValue("",Skill)*5

	-- boost the productivity
	local	Boost = 0.25 + (Talent / 100)
	local AnimTime = 1
	local	BoostDuration = duration * GetImpactValue("", 35)*0.01 -- 35 -> PropelSpeedupTime
	LoyaltyLoss = LoyaltyLoss * 0.01 * GetImpactValue("", 41) -- 41 -> PropelFavorMalus
	
	for number=0, Found-1 do
		Alias = "Worker"..number
		if LoyaltyLoss~=0 then
			AnimTime = PlayAnimationNoWait(Alias, "devotion")
			chr_ModifyFavor(Alias, "Owner", LoyaltyLoss)
		end
		AddImpact(Alias, 4, Boost, BoostDuration)		-- 4 -> Productivity
		-- include the event in the memory of the worker
		--CommitAction("propel", Alias, Alias, "Owner")
	end
	
	SetMeasureRepeat(TimeOut)
	Sleep(0.5)
	local XPAmount = GetData("BaseXP")
	XPAmount = XPAmount * Count
	chr_GainXP("",XPAmount)
	Sleep(AnimTime)
	StopMeasure()
end

function Listen()
  -- simplified this logic to make it possible to propel on farms or alchemist huts if the workers are outside building
	AlignTo("","Owner")
	while true do
		Sleep(42)
	end
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

