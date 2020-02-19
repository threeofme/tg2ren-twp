
-- -----------------------
-- Run
-- -----------------------
function Run()

	if not GetID("")==chr_GetKing() then
		StopMeasure()
	end
	
	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")

	GetScenario("scenario")
	local mapid = GetProperty("scenario", "mapid")
	local land = GetDatabaseValue("maps", mapid, "lordship")

	if GetData("#GlobalEventType")==1 then
	
		local enemy = GetProperty("WarChooser","WarEnemy")

		MsgBoxNoWait("","",
			"@L_MEASURE_SHOWWARFACTORS_HEAD_+0",
			"@L_MEASURE_SHOWWARFACTORS_BODY_+1",
			"@L_SCENARIO_WAR_"..land.."_+1","@L_SCENARIO_WAR_"..enemy.."_+1")

	else
	
		local scenarioname = GetDatabaseValue("maps", mapid, "lordship")
		local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+1"
		local lordid = gameplayformulas_GetDatabaseIdByName("Lordship", scenarioname)

		local enemy1 = "@L_SCENARIO_LORD_"..GetDatabaseValue("Lordship", lordid, "enemy1").."_+1"
		local enemy2 = "@L_SCENARIO_LORD_"..GetDatabaseValue("Lordship", lordid, "enemy2").."_+1"
		local enemy3 = "@L_SCENARIO_LORD_"..GetDatabaseValue("Lordship", lordid, "enemy3").."_+1"
		local enemy4 = "@L_SCENARIO_LORD_"..GetDatabaseValue("Lordship", lordid, "enemy4").."_+1"
		
		local val = GetProperty("WarChooser","WarRisk")
		local WarRiskLabel = "@L_MEASURE_SHOWWARFACTORS_DANGER_+"..chr_GetWarRiskLevel(val)
		val = GetProperty("WarChooser","Hostility1")
		local EnemyMood1 = "@L_MEASURE_SHOWWARFACTORS_ENEMY_MOOD_+"..chr_GetEnemyMoodLevel(val)
		val = GetProperty("WarChooser","Hostility2")
		local EnemyMood2 = "@L_MEASURE_SHOWWARFACTORS_ENEMY_MOOD_+"..chr_GetEnemyMoodLevel(val)
		val = GetProperty("WarChooser","Hostility3")
		local EnemyMood3 = "@L_MEASURE_SHOWWARFACTORS_ENEMY_MOOD_+"..chr_GetEnemyMoodLevel(val)
		val = GetProperty("WarChooser","Hostility4")
		local EnemyMood4 = "@L_MEASURE_SHOWWARFACTORS_ENEMY_MOOD_+"..chr_GetEnemyMoodLevel(val)

		local choice = MsgBox("","", "@P@B[0,@L_AdministrateWar_Peace_+0]"..
							"@B[1,@L_AdministrateWar_Normal_+0]".."@B[2,@L_AdministrateWar_War_+0]",
							"@L_MEASURE_AdministrateWar_NAME_+0",
							"@L_MEASURE_SHOWWARFACTORS_BODY_+0",
							WarRiskLabel,lordlabel,enemy1,EnemyMood1,enemy2,EnemyMood2,enemy3,EnemyMood3,enemy4,EnemyMood4)

		if choice==0 then
			local val = GetProperty("WarChooser","WarRisk")
			local mod = 10
			if val < mod then
				SetProperty("WarChooser","WarRisk", 0)
			else
				SetProperty("WarChooser","WarRisk", val-mod)
			end

			local MeasureID = GetCurrentMeasureID("")
			local duration = mdata_GetDuration(MeasureID)
			local TimeOut = mdata_GetTimeOut(MeasureID)
			SetRepeatTimer("", "AdministrateWar", TimeOut)

		elseif choice==2 then
			local val = GetProperty("WarChooser","WarRisk")
			SetProperty("WarChooser","WarRisk", val+10)

			local MeasureID = GetCurrentMeasureID("")
			local duration = mdata_GetDuration(MeasureID)
			local TimeOut = mdata_GetTimeOut(MeasureID)
			SetRepeatTimer("", "AdministrateWar", TimeOut)
		end
	end

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end
