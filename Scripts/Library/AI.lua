-- -----------------------
-- StartBuildingAction	
--
-- 
-- -----------------------
function StartBuildingAction(FirstSim, SecondSim, BuildingClass, BuildingType, BuildingAlias)

	local	IsOk1
	local IsOk2
	local BuildingAlias1
	local BuildingAlias2
	
	IsOk1, BuildingAlias1 = ai_CheckInsideBuilding(FirstSim, BuildingClass, BuildingType, BuildingAlias)
	IsOk2, BuildingAlias2 = ai_CheckInsideBuilding(SecondSim, BuildingClass, BuildingType, BuildingAlias)
	
	if not BuildingAlias then
		if BuildingAlias1 then
			BuildingAlias = BuildingAlias1
		else
			BuildingAlias = BuildingAlias2
		end
	end
	
	if not BuildingAlias then
		if not GetNearestSettlement(FirstSim, "__SBA_City") then
			return false
		end
	
		if not CityGetRandomBuilding("__SBA_City", BuildingClass, BuildingType, -1, -1, FILTER_IGNORE, "__SBA_BUILDING") then
			return false
		end
		
		BuildingAlias = "__SBA_BUILDING"
	end
	
	if not IsOk1 and IsOk2 then
		if not BlockChar(SecondSim) then
			return false
		end
		
		if not f_MoveTo(FirstSim, BuildingAlias) then
			return false
		end
		
	elseif not IsOk2 then
		if not BlockChar(SecondSim) then
			return false
		end

		if not f_MoveToBuildingAction(FirstSim, SecondSim, -1, 200) then
			return false
		end

		if not f_FollowNoWait(SecondSim, FirstSim, GL_MOVESPEED_MOVE, 100) then
			return false
		end
		
		if not f_MoveTo(FirstSim, BuildingAlias) then
			return false
		end
	else
		if not BlockChar(SecondSim) then
			return false
		end
	end	
	
	return true
end

-- -----------------------
-- CheckInsideBuilding
-- -----------------------
function CheckInsideBuilding(SimAlias, BuildingClass, BuildingType, BuildingAlias)

	local InsideAlias = "__CIB_BUILDING_"..GetID(SimAlias)
	
	if not GetInsideBuilding(SimAlias, InsideAlias) then
		return false, nil
	end
	
	if BuildingAlias then
		if GetID(InsideAlias)==GetID(BuildingAlias) then
			return true, BuildingAlias
		end
		return false, BuildingAlias
	end
		
	if BuildingClass and BuildingClass~=-1 then
		if (BuildingGetClass(InsideAlias )~=BuildingClass) then
			return false, nil
		end
	end
	
	if BuildingType and BuildingType~=-1 then
		if (BuildingGetType(InsideAlias )~=BuildingType) then
			return false, nil
		end
	end
	
	return true, InsideAlias
end

function GoInsideBuilding(SimAlias, CityObject, BuildingClass, BuildingType, BuildingAlias)

	local	IsOk
	local	InsideAlias
	local CityID = -1
	
	if AliasExists(CityObject) then
		GetSettlement(CityObject, "__GIB_City")
	else
		GetSettlement(SimAlias, "__GIB_City")
	end
	
	IsOk, InsideAlias = ai_CheckInsideBuilding(SimAlias, BuildingClass, BuildingType, BuildingAlias)
	if IsOk then
		if GetSettlementID(InsideAlias)==GetID("__GIB_City") then
			CopyAlias(InsideAlias, BuildingAlias)
			return true
		end
	end

	if not BuildingAlias then
		BuildingAlias = "__GIB_Build"
	end

	if not AliasExists(BuildingAlias) then
		if not CityGetRandomBuilding("__GIB_City", BuildingClass, BuildingType, -1, -1, FILTER_IGNORE, BuildingAlias) then
			return false
		end
	end
	
	if GetInsideBuildingID(SimAlias) == GetID(BuildingAlias) then
		return true
	end
	
	return f_WeakMoveTo(SimAlias, BuildingAlias)
end

function StartInteraction(FirstPerson, TargetPerson, ReactionDistance, ActionDistance, CommandFunction, bForceNoErrorOnBlock)
	if not TargetPerson or not GetID(TargetPerson) then
		return
	end

	if IsType(TargetPerson, "Building") then
		GetOutdoorMovePosition(FirstPerson, TargetPerson, "_SI__MoveToPosition")
		local RetVal = f_MoveTo(FirstPerson, "_SI__MoveToPosition", GL_MOVESPEED_RUN, ActionDistance)
		if not (RetVal) then
			return false
		end
		AlignTo(FirstPerson, TargetPerson)
		Sleep(0.7)
		return true
	end

	local Distance
	local success = false
	-- timeout 8 hours
	local timeout = GetGametime() + 8

	ReactionDistance = ReactionDistance * 1.5

	while success == false do
	
		if not f_Follow(FirstPerson,TargetPerson,GL_MOVESPEED_RUN,ReactionDistance, true) then
			if not bForceNoErrorOnBlock then		
				return false
			end
		end
	
		if CommandFunction then
			success = SendCommandNoWait(TargetPerson, CommandFunction)
		else
			success = BlockChar(TargetPerson)
		end
			
		if not success then
			-- check for timeout
			local curGametime = GetGametime()
			if timeout < GetGametime() then
				if not bForceNoErrorOnBlock then
					if IsType(TargetPerson,"Building") then
						if IsPartyMember(FirstPerson) then
							MsgQuick(FirstPerson,"@L_GENERAL_MEASURES_FAILURES_+1", GetID(TargetPerson))
						end
					else
						if IsPartyMember(FirstPerson) then
							MsgQuick(FirstPerson,"@L_GENERAL_MEASURES_FAILURES_+0", GetID(TargetPerson), GetID(FirstPerson))
						end
					end
					return false
				end
			end
			
			if not bForceNoErrorOnBlock then
				Sleep(1)
			end
		end
	end
	
	-- move to destinaton
	if not (f_MoveTo(FirstPerson,TargetPerson, GL_MOVESPEED_WALK, ActionDistance)) then
		return false
	end
	
	if not (bForceNoErrorOnBlock) then
		AlignTo(FirstPerson, TargetPerson)
		AlignTo(TargetPerson, FirstPerson)
	end

	Sleep(1.0)
	
	return true
end

function ShowMoveError(result) 

	if result == NIL then
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+2", GetID(""))
	end

	if result == GL_MOVERESULT_ERROR_NOT_ENTERABLE then	
		if AliasExists("Destination") then
			if GetState("",STATE_FIGHTING) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_FIGHTING")
			elseif GetState("Destination",STATE_LEVELINGUP) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_LEVELUP")
			elseif GetState("Destination",STATE_BUILDING) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_BUILDING")
			elseif GetState("Destination",STATE_BURNING) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_BURNING")
			--elseif GetState("Destination",STATE_CONTAMINATED) then
				--MsgQuick("","@L_NEWSTUFF_NOENTER_CONTAMINATED")
			elseif GetState("Destination",STATE_CUTSCENE) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_SESSION")
			elseif GetState("Destination",STATE_DEAD) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_DEAD")
			elseif (GetHPRelative("Destination")<=0.2) then
				MsgMeasure("","@L_NEWSTUFF_NOENTER_CRITICALDAMAGE")
			--elseif (SimGetProfession("")==GL_PROFESSION_MYRMIDON) then
			--	MsgMeasure("","@L_NEWSTUFF_NOENTER_NOFIGHTERS")
			--MsgQuick("","@L_NEWSTUFF_NOENTER_CLOSED")
			else
				MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+3",GetID(""))
			end
		else
			MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+3",GetID(""))
		end
	elseif result == GL_MOVERESULT_ERROR_MOVEMENT_ABORTED then
		--MsgMeasure("", "@LMOVE_OVERHEAD_CANNOT_REACH_TARGET@T%1SN: Bewegungsabbruch.")
	elseif result == GL_MOVERESULT_ERROR_NOT_ENTERABLE_ILLEGAL_DEST then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+4",GetID(""))
	elseif result == GL_MOVERESULT_ERROR_TRANSITION_FAILED then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+5",GetID(""))	
	elseif result == GL_MOVERESULT_ERROR_TARGET_GONE then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+6",GetID(""))
	elseif result == GL_MOVERESULT_ERROR_TARGET_INACCESSIBLE then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+7",GetID(""))		
	elseif result == GL_MOVERESULT_ERROR_TARGET_UNREACHABLE then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+8",GetID(""))		
	elseif result == GL_MOVERESULT_ERROR_NOT_INITIALIZED then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+9",GetID(""))				
	elseif result == GL_MOVERESULT_ERROR_UNKNOWN_PATHFINDER then 
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+10",GetID(""))	
	else
		--strange things
		--	feedback_OverheadFadeText("", "@LMOVE_OVERHEAD_CANNOT_REACH_TARGET@T%1SN: Es wurde ein MoveTask unterbrochen der den Zustand IDLE hatte?!", false)
		--elseif result == GL_MOVERESULT_TARGET_REACHED then
		--	feedback_OverheadFadeText("", "@LMOVE_OVERHEAD_CANNOT_REACH_TARGET@T%1SN: Habe Ziel erreicht, aber es wurde Fehlerbehandlung aufgerufen?!", false)
		--else
	
		MsgMeasure("", "@L_GENERAL_MEASURES_FAILURES_+11", GetID(""), 0)
		
		--end
	end
	Sleep(1)	
end

function MultiMoveTo(...)
	-- always alternating Owner and Target

	local speed = arg[1]
	local range = arg[2]

	--count args
	local argoffset = 2
	local number = argoffset
	while arg[number+1]~=nil do
		number = number + 2
	end
	-- ignore the first args 
	number = number - argoffset
	number	= number / 2

	--start moving
	local steps
	local pos
	local MMResultName
	local objectarray = {}
	for steps = 0, number-1 do
		pos = argoffset + 1 + steps*2
		MMResultName = "mmresult_"..pos
		f_MoveToNoWait(arg[pos], arg[pos+1], speed, MMResultName, range)
		--copy objects to new array
		objectarray[steps] = MMResultName
	end
		
	while (number > 0) do
		-- check results of the objects
		for steps = 0, number-1 do
			local result = GetData(objectarray[steps])
			if ( result == GL_MOVERESULT_TARGET_REACHED) then
				--copy to end
				objectarray[steps] = objectarray[number-1]
				--shorten list
				number = number-1
			elseif (	result ~= nil ) then
				if (result > GL_MOVERESULT_ERROR_UNKNOWN) then
					return false
				end
			end				
		end
		Sleep(0.50)
	end
	return true 
end

function Transfer(Executer, Buyer, BuyerInv, Seller, SellerInv, Item, ItemCount)
	local ErrorNumber, Done = Transfer(Executer, Buyer, BuyerInv, Seller, SellerInv, Item, ItemCount)
	if ErrorNumber ~=TRANSFER_SUCCESS then
		ai_TransferError(ErrorNumber, Buyer, Seller, Item, ItemCount)
		return Done
	end
	return Done
end

function TransferError(ErrorNumber, BuyerAlias, SellerAlias, ItemId, ItemCount)

	if ErrorNumber==TRANSFER_SUCCESS then
		return
	end

	local TransferErrorList= 
	{
		[TRANSFER_RESULT_UNKNOWN] = "Unknown Error";
		[TRANSFER_ERROR_ILLEGAL] = "Illegal";
		[TRANSFER_ERROR_NO_MARKET] = "No market";
		[TRANSFER_ERROR_ILLEGAL_ITEM] = "Illegal item";
		[TRANSFER_ERROR_OUT_OF_RANGE] = "Out of range";
		[TRANSFER_ERROR_ILLEGAL_EXECUTER] = "Illegal executer";
		[TRANSFER_ERROR_NO_ITEM_AT_SOURCE] = "No item at source";
		[TRANSFER_ERROR_NO_SPACE_AT_DEST] = "No space at destination";
		[TRANSFER_ERROR_ACCESS_DENIED] = "Access denied";
		[TRANSFER_ERROR_NOT_COMPLETE_TRANSFER] = "not enough items for a complete transfer";
		[TRANSFER_ERROR_NOT_ENOUGH_MONEY] = "not enough money";
		[TRANSFER_ERROR_INVALID_ITEM] = "Invalid item"
	}
	
	local Text = TransferErrorList[ErrorNumber]
	if Text then
		local	BuyerName = "(unknown)"
		if AliasExists(BuyerAlias) then
			BuyerName = GetName(BuyerAlias)
		end

		local	SellerName = "(unknown)"
		if AliasExists(SellerAlias) then
			SellerName = GetName(SellerAlias)
		end
		
		local	ItemName = ItemGetName(ItemId)
		if not ItemName then
			ItemName = "(unknown)"
		end
		
		if not ItemCount then
			ItemCount = -1
		end
	end
end

function CanBuyItem(SimAlias, Item, Count, CityAlias, PlaceAlias)

	if not Count then
		Count = 1
	end
	
	if not PlaceAlias then
		PlaceAlias = "__AI_CBI_PLACE"
	end
	
	if not CityAlias then
		CityAlias = "__AI_CBI_CITY"
	end

	if not CanAddItems(SimAlias, Item, Count, INVENTORY_STD) then
		return -1
	end
	
	if not GetSettlement(SimAlias, CityAlias) then
		return -1
	end
	
	local Price = CityGetSeller(CityAlias, SimAlias, Item, 1, PlaceAlias)

	return Price
end


function BuyItem(SimAlias, Item, ItemCount)

	if not ItemCount then
		ItemCount = 1
	end
	
	local PlaceAlias 	= "__AI_CBI_PLACE"
	if not GetNearestSettlement(SimAlias, "NextCity") then
		return false
	end
	
	local Price 			= ai_CanBuyItem(SimAlias, Item, ItemCount, "NextCity", AliasName)
	
	if Price<0 then
		return false
	end
	
	local	MoveToPos		= "__AI_CBI_MoveTo"
	local	eInv
	
	if IsType(PlaceAlias , "Building") then
		GetOutdoorMovePosition(SimAlias, PlaceAlias, MoveToPos)
		eInv = INVENTORY_SELL
	elseif IsType(PlaceAlias, "Market") then
		local Market = Rand(5)+1
		if not CityGetRandomBuilding("NextCity", 5,14,Market,-1, FILTER_IGNORE, MoveToPos) then
			CityGetRandomBuilding("NextCity", 5,14,-1,-1, FILTER_IGNORE, MoveToPos)
		end
		eInv = INVENTORY_STD
	end
	
	if not AliasExists(MoveToPos) then
		return false
	end
	
	local Speed = GL_MOVESPEED_WALK
	
	if not DynastyIsShadow(SimAlias) then
		Speed = GL_MOVESPEED_RUN
	end
	
	if not f_MoveTo(SimAlias, MoveToPos, Speed, 300) then
		return false
	end
	
	local VendorFilter = "__F((Object.GetObjectsByRadius(Sim)==1000)AND(Object.GetState(townnpc))AND(Object.Property.Vendor == 1))"
	local NumVendors = Find(SimAlias, VendorFilter, "Vendor", -1)
	if NumVendors > 0 then
		local RandVendor = Rand(NumVendors)
		AlignTo(SimAlias,"Vendor"..RandVendor)
		local RandPos = Rand(125)+25
		
		f_MoveTo(SimAlias, "Vendor", GL_MOVESPEED_WALK, RandPos)
	end
	
	local Done = ai_Transfer(SimAlias, SimAlias, INVENTORY_STD, PlaceAlias, eInv, Item, ItemCount)
	f_Stroll(SimAlias,300.0,1.0)
	return (Done >= ItemCount)
end

function CreateMutex(BaseAlias)
	local	PropertyName = "_MUTEX_"..SystemGetMeasureName()
	if HasProperty(BaseAlias, PropertyName) then
		return false
	end
	SetProperty(BaseAlias, PropertyName, GetID(""))
	return true
end

function CheckMutex(BaseAlias, MeasureName)
	local	PropertyName = "_MUTEX_"..MeasureName
	if HasProperty(BaseAlias, PropertyName) then
		return false
	end
	return true
end


function ReleaseMutex(BaseAlias)
	local	PropertyName = "_MUTEX_"..SystemGetMeasureName()
	local	Value = GetProperty(BaseAlias, PropertyName)
	
	if not Value or Value~=GetID("") then
		return fals
	end
	RemoveProperty(BaseAlias, PropertyName)
end

function IsDeploymentInProgress(SimAlias)

	local CurrentDeplicant
	local OfficeTask
	local	SimID = GetID(SimAlias)
	local Alias
	
	ListAllCutscenes("cutscene_list")
	local NumCutscenes = ListSize("cutscene_list")
	for iCutscene=0,NumCutscenes-1 do
		if ListGetElement("cutscene_list",iCutscene,"my_cutscene") and GetID("my_cutscene")~=-1 then
	
			local DepList_Count
			CutsceneGetData("my_cutscene","DepList_Count")
			DepList_Count = GetData("DepList_Count")
			
			if DepList_Count~=nil then
				for UseOffice = 1, DepList_Count, 1 do

					Alias = "DepList_"..(UseOffice).."_ID"
					CutsceneGetData("my_cutscene",Alias)
					OfficeTask	= GetData(Alias)

					Alias = "DepList_"..(OfficeTask).."_DepID"
					CutsceneGetData("my_cutscene",Alias)
					CurrentDeplicant = GetData(Alias)

					if CurrentDeplicant == SimID then
						return true
					end
					
				end
			end
		end
	end
	return false
end

function GetPower(SimAlias)

	local	WeaponDamage 	= SimGetWeaponDamage(SimAlias)
	local Damage		= gameplayformulas_GetDamage(SimAlias, WeaponDamage)
	local	Defence	 	= gameplayformulas_GetArmorValue(SimAlias)
	
	return Damage, Defence
end

function CheckForces(Agressor, Victim, Radius)

	if not Radius then
		Radius = 1500
	end

	local FoundCount
	local AgressorID = GetDynastyID(Agressor)
	local Alias
	local AddToAttack = false
	local AddToDefence = false
	local Att
	local Def
	
	local SuspectFilter = "__F((Object.GetObjectsByRadius(Sim) == "..Radius..")AND(Object.IsClass(4)))"
	FoundCount = Find(Victim, SuspectFilter, "Suspect", -1)
	
	local DefAttack = 0
	local DefArmor = 0
	local DefHP = 0
	
	local AttAttack = 0
	local AttArmor = 0
	local AttHP = 0
	
	for Count=0, FoundCount-1 do
		Alias = "Suspect"..Count
		if GetDynastyID(Alias) == AgressorID then
			AddToAttack = true
		elseif DynastyGetDiplomacyState(Alias, Victim) == DIP_ALLIANCE then --target has supporters from alliance
			AddToDefence = true
		elseif GetDynastyID(Alias)<1 and (SimGetProfession(Alias)==GL_PROFESSION_ELITEGUARD or SimGetProfession(Alias)==GL_PROFESSION_CITYGUARD) then
			-- guards?
			AddToDefence = true
		end
		
		if AddToDefence then
			Att, Def = ai_GetPower(Alias)
			DefArmor = DefArmor + Def
			DefAttack = DefAttack + Att
			DefHP = DefHP + (GetHPRelative(Alias)*GetMaxHP(Alias))
		elseif AddToAttack then
			Att, Def = ai_GetPower(Alias)
			AttArmor = AttArmor + Def
			AttAttack = AttAttack + Att
			AttHP = AttHP + (GetHPRelative(Alias)*GetMaxHP(Alias))
		end
	end
	
	if IsType(Agressor, "Sim") then
		Att, Def = ai_GetPower(Agressor)
		AttArmor = AttArmor + Def
		AttAttack = AttAttack + Att
		AttHP = AttHP + (GetHPRelative(Agressor)*GetMaxHP(Agressor))
	end
	
	if IsType(Victim, "Sim") then
		Att, Def = ai_GetPower(Victim)
		DefArmor = DefArmor + Def
		DefAttack = DefAttack + Att
		DefHP = DefHP + (GetHPRelative(Victim)*GetMaxHP(Victim))
	end
	
	if IsType(Victim, "Cart") then
		local	Escort = CartGetEscortCount(Victim)
		if Escort>0 then
			Att = 23
			Def = 10
			DefArmor = DefArmor + Def*Escort
			DefAttack = DefAttack + Att*Escort
			DefHP = DefHP + 100*Escort
		end
	end	
	
	local Choice = false -- should we attack or not?
	local AttTotalStats = AttAttack - DefArmor
	
	if AttTotalStats < 1 then
		AttTotalStats = 1
	end
	
	local DefTotalStats = DefAttack - AttArmor
	
	if DefTotalStats < 1 then
		DefTotalStats = 1
	end
	
	local AttackerValue = AttHP / DefTotalStats
	local DefenderValue = DefHP / AttTotalStats
	
	-- we are strong enough for a fight
	if AttackerValue >= DefenderValue then
		Choice = true
	end
		
	return Choice
end

function GetNearestDynastyBuilding(Owner,BuildingClass,BuildingType)
	if not GetDynasty(Owner,"BuildingDynasty") then
		return false
	end
	local NumBuildings = DynastyGetBuildingCount("BuildingDynasty",BuildingClass,BuildingType)
	if NumBuildings <= 0 then
		return false
	end
	if GetInsideBuilding(Owner,"CurrentBuilding") then
		GetOutdoorMovePosition(Owner,"CurrentBuilding","CurrentPosition")
	else
		GetPosition(Owner,"CurrentPosition")
	end
	local CurrentDistance = 0
	local OldDistance = 500000
	for i=0,NumBuildings do
		if DynastyGetRandomBuilding("BuildingDynasty",BuildingClass,BuildingType,"RandomBuilding") then
			if GetOutdoorMovePosition(Owner,"RandomBuilding","MovePos") then
				CurrentDistance = GetDistance("CurrentPosition","MovePos")
			end
			if CurrentDistance < OldDistance then
				CopyAlias("RandomBuilding","NextBuilding")
				OldDistance = CurrentDistance
			end
		end		
	end
	if AliasExists("NextBuilding") then
		return "NextBuilding"
	else
		return false
	end	
end

function GetWorkBuilding(SimAlias, BuildingType, BuildAlias)
	if AliasExists(SimAlias) then
		if not IsPartyMember(SimAlias) then
			return SimGetWorkingPlace(SimAlias, BuildAlias)
		end
	
		if GetInsideBuilding(SimAlias, BuildAlias) then
			if BuildingGetType(BuildAlias)==BuildingType then
				if SimCanWorkHere(SimAlias, BuildAlias) then
					return true
				end
			end
		end
		
		local Count = DynastyGetBuildingCount2(SimAlias)
		for l=0,Count-1 do
			if DynastyGetBuilding2(SimAlias, l, BuildAlias) then
				if BuildingGetType(BuildAlias)==BuildingType then
					if SimCanWorkHere(SimAlias, BuildAlias) then
						return true
					end
				end
			end
		end
	end
	
	return false
end

function HasAccessToItem(SimAlias, ItemName)
	if GetItemCount(SimAlias, ItemName, INVENTORY_STD)>0 then
		return true
	end
	
	if GetItemCount(SimAlias, ItemName, INVENTORY_EQUIPMENT)>0 then
		return true
	end
	
	if SimGetWorkingPlace(SimAlias, "aihati_Place") then
	
		if GetItemCount("aihati_Place", ItemName, INVENTORY_STD)>0 then
			return true
		end
		
		local ItemId = ItemGetID(ItemName)
		local ItemsInSalescounter = GetProperty("aihati_Place", "Salescounter_"..ItemId) or 0
		if ItemsInSalescounter > 0 then
			return true
		end
	end
	return false
end


function CheckTitleVSJewellery(SimAlias, ItemLevel, ModVal)

	local ReturnValue = 0
	local Title = GetNobilityTitle(SimAlias, false)
	local Level = SimGetLevel(SimAlias)
	
	if Title==ItemLevel then
		ReturnValue = ModVal
	elseif Title<ItemLevel then
		ReturnValue = ModVal - Title - (ItemLevel * 2)
	elseif Title>ItemLevel then
		if ItemLevel>4 then
			ReturnValue = ModVal
		else
			ReturnValue = ModVal - ItemLevel - (Title * 2)
		end
	end

	if ReturnValue==nil then
		return 0
	end

	if ReturnValue>0 then
		return ReturnValue
	else
		return 0
	end
end


function AICheckAction()

	local check = false
	local Difficulty = ScenarioGetDifficulty()
	local Round = GetRound()
	
	if Difficulty == 0 then
		if Round > 3 then
			check = true
		end
	elseif Difficulty == 1 then
		if Round > 2 then
			check = true
		end
	elseif Difficulty == 2 then
		if Round > 1 then
			check = true
		end
	elseif Difficulty == 3 then
		if Round > 0 then
			check = true
		end
	else
		check = true
	end

	return check
end

-------------------------------------------------------
-- Check Priority Functions
-------------------------------------------------------

function CalcNextDynastyGoal(DynastyAlias)
	if HasProperty(DynastyAlias, "Priority1") and GetProperty(DynastyAlias, "Priority1") ~= "none" then
		return
	end
	
	SetProperty(DynastyAlias, "Priority1", "none")
	
	if not HasProperty(DynastyAlias, "LastPriority1") then
		SetProperty(DynastyAlias, "LastPriority1", "none")
	end
	
	local LastPriority = GetProperty(DynastyAlias, "LastPriority1")
	
	
	local BuildingValue = ai_CalcBuildingGoal(DynastyAlias)
	local TitleValue = ai_CalcTitleGoal(DynastyAlias)
	local LevelUpValue = ai_CalcBuildingLevelGoal(DynastyAlias)
	ai_CalcItemBudget(DynastyAlias)
	local Value = BuildingValue
	local NextPriority  = "workshop"
	
	if TitleValue > Value then
		Value = TitleValue
		NextPriority = "title"
	end
	if LevelUpValue > Value then
		Value = LevelUpValue
		NextPriority = "leveluphome"
	end
	if BuildingValue > Value then
		Value = BuildingValue
		NextPriority = "workshop"
	end
	
	-- DEBUG START
	if not DynastyIsShadow(DynastyAlias) then
		DynastyGetMemberRandom(DynastyAlias, "member")
		local Name = SimGetLastname("member")
		LogMessage("@DynastyPrioritySystem "..Name..": "..NextPriority)
	end
	-- DEBUG END
	SetProperty(DynastyAlias, "Priority1", NextPriority)
	
	local Round = GetRound()
	if not HasProperty(DynastyAlias, "ItemBudget"..Round) then
		ai_CalcItemBudget(DynastyAlias)
	end
end

function CalcBuildingGoal(DynastyAlias)
	local Money = GetMoney(DynastyAlias)
	local WorkBuildingCount = DynastyGetBuildingCount(DynastyAlias, GL_BUILDING_CLASS_WORKSHOP)
	local BestNumberOfWorkshops = ai_GetBestNumberOfWorkshops(DynastyAlias)
	local Difference = BestNumberOfWorkshops - WorkBuildingCount
	if WorkBuildingCount < BestNumberOfWorkshops then
		return 65
	else
		return 0
	end
end

function CalcTitleGoal(DynastyAlias)
	DynastyGetMemberRandom(DynastyAlias, "member")
	local Wealth = GetMoney("member")
	local Title = GetNobilityTitle("member")
	local Cost = GetDatabaseValue("NobilityTitle", Title+1, "price")
	local Value = 0
	if Cost == nil or Cost == "" then
		return 0
	end
	if (Wealth-Cost)>=1000 then
		Value = 60	
	end	
	if (Wealth-Cost)>=3000 then
		Value = Value+10
	end
	if (Wealth-Cost)>=6000 then
		Value = Value+20
	end
	if Title<5 then
		Value = Value+50
	end
	
	if not ReadyToRepeat(DynastyAlias, "AI_NobilityTitle") then
		Value = 0
	end
	
	return Value	
end

function CalcBuildingLevelGoal(DynastyAlias)
	DynastyGetMemberRandom(DynastyAlias, "member")
	GetHomeBuilding("member", "home")
	local HomeBuildingLevel = BuildingGetLevel("home")
	local Title = GetNobilityTitle("member")-1
	local Wealth = GetMoney("member")
	local cost = GetDatabaseValue("Buildings", HomeBuildingLevel+440, "price")
	local Value = 0
	if HomeBuildingLevel<5 then
		if Title > HomeBuildingLevel and Wealth > cost then
			Value = 70
		end
	end
	
	if GetState("home",STATE_BUILDING) then
		Value = 0
	end
	
	return Value
end

function GetBestNumberOfWorkshops(DynastyAlias)
	DynastyGetMemberRandom(DynastyAlias, "member")
	local Title = GetNobilityTitle("member")
	local BestNumber = 1
	if Title >2 and Title <= 4 then
		BestNumber = 2
	elseif Title == 5 then
		BestNumber = 3
	elseif Title == 6 then
		BestNumber = 4
	else
		BestNumber = 6
	end
	
	return BestNumber
end

function CalcItemBudget(DynastyAlias)
	local Budget = GetMoney(DynastyAlias) * 0.25
	local Round = GetRound()
	if HasProperty(DynastyAlias, "ItemBudget"..Round) then
		return
	end
	
	if Round > 0 and HasProperty(DynastyAlias, "ItemBudget"..Round-1) then
		RemoveProperty(DynastyAlias, "ItemBudget"..Round-1)
	end
	
	if Budget < 100 then
		SetProperty(DynastyAlias, "ItemBudget"..Round, 0)
	else
		SetProperty(DynastyAlias, "ItemBudget"..Round, Budget)
	end
end

function DynastyCalcStrength(DynastyAlias)
	local Count = DynastyGetMemberCount(DynastyAlias)
	DynastyGetMember(DynastyAlias,0,"Boss")
	
	-- Nobility Title. 20 Points per Level
	local Title = 0
	Title = GetNobilityTitle("Boss")*20
	
	-- Get cash. 1 point per 200 Gold
	local Cash = 0
	Cash = math.floor(GetMoney(DynastyAlias)/500)
	
	-- Get 25 points per building
	local Workshops = DynastyGetBuildingCount(DynastyAlias, 2, -1)*25
	
	-- Fighting power of all family members. Counts Fighting Skill and Equipment
	local Fighting = 0
	for i=0, Count-1 do
		if DynastyGetMember(DynastyAlias,i,"Member"..i) then
			local SimFighting
			if f_SimIsValid("Member"..i) then -- only count available members
				SimFighting = Fighting + GetSkillValue("Member"..i,FIGHTING)*2+(SimGetWeaponDamage("Member"..i)/2)+(gameplayformulas_GetArmorValue("Member"..i)/2)
				-- higher chance of attacks if evil
				if SimGetAlignment("Member"..i)>=65 then
					SimFighting = SimFighting*2
				end
				-- higher chance of attacks if rogue
				if SimGetClass("Member"..i)==4 then
					SimFighting = SimFighting*2
				end
				
				Fighting = Fighting + SimFighting
			end
		end
	end
	
	-- Fighting power of all thugs
	if AliasExists("Boss") then
		GetHomeBuilding("Boss","Home")
		local Thugs = BuildingGetWorkerCount("Home")
		if Thugs > 0 then
			for i=0, Thugs-1 do
				if BuildingGetWorker("Home",i,"Worker"..i) then
					Fighting = Fighting + GetSkillValue("Worker"..i,FIGHTING)*2+(SimGetWeaponDamage("Worker"..i)/2)+(gameplayformulas_GetArmorValue("Worker"..i)/2)
				end
			end
		end
	end
	
	local RogueBuildings = 0
	local Found
	
	-- check for mercenaries, 21 = castle
	Found = DynastyGetBuildingCount(DynastyAlias,2,21)
	RogueBuildings = RogueBuildings + (Found*50)
	-- add to fighting power
	if Found>0 then
		if DynastyGetRandomBuilding(DynastyAlias,2,21,"Castle") then
			local Mercs = BuildingGetWorkerCount("Castle")
			if Mercs > 0 then
				for i=0, Mercs-1 do
					if BuildingGetWorker("Castle",i,"Worker"..i) then
						Fighting = Fighting + GetSkillValue("Worker"..i,FIGHTING)*2+(SimGetWeaponDamage("Worker"..i)/2)+(gameplayformulas_GetArmorValue("Worker"..i)/2)
					end
				end
			end
		end
	end
	
	-- check for robbers, 15 = robber
	Found = DynastyGetBuildingCount(DynastyAlias,2,15)
	RogueBuildings = RogueBuildings + (Found*50)
	-- add to fighting power
	if Found>0 then
		if DynastyGetRandomBuilding(DynastyAlias,2,15,"Robber") then
			local Robbers = BuildingGetWorkerCount("Robber")
			if Robbers > 0 then
				for i=0, Robbers-1 do
					if BuildingGetWorker("Robber",i,"Worker"..i) then
						Fighting = Fighting + GetSkillValue("Worker"..i,FIGHTING)*2+(SimGetWeaponDamage("Worker"..i)/2)+(gameplayformulas_GetArmorValue("Worker"..i)/2)
					end
				end
			end
		end
	end
	
	-- check for thiefs, 22 = thief
	Found = DynastyGetBuildingCount(DynastyAlias,2,22)
	RogueBuildings = RogueBuildings + (Found*50)
	-- add to fighting power
	if Found>0 then
		if DynastyGetRandomBuilding(DynastyAlias,2,22,"Thief") then
			local Thiefs = BuildingGetWorkerCount("Thief")
			if Thiefs > 0 then
				for i=0, Thiefs-1 do
					if BuildingGetWorker("Thief",i,"Worker"..i) then
						Fighting = Fighting + GetSkillValue("Worker"..i,FIGHTING)*2+(SimGetWeaponDamage("Worker"..i)/2)+(gameplayformulas_GetArmorValue("Worker"..i)/2)
					end
				end
			end
		end
	end
	
	-- get political strength of all family members
	local Power = 0
	for i=0, Count-1 do
		if DynastyGetMember(DynastyAlias,i,"Member"..i) then
			if f_SimIsValid("Member"..i) then -- only count available members
				local Level = SimGetOfficeLevel("Member"..i)
				if Level>(-1) then
					Power = Power+(1+Level)*250
				end
			end
		end
	end
	
	local Total = Title + Cash + Fighting + RogueBuildings + Power + Workshops
	
	return Total
end

function DynastyCalcThreat(DynastyAlias, TargetDynasty)
	local MyStrength = ai_DynastyCalcStrength(DynastyAlias)
	local MyAllyStrength = 0
	local MyAllyCount = 0
	local MyBossID = dyn_GetValidMember(DynastyAlias)
	GetAliasByID(MyBossID, "MyBoss")
	if AliasExists("MyBoss") then
		MyAllyCount = f_DynastyGetNumOfAllies("MyBoss")
	end
	local RelevantAllies = 0
	local MyCityID = GetSettlementID("MyBoss")
	local MyTotal = 0
	local RelevantTargetAllies = 0
	local TargetStrength = ai_DynastyCalcStrength(TargetDynasty)
	local TargetAllyStrength = 0
	local TargetTotal = 0
	local TargetAllyCount = 0
	local TargetBossID = dyn_GetValidMember(TargetDynasty)
	GetAliasByID(TargetBossID, "TargetBoss")
	if AliasExists("TargetBoss") then
		TargetAllyCount = f_DynastyGetNumOfAllies("TargetBoss")
	end
	
	-- check for my allies
	if MyAllyCount>0 then
		for i=0, MyAllyCount-1 do
			if HasProperty(DynastyAlias,"Ally_"..i) then
				local FoundID = GetProperty(DynastyAlias,"Ally_"..i)
				GetAliasByID(FoundID, "Ally_"..i)
				local AllyBossID = dyn_GetValidMember("Ally_"..i)
				GetAliasByID(AllyBossID, "AllyBoss")
				if AliasExists("AllyBoss") then
					-- only count dynasties in our city
					if GetSettlementID("AllyBoss")==MyCityID then
						-- check for NAP/alliance with Target (because they will be neutral in conflicts then)
						if DynastyGetDiplomacyState("Ally_"..i, TargetDynasty)<DIP_NAP then
							RelevantAllies = RelevantAllies + 1
							MyAllyStrength = MyAllyStrength + ai_DynastyCalcStrength("Ally_"..i)
						end
					end
				end
			end
		end
	end
	
	-- now check targets allies
	if TargetAllyCount>0 then
		for i=0, TargetAllyCount-1 do
			if HasProperty(TargetDynasty,"Ally_"..i) then
				local FoundID = GetProperty(TargetDynasty,"Ally_"..i)
				GetAliasByID(FoundID, "Ally_"..i)
				
				local AllyBossID = dyn_GetValidMember("Ally_"..i)
				GetAliasByID(AllyBossID, "AllyBoss")
				if AliasExists("AllyBoss") then
					-- only count dynasties in our city
					if GetSettlementID("AllyBoss")==MyCityID then
						-- check for NAP/alliance with me (because they will be neutral in conflicts then)
						if DynastyGetDiplomacyState("Ally_"..i, DynastyAlias)<DIP_NAP then
							RelevantTargetAllies = RelevantTargetAllies + 1
							TargetAllyStrength = TargetAllyStrength + ai_DynastyCalcStrength("Ally_"..i)
						end
					end
				end
			end
		end
	end
	
	--calc threat level	
	
	MyTotal = MyStrength+(MyAllyStrength*0.25)+RelevantAllies*250
	TargetTotal = TargetStrength+(TargetAllyStrength*0.25)+RelevantTargetAllies*250
	
	if MyTotal >= (TargetTotal*3) then
		return 0-- "NoThreat"
	elseif MyTotal >= (TargetTotal*2) then
		return 1 --"SmallThreat"
	elseif MyTotal >= TargetTotal then
		return 2 --"MediumThreat"
	elseif MyTotal < TargetTotal and TargetTotal <= MyTotal*2 then
		return 3 --"HighThreat"
	else
		return 4 -- "VeryHighThreat"
	end
end

function DynastyCheckForRival(DynastyAlias,TargetDynasty)
	
	local IsRival = 0 -- no rival
	local MyCount = DynastyGetMemberCount(DynastyAlias)
	local TargetCount = DynastyGetMemberCount(TargetDynasty)
	
	local MyBuildings = DynastyGetBuildingCount2(DynastyAlias)
	local TargetBuildings = DynastyGetBuildingCount2(TargetDynasty)
	
	-- Check for same buisnesses
	
	if MyBuildings >0 and TargetBuildings >0 then
		for i=0, MyCount-1 do
			if DynastyGetBuilding2(DynastyAlias,i,"Building") then -- check every building
				local Type = BuildingGetType("Building")
				if Type~=2 then -- we don't look for houses
					if DynastyGetRandomBuilding(TargetDynasty,2,Type,"TargetBuilding") then
						-- we found the same type building
						if GetSettlementID("TargetBuilding") == GetSettlementID("Building") then
							-- workshops in same city
							CopyAlias("Building","RivalBuilding")
							break
						end
					end
				end
			end
		end
	end
	
	if AliasExists("RivalBuilding") then
		IsRival = GetID("RivalBuilding")
	end
	
	-- check for political ambitions
	
	for i=0, MyCount-1 do
		if DynastyGetMember(DynastyAlias,i,"Member"..i) then -- check every member
			local OfficeLevel = SimGetOfficeLevel("Member"..i)
			if OfficeLevel>=0 then -- we found someone
				for y=0, TargetCount-1 do -- check every member of target
					if DynastyGetMember(TargetDynasty,y,"TargetMember"..i) then
						if SimGetOfficeLevel("TargetMember"..i)==(OfficeLevel+1) then 
							if GetSettlementID("TargetMember"..i) == GetSettlementID("Member"..i) then
								-- you have the office I want and we live in the same city
								CopyAlias("TargetMember"..i,"RivalOfficeHolder")
								break
							end
						end
					end
				end
			end
		end
	end
	
	if AliasExists("RivalOfficeHolder") then
		IsRival = GetID("RivalOfficeHolder")
	end
	
	return IsRival
end

function DynastyGetBestDiplomacyState(DynastyAlias,TargetDynasty)
	local CurrentStatus = DynastyGetDiplomacyState(DynastyAlias,TargetDynasty)
	local Favor = GetFavorToDynasty(DynastyAlias,TargetDynasty)
	local Threat = ai_DynastyCalcThreat(DynastyAlias,TargetDynasty)
	local IsRival = ai_DynastyCheckForRival(DynastyAlias,TargetDynasty)
	
	if CurrentStatus == DIP_ALLIANCE then
		if IsRival == 0 then
			if Favor >= 75 then
				return "CurrentState"
			else
				if Threat >3 then
					return "CurrentState"
				else
					return "NAP"
				end
			end
		else
			return "NAP"
		end
		
	elseif CurrentStatus == DIP_NAP then
		if IsRival == 0 then
			if Favor >= 70 and Threat>=3 then
				return "ALLIANCE"
			elseif Favor >= 50 and Threat>=2 then
				return "CurrentState"
			elseif Favor <50 and Favor >=30 and Threat >=2 then
				return "CurrentState"
			elseif Favor <30 then
				return "NEUTRAL"
			elseif Threat <2 then
				return "NEUTRAL"
			end
		else
			if Threat>=3 then
				return "CurrentState"
			else
				return "NEUTRAL"
			end
		end
			
	elseif CurrentStatus == DIP_NEUTRAL then
		if IsRival == 0 then
			if Favor >=70 then 
				return "NAP"
			elseif Favor >= 50 then
				if Threat >= 2 then
					return "NAP"
				else
					return "CurrentState"
				end
			elseif Favor <50 and Favor >=25 then
				if Threat >=2 then
					return "NAP"
				else
					return "CurrentState"
				end
			elseif Favor <25 then
				if Favor <=15 then
					return "FOE"
				else
					if Threat<3 then
						return "FOE"
					else
						return "CurrentState"
					end
				end
			end
		else
			if Favor >=65 then
				if Threat>=2 then
					return "NAP"
				else 
					return "CurrentState"
				end
			elseif Favor >=30 then
				return "CurrentState"
			else
				return "FOE"
			end
		end
		
	else -- DIP_FOE
		if IsRival == 0 then
			if Favor >=50 then
				if Threat>=3 then
					return "NAP"
				elseif Threat == 2 then
					return "NEUTRAL"
				else
					return "CurrentState"
				end
			elseif Favor >= 25 then
				if Threat >= 3 then
					return "NAP"
				else
					return "CurrentState"
				end
			else
				return "CurrentState"
			end
		else
			if Favor >=60 then
				if Threat >=3 then
					return "NAP"
				else
					return "CurrentState"
				end
			elseif Favor >=30 then
				if Threat >=3 then
					return "NEUTRAL"
				else
					return "CurrentState"
				end
			else
				return "CurrentState"
			end
		end
	end		
end

function BuildNewWorkshop(Owner, Type)
	 local proto = ScenarioFindBuildingProto(GL_BUILDING_CLASS_WORKSHOP, Type, 1, 0)
	if not GetHomeBuilding(Owner, "home") then
		return false
	end
	if not BuildingGetCity("home", "city") then
		return false
	end
	-- this will only work for buildings inside the city boundaries
	CityBuildNewBuilding("city", proto, Owner, "building")
end

function BuyRandomWorkshop(Owner)
	if not GetHomeBuilding(Owner, "home") then
		return false
	end
	if not BuildingGetCity("home", "city") then
		return false
	end
	local money = GetMoney(Owner) - 1000
	-- decide, which building to buy
	local n = CityGetBuildingCount("city", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_IS_BUYABLE)
	if n >= 1 then 
		CityGetBuildings("city", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_IS_BUYABLE, "bld")
		for i=0, n-1 do
			local cost = BuildingGetBuyPrice("bld"..i)
			if BuildingCanBeOwnedBy("bld"..i, Owner) and cost < money then		
				MeasureRun("bld"..i, Owner, "BuyBuilding", true)
				return true
			end
		end
	end

	-- no buildings available or not able to buy any of them
	local m = CityGetBuildingCount("city", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_NO_DYNASTY )
	for i=0, m-1 do
		if not BuildingGetForSale("bld"..i) and BuildingCanBeOwnedBy("bld"..i, Owner)then
			if MeasureRun("bld"..i, Owner, "TakeOverBid", true) then 
				return true
			end
		end
	end
	return false
end
