function Run()
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	local MenCnt = GetProperty("", "ShipMenCnt") * GetImpactValue("", "ShipMenMod")
	SetProcessMaxProgress("",MenCnt)
	

	if (MenCnt == 0) then
		-- tell ze plaier zat he niidz a party
		MsgQuick("","@L_GENERAL_MEASURES_PLUNDERSHIP_MSG_+1")
		StopMeasure()
	end
	
	if GetImpactValue("Destination","shipplunderedtoday")>0 then
		MsgQuick("","@L_GENERAL_MEASURES_PLUNDERSHIP_MSG_+0")
		StopMeasure()
	end
	
	local OtherMenCnt = GetProperty("Destination", "ShipMenCnt") * GetImpactValue("Destination", "ShipMenMod")
	SetProcessMaxProgress("Destination",OtherMenCnt)
	
	MeasureSetNotRestartable()
	
	if not f_Follow("", "Destination", GL_MOVESPEED_RUN,700,true) then
		StopMeasure()
	end
	
	SetState("", STATE_HIDDEN, false)
	
	local NumCrew = GetProperty("Destination","ShipMenCnt")
	local NumCannons = GetProperty("Destination","ShipCannonCntBase") * GetImpactValue("","ShipCannonMod")
	local Booty = chr_GetBootyCount("Destination",INVENTORY_STD)
	local Result = "A"
	if GetDynasty("Destination","VictimDynasty") and DynastyIsPlayer("VictimDynasty") then
		
		MoveStop("Destination")
		if GetImpactValue("Destination","messagesent")==0 then
			Result = MsgNews("Destination","Destination","@P"..
					"@B[A,@L_PIRATE_PLUNDERSHIP_MSG_BUTTONS_+0]"..
					"@B[D,@L_PIRATE_PLUNDERSHIP_MSG_BUTTONS_+1]"..
					"@B[B,@L_PIRATE_PLUNDERSHIP_MSG_BUTTONS_+2]"..
					"@B[C,@L_PIRATE_PLUNDERSHIP_MSG_BUTTONS_+3]",
					-1,"intrigue",0.25,
					"@L_PIRATE_PLUNDERSHIP_MSG_HEAD_+0",
					"@L_PIRATE_PLUNDERSHIP_MSG_BODY_+0",
					GetID("Destination"),NumCrew,NumCannons,Booty)
		else
			Result = MsgNews("Destination","Destination","@P"..
					"@B[A,@L_PIRATE_PLUNDERSHIP_MSG_BUTTONS_+0]"..
					"@B[D,@L_PIRATE_PLUNDERSHIP_MSG_BUTTONS_+1]"..
					"@B[B,@L_PIRATE_PLUNDERSHIP_MSG_BUTTONS_+2]",
					-1,"intrigue",0.25,
					"@L_PIRATE_PLUNDERSHIP_MSG_HEAD_+0",
					"@L_PIRATE_PLUNDERSHIP_MSG_BODY_+0",
					GetID("Destination"),NumCrew,NumCannons,Booty)
		end
		
	else
		if GetHPRelative("Destination")>0.7 then
			local Type = CartGetType("Destination")
			local AttackChance = 2*((Booty+(NumCrew+NumCannons)*10)/1000)
			if Type == EN_CT_MERCHANTMAN_BIG then
				AttackChance = AttackChance + 25
			elseif Type == EN_CT_WARSHIP then
				AttackChance = AttackChance + 80
			elseif Type == EN_CT_CORSAIR then
				AttackChance = AttackChance + 97
			else
				AttackChance = AttackChance + 10
			end
			if Rand(100) < AttackChance then
				BattleJoin("Destination","",true)
				return
			end
		end
	end
	
	if Result then
		if Result == "D" then
			BattleJoin("Destination","",true)			
		elseif Result == "C" then
			GetHomeBuilding("Destination","FleePos")
			if GetImpactValue("Destination","messagesent")==0 then
				AddImpact("Destination","messagesent",1,1)
				f_MoveToNoWait("Destination","FleePos",GL_MOVESPEED_RUN)
				Sleep(2)
				StopMeasure()
			end
		end
	end
	
	
	PlaySound3DVariation("","Locations/alarm_horn_single",1)
	SetData("FightAnim",1)
	if not SendCommandNoWait("Destination","DeckFight") then
		StopMeasure()
	end
	
	local HPLoss = 0.05 * GetMaxHP("")
	local OtherHPLoss = 0.05 * GetMaxHP("Destination")
	
	if Result == "A" then
		ModifyHP("",-HPLoss,false)
		ModifyHP("Destination",-OtherHPLoss,false)
		while ((MenCnt > 0)  and (OtherMenCnt > 0)) do
			if (OtherMenCnt == MenCnt) then 
				local OneOrAnother = Rand(10)
				if (OneOrAnother <= 5) then
					MenCnt = MenCnt - 1
				else
					OtherMenCnt = OtherMenCnt - 1
				end
			end
			
			local relation = MenCnt / OtherMenCnt
			local MenLoss = 0
			local OtherMenLoss = 0
			if (relation < 1) then
				MenLoss = (0.2*MenCnt) +1 
				OtherMenLoss = 0.1*MenCnt
			elseif (relation > 1) then
				MenLoss = 0.1*OtherMenCnt
				OtherMenLoss = (0.2*OtherMenCnt) +1
			end
		
			local oldmencount = MenCnt
			local oldothermencount = OtherMenCnt 
			
			MenCnt = math.floor(MenCnt - MenLoss)
			OtherMenCnt = math.floor(OtherMenCnt - OtherMenLoss)

			ShowOverheadSymbol("", false, false, 0, "@L_GENERAL_OVERHEADSYMBOL_MENCNT_DEC_+0", MenCnt - oldmencount)  
			ShowOverheadSymbol("Destination", false, false, 0, "@L_GENERAL_OVERHEADSYMBOL_MENCNT_DEC_+0", OtherMenCnt - oldothermencount) 
				
			if (MenCnt < 0) then 
				MenCnt = 0
			end
			if (OtherMenCnt < 0) then 
				OtherMenCnt = 0
			end
	
			SetProcessProgress("",MenCnt)
			SetProcessProgress("Destination",OtherMenCnt)
			SetProperty("","ShipMenCnt", MenCnt / GetImpactValue("", "ShipMenMod"))
			SetProperty("Destination","ShipMenCnt", OtherMenCnt / GetImpactValue("Destination", "ShipMenMod"))
	
			GetPosition("Destination", "MyPos")			
			Sleep (2)
		end
	end
	
	AddImpact("Destination","shipplunderedtoday",1,6)
	
	SetData("FightAnim",2)
	while not (GetData("FightAnim")==3) do
		Sleep(1) 
	end
	ResetProcessProgress("")
	ResetProcessProgress("Destination")
	
	if (MenCnt < OtherMenCnt) then
		-- plunder failed
		MsgQuick("","@L_GENERAL_MEASURES_PLUNDERSHIP_MSG_+2")
		StopMeasure()
		return
	end
	
	GetLocalPlayerDynasty("LocalPlayerDynasty")
	if (GetID("LocalPlayerDynasty") == GetDynastyID("")) then
		gameplayformulas_StartHighPriorMusic(MUSIC_ENEMY_SHIP_PLUNDERED)
	elseif (GetID("LocalPlayerDynasty") == GetDynastyID("Destination")) then
		gameplayformulas_StartHighPriorMusic(MUSIC_SHIP_PLUNDERED)
	end
	
	local Money = Plunder("","Destination",22)
	if (Money > 0) then
		ModifyHP("Destination",-1,false)
		PlaySound3DVariation("","measures/plunderbuilding",1)
	
		Sleep(10)

		
	else
		--nothing to plunder, give some money
		GetHomeBuilding("","MyPiratesnest")
		local Level = BuildingGetLevel("MyPiratesnest")
		local EnemyType = CartGetType("Destination")
		local Bonus = 0
		if EnemyType == EN_CT_MERCHANTMAN_SMALL then
			Bonus = 1
		elseif EnemyType == EN_CT_MERCHANTMAN_BIG then
			Bonus = 2
		elseif EnemyType == EN_CT_WARSHIP then
			Bonus = 3
		else
			Bonus = 0
		end	
		Money = Rand(400)+Level * Bonus * 200
		f_CreditMoney("dynasty",Money,"IncomeRobbers")
		economy_UpdateBalance("MyPiratesnest", "Theft", Money)
		ShowOverheadSymbol("", false, false, 0, "@L%1t",Money)
	end
	
	--for the mission
	mission_ScoreCrime("",Money)
	
	
	if HasProperty("Destination","BeeingPlundered") then
		local PlunderCount = GetProperty("Destination","BeeingPlundered") + 1
		SetProperty("Destination","BeeingPlundered",PlunderCount)
	else
		SetProperty("Destination","BeeingPlundered",1)
	end
		
	
--	GetFleePosition("", "Destination", 1500, "Away")
--	f_MoveTo("", "Away", GL_MOVESPEED_RUN)
	StopMeasure()
end

function DeckFight()
	Attach3DSound("Destination","ambient/battle+0.wav",1)
	while GetData("FightAnim")==1 do
		GetPosition("","ShipPos")
		local tx,ty,tz = PositionGetVector("ShipPos") 
		PositionSetVector("ShipPos",tx,ty+130,tz)
		--PlaySound3D("","ambient/battle+0.wav",1)
		GfxStartParticle("ParticleSpawn","particles/deckfight.nif","ShipPos",7)
		Sleep(3)
		GfxStopParticle("ParticleSpawn")	
	end
	Detach3DSound("")
	SetData("FightAnim",3)
end
-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	Detach3DSound("")
	ResetProcessProgress("")
	if AliasExists("Destination") then
		ResetProcessProgress("Destination")
	end
end

