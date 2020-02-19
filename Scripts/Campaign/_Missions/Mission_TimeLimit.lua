function CheckStart()
  return true
end

function Start()
	local Options = FindNode("\\Settings\\Options")
	local MissionSubType = Options:GetValueInt("MissionSubType")
	local Rounds = 2
	if MissionSubType==0 then			
		Rounds = 1
	elseif MissionSubType==1 then			
		Rounds = 2
	elseif MissionSubType==2 then			
		Rounds = 3
	elseif MissionSubType==3 then			
		Rounds = 4
	elseif MissionSubType==4 then			
		Rounds = 6
	elseif MissionSubType==5 then			
		Rounds = 10
	elseif MissionSubType==6 then			-- 5 hours
		Rounds = 20
	elseif MissionSubType==7 then			-- 6 hours
		Rounds = 24
	else
		Rounds = 24
	end

	SetData("Rounds",Rounds)
	
	SetMainQuestTitle("MAIN_MISSION","@L_MISSIONS_SPECIAL_TIMELIMIT_+0")
	SetMainQuest("MAIN_MISSION")

	feedback_MessageMission("Actor","@L_MISSIONS_SPECIAL_TIMELIMIT_+0","@L_MISSIONS_SPECIAL_TIMELIMIT_+1",(GetData("Rounds")-1)*24*60)
	
	GetScenario("World")
	if HasProperty("World", "Finito") then
		RemoveProperty("World", "Finito")
	end
end

function CheckEnd()
	time_left = (GetData("Rounds")*24-4) - ScenarioGetTimePlayed()  -- time left in hours
	--time_left = time_left/24	-- time left in rounds
	--time_left = time_left*15*60	
	time_left = time_left * 60
		
	if time_left<=0 then		
		if not HasProperty("World","Finito") then	
			local Count = ScenarioGetObjects("Dynasty", 99, "Dynasties")
			local BestCapital = -1
			local BestDynasty = -1
			for dyn=0,Count-1 do
				Alias = "Dynasties"..dyn
				if (DynastyIsShadow(Alias)==false) then
					if not DynastyIsDead(Alias) then
						if (DynastyGetRanking(Alias)>BestCapital) then
							BestCapital = DynastyGetRanking(Alias)
							BestDynasty = GetID(Alias)
						end
					end
				end
			end
			SetProperty("World","Finito",BestDynasty)
		end
		return true
	else	
		if CheckPlayerExtinct("Actor") then
			SetData("extinct", 1)
			return true
		elseif CheckPlayerBankrupt("Actor") then
			SetData("bankrupt", 1)
			return true
		end
		
		SetMainQuestDescription("MAIN_MISSION","@L_INTERFACE_MISSIONS_TIMELIMIT_+0",(GetData("Rounds")-1)*24*60,time_left)
		return false
	end
end

function End()

	GetLocalPlayerDynasty("LocalPlayerDynasty")
	local Won = 0
	local Extinct = HasData("extinct")
	local Bankrupt = HasData("bankrupt")
	local LastMemberID = GetProperty("Actor", "LastMemberID")
	
	if IsMultiplayerGame() then
	
		-- ---------------
		-- Multiplayer end
		-- ---------------
		DynastyAvoidControl("Actor")
		if Extinct then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			MsgBoxNoWait("Actor", nil, "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_BODY", LastMemberID)
			
		elseif Bankrupt then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			MsgBoxNoWait("Actor", nil, "@L_TOOMUCHDEBT_2_HEAD", "@L_TOOMUCHDEBT_2_BODY", GetID("Actor"))
			
		else
			local BestDynasty = GetProperty("World","Finito")
			
			if (BestDynasty==GetID("Actor")) and (GetID("LocalPlayerDynasty") == BestDynasty) then
				gameplayformulas_StartHighPriorMusic(MUSIC_GAME_WON)
				MsgBoxNoWait("Actor", nil, "@L_MISSIONS_MISSIONS_WIN_+1", "@L_MISSIONS_TIMELIMIT_SUCCESS_+0")
			else		
				gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
				MsgBoxNoWait("Actor", nil, "@L_MISSIONS_TIMELIMIT_FAILURE_+0", "@L_MISSIONS_TIMELIMIT_FAILURE_+1", BestDynasty)
			end
		end
		
	else
	
		-- ----------------
		-- Singleplayer end
		-- ----------------
		local ShowStats = 0
		if Extinct then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			if MsgBox("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_BODY", LastMemberID) == "S" then
				ShowStats = 1
			end
		elseif Bankrupt then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			if MsgBox("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", "@L_TOOMUCHDEBT_2_HEAD", "@L_TOOMUCHDEBT_2_BODY", GetID("Actor")) == "S" then
				ShowStats = 1
			end
		else
			local Count = ScenarioGetObjects("Dynasty", 99, "Dynasties")
			local BestCapital = -1
			local BestDynasty = -1
			for dyn=0,Count-1 do
				Alias = "Dynasties"..dyn
				if (DynastyIsShadow(Alias)==false) then
					if not DynastyIsDead(Alias) then
						if (DynastyGetRanking(Alias)>BestCapital) then
							BestCapital = DynastyGetRanking(Alias)
							BestDynasty = GetID(Alias)
						end
					end
				end
			end
			
			if (BestDynasty==GetID("Actor")) and (GetID("LocalPlayerDynasty") == BestDynasty) then
				gameplayformulas_StartHighPriorMusic(MUSIC_GAME_WON)
				Won = 1
				if MsgNews("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", nil, "default", -1, "@L_MISSIONS_MISSIONS_WIN_+1", "@L_MISSIONS_TIMELIMIT_SUCCESS_+0") == "S" then
					ShowStats = 1
				end
			else		
				gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
				Won = 0
				if MsgNews("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", nil, "default", -1, "@L_MISSIONS_TIMELIMIT_FAILURE_+0", "@L_MISSIONS_TIMELIMIT_FAILURE_+1", BestDynasty) == "S" then
					ShowStats = 1
				end
			end
		end
					
		-- Show the statistics screen or not
		if ShowStats == 1 then
			ShowStatistics()
			while HudPanelIsVisible("StatisticsSheetGold") or
				HudPanelIsVisible("StatisticsSheetAsset") or
				HudPanelIsVisible("StatisticsSheetSkill") or
				HudPanelIsVisible("StatisticsSheetAlign") or
				HudPanelIsVisible("StatisticsSheetPoints") or
				HudPanelIsVisible("StatisticsBalanceLast") or
				HudPanelIsVisible("StatisticsBalanceTotal") do
					Sleep(1.0)
			end
		end
		
		-- End the game
		if Won == 0 then
			CampaignExit(false)
		else
			CampaignExit(true)
		end
		
	end
	
end

function CleanUp()
end
