function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	--SetStateImpact("no_control")
	--SetStateImpact("no_measure_start")	
	SetStateImpact("no_measure_attach")	
	--SetStateImpact("no_charge")
	--SetStateImpact("no_arrestable")
end

function Run()

	-- state initiated by ms_134_PressProtectionMoney.lua
	local iVictimBuildingID = GetProperty("", "RobberProtecting")
	if (GetAliasByID(iVictimBuildingID, "VictimBuilding") == false) then
		return
	end
	
	if not HasProperty("","TotalMoney") then
		return
	end
	
	if not GetDynasty("VictimBuilding", "VictimDyn") then 
		return
	end
	
	if not GetOutdoorMovePosition("", "VictimBuilding", "FrontPos") then
		return
	end

	-- 12 hours atm
	local fMeasureDuration = 12
	local secstowait = Gametime2Realtime(fMeasureDuration)
	local fullsecstowait = secstowait
	SetProcessMaxProgress("",secstowait)
	SetProcessProgress("",0)
	while (secstowait > 0) do
		-- dead or something -> break
		if (GetState("", STATE_DEAD) or GetState("", STATE_UNCONSCIOUS)) then
			return
		end

		local CurrentMeasure = GetCurrentMeasureName("")
		local bFighting = GetState("", STATE_FIGHTING)	

		-- if other measure runing rather than ms_134_PressProtectionMoney || state fighting
		if ((CurrentMeasure ~= NIL) and (CurrentMeasure ~= "PressProtectionMoney") and (bFighting == false)) then
			return
		end
				
		--more than 5 meters of door pos
		if ((bFighting == false) and (GetDistance("", "FrontPos") > 500)) then 
			f_MoveToNoWait("","FrontPos",GL_MOVESPEED_RUN, 250)
		end
		
		Sleep(3)
		secstowait = secstowait - 3
		SetProcessProgress("",fullsecstowait-secstowait)		
	end
		
	local fSingleMoney = GetProperty("","TotalMoney")
	
	--gold transfer, every robber on his own
	f_SpendMoney("VictimBuilding", fSingleMoney, "CostRobbers",true)
	
	MsgQuick("VictimBuilding","@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_END_HEAD_+0")
	
	MsgNewsNoWait("","VictimBuilding","","intrigue",-1,
			"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_END_HEAD_+0",
			"@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_ACTOR_END_BODY_+0",
			GetID("VictimBuilding"))
	
	chr_RecieveMoney("", fSingleMoney, "IncomeRobbers")
	chr_GainXP("",100)
	--for the mission
	mission_ScoreCrime("",fSingleMoney)
	
	ResetProcessProgress("")
	return
end

function CleanUp()
	if HasProperty("","TotalMoney") then
		RemoveProperty("","TotalMoney")
	end
	ResetProcessProgress("")
	local iVictimBuildingID = GetProperty("", "RobberProtecting")
	RemoveProperty("", "RobberProtecting")
	
	local result = GetAliasByID(iVictimBuildingID, "VictimBuilding")
	if (result == false) then
		return
	end

	local iCurrentRobberCnt = GetProperty("VictimBuilding", "RobberCnt")
	if (iCurrentRobberCnt  == NIL) then
		return 
	end	

	iCurrentRobberCnt = iCurrentRobberCnt - 1
	
	-- last one removes the properties
	if (iCurrentRobberCnt == 0) then
		SimGetWorkingPlace("","MyRobbercamp")
		BuildingGetOwner("MyRobbercamp","MrRobber")
		local OwnerID = GetID("MrRobber")
	
		RemoveProperty("VictimBuilding", "RobberCnt")
		RemoveProperty("VictimBuilding", "RobberProtected")
		DynastyRemoveDiplomacyStateImpact("","VictimBuilding", OwnerID, false)
		DynastyForceCalcDiplomacy("")
		DynastyForceCalcDiplomacy("VictimBuilding")	
	else
		SetProperty("VictimBuilding", "RobberCnt", iCurrentRobberCnt)
	end	
end

