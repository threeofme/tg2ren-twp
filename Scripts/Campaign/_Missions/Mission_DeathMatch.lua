function CheckStart()
  return true
end

function Start()
	local Options = FindNode("\\Settings\\Options")
	local Difficulty = Options:GetValueInt("MissionDifficulty")

	SetData("MissionDifficulty",Difficulty)
	SetData("EnemyDynastyCount",-1)

	SetMainQuestTitle("MAIN_MISSION","@L_INTERFACE_MISSIONS_QUESTBOOK_HEADER","@L_MISSIONS_SPECIAL_DEATHMATCH_+0")
	SetMainQuestDescription("MAIN_MISSION","@L_MISSIONS_SPECIAL_DEATHMATCH_+1")
	SetMainQuest("MAIN_MISSION")
	
	-- feedback_MessageMission("Actor","@L_MISSIONS_SPECIAL_DEATHMATCH_+0","@L_MISSIONS_SPECIAL_DEATHMATCH_+1")
end

function CheckEnd()
	if CheckPlayerExtinct("Actor") then	
		SetData("extinct", 1)
		return true
	elseif CheckPlayerBankrupt("Actor") then
		SetData("bankrupt", 1)
		return true
	end
	
	if GetData("EnemyDynastyCount")==-1 and ScenarioGetUnspawnedEnemiesCount()>0 then
		return false
	end
	
	local Count = ScenarioGetObjects("Dynasty", 99, "Dynasties")
	if Count==0 then
		return
	end
	
	local FriendCount = 0
	
	local CountActiveEnemies = 0
	local Team = DynastyGetTeam("Actor")
	 
	for dyn=0,Count-1 do
	
		local Alias = "Dynasties"..dyn
		if (DynastyIsShadow(Alias)==false) then
			if not DynastyIsDead(Alias) then
				if (GetID(Alias)~=GetID("Actor")) then
					local DynTeam = DynastyGetTeam(Alias)
					if DynTeam == 0 or DynTeam ~= Team then
						CountActiveEnemies = CountActiveEnemies + 1
					end
				end
			end
		end
	end

	if CountActiveEnemies==0 then
		return true
	elseif GetData("EnemyDynastyCount")==-1 then
		feedback_MessageMission("Actor","@L_MISSIONS_SPECIAL_DEATHMATCH_+0","@L_INTERFACE_MISSIONS_DEATHMATCH_+0",CountActiveEnemies)
		SetData("EnemyDynastyCount",CountActiveEnemies)
	elseif GetData("EnemyDynastyCount")~=CountActiveEnemies then
		feedback_MessageMission("Actor","@L_MISSIONS_SPECIAL_DEATHMATCH_+0","@L_INTERFACE_MISSIONS_DEATHMATCH_+1",CountActiveEnemies)
		SetData("EnemyDynastyCount",CountActiveEnemies)
	end
	SetMainQuestDescription("MAIN_MISSION","@L_INTERFACE_MISSIONS_DEATHMATCH_+1",CountActiveEnemies)

	return false
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
		DynastyAvoidControl("Actor")
		if Extinct then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			MsgBoxNoWait("Actor", nil, "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_END_OWNER_BODY", LastMemberID)
		elseif Bankrupt then
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_LOST)
			MsgBoxNoWait("Actor", nil, "@L_TOOMUCHDEBT_2_HEAD", "@L_TOOMUCHDEBT_2_BODY", GetID("Actor"))
		else
			-- No need to check for other players because there are no other players left in deathmatch
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_WON)
			MsgBoxNoWait("Actor", nil, "@L_MISSIONS_SPECIAL_DEATHMATCH_+0", "@L_MISSIONS_MISSIONS_WIN_+1")
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
			gameplayformulas_StartHighPriorMusic(MUSIC_GAME_WON)
			if MsgBox("Actor", nil, "@P@B[M,@L_INTERFACE_BUTTONS_ENDGAME]@B[S,@L_INTERFACE_BUTTONS_STATISTICS]", "@L_MISSIONS_SPECIAL_DEATHMATCH_+0", "@L_MISSIONS_MISSIONS_WIN_+1") == "S" then
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

