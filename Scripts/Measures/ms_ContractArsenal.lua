function Run()

	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")

	if not GetProperty("WarChooser","WarPhase")==1 then
		StopMeasure()
	end

	local Count = Find("", "__F((Object.GetObjectsByRadius(Building)==2000)AND(Object.IsType(27))AND(Object.Property.prewar>0))","Arsenal", -1)
	
	if Count < 1 then
		StopMeasure()
	end
	
	CopyAlias("Arsenal0", "Arsenal")
	
	if IsStateDriven() then 
		if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
	end

	GetSettlement("Arsenal", "City")
	GetSettlement("", "settlement")

	if not GetID("City") == GetID("settlement") then
		MsgBoxNoWait("","Arsenal","@L_GENERAL_ERROR_HEAD_+0","@L_CONTRACTARSENAL_FAILURE_+0",GetID("settlement"))
		StopMeasure()
	end

	GetScenario("scenario")
	local mapid = GetProperty("scenario", "mapid")
	local scenarioname = GetDatabaseValue("maps", mapid, "lordship")
	local land = GetDatabaseValue("maps", mapid, "lordship")
	local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+1"
	local enemy = GetProperty("WarChooser","WarEnemy")

	local TrooperCount = GetProperty("Arsenal", "trooper")
	local ArkebusierCount = GetProperty("Arsenal", "arkebusier")
	local CannonCount = GetProperty("Arsenal", "cannon")
	local trooperlabel
	local arkebusierlabel
	local cannonslabel

	if TrooperCount==1 then
		trooperlabel = "_WAR_MERC_TROOPER_MALE_+0"
	else
		trooperlabel = "_WAR_MERC_TROOPER_MORE_+0"
	end
	if ArkebusierCount==1 then
		arkebusierlabel = "_WAR_MERC_ARKEBUSIER_MALE_+0"
	else
		arkebusierlabel = "_WAR_MERC_ARKEBUSIER_MORE_+0"
	end
	if CannonCount==1 then
		cannonslabel = "_WAR_MERC_CANNON_MALE_+0"
	else
		cannonslabel = "_WAR_MERC_CANNON_MORE_+0"
	end

	local choice
	local choice2
	local money
	local totalpower
	local familypower
	local Count
	local cost
	local fame
	local power
	local label
	GetDynasty("", "family")
	
	if IsStateDriven() then
		
		--!!!!!!!!!!!!!!!!!!
		
	else
		
		choice = MsgBox("", "", "@P@B[1,@L_WAR_MERC_TROOPER_MORE_+0]"..
							"@B[2,@L_WAR_MERC_ARKEBUSIER_MORE_+0]"..
							"@B[3,@L_WAR_MERC_CANNON_MORE_+0]"..
							"@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]",
			        "@L_CONTRACTARSENAL_HIRE_MAIN_HEAD_+0",
			        "@L_CONTRACTARSENAL_HIRE_MAIN_BODY_+0",
					    "@L_SCENARIO_WAR_"..enemy.."_+0",GetID("City"),TrooperCount,trooperlabel,ArkebusierCount,arkebusierlabel,CannonCount,cannonslabel)

		if (choice==1) then
			label = "trooper"
			cost = 1000
			fame = 1
			power = 1
		elseif (choice==2) then
			label = "arkebusier"
			cost = 3000
			fame = 2
			power = 3
		elseif (choice==3) then
			label = "cannon"
			cost = 10000
			fame = 4
			power = 8
		else
			StopMeasure()
		end

		choice2 = MsgBox("", "", "@P@B[1,@L_CONTRACTARSENAL_HIRE_OPTION_+0]"..
							"@B[5,@L_CONTRACTARSENAL_HIRE_OPTION_+1]"..
							"@B[10,@L_CONTRACTARSENAL_HIRE_OPTION_+2]"..
							"@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]",
			        "@L_CONTRACTARSENAL_HIRE_MAIN_HEAD_+0",
			        "@L_CONTRACTARSENAL_HIRE_MAIN_BODY_+1",
					    "_WAR_MERC_"..label.."_MALE_+0","_WAR_MERC_"..label.."_MORE_+0",cost,cost*5,cost*10)

		if not GetProperty("WarChooser","WarPhase")==1 then
			MsgBoxNoWait("","Arsenal","@L_GENERAL_ERROR_HEAD_+0","@L_CONTRACTARSENAL_FAILURE_+1")
			StopMeasure()
		else
			if (choice2==1) or (choice2==5) or (choice2==10) then
				money = cost*choice2
				if money > GetMoney("") then
					MsgBoxNoWait("","Arsenal","@L_GENERAL_ERROR_HEAD_+0","@L_CONTRACTARSENAL_FAILURE_+2")
					StopMeasure()
				else
					f_SpendMoney("", money, "HireMercenaries")
					chr_SimAddImperialFame("",fame * choice2)
					Count = GetProperty("Arsenal", label) + choice2
					SetProperty("Arsenal", label, Count)
					if HasProperty("family", "WarLandNo") then
						familypower = GetProperty("family", "WarLandNo") + (power * choice2)
						SetProperty("family", "WarLandNo", familypower)
					else
						SetProperty("family", "WarLandNo", power * choice2)
					end
					totalpower = GetProperty("WarChooser","WarLandNo") + (power * choice2)
					SetProperty("WarChooser","WarLandNo", totalpower)
				end
			end
		end
	end
end

function CleanUp()

end
