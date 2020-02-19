-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_AdministrateDiplomacy.lua"
----
----	With this measure the player can change the diplomatic status, 
----	can make requests, demands, gifts or send diplomatic messages
----
----	This measure has been greatly reworked by Fajeth
----
----	Note: AI will use scriptcalls instead, using the 
----	AI scripts found in: ac_AdministrateDiplomacy.lua
-------------------------------------------------------------------------------

function Init() -- this is called before Run

	-- We need the Owner because this measure is now a building-measure
	if not BuildingGetOwner("", "MyBoss") then
		MsgBoxNoWait("dynasty","","@L_GENERAL_ERROR_HEAD_+0","@L_MEASURE_ADMINISTRATE_DIPLOMACY_NOOWNER_BODY_+0")
		return false
	end
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	if DynastyIsPlayer("") then
		-- First we need to choose what we want to do
		local Selection = MsgBox("MyBoss","Destination","@P"..
						"@B[1,@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_+0]"..
						"@B[2,@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_+0]"..
						"@B[4,@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_+0]"..
						"@B[3,@L_MEASURE_ADMINISTRATE_DIPLOMACY_GIFT_+0]"..
						"@B[5,@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_+0]",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_SELECTION_HEAD_+0",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_SELECTION_BODY_+0", GetID("Destination"))
	
		SetData("Choice",Selection)
	end
end

function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end

	local Selection = GetData("Choice")
	local result = 0
	
	if Selection == 1 then -- status
		if DynastyGetTeam("MyBoss") > 0 and DynastyGetTeam("MyBoss") == DynastyGetTeam("Destination") then
			MsgBoxNoWait("MyBoss", "Destination","@L_GENERAL_ERROR_HEAD_+0", "@L_MEASURE_AdministrateDiplomacy_FAILURE_TEAM_+0")
			StopMeasure()
		else
			if DynastyIsPlayer("") then 
				ms_administratediplomacy_Status()
			end
			result = GetData("InitResult")
			if result == 0 then -- feud
				ms_administratediplomacy_ConfirmFeud()
			elseif result == 1 then -- neutral
				ms_administratediplomacy_ConfirmNeutral()
			elseif result == 2 then -- NAP
				ms_administratediplomacy_ConfirmNAP()
			elseif result == 3 then -- Alliance
				ms_administratediplomacy_ConfirmAlliance()
			end
		end
	elseif Selection == 2 then -- message to raise/lower favor (not with enemies)
		ms_administratediplomacy_Message()
	elseif Selection == 3 then -- gift for allies
		ms_administratediplomacy_Gift()
	elseif Selection == 4 then -- demand for non-allies
		ms_administratediplomacy_RequestEnemies()
	elseif Selection == 5 then -- request for allies
		ms_administratediplomacy_RequestAllies()
	end
end

function Status()

	-- Change the status
	
	local DestID = GetDynastyID("Destination")
	
	if not ReadyToRepeat("", "DIP_"..DestID) then
		MsgBoxNoWait("MyBoss","Destination",
				"@L_GENERAL_ERROR_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ERROR_COOLDOWN",GetID("Destination"))
		StopMeasure()
	end
	
	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	local Buttons = ""
	
	local MinState = DynastyGetMinDiplomacyState("MyBoss", "Destination")
	local MaxState = DynastyGetMaxDiplomacyState("MyBoss", "Destination")
	
	if MinState<0 or MaxState<0 then
		StopMeasure()
	end
	
	local	Count = 0
	
	for i=0,3 do
		if i>=MinState and i<=MaxState and i~= CState then
			if i==0 then
				Buttons	= Buttons .. "@B[0,,@LHostility,Hud/Buttons/btn_034_ArmCharacter.tga]"
			elseif i==1 then
				Buttons	= Buttons .. "@B[1,,@LNeutral,Hud/Buttons/btn_030_GuardObject.tga]"			
			elseif i==2 then
				Buttons	= Buttons .. "@B[2,,@LNAP,Hud/Buttons/btn_015_ReclaimField.tga]"
			elseif i==3 then
				Buttons	= Buttons .. "@B[3,,@LAlliance,Hud/Buttons/btn_047_Administrate_Diplomacy.tga]"
			end
				Count = Count + 1
		end
	end
	
	if Count<2 then
		-- error
		StopMeasure()
	end

	local result = InitData("@P"..Buttons, 1,"@LAdministrateDiplomacySheet","")
	
	if result == "C" then
		StopMeasure()
	end
	
	SetRepeatTimer("", "DIP_"..DestID, 20)
	SetData("InitResult",result)
end

function Message()
	
	local DestID = GetDynastyID("Destination")
	
	if not ReadyToRepeat("", "DIP_"..DestID) then
		MsgBoxNoWait("MyBoss","Destination",
				"@L_GENERAL_ERROR_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ERROR_COOLDOWN",GetID("Destination"))
		StopMeasure()
	end
	
	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	
	if CState == DIP_FOE then
		MsgBoxNoWait("MyBoss","Destination",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_ERROR_FOE",GetID("Destination"))
		StopMeasure()
	end
	
	local result = 0
	if IsGUIDriven() then
		result = InitData("@P".."@B[0,,@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_NICE_BTN,hud/buttons/btn_MakeACompliment.tga]"..
					"@B[1,,@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_MEAN_BTN,hud/buttons/btn_039_blackmailCharacter.tga]",
					1,"@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_HEAD_+0","@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_BODY_+0",GetID("Destination"))
	end
		
	local Skill = GetSkillValue("MyBoss", RHETORIC)
	local ResultLabel = ""
	local RhetLabel = "LOW"
	local Favor = 0
	 
	if Skill<4 then
		Favor = 3+Rand(3)
	elseif Skill <7 then
		Favor = 6+Rand(3)
		RhetLabel = "MEDIUM"
	elseif Skill <10 then
		Favor = 9+Rand(3)
		RhetLabel = "HIGH"
	else
		Favor = 12+Rand(3)
		RhetLabel = "PERFECT"
	end
		
	if result == 0 then
		ResultLabel = "NICE"
	elseif result == 1 then
		ResultLabel = "MEAN"
		Favor = Favor*(-1)
	else
		StopMeasure()
	end
	
	SetRepeatTimer("", "DIP_"..DestID, 20)
	ModifyFavorToSim("MyBoss","Destination",(Favor))
	MsgBoxNoWait("MyBoss","Destination",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_"..ResultLabel.."_SEND_"..RhetLabel,GetID("Destination"))
					
	-- Message the destination
	MsgNewsNoWait("Destination","MyBoss","","politics",-1,
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_RECEIVE_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_MESSAGE_"..ResultLabel.."_RECEIVE_"..RhetLabel,GetID("MyBoss"))
end

function Gift()
	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	
	if CState ~= DIP_ALLIANCE then
		-- error - only allies get gifts
		MsgBoxNoWait("MyBoss", "", "@L_GENERAL_ERROR_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ERROR_GIFT_+0")
		StopMeasure()
	end
	
	local MyMoney = GetMoney("dynasty")
	
	local VeryLow = math.floor(MyMoney*0.15)
	local Low = math.floor(MyMoney*0.3)
	local Medium = math.floor(MyMoney*0.45)
	local High = math.floor(MyMoney*0.6)
	local VeryHigh = math.floor(MyMoney*0.75)
	local Amount = 0
	
	-- how much money do you want to send?
	local GiftResult = InitData("@P".."@B[0,"..VeryLow..",,hud/items/Item_goldlow.tga]"..
					"@B[1,"..Low..",,hud/items/Item_goldlowmed.tga]"..
					"@B[2,"..Medium..",,hud/items/Item_goldmed.tga]"..
					"@B[3,"..High..",,hud/items/Item_goldmedhigh.tga]"..
					"@B[4,"..VeryHigh..",,hud/items/Item_goldveryhigh.tga]",
					1,"@L_MEASURE_ADMINISTRATE_DIPLOMACY_GIFT_HEAD_+0","@L_MEASURE_ADMINISTRATE_DIPLOMACY_GIFT_BODY_+0",GetID("Destination"))
	
	if GiftResult == 0 then
		Amount = VeryLow
	elseif GiftResult == 1 then
		Amount = Low
	elseif GiftResult == 2 then
		Amount = Medium
	elseif GiftResult == 3 then
		Amount = High
	elseif GiftResult == 4 then
		Amount = VeryHigh
	else
		StopMeasure()
	end
	
	f_SpendMoney("MyBoss", Amount, "misc")
	f_CreditMoney("Destination", Amount, "misc")
	
	-- message to the destination
	MsgNewsNoWait("Destination", "MyBoss", "", "politics", -1,
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_GIFT_RECEIVE_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_GIFT_RECEIVE_BODY", GetID("MyBoss"), Amount)
		
	if DynastyIsAI("Destination") then
		-- reaction for AI
		local AnswerTime = 0.1
		CreateScriptcall("Answer_Gift",AnswerTime,"Measures/ms_AdministrateDiplomacy.lua","AnswerGift","MyBoss","Destination",Amount)
	end
end

function RequestAllies()
	
	local DestID = GetDynastyID("Destination")
	local resultReq
	
	if not ReadyToRepeat("", "DIP_"..DestID) then
		MsgBoxNoWait("MyBoss","Destination",
				"@L_GENERAL_ERROR_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ERROR_COOLDOWN",GetID("Destination"))
		StopMeasure()
	end

	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	
	if CState ~= DIP_ALLIANCE then
		-- error - only allies answer requests
		MsgBoxNoWait("MyBoss","","@L_GENERAL_ERROR_HEAD_+0","@L_MEASURE_ADMINISTRATE_DIPLOMACY_ERROR_REQUEST_+0")
		StopMeasure()
	end
	
	local DesMoney = GetMoney("Destination")
	local Amount = math.floor(DesMoney*0.1)
	
	if DynastyIsPlayer("") then
		resultReq = MsgBox("MyBoss","Destination","@P"..
				"@B[1,@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_MONEY_BTN_+0]"..
				"@B[2,@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_ATTACK_BUILDING_BTN_+0]"..
				"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_GENERAL_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_GENERAL_BODY_+0",GetID("Destination"))
	else
		resultReq = 1
	end
	
	if resultReq == 1 then 
		SetRepeatTimer("", "DIP_"..DestID, 20)
		-- Can I have some money?
		MsgBoxNoWait("MyBoss","Destination","@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_MONEY_BTN_+0","@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_MONEY_BODY_+0",GetID("Destination"))
	
		-- message to the destination if player
		if DynastyIsPlayer("Destination") then
			MsgNewsNoWait("Destination","MyBoss","","politics",-1,
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_RECEIVE_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_RECEIVE_MONEY_BODY_+0",GetID("MyBoss"))
		else
			local AnswerTime = 0.15
			CreateScriptcall("Answer_Request",AnswerTime,"Measures/ms_AdministrateDiplomacy.lua","AnswerRequest","MyBoss","Destination",Amount)
		end
	elseif resultReq == 2 then
		
		-- please attack my enemy!
		
		local NumOfEnemies = f_DynastyGetNumOfEnemies("MyBoss")
		local EnemyID
		local EnemyButton = ""
		
		if NumOfEnemies == 0 then
			-- you have no enemies!
			MsgBoxNoWait("MyBoss","","@L_GENERAL_ERROR_HEAD_+0","@L_MEASURE_ADMINISTRATE_DIPLOMACY_ERROR_REQUEST_NOENEMIES_+0")
			StopMeasure()
		end
		
		-- my enemies
		
		for i=0, NumOfEnemies-1 do
			local FoundID = GetProperty("dynasty","Enemy_"..i)
			GetAliasByID(FoundID,"EnemyAlias_"..i)
			EnemyButton = EnemyButton.."@B["..i..","..GetName("EnemyAlias_"..i).."]"
			SetData("Enemy_"..i,"EnemyAlias_"..i)
		end
		
		local EnemyResult = MsgBox("MyBoss","Destination","@P"..
				EnemyButton,
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_ATTACK_ENEMY_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_ATTACK_ENEMY_BODY_+0",GetID("Destination"))
		
		if EnemyResult == "C" then
			StopMeasure()
		else
			for i=0, NumOfEnemies-1 do
				if EnemyResult==i then
					CopyAlias((GetData("Enemy_"..i)),"EnemyDyn")
					break
				end
			end
		end
		
		if not AliasExists("EnemyDyn") then
			StopMeasure()
		end
		
		-- select a random building for the AI attack
		if not DynastyGetRandomBuilding("EnemyDyn",2,-1,"EnemyBuilding") then
			-- no buildings found
			local BossID = dyn_GetValidMember("EnemyDyn")
			GetAliasByID(BossID, "Enemy")
			MsgBoxNoWait("MyBoss","","@L_GENERAL_ERROR_HEAD_+0","@L_MEASURE_ADMINISTRATE_DIPLOMACY_ERROR_REQUEST_NOBUILDINGS_+0",GetID("Enemy"))
			StopMeasure()
		end
		
		-- get the owner or boss
		
		if not BuildingGetOwner("EnemyBuilding","Enemy") then
			local BossID = dyn_GetValidMember("EnemyDyn")
			GetAliasByID(BossID, "Enemy")
		end
		
		-- all fine? then set the cooldown
		SetRepeatTimer("", "DIP_"..DestID, 20)
		
		-- Send a message to human players or calc AI reaction
		if DynastyIsPlayer("Destination") then
			MsgNewsNoWait("Destination","MyBoss","","politics",-1,
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_RECEIVE_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_RECEIVE_ATTACK_BUILDING_BODY_+0",GetID("MyBoss"),GetID("EnemyBuilding"))
		else
			-- AI reaction
			GetDynasty("Destination","DesDyn")
			-- for some reason we lose the Alias "MyBoss" at this point so save it to data
			SetData("MyBoss",GetID("MyBoss"))
			
			local BuildingDip = DynastyGetDiplomacyState("Destination","Enemy")
			local ThreatEnemy =  ai_DynastyCalcThreat("DesDyn","EnemyDyn")
			local Help = 0
			local EnemySettlement = GetSettlementID("EnemyBuilding")
			local AllySettlement = GetSettlementID("Destination")
			
			-- need same settlement as target
			if EnemySettlement ~= AllySettlement then
				-- get the lost Alias
				local BossID = GetData("MyBoss")
				GetAliasByID(BossID,"MyBoss")
			
				MsgBoxNoWait("MyBoss","Destination",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD_+0",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ATTACK_BUILDING_NO_SETTLEMENT_+0",GetID("Destination"),GetID("EnemyBuilding"))
				StopMeasure()
			end
			
			-- get the lost Alias
			local BossID = GetData("MyBoss")
			GetAliasByID(BossID,"MyBoss")
			
			if BuildingDip == DIP_FOE then
				-- yes
				Help = 1
			elseif BuildingDip >=DIP_NAP then
				-- no cause diplomatics
				MsgNewsNoWait("MyBoss","Destination","","politics",-1,
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ATTACK_BUILDING_NO_DIPLO_+0",GetID("Destination"),GetID("Enemy"))
				StopMeasure()
			else
				if ThreatEnemy >= 3 then
					-- no, too dangerous
					MsgNewsNoWait("MyBoss","Destination","","politics",-1,
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ATTACK_BUILDING_NO_THREAT_+0",GetID("Destination"),GetID("Enemy"))
					StopMeasure()
				else
					-- yes
					Help = 1
				end
			end
			
			-- check what we can do
			local TotalFound = 0
			local MyrmCount = DynastyGetWorkerCount("DesDyn", GL_PROFESSION_MYRMIDON)
			
			for i=0,MyrmCount-1 do
				if DynastyGetWorker("DesDyn", GL_PROFESSION_MYRMIDON, i, "CHECKME") then
					if SimIsWorkingTime("CHECKME") then
						if GetState("CHECKME", STATE_IDLE) then
							CopyAlias("CHECKME", "MEMBER"..TotalFound )
							TotalFound = TotalFound + 1
						else
							SimStopMeasure("CHECKME")
							CopyAlias("CHECKME", "MEMBER"..TotalFound )
							TotalFound = TotalFound + 1
						end
					end
				end
			end
	
			if TotalFound >0 then
				Help = 2 -- we can send thugs to bomb it
				local random = Rand(TotalFound)
				if not CopyAlias("MEMBER"..random, "Thug") then
					Help = 1 -- something went wrong
				end
			end
		
			-- ToDO: More possibilities?
			
			-- Send the answer
			if Help == 1 then 
				-- we want to help, but we can't
				MsgNewsNoWait("MyBoss","EnemyBuilding","","politics",-1,
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ATTACK_BUILDING_NO_SORRY_+0",GetID("Destination"),GetID("EnemyBuilding"))
				StopMeasure()
			elseif Help == 2 then
				-- okay, we send a thug to bomb the building.
				if DynastyGetWorker("DesDyn", GL_PROFESSION_MYRMIDON,0,"Thug") then
					MsgNewsNoWait("MyBoss","EnemyBuilding","","politics",-1,
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ATTACK_BUILDING_YES_BOMB_+0",GetID("Destination"),GetID("EnemyBuilding"))
				else
					-- we want to help, but we can't
					MsgNewsNoWait("MyBoss","EnemyBuilding","","politics",-1,
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ATTACK_BUILDING_NO_SORRY_+0",GetID("Destination"),GetID("EnemyBuilding"))
					StopMeasure()
				end
				
				SimStopMeasure("Thug")
				MeasureRun("Thug", "EnemyBuilding", "OrderASabotage_Bomb")
			end
		end
	end
end

function AnswerRequest(Amount)
	-- only help strong allies
	GetDynasty("Destination","DestinationDyn")
	GetDynasty("","AskerDyn")
	local Threat = ai_DynastyCalcThreat("DestinationDyn","AskerDyn")
	
	if Threat <2 then
		MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_MONEY_NO_THREAT",GetID("Destination"))
		return
	end
	
	-- only send money if we have enough
	if GetMoney("Destination")>10000 then
		-- 50% chance to accept
		if Rand(2) == 0 then
			--yes
			MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_MONEY_YES",GetID("Destination"),Amount)
			f_SpendMoney("Destination",Amount,"misc")
			f_CreditMoney("",Amount,"misc")
		else
			-- no
			MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_MONEY_NO",GetID("Destination"))
		end
	else
		-- no
		MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_MONEY_NO_LOWMONEY",GetID("Destination"))
	end
end

function AnswerGift(Amount)
	-- AI sends a message depending on how useful the gift is
	local DesMoney = GetMoney("Destination")
	local AmountPercent = (Amount*100)/DesMoney
	
	if AmountPercent <25 then -- no positive effect
		MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_GIFT_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_GIFT_NEUTRAL",GetID("Destination"))
	elseif AmountPercent >= 25 and AmountPercent <75 then -- small effect
		ModifyFavorToSim("Destination","",7)
		MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_GIFT_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_GIFT_POSITIVE",GetID("Destination"))
	else -- big effect
		ModifyFavorToSim("Destination","",14)
		MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_GIFT_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_GIFT_GRATEFUL",GetID("Destination"))
	end
end

function RequestEnemies()
	-- Do you really want to demand money from the target? You will lose some favor
	local DestID = GetDynastyID("Destination")
	
	if not ReadyToRepeat("", "DIP_"..DestID) then
		MsgBoxNoWait("MyBoss","Destination",
				"@L_GENERAL_ERROR_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_ERROR_COOLDOWN",GetID("Destination"))
		StopMeasure()
	end
	
	-- you cant make demands on feud
	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	
	if CState == DIP_FOE then
		MsgBoxNoWait("MyBoss","","@L_GENERAL_ERROR_HEAD_+0","@L_MEASURE_ADMINISTRATE_DIPLOMACY_ERROR_REQUEST_ENEMIES_+0")
		StopMeasure()
	end
	
	local DesMoney = GetMoney("Destination")
	local ReqFactor = 0.35
	-- factor goes down the more money destination has
	if DesMoney > 2500 and DesMoney < 10000 then
		ReqFactor = 0.3
	elseif DesMoney >= 10000 and DesMoney <20000 then
		ReqFactor = 0.25
	elseif DesMoney >= 20000 and DesMoney <40000 then
		ReqFactor = 0.2
	elseif DesMoney >= 40000 and DesMoney <80000 then
		ReqFactor = 0.1
	else
		ReqFactor = 0.05
	end
	
	local ReqMoney = math.floor(DesMoney*ReqFactor)
	local RequestResult = MsgBox("MyBoss","MyBoss","@P"..
					"@B[1,@L_MEASURE_TAKEOVERBID_BUTTON_YES_+0]"..
					"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
					"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_ENEMIES_HEAD_+0",
					"@L_MEASURE_ADMINISTRATE_DIPLOMACY_REQUEST_ENEMIES_BODY_+0",GetID("Destination"),ReqMoney)
					
	if RequestResult == 1 then
		SetRepeatTimer("", "DIP_"..DestID, 20)
		ModifyFavorToSim("Destination","MyBoss",(-10))
		CreateScriptcall("Answer_RequestEnemies",0.15,"Measures/ms_AdministrateDiplomacy.lua","AnswerRequestEnemies","MyBoss","Destination",ReqMoney)
	else
		StopMeasure()
	end
end

function AnswerRequestEnemies(ReqMoney)
	-- Will the destination pay? Depends on threat level
	GetDynasty("Destination","DestinationDyn")
	GetDynasty("","AskerDyn")
	local IsRival = ai_DynastyCheckForRival("DestinationDyn","AskerDyn")
	local Threat = ai_DynastyCalcThreat("DestinationDyn","AskerDyn")
	-- chance to accept
	local cta = 0
	if Threat == 1 then
		cta = 5
	elseif Threat == 2 then
		cta = 20
	elseif Threat == 3 then
		cta = 45
	elseif Threat == 4 then
		cta = 75
	end
	
	-- no rival
	if IsRival >0 then
		MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ENEMIES_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ENEMIES_RIVAL",GetID("Destination"))
		ModifyFavorToSim("Destination","MyBoss",(-5)) -- small loss
	else
		if cta > Rand(100) then
			-- accept
			MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ENEMIES_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ENEMIES_YES",GetID("Destination"),ReqMoney)
			ModifyFavorToSim("Destination","MyBoss",12) -- small bonus
			f_SpendMoney("Destination",ReqMoney,"misc")
			f_CreditMoney("",ReqMoney,"misc")
		else
			-- decline
			MsgNewsNoWait("","Destination","","politics",-1, "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ENEMIES_HEAD_+0", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_REQUEST_ENEMIES_NO",GetID("Destination"),ReqMoney)
			ModifyFavorToSim("Destination","MyBoss",(-10)) -- huge loss
		end
	end
end

function ConfirmFeud()
	-- Do you really want to declare war?
	local result
	
	if DynastyIsPlayer("") then
		result = MsgBox("MyBoss","MyBoss","@P"..
					"@B[1,@L_MEASURE_TAKEOVERBID_BUTTON_YES_+0]"..
					"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
					"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CONFIRM_HEAD_+0",
					"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CONFIRM_FOE_BODY_+0",GetID("Destination"))
	else
		result = 1
	end
		
	if result == 1 then 
		--Yes, declare war
			
		MsgBoxNoWait("MyBoss","Destination",
					"@LDIPLOMATIC_STATE_CHANGED_HEAD",
					"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CHANGED_FOE_+0",GetID("Destination"))
						
		if DynastyIsPlayer("Destination") then
			-- send a message to the destination
			MsgNewsNoWait("Destination","MyBoss","","politics",-1,
						"@LDIPLOMATIC_STATE_CHANGED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CHANGED_FOE_DESTINATION_+0",GetID("MyBoss"))
		end
			
		-- write an answer to the player if destination is AI
		if DynastyIsAI("Destination") and DynastyIsPlayer("MyBoss") then
			local AnswerTime = 0.1
			local Status = "FOE"
			CreateScriptcall("Answer_Diplomacy",AnswerTime,"Measures/ms_AdministrateDiplomacy.lua","AnswerLetter","MyBoss","Destination",Status)
		else	
			
			-- in case we downgrade from alliance (who would do that?) we need to remove properties
			if DynastyGetDiplomacyState("Destination","MyBoss") == DIP_ALLIANCE then
				f_DynastyRemoveAlly("MyBoss","Destination")
				f_DynastyRemoveAlly("Destination","MyBoss")
			end
			
			-- set the new status and favor
			DynastySetDiplomacyState("Destination","",DIP_FOE)
			DynastyForceCalcDiplomacy("MyBoss")
			SetFavorToDynasty("Destination","MyBoss",0)
			
			-- add the new property
			f_DynastyAddEnemy("MyBoss","Destination")
			f_DynastyAddEnemy("Destination","MyBoss")
			
		end
	else
		StopMeasure()
	end
end

function ConfirmNeutral()
	SetData("Offer","NEUTRAL")
	local result
	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	-- Do you really want a neutral agreement?
	if DynastyIsPlayer("") then
		result = MsgBox("MyBoss","Destination","@P"..
					"@B[1,@L_MEASURE_TAKEOVERBID_BUTTON_YES_+0]"..
					"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
					"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CONFIRM_HEAD_+0",
					"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CONFIRM_NEUTRAL_BODY_+0",GetID("Destination"))
	else
		result = 1
	end
						
	if result == 1 then
		-- check if we downgrade the status. No agreement needed then
		if CState > DIP_NEUTRAL then
				
			MsgBoxNoWait("MyBoss","Destination",
						"@LDIPLOMATIC_STATE_CHANGED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CHANGED_NEUTRAL_+0",GetID("Destination"))
								
			if DynastyIsPlayer("Destination") then
				-- send a message to the destination
				MsgNewsNoWait("Destination","MyBoss","","politics",-1,
						"@LDIPLOMATIC_STATE_CHANGED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CHANGED_NEUTRAL_DESTINATION_+0",GetID("MyBoss"))
			end			
			
			-- write an answer to the player if destination is AI
			if DynastyIsAI("Destination") and DynastyIsPlayer("MyBoss") then
				local Status = "NEUTRAL"
				local AnswerTime = 0.1
				CreateScriptcall("Answer_Diplomacy",AnswerTime,"Measures/ms_AdministrateDiplomacy.lua","AnswerLetter","MyBoss","Destination",Status)
			else
				-- set the new status and favor here
				DynastySetDiplomacyState("Destination","",DIP_NEUTRAL)
				DynastyForceCalcDiplomacy("MyBoss")
				if GetFavorToDynasty("MyBoss","Destination")>50 then
					SetFavorToDynasty("MyBoss","Destination",50)
				end
				
				-- in case we downgrade from alliance (who would do that?) we need to remove properties
				if CState == DIP_ALLIANCE then
					f_DynastyRemoveAlly("MyBoss","Destination")
					f_DynastyRemoveAlly("Destination","MyBoss")
				end
			end
				
		else
		
			-- we need to save the ID here because the MyBoss-Alias gets lost after AIDecision
			SetData("MyBossID",(GetID("MyBoss")))
			SetData("MyDestID",(GetID("Destination")))
			
			-- we have a feud and I want to end it. Hopefully destination agrees
			-- send a message to the destination and ask
			
			local MsgTimeOut = 1 --60sec wait-time to answer
			local DestResult = MsgNews("Destination","MyBoss",
								"@B[A,@L_FAMILY_2_COHABITATION_BIRTH_BAPTISM_BTN_+1]"..
								"@B[C,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_BTN_+1]",
								ms_administratediplomacy_AIDecision,  --AIFunc
								"politics", --MessageClass
								MsgTimeOut, --TimeOut
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_HEAD_+0",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_NEUTRAL_BODY",
								GetID("MyBoss"),GetID("Destination"))
				
	
			if DestResult == "C" then
				-- get the saved IDs
				local MyBoss = GetData("MyBossID")
				local Destination = GetData("MyDestID")
				GetAliasByID(MyBoss,"MyBoss")
				GetAliasByID(Destination,"Destination")
				
				--decline
				-- if player declines, he will lose favor
				if DynastyIsPlayer("Destination") then
					ModifyFavorToDynasty("Destination","",-10)
				end
			
				local ReasonToDecline = 0
				if HasData("ReasonToDecline") then
					ReasonToDecline = GetData("ReasonToDecline")
				end
						
				if ReasonToDecline == 0 then -- No! I don't like you. This option is always called for players.
					MsgBoxNoWait("MyBoss","Destination",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_HEAD_+0",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_BODY",GetID("Destination"))
				elseif ReasonToDecline == 1 then -- I don't fear you
					MsgBoxNoWait("MyBoss","Destination",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_HEAD_+0",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_NOTHREAT_BODY",GetID("Destination"))
				elseif ReasonToDecline == 2 then -- I will accept if you listen to my demands
					local ConfirmDemand = MsgBox("MyBoss","Destination","@P"..
											"@B[1,@L_MEASURE_TAKEOVERBID_BUTTON_YES_+0]"..
											"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
											"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_HEAD_+0",
											"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_DEMAND_BODY",GetID("Destination"))
					local Status = "NEUTRAL"
				
					if ConfirmDemand == 1 then
						ms_administratediplomacy_Demand(Status)
					end
				end
				StopMeasure()
			else
				-- get the saved IDs
				local MyBoss = GetData("MyBossID")
				local Destination = GetData("MyDestID")
				GetAliasByID(MyBoss,"MyBoss")
				GetAliasByID(Destination,"Destination")
				
				--accepted
				MsgBoxNoWait("MyBoss","Destination",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_ACCEPT_NEUTRAL_HEAD_+0",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_ACCEPT_NEUTRAL_BODY_+0",GetID("Destination"))
	
				if GetFavorToDynasty("MyBoss","Destination")<45 then
					SetFavorToDynasty("MyBoss","Destination",45)
				end
				DynastySetDiplomacyState("Destination","MyBoss",DIP_NEUTRAL)
				DynastyForceCalcDiplomacy("MyBoss")
				--remove enemy property
				if CState == DIP_FOE then
					f_DynastyRemoveEnemy("MyBoss","Destination")
					f_DynastyRemoveEnemy("Destination","MyBoss")
				end
			end
		end
	else
		StopMeasure()
	end
end

function ConfirmNAP()
	
	local result
	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	SetData("Offer","NAP")
	 -- Do you really want a NAP?
	if DynastyIsPlayer("") then
		result = MsgBox("MyBoss","Destination","@P"..
				"@B[1,@L_MEASURE_TAKEOVERBID_BUTTON_YES_+0]"..
				"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CONFIRM_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CONFIRM_NAP_BODY_+0",GetID("Destination"))
	else
		result = 1
	end
						
	if result == 1 then
		-- check if we downgrade the status. No agreement needed then
		if CState > DIP_NAP then
				
			MsgBoxNoWait("MyBoss","Destination",
						"@LDIPLOMATIC_STATE_CHANGED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CHANGED_NAP_+0",GetID("Destination"))
								
			if DynastyIsPlayer("Destination") then
				-- send a message to the destination
				MsgNewsNoWait("Destination","MyBoss","","politics",-1,
							"@LDIPLOMATIC_STATE_CHANGED_HEAD",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CHANGED_NAP_DESTINATION_+0",GetID("MyBoss"))
			end			
			
			-- write an answer to the player if destination is AI
			if DynastyIsAI("Destination") and DynastyIsPlayer("MyBoss") then
				local Status = "NAP"
				local AnswerTime = 0.1
				CreateScriptcall("Answer_Diplomacy",AnswerTime,"Measures/ms_AdministrateDiplomacy.lua","AnswerLetter","MyBoss","Destination",Status)
			else
				-- set the new status and favor here
				DynastySetDiplomacyState("Destination","",DIP_NAP)
				DynastyForceCalcDiplomacy("MyBoss")
				if GetFavorToDynasty("MyBoss","Destination")>60 then
					SetFavorToDynasty("MyBoss","Destination",60)
				end
				
				-- in case we downgrade from alliance (who would do that?) we need to remove properties
				if CState == DIP_ALLIANCE then
					f_DynastyRemoveAlly("MyBoss","Destination")
					f_DynastyRemoveAlly("Destination","MyBoss")
				end
			end
				
		else
			-- send a message to the destination and ask
			
			local VariableMessage -- different messsage if we want to end a feud
			if CState == DIP_FOE then
				VariableMessage = "@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_NAP_BODY"
			else
				VariableMessage = "@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_BODY"
			end
			
			-- we need to save the ID here because the MyBoss-Alias gets lost after AIDecision
			SetData("MyBossID",(GetID("MyBoss")))
			SetData("MyDestID",(GetID("Destination")))
			
			local MsgTimeOut = 1 --60sec wait-time to answer
			local DestResult = MsgNews("Destination","MyBoss",
								"@B[A,@L_FAMILY_2_COHABITATION_BIRTH_BAPTISM_BTN_+1]"..
								"@B[C,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_BTN_+1]",
								ms_administratediplomacy_AIDecision,  --AIFunc
								"politics", --MessageClass
								MsgTimeOut, --TimeOut
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_HEAD_+0",
								VariableMessage,
								GetID("MyBoss"),GetID("Destination"))
				
	
			if DestResult == "C" then
				-- get the saved IDs
				local MyBoss = GetData("MyBossID")
				local Destination = GetData("MyDestID")
				GetAliasByID(MyBoss,"MyBoss")
				GetAliasByID(Destination,"Destination")
				
				--decline
				-- if player declines, he will lose favor
				
				if DynastyIsPlayer("Destination") then
					ModifyFavorToDynasty("Destination","",-10)
				end
				
				local ReasonToDecline = 0
				if HasData("ReasonToDecline") then
					ReasonToDecline = GetData("ReasonToDecline")
				end
				
				-- different messages if foe or neutral
				if CState == DIP_FOE then
					if ReasonToDecline == 0 then -- No! I don't like you. This option is always called for players.
						MsgBoxNoWait("MyBoss","Destination",
									"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_HEAD_+0",
									"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_BODY",GetID("Destination"))
					elseif ReasonToDecline == 1 then -- I don't fear you
						MsgBoxNoWait("MyBoss","Destination",
									"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_HEAD_+0",
									"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_NOTHREAT_BODY",GetID("Destination"))
					else -- I will not accept anything unless you pay me some gold
						local ConfirmDemand = MsgBox("MyBoss","Destination","@P"..
											"@B[1,@L_MEASURE_TAKEOVERBID_BUTTON_YES_+0]"..
											"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
											"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_HEAD_+0",
											"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_DECLINE_DEMAND_BODY",GetID("Destination"))
						local Status = "NAP"
				
						if ConfirmDemand == 1 then
							ms_administratediplomacy_Demand(Status)
						else
							StopMeasure()
						end
					end
				else
					if ReasonToDecline == 0 then -- No! I don't like you. This option is always called for players.
						MsgBoxNoWait("MyBoss","Destination",
									"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_DECLINE_HEAD_+0",
									"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_DECLINE_BODY",GetID("Destination"))
					elseif ReasonToDecline == 1 then -- I don't fear you
						MsgBoxNoWait("MyBoss","Destination",
									"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_DECLINE_HEAD_+0",
									"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_DECLINE_NOTHREAT_BODY",GetID("Destination"))
					else -- I will not accept anything unless you pay me some gold
						local ConfirmDemand = MsgBox("MyBoss","Destination","@P"..
											"@B[1,@L_MEASURE_TAKEOVERBID_BUTTON_YES_+0]"..
											"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
											"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_DECLINE_HEAD_+0",
											"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_DECLINE_DEMAND_BODY",GetID("Destination"))
						local Status = "NAP"
				
						if ConfirmDemand == 1 then
							ms_administratediplomacy_Demand(Status)
						end
					end
					StopMeasure()
				end
			else
				--accepted
				
				-- get the saved IDs
				local MyBoss = GetData("MyBossID")
				local Destination = GetData("MyDestID")
				GetAliasByID(MyBoss,"MyBoss")
				GetAliasByID(Destination,"Destination")
				
				-- different messages if current state was feud
				if CState == DIP_FOE then
					MsgBoxNoWait("MyBoss","Destination",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_ACCEPT_NAP_HEAD_+0",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ENDFEUD_ACCEPT_NAP_BODY_+0",GetID("Destination"))
				else
					MsgBoxNoWait("MyBoss","Destination",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_ACCEPT_HEAD_+0",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_NAP_ACCEPT_BODY",GetID("Destination"))
				end
			
				if GetFavorToDynasty("MyBoss","Destination")<50 then
					SetFavorToDynasty("MyBoss","Destination",50)
				end
				DynastySetDiplomacyState("Destination","MyBoss",DIP_NAP)
				DynastyForceCalcDiplomacy("MyBoss")
				
				--remove enemy property
				if CState == DIP_FOE then
					f_DynastyRemoveEnemy("MyBoss","Destination")
					f_DynastyRemoveEnemy("Destination","MyBoss")
				end
			end
		end
	else	
		StopMeasure()
	end
end

function ConfirmAlliance()
	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	local result
	SetData("Offer","ALLIANCE")
	 -- Do you really want a Alliance?
	if DynastyIsPlayer("") then
		result = MsgBox("MyBoss","Destination","@P"..
				"@B[1,@L_MEASURE_TAKEOVERBID_BUTTON_YES_+0]"..
				"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CONFIRM_HEAD_+0",
				"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CONFIRM_ALLIANCE_BODY_+0",GetID("Destination"))
	else
		result = 1
	end
						
	if result == 1 then
		-- send a message to the destination and ask
		
		-- we need to save the ID here because the MyBoss-Alias gets lost after AIDecision
		SetData("MyBossID",(GetID("MyBoss")))
		SetData("MyDestID",(GetID("Destination")))
		
		local MsgTimeOut = 1 --60sec wait-time to answer
		local DestResult = MsgNews("Destination","MyBoss",
							"@B[A,@L_FAMILY_2_COHABITATION_BIRTH_BAPTISM_BTN_+1]"..
							"@B[C,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_BTN_+1]",
							ms_administratediplomacy_AIDecision,  --AIFunc
							"politics", --MessageClass
							MsgTimeOut, --TimeOut
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_HEAD_+0",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_BODY",
							GetID("MyBoss"),GetID("Destination"))
	
		if DestResult == "C" then
			--decline
			-- get the saved IDs
				local MyBoss = GetData("MyBossID")
				local Destination = GetData("MyDestID")
				GetAliasByID(MyBoss,"MyBoss")
				GetAliasByID(Destination,"Destination")
				
			-- if player declines, he will lose favor
				
			if DynastyIsPlayer("Destination") then
				ModifyFavorToDynasty("Destination","",-10)
			end
				
			local ReasonToDecline = 0
			if HasData("ReasonToDecline") then
				ReasonToDecline = GetData("ReasonToDecline")
			end
				
			if ReasonToDecline == 0 then -- No! I don't like you. This option is always called for players.
				MsgBoxNoWait("MyBoss","Destination",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_HEAD_+0",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_BODY",GetID("Destination"))
			elseif ReasonToDecline == 1 then -- I don't fear you
				MsgBoxNoWait("MyBoss","Destination",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_HEAD_+0",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_NOTHREAT_BODY",GetID("Destination"))
			elseif ReasonToDecline == 3 then -- You are a rival, i will not ally with you
				GetDynasty("MyBoss","MyDyn")
				GetDynasty("Destination","DestDyn")
				local RivalID = ai_DynastyCheckForRival("DestDyn","MyDyn")
				GetAliasByID(RivalID,"RivalAlias")
				
				if IsType("RivalAlias","Sim") then -- political ambitions
					
					MsgBoxNoWait("MyBoss","Destination",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_HEAD_+0",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_RIVAL_SIM_BODY",GetID("Destination"),RivalID)
				else -- same building
					MsgBoxNoWait("MyBoss","Destination",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_HEAD_+0",
								"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_RIVAL_BUILDING_BODY",GetID("Destination"),RivalID)
				end
			else -- I will not accept anything unless you pay me some gold
				local ConfirmDemand = MsgBox("MyBoss","Destination","@P"..
										"@B[1,@L_MEASURE_TAKEOVERBID_BUTTON_YES_+0]"..
										"@B[C,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
										"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_HEAD_+0",
										"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_DECLINE_DEMAND_BODY",GetID("Destination"))
				local Status = "ALLIANCE"
				
				if ConfirmDemand == 1 then
					ms_administratediplomacy_Demand(Status)
				end
			end
			StopMeasure()
		else
			-- get the saved IDs
				local MyBoss = GetData("MyBossID")
				local Destination = GetData("MyDestID")
				GetAliasByID(MyBoss,"MyBoss")
				GetAliasByID(Destination,"Destination")
				
			--accepted
			MsgBoxNoWait("MyBoss","Destination",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_ACCEPT_HEAD_+0",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_STATUS_ALLIANCE_ACCEPT_BODY",GetID("Destination"))
	
			if GetFavorToDynasty("MyBoss","Destination")<75 then
				SetFavorToDynasty("MyBoss","Destination",75)
			end
			DynastySetDiplomacyState("Destination","MyBoss",DIP_ALLIANCE)
			DynastyForceCalcDiplomacy("MyBoss")
			-- add the new property
			f_DynastyAddAlly("MyBoss","Destination")
			f_DynastyAddAlly("Destination","MyBoss")
			
			--remove enemy property
			if CState == DIP_FOE then
				f_DynastyRemoveEnemy("MyBoss","Destination")
				f_DynastyRemoveEnemy("Destination","MyBoss")
			end
			StopMeasure()
		end
	else
		StopMeasure()
	end
end

function AIDecision()
	-- Is the AI going to accept my offer?
	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	local OfferedState = GetData("Offer")
	if not GetDynasty("Destination","DestinationDyn") then
		return "A"
	end
	if not GetDynasty("MyBoss","AskerDyn") then
		return "A"
	end
	
	local DesiredState = ai_DynastyGetBestDiplomacyState("DestinationDyn","AskerDyn")
	local CurrentFavor = GetFavorToDynasty("AskerDyn","DestinationDyn")
	local MinFavor = 0
	local IsRival = ai_DynastyCheckForRival("DestinationDyn","AskerDyn")
	local RivalAllowed = true
	local Threat = ai_DynastyCalcThreat("DestinationDyn","AskerDyn")
	local MinThreat = 0
	
	if not AliasExists("Destination") then
		LogMessage("Destination fehlt")
	end
	
	if not AliasExists("MyBoss") then
		LogMessage("My Boss fehlt")
	end
	
	if OfferedState == "ALLIANCE" then
		MinFavor = 75
		MinThreat = 2
		RivalAllowed = false
	elseif OfferedState == "NAP" then
		MinFavor = 40
		MinThreat = 1
	elseif OfferedState == "NEUTRAL" then
		MinFavor = 30
		MinThreat = 0
	end
	
	if OfferedState == DesiredState then
		return "A" --yes
	elseif OfferedState == "NEUTRAL" and DesiredState == "NAP" then
		return "A"
	else 
		if RivalAllowed or IsRival==0 then
			if CurrentFavor >= MinFavor then
				if DesiredState ~= "ALLIANCE" then -- special thoughts about alliances
					if CurrentFavor <90 then
						if Threat >= MinThreat then
							SetData("ReasonToDecline",2) -- I will make a demand
							return "C" -- no
						else
							SetData("ReasonToDecline",1) -- You are not dangerous enough
							return "C"
						end
					else
						return "A" -- okay, we have an friendship already, let's make it official
					end
				else
					if Threat >= MinThreat then
						SetData("ReasonToDecline",2) -- I will make a demand
						return "C" -- no
					else
						SetData("ReasonToDecline",1) -- You are not dangerous enough
						return "C"
					end
				end
			else
				SetData("ReasonToDecline",0) -- I don't like you
				return "C" -- no
			end
		else
			SetData("ReasonToDecline",3) -- rival
			return "C" -- no 
		end
	end
end

function AnswerLetter(NewState)
	-- You downgraded our relation. Our reaction is either positive (1) or negative (2). This is purely RP though
	
	GetDynasty("Destination","DynastyAlias")
	GetDynasty("","MyDyn")
	
	local CState = DynastyGetDiplomacyState("Destination","")
	local Reaction = 0
	local DipStatus
	local MinFavor = 0
	local MaxFavor = 0
	local CurrentFavor = GetFavorToDynasty("MyDyn","DynastyAlias")
	
	if NewState == "FOE" then
		DipStatus = DIP_FOE
	elseif NewState == "NEUTRAL" then
		DipStatus = DIP_NEUTRAL
		MinFavor = 35
		MaxFavor = 50
	elseif NewState == "NAP" then
		DipStatus = DIP_NAP
		MinFavor = 45
		MaxFavor = 60
	end
	
	if ai_DynastyGetBestDiplomacyState("DynastyAlias","MyDyn") == NewState then
		Reaction = 1 -- positive reaction
	else
		Reaction = 2 -- negative reaction
	end
	
	-- set the new status and favor here
	DynastySetDiplomacyState("","Destination",DipStatus)
	DynastyForceCalcDiplomacy("")
	
	if DipStatus == DIP_FOE then
		-- add the new property
		f_DynastyAddEnemy("","Destination")
		f_DynastyAddEnemy("Destination","")
	end
	
	-- remove properties
	if CState == DIP_ALLIANCE then
		f_DynastyRemoveAlly("","Destination")
		f_DynastyRemoveAlly("Destination","")
	elseif CState == DIP_FOE then
		f_DynastyRemoveEnemy("","Destination")
		f_DynastyRemoveEnemy("Destination","")
	end

	if CurrentFavor<MinFavor then
		SetFavorToDynasty("MyDyn","DynastyAlias",MinFavor)
	elseif CurrentFavor>MaxFavor then
		SetFavorToDynasty("MyDyn","DynastyAlias",MaxFavor)
	end
	
	if NewState == "FOE" then
		if Reaction == 1 then
			MsgNewsNoWait("","Destination","","politics",-1, "@LDIPLOMATIC_STATE_CHANGED_HEAD", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_FOE_POSITIVE",GetID("MyBoss"))
		else
			MsgNewsNoWait("","Destination","","politics",-1, "@LDIPLOMATIC_STATE_CHANGED_HEAD", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_FOE_NEGATIVE",GetID("MyBoss"))
		end
	elseif NewState == "NEUTRAL" then
		if Reaction == 1 then
			MsgNewsNoWait("","Destination","","politics",-1, "@LDIPLOMATIC_STATE_CHANGED_HEAD", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_NEUTRAL_POSITIVE",GetID("MyBoss"))
		else
			MsgNewsNoWait("","Destination","","politics",-1, "@LDIPLOMATIC_STATE_CHANGED_HEAD", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_NEUTRAL_NEGATIVE",GetID("MyBoss"))
		end
	elseif NewState == "NAP" then
		if Reaction == 1 then
			MsgNewsNoWait("","Destination","","politics",-1, "@LDIPLOMATIC_STATE_CHANGED_HEAD", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_NAP_POSITIVE",GetID("MyBoss"))
		else
			MsgNewsNoWait("","Destination","","politics",-1, "@LDIPLOMATIC_STATE_CHANGED_HEAD", "@L_MEASURE_ADMINISTRATE_DIPLOMACY_ANSWER_NAP_NEGATIVE",GetID("MyBoss"))
		end
	end
end

function Demand(RequestedState)
	-- to end our feud we demand you to...
	
	-- get the saved IDs
	local MyBoss = GetData("MyBossID")
	local Destination = GetData("MyDestID")
	GetAliasByID(MyBoss,"MyBoss")
	GetAliasByID(Destination,"Destination")
	
	local CState = DynastyGetDiplomacyState("Destination","MyBoss")
	
	local MoneyToPay = 0
	local MyCash = GetMoney("MyBoss")
	local DestCash = GetMoney("Destination")
	local HasEnemy = 0
	local NewDip
	
	local MinFavor = 0
	local MaxFavor = 0
	
	if RequestedState == "NEUTRAL" then
		MoneyToPay = 2500+(math.floor(DestCash*0.1))+(math.floor(MyCash*0.05))
		NewDip = DIP_NEUTRAL
		MinFavor = 30
		MaxFavor = 50
			
	elseif RequestedState == "NAP" then
		MoneyToPay = 5000+(math.floor(DestCash*0.1))+(math.floor(MyCash*0.05))
		if DynastyGetDiplomacyState("MyBoss","Destination")==DIP_FOE then
			MoneyToPay = MoneyToPay*2
		end
		NewDip = DIP_NAP
		MinFavor = 40
		MaxFavor = 60
	elseif RequestedState == "ALLIANCE" then
		MoneyToPay = 7500+(math.floor(DestCash*0.2))+(math.floor(MyCash*0.1))
		NewDip = DIP_ALLIANCE
		MinFavor = 75
		MaxFavor = 100
	end
	
	-- alternative make war with my enemy
	
	-- get all relevant dynasties and data
	
	local MyEnemiesCount = f_DynastyGetNumOfEnemies("MyBoss")
	
	GetDynasty("MyBoss","MyDyn")
	GetDynasty("Destination","DestDyn")
	
	local MyCityID = GetSettlementID("MyBoss")
	
	local CurrentFavor = GetFavorToDynasty("MyBoss","DestDyn")
	
	-- only count dynasties in our city
	for i=0, MyEnemiesCount-1 do
		if HasProperty("MyDyn","Enemy_"..MyEnemiesCount) then
			local FoundID = GetProperty("MyDyn","Enemy_"..MyEnemiesCount)
			GetAliasByID(FoundID,"Enemy_"..i)
			local BossID = dyn_GetValidMember("Enemy_"..i)
			GetAliasByID(BossID, "EnemyBoss")
			if DynastyGetDiplomacyState("DestDyn", "Enemy_"..i)<DIP_NAP then
				if GetSettlementID("EnemyBoss")==MyCityID then
					-- calc threat-level. 3/4 means we need assistance
					if ai_DynastyCalcThreat("DestDyn","Enemy_"..i) >= 2 then
						CopyAlias("EnemyBoss","EnemyAlias")
						break
					end
				end
			end
		end
	end
	
	
	if AliasExists("EnemyAlias") then
		HasEnemy = 1
		SetData("DemandEnemy",(GetID("EnemyAlias")))
	end
	
	if HasEnemy == 0 then
		-- No enemy, we want money
		local accept = MsgBox("MyBoss","Destination","@P"..
						"@B[1,@L_FAMILY_2_COHABITATION_BIRTH_BAPTISM_BTN_+1]"..
						"@B[C,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_BTN_+1]",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_MESSAGE_HEAD_+0",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_MESSAGE_"..RequestedState.."_BODY",
						GetID("Destination"),MoneyToPay)
		
		if accept == "C" then
			StopMeasure()
		elseif accept == 1 then
			if GetMoney("MyBoss")>=MoneyToPay then
				f_SpendMoney("MyBoss",MoneyToPay,"Diplomatics")
				f_CreditMoney("Destination",MoneyToPay,"Diplomatics")
				
				-- set the new status and favor here
				DynastySetDiplomacyState("MyBoss","Destination",NewDip)
				DynastyForceCalcDiplomacy("MyBoss")
				
				if NewDip == DIP_ALLIANCE then
					-- add the new property
					f_DynastyAddAlly("MyBoss","Destination")
					f_DynastyAddAlly("Destination","MyBoss")
				end
				
				-- remove properties
				if CState == DIP_FOE then
					f_DynastyRemoveEnemy("MyBoss","Destination")
					f_DynastyRemoveEnemy("Destination","MyBoss")
				end

				if CurrentFavor<MinFavor then
					SetFavorToDynasty("MyBoss","DestDyn",MinFavor)
				elseif CurrentFavor>MaxFavor then
					SetFavorToDynasty("MyBoss","DestDyn",MaxFavor)
				end
				
				MsgBoxNoWait("MyDynBoss","Destination",
						"@LDIPLOMATIC_STATE_CHANGED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_CHANGED_"..RequestedState.."_+0",GetID("Destination"))
			else
				MsgBoxNoWait("MyDynBoss","Destination",
						"@LDIPLOMATIC_DEMAND_FAILED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_FAILED_BODY_+0",GetID("Destination"))
				StopMeasure()
			end
		end
	else	
		-- you can make war with our enemy or pay us the gold
		local Choice = MsgBox("MyBoss","EnemyAlias","@P"..
							"@B[1,@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_MESSAGE_CHOICE_MONEY]"..
							"@B[2,@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_MESSAGE_CHOICE_WAR]"..
							"@B[C,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_BTN_+1]",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_MESSAGE_HEAD_+0",
							"@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_MESSAGE_CHOICE_BODY",
							GetID("Destination"),MoneyToPay,GetID("EnemyAlias"))
		
		if Choice == "C" then
			StopMeasure()
		elseif Choice == 1 then
			if GetMoney("MyBoss")>=MoneyToPay then
				f_SpendMoney("MyBoss",MoneyToPay,"Diplomatics")
				f_CreditMoney("Destination",MoneyToPay,"Diplomatics")
				
				-- set the new status and favor here
				DynastySetDiplomacyState("MyBoss","DestDyn",NewDip)
				DynastyForceCalcDiplomacy("MyBoss")
				
				if NewDip == DIP_ALLIANCE then
					-- add the new property
					f_DynastyAddAlly("MyBoss","Destination")
					f_DynastyAddAlly("Destination","MyBoss")
				end
				
				-- remove properties
				if CState == DIP_FOE then
					f_DynastyRemoveEnemy("MyBoss","Destination")
					f_DynastyRemoveEnemy("Destination","MyBoss")
				end
				
				if CurrentFavor<MinFavor then
					SetFavorToDynasty("MyBoss","DestDyn",MinFavor)
				elseif CurrentFavor>MaxFavor then
					SetFavorToDynasty("MyBoss","DestDyn",MaxFavor)
				end
				
				MsgBoxNoWait("MyBoss","Destination",
						"@LDIPLOMATIC_STATE_CHANGED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_CHANGED_"..RequestedState.."_+0",GetID("Destination"))
			else
				MsgBoxNoWait("MyBoss","Destination",
						"@LDIPLOMATIC_DEMAND_FAILED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_FAILED_BODY_+0",GetID("Destination"))
				StopMeasure()
			end
		elseif Choice == 2 then
			-- set the new status and favor here
			DynastySetDiplomacyState("MyDyn","DestDyn",NewDip)
			
			if NewDip == DIP_ALLIANCE then
				-- add the new property
				f_DynastyAddAlly("MyBoss","Destination")
				f_DynastyAddAlly("Destination","MyBoss")
			end
			
			-- remove properties
			if CState == DIP_FOE then
				f_DynastyRemoveEnemy("MyBoss","Destination")
				f_DynastyRemoveEnemy("Destination","MyBoss")
			end

			if CurrentFavor<MinFavor then
				SetFavorToDynasty("MyDyn","DestDyn",MinFavor)
			elseif CurrentFavor>MaxFavor then
				SetFavorToDynasty("MyDyn","DestDyn",MaxFavor)
			end
			
			-- set the favor to the enemy
			SetFavorToDynasty("EnemyAlias","MyDyn",0)
			DynastySetDiplomacyState("MyDyn","EnemyAlias",DIP_FOE)
			DynastyForceCalcDiplomacy("MyDyn")
			f_DynastyAddEnemy("MyBoss","EnemyAlias")
			
			if DynastyIsPlayer("EnemyAlias") then
				-- send a message to the enemy
				MsgNewsNoWait("EnemyAlias","MyBoss","","politics",-1,
						"@LDIPLOMATIC_STATE_CHANGED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_CHANGED_FOE_DESTINATION_+0",GetID("MyBoss"),GetID("Destination"))
			end
			
			MsgBoxNoWait("MyBoss","Destination",
						"@LDIPLOMATIC_STATE_CHANGED_HEAD",
						"@L_MEASURE_ADMINISTRATE_DIPLOMACY_DEMAND_MESSAGE_ACCEPTED_WAR_FOR_"..RequestedState.."_+0",GetID("EnemyAlias"),GetID("Destination"))
			StopMeasure()
		else
			StopMeasure()
		end
	end
end

function CleanUp()
end