function Run()

	GetScenario("scenario")
	if not HasProperty("scenario", "static") then
		local	TimeToSleep = 583
		local	EventType
		local currentRound
		local WarRiskVal
		
		--------------------------
		-- initiate war parameters
		SetProperty("","WarPhase", 0)
		SetProperty("","WarWon", 0)
		if not HasProperty("","WarEndTime") then
			SetProperty("","WarEndTime", 0)
		end
		if not HasProperty("","WarRisk") then
			SetProperty("","WarRisk", 25)
			SetProperty("","Hostility1", 25)
			SetProperty("","Hostility2", 25)
			SetProperty("","Hostility3", 25)
			SetProperty("","Hostility4", 25)
		end
		--------------------------
		
		while true do
			
			currentRound = GetRound()
			EventType = GetData("#GlobalEventType")
	
			if currentRound > 0 then
				
				if EventType ~= 1 then
				
					local WarRiskChange = Rand(4)-1
					gameplayformulas_ChangeWarRisk(WarRiskChange)
	
					WarRiskVal = GetProperty("","WarRisk")
					if (Rand(200)+15)<WarRiskVal then
						if (GetProperty("","WarPhase")==0) then
							ms_globalevent_War()
						end
					end
	
				end
				
			end
	
			Sleep(TimeToSleep)
			
		end
	end
end

function War()
	SetData("#GlobalEventType", 1)

	GetScenario("scenario")
	local mapid = GetProperty("scenario", "mapid")
	local scenarioname = GetDatabaseValue("maps", mapid, "lordship")
	local lordid = gameplayformulas_GetDatabaseIdByName("Lordship", scenarioname)

	----------------
	-- find an enemy
	local enemyHost1 = GetProperty("","Hostility1")
	local enemyHost2 = GetProperty("","Hostility2")
	local enemyHost3 = GetProperty("","Hostility3")
	local enemyHost4 = GetProperty("","Hostility4")

	math.randomseed(GetGametime())

	local enemynum
	local enemyRand = Rand(100)+1
	if enemyRand <= enemyHost1 then
		enemynum = 1
	elseif enemyRand <= (enemyHost1 + enemyHost2) then
		enemynum = 2
	elseif enemyRand <= (enemyHost1 + enemyHost2 + enemyHost3) then
		enemynum = 3
	else
		enemynum = 4
	end
	
	local enemy = GetDatabaseValue("Lordship", lordid, "enemy"..enemynum)
	----------------

	local land = GetDatabaseValue("maps", mapid, "lordship")
	local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+1"

	local Gametime	= 8
	local WarTime	= Rand(24) + 6
	local CurrentTime = GetGametime()
	local StartTime  = CurrentTime + Gametime
	local EndTime  = CurrentTime + Gametime + WarTime
	local ID = "Event"..GetID("")

	local WarNoLand
	local WarNoEnemy
	local WarNoMod = Rand(5) + 1
	if WarNoMod==1 then
		WarNoLand = Rand(100) + 300
		WarNoEnemy = Rand(100) + 300
	elseif WarNoMod==2 then
		WarNoLand = Rand(200) + 400
		WarNoEnemy = Rand(200) + 400
	elseif WarNoMod==3 then
		WarNoLand = Rand(300) + 500
		WarNoEnemy = Rand(300) + 500
	elseif WarNoMod==4 then
		WarNoLand = Rand(400) + 600
		WarNoEnemy = Rand(400) + 600
	else
		WarNoLand = Rand(500) + 700
		WarNoEnemy = Rand(500) + 700
	end

	SetProperty("","WarStartTime", StartTime)
	SetProperty("","WarEndTime", EndTime)
	SetProperty("","WarEnemy", enemy)
	SetProperty("","WarLandNo", WarNoLand)
	SetProperty("","WarEnemyNo", WarNoEnemy)
	SetProperty("","WarPhase", 1)

	MsgNewsNoWait("All","","@C[@L_WAR_DECLARED_COOLDOWN_+0,%6i,%7l]","economie",-1,
						"@L_WAR_DECLARED_HEAD_+0",
						"@L_WAR_DECLARED_BODY_+0",
						"@L_SCENARIO_WAR_"..land.."_+1", "@L_SCENARIO_WAR_"..enemy.."_+1", Gametime, lordlabel, "@L_SCENARIO_WAR_"..enemy.."_+0", StartTime, ID)
	
	local	ToDo	= Gametime2Realtime(Gametime)
	while ToDo>0 do
		ToDo = ToDo - 2
		Sleep(2)
	end

	local ID = "Event"..GetID("")
	HudRemoveCountdown(ID,false)

	SetProperty("","WarPhase", 2)
	
	gameplayformulas_StartHighPriorMusic(38,true)
	
	MsgBoxNoWait("All", nil,
						"@L_WAR_BEGINS_HEAD_+0",
						"@L_WAR_BEGINS_BODY_+0",
						lordlabel, "@L_SCENARIO_WAR_"..enemy.."_+1")

	while GetGametime() < EndTime do
		Sleep(2)
	end

	if ms_globalevent_Combat()==true then
		MsgBoxNoWait("All", nil,
							"@L_WAR_END_WON_HEAD_+0",
							"@L_WAR_END_WON_BODY_+0",
							lordlabel, "@L_SCENARIO_WAR_"..enemy.."_+1")

		Sleep(2)

		local KingDyn = chr_GetKing()
		if KingDyn > 0 and GetAliasByID(KingDyn, "TheKing") then
			GetDynasty("TheKing", "kingfamily")
			local NumDynasties = ScenarioGetObjects("cl_Dynasty",99,"OutPutDyn")
			for i=0,NumDynasties-1 do
				if GetDynasty("OutPutDyn"..i, "family") then
					if GetID("family")==GetID("kingfamily") then
						if GetProperty("family","WarLandNo") then
							local money = (Rand(1100) + 250) * (25 + GetProperty("family","WarLandNo"))
							
							feedback_MessagePolitics("family","@L_WAR_END_WON_HEAD_+1","@L_WAR_END_WON_BODY_+1","@L_SCENARIO_WAR_"..enemy.."_+0", GetDynastyID("family"), money, lordlabel)
		
							f_CreditMoney("family", money, "WarMoney")
							RemoveProperty("family", "WarLandNo")
						else
							local money = (Rand(1100) + 250) * 25
							
							feedback_MessagePolitics("family","@L_WAR_END_WON_HEAD_+1","@L_WAR_END_WON_BODY_+1","@L_SCENARIO_WAR_"..enemy.."_+0", GetDynastyID("family"), money, lordlabel)
		
							f_CreditMoney("family", money, "WarMoney")
						end
					elseif GetProperty("family","WarLandNo") then
						local money = (Rand(1100) + 250) * GetProperty("family","WarLandNo")
						
						feedback_MessagePolitics("family","@L_WAR_END_WON_HEAD_+1","@L_WAR_END_WON_BODY_+1","@L_SCENARIO_WAR_"..enemy.."_+0", GetDynastyID("family"), money, lordlabel)
	
						f_CreditMoney("family", money, "WarMoney")
						RemoveProperty("family", "WarLandNo")
					end
				end
			end
		else
			local NumDynasties = ScenarioGetObjects("cl_Dynasty",99,"OutPutDyn")
			for i=0,NumDynasties-1 do
				if GetDynasty("OutPutDyn"..i, "family") then
					if GetProperty("family","WarLandNo") then
						local money = (Rand(1100) + 250) * GetProperty("family","WarLandNo")
						
						feedback_MessagePolitics("family","@L_WAR_END_WON_HEAD_+1","@L_WAR_END_WON_BODY_+1","@L_SCENARIO_WAR_"..enemy.."_+0", GetDynastyID("family"), money, lordlabel)
	
						f_CreditMoney("family", money, "WarMoney")
						RemoveProperty("family", "WarLandNo")
					end
				end
			end
		end

	else
		MsgBoxNoWait("All", nil,
							"@L_WAR_END_LOOSE_HEAD_+0",
							"@L_WAR_END_LOOSE_BODY_+0",
							"@L_SCENARIO_LORD_"..enemy.."_+1", "@L_SCENARIO_WAR_"..land.."_+1", "@L_SCENARIO_WAR_"..land.."_+0")

		Sleep(2)

		local KingDyn = chr_GetKing()
		if KingDyn > 0 and GetAliasByID(KingDyn, "TheKing") then
			GetDynasty("TheKing", "kingfamily")
			local NumDynasties = ScenarioGetObjects("cl_Dynasty",99,"OutPutDyn")
			for i=0,NumDynasties-1 do
				if GetDynasty("OutPutDyn"..i, "family") then
					if GetID("family")==GetID("kingfamily") then
						if GetProperty("family","WarLandNo") then
							local money = (Rand(1100) + 250) * (25 + GetProperty("family","WarLandNo"))
							local dynmoney = GetMoney("family")
							if money < dynmoney then
								dynmoney = money
							end
							
							feedback_MessagePolitics("family","@L_WAR_END_LOOSE_HEAD_+1","@L_WAR_END_LOOSE_BODY_+1","@L_SCENARIO_WAR_"..enemy.."_+0", GetDynastyID("family"), money, "@L_SCENARIO_LORD_"..enemy.."_+1")
		
							f_SpendMoney("family", money, "WarMoney")
							RemoveProperty("family", "WarLandNo")
						else
							local money = (Rand(1100) + 250) * 25
							local dynmoney = GetMoney("family")
							if money < dynmoney then
								dynmoney = money
							end
							
							feedback_MessagePolitics("family","@L_WAR_END_LOOSE_HEAD_+1","@L_WAR_END_LOOSE_BODY_+1","@L_SCENARIO_WAR_"..enemy.."_+0", GetDynastyID("family"), money, "@L_SCENARIO_LORD_"..enemy.."_+1")
		
							f_SpendMoney("family", money, "WarMoney")
						end
					elseif GetProperty("family","WarLandNo") then
						local money = (Rand(1100) + 250) * GetProperty("family","WarLandNo")
						local dynmoney = GetMoney("family")
						if money < dynmoney then
							dynmoney = money
						end
						
						feedback_MessagePolitics("family","@L_WAR_END_LOOSE_HEAD_+1","@L_WAR_END_LOOSE_BODY_+1","@L_SCENARIO_WAR_"..enemy.."_+0", GetDynastyID("family"), money, "@L_SCENARIO_LORD_"..enemy.."_+1")
	
						f_SpendMoney("family", money, "WarMoney")
						RemoveProperty("family", "WarLandNo")
					end
				end
			end
		else
			local NumDynasties = ScenarioGetObjects("cl_Dynasty",99,"OutPutDyn")
			for i=0,NumDynasties-1 do
				if GetDynasty("OutPutDyn"..i, "family") then
					if GetProperty("family","WarLandNo") then
						local money = (Rand(1100) + 250) * GetProperty("family","WarLandNo")
						local dynmoney = GetMoney("family")
						if money < dynmoney then
							dynmoney = money
						end
						
						feedback_MessagePolitics("family","@L_WAR_END_LOOSE_HEAD_+1","@L_WAR_END_LOOSE_BODY_+1","@L_SCENARIO_WAR_"..enemy.."_+0", GetDynastyID("family"), money, "@L_SCENARIO_LORD_"..enemy.."_+1")
	
						f_SpendMoney("family", money, "WarMoney")
						RemoveProperty("family", "WarLandNo")
					end
				end
			end
		end
	end
	gameplayformulas_ChangeEnemyHostility(enemynum,6)
	gameplayformulas_ChangeWarRisk(-20)
	Sleep(12)
	SetData("#GlobalEventType", 0)
end

function Combat()

	local WarLandNo = GetProperty("","WarLandNo")
	local WarEnemyNo = GetProperty("","WarEnemyNo")

	SetProperty("","WarPhase", 0)

	if WarEnemyNo < WarLandNo then
		SetProperty("","WarWon", 2)
		return true
	else
		SetProperty("","WarWon", 1)
		return false
	end
end

function CleanUp()

	RemoveProperty("","WarStartTime")
	RemoveProperty("","WarEnemy")
	RemoveProperty("","WarLandNo")
	RemoveProperty("","WarEnemyNo")
	RemoveProperty("","WarPhase")
	RemoveProperty("","WarWon")
	RemoveData("#GlobalEventType")

end
