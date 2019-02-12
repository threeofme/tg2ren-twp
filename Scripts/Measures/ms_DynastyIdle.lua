---
-- TODO: buy and use random artefacts

function Run()
	repeat
		if GetImpactValue("", "banned")==1 then
			MeasureRun("", nil, "DynastyBanned")
			StopMeasure()
		end 
		
		if SimGetBehavior("")=="CheckPresession" or SimGetBehavior("")=="CheckPretrial" then
			-- TODO also check Presession?
			StopMeasure()
		end
		
		-- no idle measures just before trial
		if GetImpactValue("", "TrialTimer") >= 1 and ImpactGetMaxTimeleft("", "TrialTimer") <= 3 then
			StopMeasure()
		end
		-- no idle measures just before duel
		if GetImpactValue("", "DuelTimer") >= 1 and ImpactGetMaxTimeleft("", "DuelTimer") <= 3 then
			StopMeasure()
		end
		-- no idle measures just before office session
		if GetImpactValue("", "OfficeTimer") >= 1 and ImpactGetMaxTimeleft("", "OfficeTimer") <= 3 then
			StopMeasure()
		end

		-- priority checks first: health, poison and banned
		ms_dynastyidle_CheckHealth()
		if GetImpactValue("", "banned") > 0 then
			MeasureRun("", nil, "DynastyBanned", true)
		end

		local Value = Rand(80)
		aitwp_Log("Going idle with "..Value, "", true)
		if Value < 5 then -- move about
			idlelib_GoToRandomPosition()
		elseif Value < 10 then -- sit down
			idlelib_SitDown()
		elseif Value < 20 then -- go shopping
			if DynastyIsShadow("") then
				idlelib_CheckInsideStore(Rand(2)+1)
			else
				idlelib_BuySomethingAtTheMarket(Rand(2)+1)
			end
		elseif Value < 25 then -- get drunk
			if Rand(2) == 0 then
				idlelib_BeADrunkChamp()
			else
				idlelib_BeADiceChamp()
			end
		elseif Value < 30 then
			idlelib_UseCocotte()
		elseif Value < 40 then
			local need = 2
			if Rand(4) > 0 then
				need = 8
			end
			if SimGetClass("") == 4 then
				idlelib_GoToDivehouse()
			else
				if Rand(3) == 1 then
					idlelib_GoToDivehouse()
				else
					idlelib_GoToTavern(need)
				end
			end
		elseif Value < 45 then
			idlelib_CollectWater()
		elseif Value < 55 then
			ms_dynastyidle_UseRandomArtefact("")
		elseif Value < 70 and not SimGetSpouse("") and GetDynasty("", "MyDyn") and DynastyIsAI("MyDyn") then
			-- find lover, court and marry (disabled for family of players)
			aitwp_CourtLover("")
		else
			idlelib_DoNothing()
		end
		Sleep(5)	
		-- will terminate right away for AI, continue until abort for players	
	until not IsGUIDriven()
end

function CheckHealth()
	-- sickness, go to doctor
	if GetImpactValue("","Sickness") > 0 and Rand(10) < 5 and not GetMeasureRepeat("", "AttendDoctor") > 0 then
		MeasureRun("", nil, "AttendDoctor")
		-- I could also just go home and sleep...
	end
	
	-- poisoned, try to use antidote
	if GetState("", STATE_POISONED) 
			and Rand(10) < 5
			and not GetMeasureRepeat("", "UseAntidote") > 0 
			and ai_CanBuyItem("", "Antidote") > 0 then
		MeasureRun("", nil, "UseAntidote")
	end
	
	-- Check HP damage
	if GetHPRelative("") < 0.85 and Rand(10) < 5 then
		-- either doctor or lingerplace or nothing
		if GetMoney("") > 2500 and not GetMeasureRepeat("", "AttendDoctor") > 0 then
			MeasureRun("", nil, "AttendDoctor")
		else
			MeasureRun("", "LingerPlace", "Linger")
		end
	end
end

function UseRandomArtefact(SimAlias)
	local Item = "WalkingStick"
	local Money = GetMoney(SimAlias)
	
	if Money < 2000 then
		return
	end
	
	if GetMeasureRepeat(SimAlias, "Use"..Item) > 0 then
		return
	end
	
	if GetImpactValue(SimAlias, "walkingstick") > 0 or GetImpactValue(SimAlias, "Sugar") > 0 then
		return
	end

	local Price = ai_CanBuyItem(SimAlias, Item)
	
	if Price < 0 then
		return
	end
	
	-- use item
	MeasureRun(SimAlias, nil, "UseWalkingStick")
end

