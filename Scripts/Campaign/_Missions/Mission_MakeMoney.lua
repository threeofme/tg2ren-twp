function CheckStart()
  return true
end

function Start()
	local Options = FindNode("\\Settings\\Options")
	local Difficulty = Options:GetValueInt("MissionDifficulty")
	
	SetData("MissionDifficulty",Difficulty)
	if (Difficulty==0) then
		SetData("MoneyLimit",25000)
		SetData("DiffReplace","EASY")
	elseif (Difficulty==1) then
		SetData("MoneyLimit",100000)
		SetData("DiffReplace","MEDIUM")
	else
		SetData("MoneyLimit",500000)
		SetData("DiffReplace","HARD")
	end

	GetLocalPlayerDynasty("LocalPlayerDynasty")
	if (GetID("LocalPlayerDynasty") == GetID("Actor")) then
		SetMainQuestTitle("MAIN_MISSION","@L_INTERFACE_MISSIONS_QUESTBOOK_HEADER","@L_MISSIONS_MISSIONS_MAKEMONEY_+0")
		SetMainQuestDescription("MAIN_MISSION","@L_MISSIONS_MISSIONS_MAKEMONEY_+1",GetData("MoneyLimit"))
		SetMainQuest("MAIN_MISSION")
	end
	
	GetScenario("World")
	if HasProperty("World", "Finito") then
		RemoveProperty("World", "Finito")
	end
	
	feedback_MessageMission("Actor","@L_MISSIONS_MISSIONS_MAKEMONEY_+0","@L_MISSIONS_MISSIONS_MAKEMONEY_+1",GetData("MoneyLimit"))
end

function CheckEnd()

	if HasProperty("World", "Finito") then
		return true
	end

	if (DynastyGetRanking("Actor") >= GetData("MoneyLimit")) then
		return true
	else
		if CheckPlayerExtinct("Actor") then
			SetData("extinct", 1)
			return true
		elseif CheckPlayerBankrupt("Actor") then
			SetData("bankrupt", 1)
			return true
		end
		
		GetLocalPlayerDynasty("LocalPlayerDynasty")
		if (GetID("LocalPlayerDynasty") == GetID("Actor")) then
			SetMainQuestDescription("MAIN_MISSION","@L_INTERFACE_MISSIONS_MAKEMONEY_+0",GetData("MoneyLimit"),DynastyGetRanking("Actor"))
		end
		return false
  end
end

-- ---------------
-- End
-- ---------------
function End()

	local Won = 0
	local Extinct = HasData("extinct")
	local Bankrupt = HasData("bankrupt")
	local LastMemberID = GetProperty("Actor", "LastMemberID")
	
	if IsMultiplayerGame() then
		
		-- ---------------
		-- Multiplayer end
		-- ---------------

		if HasProperty("World", "Finito") then
			local	Winner = GetProperty("World", "Finito")
			MsgBoxNoWait("Actor", nil, "@L_MISSIONS_MISSIONS_LOOSE_HEAD", "@L_MISSIONS_MISSIONS_LOOSE_MULTIPLAYER_BODY", Winner)
			DynastyAvoidControl("Actor")
			return
		end

		if Extinct then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			MsgBoxNoWait("Actor", nil, "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_BODY", LastMemberID)
		elseif Bankrupt then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			MsgBoxNoWait("Actor", nil, "@L_TOOMUCHDEBT_2_HEAD", "@L_TOOMUCHDEBT_2_BODY", GetID("Actor"))
		else
			SetProperty("World", "Finito", GetID("Actor"))
			
			if (GetID("LocalPlayerDynasty") == GetID("Actor")) then
				gameplayformulas_StartHighPriorMusic(MUSIC_GAME_WON)
				local MoneyLimit = GetData("MoneyLimit")
				MsgBoxNoWait("Actor", nil, "@L_MISSIONS_MISSIONS_MAKEMONEY_+0", "@L_MISSIONS_MISSIONS_MAKEMONEY_+2", MoneyLimit)
			else
				gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			end
			
		end
		DynastyAvoidControl("Actor")
		
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
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_WON)
			local MoneyLimit = GetData("MoneyLimit")
			if MsgBox("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", "@L_MISSIONS_MISSIONS_MAKEMONEY_+0", "@L_MISSIONS_MISSIONS_MAKEMONEY_+2", MoneyLimit) == "S" then
				ShowStats = 1
				Won = 1
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
