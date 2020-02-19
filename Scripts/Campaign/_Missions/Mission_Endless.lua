function CheckStart()
  return true
end

function Start()
	local Options = FindNode("\\Settings\\Options")
	local Difficulty = Options:GetValueInt("MissionDifficulty")
	
	SetData("MissionDifficulty",Difficulty)
	if (Difficulty==0) then
		SetData("Title",5)
	elseif (Difficulty==1) then
		SetData("Title",6)
	else
		SetData("Title",7)
	end
	
	SetMainQuestTitle("MAIN_MISSION","@L_INTERFACE_MISSIONS_ENDLESS_+0")
	SetMainQuestDescription("MAIN_MISSION","@L_INTERFACE_MISSIONS_ENDLESS_+1")
	SetMainQuest("MAIN_MISSION")
	
	feedback_MessageMission("Actor","@L_INTERFACE_MISSIONS_ENDLESS_+0","@L_INTERFACE_MISSIONS_ENDLESS_+1")
end

function CheckEnd()
	if CheckPlayerExtinct("Actor") then
		log_death("Actor", "Player is extinct (Mission_Endless).")
		SetData("extinct", 1)
		return true
	elseif CheckPlayerBankrupt("Actor") then
		log_death("Actor", "Player is bankrupt (Mission_Endless).")
		SetData("bankrupt", 1)
		return true
	end
	
	return false
end

function End()
	
	if IsDemo() then
	
		if MsgBox("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", "@L_DEMO_END_HEADER", "@L_DEMO_END_BODY", LastMemberID) == "S" then
			ShowStats = 1
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
		
		CampaignExit(false)
	
	else
	
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
				Sleep(20000.0)
			elseif Bankrupt then
				gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
				MsgBoxNoWait("Actor", nil, "@L_TOOMUCHDEBT_2_HEAD", "@L_TOOMUCHDEBT_2_BODY", GetID("Actor"))
				Sleep(20.0)
			end
		
			if DynastyIsPlayer("Actor") then
				CampaignExit(true)
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
			CampaignExit(false)
			
		end
	
	end
	
end

function CleanUp()
end
