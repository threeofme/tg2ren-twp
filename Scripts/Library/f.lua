function BeginUseLocator(Actor, LocatorName, Stance, MoveToLocator, Speed)
	
	if not AliasExists(Actor) or not AliasExists(LocatorName) then
		return false
	end	

	if not BlockLocator(Actor, LocatorName) then
		return false
	end
	
	if(MoveToLocator) then 
		if not f_MoveTo(Actor, LocatorName, Speed) then
			ReleaseLocator(Actor, LocatorName)
			return false
		end
	end
	
	local WaitTime = CUseLocator(Actor, Stance)
	Sleep(WaitTime)

	return true
end

function BeginUseLocatorWeak(Actor, LocatorName, Stance, MoveToLocator, Speed)
	if not BlockLocator(Actor, LocatorName) then
		return false  
	end
	
	if(MoveToLocator) then 
		if not f_WeakMoveTo(Actor, LocatorName, Speed) then
			ReleaseLocator(Actor, LocatorName)
			return false
		end
	end
	
	local WaitTime = CUseLocator(Actor, Stance)
	Sleep(WaitTime)

	return true
end

function BeginUseLocatorNoWait(Actor, LocatorName, Stance, MoveToLocator)
	if not BlockLocator(Actor, LocatorName) then
		return false
	end
	
	if(MoveToLocator) then
		if not f_MoveToNoWait(Actor, LocatorName) then
			ReleaseLocator(Actor, LocatorName)
			return false
		end
	end
	CUseLocator(Actor, Stance)
	return true
end

function EndUseLocator(Actor, LocatorName, Stance)

	if not AliasExists(Actor) then
		return false
	end

	if LocatorName and AliasExists(LocatorName) then
		if LocatorGetBlocker(LocatorName) ~= GetID(Actor) then
			return false
		end
	end
	
	if Stance==nil or Stance=="" then
		Stance = GL_STANCE_STAND
	end
	
	local WaitTime = CUseLocator(Actor, Stance)
	Sleep(WaitTime)
	
	return ReleaseLocator(Actor, LocatorName)
end

function EndUseLocatorNoWait(Actor, LocatorName, Stance)

	if LocatorName and AliasExists(LocatorName) then
		if LocatorGetBlocker(LocatorName) ~= GetID(Actor) then
			return false
		end
	end

	CUseLocator(Actor, Stance)
	return ReleaseLocator(Actor, LocatorName)
end

function AttendMoveTo(Owner,Destination,Speed,Hours)

	for i=0,(Hours*2-1) do
		if f_MoveTo(Owner,Destination,Speed)==true then
			return true
		end

		if BuildingGetCutscene(Destination,"_a_cutscene") then
			f_Stroll(Owner,250.0,1.0)
			MsgSay(Owner,"@L_NEWSTUFF_WAITING_COMPLAINTS")
			Sleep(15)
			f_Stroll(Owner,250.0,1.0)
			Sleep(15)
		else
			return false
		end
	end
	return false
end

function MoveToSilent(Owner, Destination, iSpeed, fRange)
	if not AliasExists(Destination) then
		return false
	end
	local Result
	local ResultName
		ResultName = "__MoveToResult_"..GetID(Owner).."_"..GetID(Destination)
		Result = CMoveTo(Owner, Destination, iSpeed, ResultName, fRange, true)	
		if (Result) then 
			WaitForMessage("WaitForTask")
	 		local lateresult = GetProperty(Owner, ResultName)
			RemoveProperty(Owner, ResultName)
			if lateresult == NIL or lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
				-- if IsType("","Sim") then
					-- ai_ShowMoveError(lateresult, Owner)
				-- end
				return false
			end
			return true
		end
	-- end
	
	-- ai_ShowMoveError(GL_MOVERESULT_ERROR_TARGET_UNREACHABLE, Owner)
	return false
end

function MoveTo(Owner, Destination, iSpeed, fRange, Special)
	if not AliasExists(Owner) then
		return false
	end
	
	if not AliasExists(Destination) then
		return false
	end

	if Special == "AIDance" then
		SetProperty(Destination, "GoToDance", 1)
	elseif Special == "AIService" then
		SetProperty(Destination, "GoToService", 1)
	end

	StopAllAnimations("")

	--workaround for spinning carts...
	SetState(Owner, STATE_CHECKFORSPINNINGS, true)
	----------------------------------

	--workaround for unreachable entry locators...
	if HasProperty(Owner,"BlockLocB") then
		if SimIsInside(Owner) and (GetProperty(Owner,"BlockLocB") == GetInsideBuildingID(Owner)) then
			f_ExitCurrentBuilding(Owner)
		else
			RemoveProperty(Owner,"BlockLocB")
		end
	end
	----------------------------------------------
	
	local ResultName = "__MoveToResult_"..GetID(Owner).."_"..GetID(Destination)
	local Result = CMoveTo(Owner, Destination, iSpeed, ResultName, fRange, true)

	if (Result) then
		WaitForMessage("WaitForTask")
		local lateresult = GetProperty(Owner, ResultName)
		RemoveProperty(Owner, ResultName)
		
		if lateresult == NIL or lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
			if IsType(Owner, "Sim") then
				ai_ShowMoveError(lateresult, Owner)
			end
			--workaround for spinning carts...
			SetState(Owner, STATE_CHECKFORSPINNINGS, false)
			----------------------------------
			return false
		end
		--workaround for spinning carts...
		SetState(Owner, STATE_CHECKFORSPINNINGS, false)
		----------------------------------
		return true
	end

	--workaround for unreachable entry locators...
	if IsType(Destination, "cl_Building") and BuildingCanBeEntered(Destination,Owner) then

		local locator = "Walledge1"
		GetLocatorByName(Destination, locator, "entry")

		if AliasExists("entry") then
			
			local ResultName2 = "__MoveToResult_"..GetID(Owner).."_"..GetID(Destination)
			local Result2 = CMoveTo(Owner, "entry", iSpeed, ResultName, fRange, true)
			
			
			if (Result2) then
				WaitForMessage("WaitForTask")
				local lateresult = GetProperty(Owner, ResultName2)
				RemoveProperty(Owner, ResultName2)
				
				if lateresult == NIL or lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
					local locator = "Walledge2"
					GetLocatorByName(Destination, locator, "entry")

					local Result3 = CMoveTo(Owner, "entry", iSpeed, ResultName, fRange, true)
				end

				SetProperty(Owner, "BlockLocL", locator)
				SetProperty(Owner, "BlockLocB", GetID(Destination))
			end
			--workaround for spinning carts...
			SetState(Owner, STATE_CHECKFORSPINNINGS, false)

			SimBeamMeUp(Owner,Destination,false)
			return true
		else
			return false
		end
	end
	----------------------------------------------

	ai_ShowMoveError(GL_MOVERESULT_ERROR_TARGET_UNREACHABLE, Owner)
	--workaround for spinning carts...
	SetState(Owner, STATE_CHECKFORSPINNINGS, false)
	----------------------------------
	return false
end

function MoveToBuildingAction(Owner, Destination, iSpeed, fRange)
	local Moving = true
	local OwnerOutside = false
	local DestOutside = false
	local Distance

	while Moving == true do

		if not GetInsideRoom(Owner,"OwnerRoom") then
			OwnerOutside = true
		end
		if not GetInsideRoom(Destination,"DestRoom") then
			DestOutside = true
		end

		if (OwnerOutside==false) and (DestOutside==true) then
			f_ExitCurrentBuilding(Owner)
		elseif (OwnerOutside==true) and (DestOutside==false) then
			f_MoveTo(Owner, Destination, iSpeed, fRange)
		end

		if (GetID("OwnerRoom") == GetID("DestRoom")) or ((OwnerOutside==true) and (DestOutside==true)) then
			Distance = GetDistance(Owner,Destination)
			if Distance > fRange then
				f_MoveToNoWait(Owner, Destination, iSpeed, fRange)
				f_MoveToNoWait(Destination, Owner, iSpeed, fRange)
			end

			if Distance > 3000 then
				Sleep(10)
			elseif Distance > 2200 then
				Sleep(6)
			elseif Distance > 1700 then
				Sleep(4)	
			elseif Distance > 1200 then
				Sleep(2)
			elseif Distance > 820 then
				Sleep(0.6)
			elseif Distance < 270 then
				Moving = false
				return true
			else
				Sleep(2)
			end
		end
	end

	return false
end

function WeakMoveTo(Owner, Destination, iSpeed, fRange)
	local ResultName = "__MoveToResult_"..GetID(Owner).."_"..GetID(Destination)
	if not AliasExists(Destination) then
		return false
	end
	local Result = CMoveToWeak(Owner, Destination, iSpeed, ResultName, fRange, true)
	if (Result) then 
		WaitForMessage("WaitForTask")
		--local lateresult = GetData(ResultName)
 		local lateresult = GetProperty(Owner, ResultName)
		RemoveProperty(Owner, ResultName)
		if lateresult == NIL or lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
			if IsType("","Sim") then
				ai_ShowMoveError(lateresult, Owner)
			end
			return false
		end
		return true
	end
	ai_ShowMoveError(GL_MOVERESULT_ERROR_TARGET_UNREACHABLE, Owner)
	return false
end

function Follow(pOwner, pDestination, iSpeed, fRange, bFollowOnce)
	if not pDestination or not GetID(pDestination) then
		return
	end
	
	local ResultName = "__FollowResult_"..GetID(pOwner).."_"..GetID(pDestination)
	
	local Result = CFollow(pOwner, pDestination, iSpeed, ResultName, fRange, bFollowOnce, true)
	if (Result) then 
		WaitForMessage("WaitForTask")
		--local lateresult = GetData(ResultName)
 		local lateresult = GetProperty("", ResultName)
		RemoveProperty("", ResultName)
		if lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
			ai_ShowMoveError(lateresult, pOwner)
			return false
		end
		return true
	end
	ai_ShowMoveError(GL_MOVERESULT_ERROR_TARGET_UNREACHABLE, pOwner)
	return Result
end	


function MoveToNoWait(pOwner, pDestination, iSpeed, fRange) 
	return CMoveTo(pOwner, pDestination, iSpeed, NIL, fRange, false)
end

function WeakMoveToNoWait(Owner, Destination, iSpeed, fRange)
	return CMoveToWeak(Owner, Destination, iSpeed, NIL, fRange, true)
end
	
function FollowNoWait(pOwner, pDestination, iSpeed, fRange, bFollowOnce)
	if not AliasExists(pOwner) or not AliasExists(pDestination) then
		return false
	end

	return CFollow(pOwner, pDestination, iSpeed, NIL, fRange, bFollowOnce, false)
end	

function Fight(pSource,pDestination, Type)
	local Result=CFight(pSource,pDestination, Type)	
	if(Result) then
		WaitForMessage("WaitForTask")
	end
	return Result
end
	
function FightNoWait(pSource,pDestination,Type)
	return CFight(pSource,pDestination,Type)
end

function Stroll(pSource,Range, Duration)
	local Result = CStroll(pSource,Range,Duration)
	if(Result) then
		WaitForMessage("WaitForTask")
	end
end
  
function StrollNoWait(pSource,Range,Duration)
	return CStroll(pSource,Range,Duration)
end
			
function ExitCurrentBuilding(Alias)
	if not AliasExists(Alias) then
		return false
	else
		local Result = CExitCurrentBuilding(Alias)
		if (Result) then
			WaitForMessage("WaitForTask")
		end
	
		--workaround for unreachable entry locators...
		if HasProperty(Alias,"BlockLocB") then
	    GetNearestSettlement(Alias,"TheCity")
	    CityGetNearestBuilding("TheCity",Alias,-1,-1,-1,-1,FILTER_IGNORE,"TheBuilding")
			local l = GetProperty(Alias,"BlockLocL")
			local b = GetProperty(Alias,"BlockLocB")
			RemoveProperty(Alias,"BlockLocL")
			RemoveProperty(Alias,"BlockLocB")
	
			if GetID("TheBuilding")==b then
				GetLocatorByName("TheBuilding", l, "entry")
				SimBeamMeUp(Alias,"entry",false)
			end
		end
		----------------------------------------------
	
		return Result
	end
end

function GetRandomPositionFromAlias(AliasName,Range)
	GetPosition(AliasName,"NewPos")
	local X,Y,Z = PositionGetVector("NewPos")
	X = X + ((Rand(Range)*2)-Range)
	Z = Z + ((Rand(Range)*2)-Range)
	PositionModify("NewPos",X,Y,Z)
	return "NewPos"
end

function SimIsValid(Target)
	if (not AliasExists(Target) or
	GetHP(Target)<1 or 
	GetStateImpact(Target, "no_control")) then
		return false
	else
		return true
	end
end

function DynastyGetNumOfEnemies(Sim)
	GetDynasty(Sim,"MyDyn")
	local NumOfEnemies = 0
	if HasProperty("MyDyn","Enemy_No") then
		NumOfEnemies = GetProperty("MyDyn","Enemy_No")
	end
	
	-- we need to save this forever to keep our IDs
	local EnemyTotal = 0 
	if HasProperty("MyDyn", "Enemy_Total") then 
		EnemyTotal = GetProperty("MyDyn", "Enemy_Total")
	end
	
	if NumOfEnemies >0 and EnemyTotal >0 then
		-- check if all are still alive
		for i=0, EnemyTotal-1 do
			if HasProperty("MyDyn","Enemy_"..i) then
				local FoundID = GetProperty("MyDyn","Enemy_"..i)
				GetAliasByID(FoundID, "Enemy_"..i)
				local FoundCount = DynastyGetMemberCount("Enemy_"..i)
				if FoundCount <1 then
					-- no members alive, remove
					RemoveProperty("MyDyn","Enemy_"..i)
					NumOfEnemies = NumOfEnemies-1
					SetProperty("MyDyn","Enemy_No",NumOfEnemies)
				end
			end
		end
	end
	
	return NumOfEnemies
end

function DynastyGetNumOfAllies(Sim)
	GetDynasty(Sim,"MyDyn")
	local NumOfAllies = 0
	if HasProperty("MyDyn","Allies_No") then
		NumOfAllies = GetProperty("MyDyn","Allies_No")
	end
	
	-- we need to save this forever to keep our IDs
	local AlliesTotal = 0 
	if HasProperty("MyDyn", "Allies_Total") then 
		AlliesTotal = GetProperty("MyDyn", "Allies_Total")
	end
	
	if NumOfAllies >0 and AlliesTotal >0 then
		-- check if all are still alive
		for i=0, AlliesTotal-1 do
			if HasProperty("MyDyn","Ally_"..i) then
				local FoundID = GetProperty("MyDyn","Ally_"..i)
				GetAliasByID(FoundID, "Ally_"..i)
				local FoundCount = DynastyGetMemberCount("Ally_"..i)
				if FoundCount <1 then
					-- no members alive, remove
					RemoveProperty("MyDyn","Ally_"..i)
					NumOfAllies = NumOfAllies-1
					SetProperty("MyDyn","Allies_No",NumOfAllies)
				end
			end
		end
	end
	
	return NumOfAllies
end

function DynastyAddEnemy(Sim,Destination)
	GetDynasty(Sim,"MyDyn")
	local DesDynID = GetDynastyID(Destination)
	local NumOfEnemies = 0
	if HasProperty("MyDyn","Enemy_No") then
		NumOfEnemies = GetProperty("MyDyn","Enemy_No")
	end
	
	-- we need to save this forever to keep our IDs
	local EnemyTotal = 0 
	if HasProperty("MyDyn", "Enemy_Total") then 
		EnemyTotal = GetProperty("MyDyn", "Enemy_Total")
	end
	
	-- add it up
	NumOfEnemies = NumOfEnemies + 1
	SetProperty("MyDyn","Enemy_No",NumOfEnemies)
	EnemyTotal = EnemyTotal +1
	SetProperty("MyDyn","Enemy_Total",EnemyTotal)
	
	-- add the new unique id
	SetProperty("MyDyn","Enemy_"..(EnemyTotal-1),DesDynID)
end

function DynastyAddAlly(Sim,Destination)
	GetDynasty(Sim,"MyDyn")
	local DesDynID = GetDynastyID(Destination)
	local NumOfAllies = 0
	if HasProperty("MyDyn","Allies_No") then
		NumOfAllies = GetProperty("MyDyn","Allies_No")
	end
	
	-- we need to save this forever to keep our IDs
	local AlliesTotal = 0 
	if HasProperty("MyDyn", "Allies_Total") then 
		AlliesTotal = GetProperty("MyDyn", "Allies_Total")
	end
	
	-- add it up
	NumOfAllies = NumOfAllies+1
	SetProperty("MyDyn","Allies_No",NumOfAllies)
	AlliesTotal = AlliesTotal +1
	SetProperty("MyDyn","Allies_Total",AlliesTotal)
	
	-- add the new unique ally id
	SetProperty("MyDyn","Ally_"..(AlliesTotal-1),DesDynID)
end

function DynastyRemoveEnemy(Sim,Destination)
	GetDynasty(Sim, "MyDyn")
	local DesDynID = GetDynastyID(Destination)
	local NumOfEnemies = 0
	if HasProperty("MyDyn","Enemy_No") then
		NumOfEnemies = GetProperty("MyDyn","Enemy_No")
	end
	
	-- we need to save this forever to keep our IDs
	local EnemyTotal = 0 
	if HasProperty("MyDyn", "Enemy_Total") then 
		EnemyTotal = GetProperty("MyDyn", "Enemy_Total")
	end
	
	-- remove the id
	for i=0, EnemyTotal-1 do
		if HasProperty("MyDyn","Enemy_"..i) then
			if GetProperty("MyDyn", "Enemy_"..i) == DesDynID then
				RemoveProperty("MyDyn", "Enemy_"..i)
			end
		end
	end
	
	-- substract it
	NumOfEnemies = NumOfEnemies - 1
	SetProperty("MyDyn","Enemy_No",NumOfEnemies)
end

function DynastyRemoveAlly(Sim,Destination)
	GetDynasty(Sim, "MyDyn")
	local DesDynID = GetDynastyID(Destination)
	local NumOfAllies = 0
	if HasProperty("MyDyn","Allies_No") then
		NumOfAllies = GetProperty("MyDyn","Allies_No")
	end
	
		-- we need to save this forever to keep our IDs
	local AlliesTotal = 0 
	if HasProperty("MyDyn", "Allies_Total") then 
		AlliesTotal = GetProperty("MyDyn", "Allies_Total")
	end
	
	-- remove the id
	for i=0, AlliesTotal-1 do
		if HasProperty("MyDyn","Ally_"..i) then
			if GetProperty("MyDyn", "Ally_"..i) == DesDynID then
				RemoveProperty("MyDyn", "Ally_"..i)
			end
		end
	end
	
	-- substract it
	NumOfAllies = NumOfAllies - 1
	SetProperty("MyDyn","Allies_No",NumOfAllies)
end


function debug(Header, Body, TargetAlias, Param)
	local debug = GetSettingNumber("DEBUG", "DebugLvl", 0)
	if debug > 0 then
		LogMessage("::TOM:: "..Header .. Body)
		if debug > 1 then
			MsgNewsNoWait(
				"All", -- recipient
				TargetAlias, -- jump to target 
				"", -- String pPanelParam, 
				"politics", -- String pMessageClass, 
				-1, -- Number TimeOut, 
				Header, -- String pHeaderLabel, 
				Body, -- String pBodyLabel
				Param ) -- variable argument list
		end
	end
end

function CityFindCrowdedPlace(CityAlias, SimAlias, RetAlias)
	-- go to one of these places: market, townhall, church ev, church cath, hospital, tavern
	local BldTypes = { GL_BUILDING_TYPE_TOWNHALL, GL_BUILDING_TYPE_CHURCH_CATH, GL_BUILDING_TYPE_CHURCH_EV, GL_BUILDING_TYPE_TAVERN, GL_BUILDING_TYPE_HOSPITAL, GL_BUILDING_TYPE_MARKET, GL_BUILDING_TYPE_MARKET }
	local BldType = BldTypes[Rand(7)+1] 
	CityGetNearestBuilding(CityAlias, SimAlias, -1, BldType, -1, -1, FILTER_IGNORE, "NearBld")
	GetOutdoorMovePosition("NearBld", "OutdoorMovePosition")
	if AliasExists("OutdoorMovePosition") then
		CopyAlias("OutdoorMovePosition", RetAlias)
	else
		CopyAlias("NearBld", RetAlias)
	end
	return 1
end
