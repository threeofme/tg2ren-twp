-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching 
end

-- -------------------
-- BlockSocialMeasures
-- -------------------
function BlockSocialMeasures(ActorAlias, TimeOut)
	
	if TimeOut == nil then
		TimeOut = 2
	end
	
	SetRepeatTimer(ActorAlias, GetMeasureRepeatName2("Flirt"), TimeOut)
	SetRepeatTimer(ActorAlias, GetMeasureRepeatName2("HugCharacter"), TimeOut)
	SetRepeatTimer(ActorAlias, GetMeasureRepeatName2("KissCharacter"), TimeOut)
	SetRepeatTimer(ActorAlias, GetMeasureRepeatName2("MakeACompliment"), TimeOut)
	
end

-- ----------- 
-- MoveToExact
-- -----------
function MoveToExact(MoverAlias, DestinationAlias, Movespeed, Range)
	
	-- Get the current exact distance
	local Distance = CalcDistance(MoverAlias, DestinationAlias)
	
	-- Check if the sim is not already there
	if (Range < Distance) then
	
		-- Move to the destination until the offset position is reached and get the new distance
		f_MoveTo(MoverAlias, DestinationAlias, Movespeed, Range)
		
		-- Get the new exact distance
		Distance = CalcDistance(MoverAlias, DestinationAlias)
		
	end
	
	-- Get the direction from the mover to the destination
	local DirX = 0
	local DirY = 0
	local DirZ = 0
	DirX, DirY, DirZ = GetDirectionTo(MoverAlias, DestinationAlias)
	
	-- Calculate the last step distance
	local LastStepLength = Distance - Range
	
	-- Move the last step
	GfxMoveToPosition(MoverAlias, DirX * LastStepLength, DirY * LastStepLength, DirZ * LastStepLength, 1, false)
	
	local Error = CalcDistance(MoverAlias, DestinationAlias) - Range
	
	return MoveResult
	
end

-- -------------
-- StopFollowing
-- -------------
function StopFollowing(Follower, Followed)
	if HasProperty(Follower, "Follows") then
		if GetID(Followed) == GetProperty(Follower, "Follows") then
			SimStopMeasure(Follower)
		end
	end
end

-- ----------
-- AlignExact
-- ----------
function AlignExact(MoverAlias, DestinationAlias, Range, Duration)

	-- Get the current exact distance
	local Distance = CalcDistance(MoverAlias, DestinationAlias)
	
	-- Get the direction from the mover to the destination
	local DirX = 0
	local DirY = 0
	local DirZ = 0
	DirX, DirY, DirZ = GetDirectionTo(DestinationAlias, MoverAlias)
	
	-- Calculate the last step distance
	local LastStepLength = Distance - Range
	
	if not Duration then
		local Duration = 1
	end
	
	-- Get the terrain-height of the sims
	local tempx = 0
	local tempz = 0
	local HeightMover = 0
	local HeightDest = 0

	GetPosition(MoverAlias, "MoverPos")
	tempx, HeightMover, tempz = PositionGetVector("MoverPos")

	GetPosition(DestinationAlias, "DestinationPos")
	tempx, HeightDest, tempz = PositionGetVector("DestinationPos")

	local HeightComm = (HeightMover + HeightDest) * 0.5
	local MovMover = HeightComm - HeightMover
	local MovDest = HeightComm - HeightDest
	
	-- Prevent BJ-Bug
	GfxMoveToPositionNoWait(MoverAlias, 0, MovMover, 0, 1, false)
	GfxMoveToPosition(DestinationAlias, 0, MovDest, 0, 1, false)
	
	-- Move the last step
	GfxMoveToPosition(DestinationAlias, DirX * LastStepLength, DirY * LastStepLength, DirZ * LastStepLength, 1, false)
	
	local Error = CalcDistance(MoverAlias, DestinationAlias) - Range
	
end

-- -----------------------
-- AttemptToBribeIsSuccess
-- -----------------------
function AttemptToBribeIsSuccess(BriberAlias, TargetAlias)

	Favor = GetFavorToSim(TargetAlias, BriberAlias)
	Alignment = SimGetAlignment(TargetAlias)
	SuccessValue = Favor + Alignment * 0.5
	
	if(SuccessValue >= 50) then
		return true
	end
	
	return false

end

-- -----------------------
-- GetFavorWonFromBribe
-- -----------------------
function GetFavorWonFromBribe(TargetAlias, BribeAmount)
	local wealth = SimGetWealth(TargetAlias)
	 
	if(wealth <= 1500) then 
	  wealth=1500
	end
		
  return ( 250 * BribeAmount / wealth)
end

-- -----------------------
-- GetTradeBonus
-- -----------------------
function GetTradeBonus(BuyerAlias, HowMuch)
	Chance = 3 * GetSkillValue(BuyerAlias, BARGAINING)
	
	if(IsDynastySim(BuyerAlias)) then
		Chance = Chance + 20
	end
	
	if(Chance > Rand(199)) then	
		Bonus2 = 0.0025 * HowMuch * (4 * GetSkillValue(BuyerAlias, RHETORIC) + 100 - SimGetAlignment(BuyerAlias))		
		return Bonus	
	end
end

-- -----------------------
-- AnswerCourtingMeasure
-- -----------------------
function AnswerCourtingMeasure(Kind, Rhetoric, Gender, CourtingProgress)

	label = "@L_SOCIAL_ANSWER_"..Kind
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end	
	
	if (Kind=="TALK") or (Kind=="COMPLIMENT") or (Kind=="DANCE") or (Kind=="MAKE_A_PRESENT") then
		
		if (CourtingProgress<=0) then
			if (CourtingProgress<-5) then
				label = label.."_WAY_TOO_PROFOUND_"
			else
				label = label.."_PROFOUND_"
			end
		else
			if (CourtingProgress>5) then
				label = label.."_VERY_WELL_RECEIVED_"
			else			
				label = label.."_WELL_RECEIVED_"
			end
		end
		
	else
	
		if (CourtingProgress<=0) then
			if (CourtingProgress<-5) then
				label = label.."_WAY_TOO_OFFENSIVE_"
			else
				label = label.."_OFFENSIVE_"
			end
		else
			if (CourtingProgress>5) then
				label = label.."_VERY_WELL_RECEIVED_"
			else			
				label = label.."_WELL_RECEIVED_"
			end
		end		
	
	end
	
	label = label.."+"..Gender
	return label
end

-- -----------------------
-- AnswerMissingVariation
-- -----------------------
function AnswerMissingVariation(Gender, Rhetoric)

	label = "@L_SOCIAL_ANSWER_NO_VARIATION"
	
	if (Gender == GL_GENDER_MALE) then
		label = label.."_MALE"
	else
		label = label.."_FEMALE"
	end
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	return label
	
end

-- -----------------------
-- AnswerBathSuccess
-- -----------------------
function AnswerBathing(Gender, Rhetoric, Success)

	label = "@L_SOCIAL_ANSWER_TAKE_A_BATH"
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end

	if (Success == true) then
		label = label.."_WELL_RECEIVED"
	else
		label = label.."_OFFENSIVE"
	end

	if (Gender == GL_GENDER_MALE) then
		label = label.."_+1"
	else
		label = label.."_+0"
	end
		
	return label
	
end

-- ------------------------------
-- SocialMeasureFailedBeforeStart
-- ------------------------------
function SocialMeasureFailedBeforeStart(Gender, Rhetoric, Kind)

	label = "@L_SOCIAL_ANSWER_FAILED_BEFORE_START"
	
	if (Kind == "Slap") then
		label = label.."_SLAP"
	else
		label = label.."_OUTRAGED"
	end
	
	if (Gender == GL_GENDER_MALE) then
		label = label.."_MALE"
	else
		label = label.."_FEMALE"
	end
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	return label
	
end

-- ----------------------
-- SocialMeasureSucceeded
-- ----------------------
function SocialMeasureSucceeded(Gender, Rhetoric, Kind)

	Assert(Kind, "Param 'Kind' not specified")
	if not Kind then
		return
	end
	label = "@L_SOCIAL_ANSWER_SUCCEEDED_"..Kind
	
	if (Gender == GL_GENDER_MALE) then
		label = label.."_MALE"
	else
		label = label.."_FEMALE"
	end
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	return label
	
end

-- -----------------------
-- AskCohabit
-- -----------------------
function AskCohabit(Rhetoric, Gender)

	label = "@L_FAMILY_2_COHABITATION_QUESTION"
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	if (Gender==GL_GENDER_MALE) then
		label = label.."_TOFEMALE"
	else
		label = label.."_TOMALE"
	end
	
	return label
end

-- -----------------------
-- AnswerCohabit
-- -----------------------
function AnswerCohabit(Rhetoric, Gender, Success)

	label = "@L_FAMILY_2_COHABITATION"
	
	if (Success == 1) then
		label = label.."_ANSWER_POSITIVE"
	elseif (Success == 2) then
		label = label.."_ANSWER_NEGATIVE"
	else
		label = label.."_ANSWER_OUTRAGED"
	end
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	return label
end

-- ---------------
-- MakeACompliment
-- ---------------
function MakeACompliment(Gender, Rhetoric)

	label = "@L_COMPLIMENT"
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	if (Gender==GL_GENDER_MALE) then
		label = label.."_TOFEMALE"
	else
		label = label.."_TOMALE"
	end
	
	return label
		
end

-- -----------------------
-- FlirtSaying1
-- -----------------------
function FlirtSaying1(Rhetoric, Gender)

	label = "@L_FLIRT_SAYING1"
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	if (Gender==GL_GENDER_MALE) then
		label = label.."_TOFEMALE"
	else
		label = label.."_TOMALE"
	end
	
	return label
end

-- -----------------------
-- FlirtAnswer
-- -----------------------
function FlirtAnswer(Rhetoric, Gender)

	label = "@L_FLIRT_ANSWER"
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	if (Gender==GL_GENDER_MALE) then
		label = label.."_TOFEMALE"
	else
		label = label.."_TOMALE"
	end
	
	return label
end

-- -----------------------
-- FlirtSaying2
-- -----------------------
function FlirtSaying2(Rhetoric, Gender)

	label = "@L_FLIRT_SAYING2"
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	if (Gender==GL_GENDER_MALE) then
		label = label.."_TOFEMALE"
	else
		label = label.."_TOMALE"
	end
	
	return label
end

-- -----------------------
-- SetOfficeImpactList
-- -----------------------
function SetOfficeImpactList( Office, ... )
	for i=1,arg.n,1 do
		local blubb = arg[i]
		AddObjectDependendImpact("",GetID(Office),blubb,1)
	end
end

-- -----------------------
-- SetNobilityImpactList
-- -----------------------
function SetNobilityImpactList(TitleHolder, ... )
	for i=1,arg.n,1 do
		local element=arg[i]
		if element ~= "" then
			AddImpact(TitleHolder, element, 1, -1)
		end
	end
end

-- -----------------------
-- RemoveNobilityImpactList
-- -----------------------
function RemoveNobilityImpactList(TitleHolder, ... )
	for i=1,arg.n,1 do
		local element=arg[i]
		if element ~= "" then
			RemoveImpact(TitleHolder, element)
		end
	end
end

-- -----------------------
-- GeneratePrivilegeListLabels
-- -----------------------
function GeneratePrivilegeListLabels(... )
	--local result = {0, 0, 0, 0, 0}
	local Labels  = {}
	for k=0,20 do
		Labels[k] = ""
	end
	
	local Privileges = {"CanApplyForLowestOffice", "RunForAnOffice", "DuelWithOpponent", "PoliticalAttention", "SendApplicant", "BeFromNobleBlood", "GoldenSpoon", "CanApplyForEpicOffice"} -- add new privileges here!
	
	local Counter = 0
	
	for i=1,arg.n,1 do
		for j=1,7 do -- increment if you add new privileges!
			if arg[i] == Privileges[j] then
				Labels[Counter] = "_PRIVILEGE_"..arg[i].."_MESSAGETEXT_+0"
				Labels[Counter+1] = "$N"
				Counter = Counter + 2
			end
		end
	
		--result[i-1] = "_MEASURE_"..arg[i].."_NAME_+0"
		--result = result.."@L_MEASURE_"..arg[i].."_NAME_+0$N"
	end
	-- quick'n dirty
	return Labels[0], Labels[1], Labels[2], Labels[3], Labels[4], Labels[5], Labels[6], Labels[7], Labels[8], Labels[9], Labels[10], Labels[11], Labels[12], Labels[13], Labels[14], Labels[15], Labels[16], Labels[17], Labels[18], Labels[19], Labels[20]
end

-- -----------------------
-- Compute Secret Knowledge
-- -----------------------
function ArtifactsDuration(User, duration)
	local Value = GetSkillValue(User,SECRET_KNOWLEDGE)
	if Value <= 1 then
		return 0
	else
		return ((Value/20)*duration)
	end

end

-- -----------------------
-- RecieveMoney 
-- -----------------------
function RecieveMoney(ObjectAlias, val, topic)

	CreditMoney(ObjectAlias, val, topic)
	ShowOverheadSymbol(ObjectAlias, false, false, 0, "@L%1t",val)
	return val

end

-- -----------------------
-- ModifyFavor
-- -----------------------
function ModifyFavor(source, dest, val)
	
	-- check if the owner has RattleTheChains impact
	if GetImpactValue(dest,"RattleTheChains")==1 and val < 0 then
		val = val / 2
	end
	ModifyFavorToSim(source, dest, val)

	if DynastyIsPlayer(source) or DynastyIsPlayer(dest) then
		if (val >0) then
			feedback_OverheadSkill("","@L$S[2007] +%1n", true, val)
		else
			feedback_OverheadSkill("","@L$S[2006] %1n", true, val)
		end
	end

end


-- -----------------------
-- SkillResultValue
-- -----------------------
function SkillResultValue(target, skill, maxvalue)

	local CharSkill = GetSkillValue(target, skill)
	CharSkill = (Rand(200) - 100 + CharSkill * 100) / 1000
	if(CharSkill > 1.0) then 
		CharSkill = 1.0
	elseif (CharSkill < 0.0) then
		CharSkill = 0.0
	end
		
	return CharSkill * maxvalue

end

-- -----------------------
-- GetMaxHaulValue 
-- berechnet den maximalen wert der beute, die ein dieb abhängig von der gebäudestufe klauen kann
-- -----------------------

function GetMaxHaulValue(DestAlias, DynastyID, ThiefLevel)

	local BaseValue		= BuildingGetPriceProto(BuildingGetProto(DestAlias))
	
	if BaseValue < 1000 then
		return 0
	end
	
	BaseValue = BaseValue * 0.025
	if GetDynastyID(DestAlias) then
		BaseValue = BaseValue * 2
	end
	
	if HasProperty(DestAlias,"ScoutedBy"..DynastyID) then
		BaseValue = BaseValue * 3
	end

	local LootFactor	= ((101 - GetImpactValue(DestAlias,"ProtectionOfBurglary"))*100 + 10*ThiefLevel )
	local LootValue		=	(BaseValue * LootFactor / 100)
	
	if LootValue > 1500 then
		LootValue = 1500
	end
	
	return LootValue
	
end


-- -----------------------
-- GetBuildingLootLevel 
-- -----------------------
function GetBuildingLootLevel(DestAlias, DynastyID)
 
	local maxvalue = chr_GetMaxHaulValue(DestAlias, DynastyID, 6)
	local LootClass = 0
	
	if maxvalue <= 100 then
		LootClass = 0
	elseif maxvalue <= 350 then
		LootClass = 1
	elseif maxvalue <= 700 then
		LootClass = 2
	elseif maxvalue <= 1000 then
		LootClass = 3
	else
		LootClass = 4
	end
	return LootClass
	
end

-- -----------------------
-- GetBuildingProtFromBurglaryLevel 
-- -----------------------
function GetBuildingProtFromBurglaryLevel(destination)	
	--the protection of burglary from the target building
	local ProtectionValue = GetImpactValue(destination,"ProtectionOfBurglary")
	ProtectionValue = (ProtectionValue - 100)*100
	local ProtectionClass = 0

	if ProtectionValue <= 0 then
		ProtectionClass = 0
	elseif ProtectionValue <= 25 then
		ProtectionClass = 1
	elseif ProtectionValue <= 50 then
		ProtectionClass = 2
	elseif ProtectionValue <= 75 then
		ProtectionClass = 3
	else
		ProtectionClass = 4
	end
	return ProtectionClass	
end


-- -----------------------
-- SpeakPoem
-- -----------------------
function SpeakPoem(GenderDes,OwnMarried,InLove,DesFName,OwnFName)

	label = "@L_GIVEAPOEM"
	
	if (DesFName == OwnFName) or (OwnMarried == false) or (InLove == true) then
		label = label.."_POETRY"
	else
		label = label.."_HOMAGE"
	end
	
	if GenderDes == GL_GENDER_FEMALE then
		label = label.."_TOFEMALE"
	else
		label = label.."_TOMALE"
	end	
	
	return label
end

-- -----------------------
-- GetTitle
-- -----------------------
function GetTitle(Sim)
	return GetNobilityTitle(Sim)
end

-- -----------------------
-- SimModifyFaith
-- -----------------------
function SimModifyFaith(Sim,FaithAmount,Religion)

	local faith = SimGetFaith(Sim) + FaithAmount
	SimSetFaith(Sim,faith)
	if Religion == 0 then
		ShowOverheadSymbol(Sim,false,true,0,"@L$S[2015] %1n",FaithAmount)
	else
		ShowOverheadSymbol(Sim,false,true,0,"@L$S[2014] %1n",FaithAmount)
	end
end

-- -----------------------
-- GetBootyCount
-- for the robbers
-- -----------------------
function GetBootyCount(Destination, InventoryType)
	local	Slots = InventoryGetSlotCount(Destination, InventoryType)
	local	Number
	local	ItemId
	local	ItemCount
	local	Total = 0
	
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo(Destination, Number, InventoryType)
		if ItemId and ItemCount then
			Total = Total + ItemGetBasePrice(ItemId) * ItemCount
		end
	end
	
	return Total

end

function OutputHireError(SimAlias, BuildingAlias, Error)

	if Error == "" then
		return
	end
	
	if (Error == "WrongGender") then
		local Profession = BuildingGetProfession(BuildingAlias)
		local Label = ProfessionGetLabel(Profession, GL_GENDER_MALE)
		MsgQuick(BuildingAlias,"@L_GENERAL_MEASURES_FAILURES_+12", Label)
	elseif (Error == "NoSpace") then
		local	MaxWorker = BuildingGetMaxWorkerCount(BuildingAlias)
		MsgQuick(BuildingAlias, "@L_GENERAL_MEASURES_FAILURES_+13", MaxWorker, GetID(BuildingAlias))
	elseif (Error == "NoMoney") then
		local Handsel = SimGetHandsel(SimAlias, BuildingAlias)
		MsgQuick(BuildingAlias, "@L_GENERAL_MEASURES_FAILURES_+14", Handsel, GetID(SimAlias))
	elseif (Error == "NoWorker") then
		MsgQuick(BuildingAlias, "@L_GENERAL_MEASURES_FAILURES_+15",GetID(BuildingAlias))
	else
		-- "WrongParams", etc.
		MsgQuick(BuildingAlias, "@L_GENERAL_MEASURES_FAILURES_+16", GetID(SimAlias))
	end
	
end

function CreateFamily(SimAlias)

	if not AliasExists(SimAlias) then
		return
	end
	
	local	Age = SimGetAge(SimAlias)
	if Age < 16 then
		return
	end

	local	Var = 90
	if Age < 26 then
		Var = 100 - (26 - Age) * 10
		if Var > 90 then
			Var = 90
		end
	end
	
	local SpouseAlias = SimAlias.."_s"
	
	local	Married = false
	if Rand(100) < Var then
		if BossCreate(HomeAlias, 1-SimGetGender(SimAlias), 0, 2, SpouseAlias) then
			SimSetAge(SpouseAlias, Rand(9) + Age - 4)
			if SimMarry(SimAlias, SpouseAlias) then
				Married = true
			end
		end
	end
	
	if not Married then
		return
	end
	
	Age = math.min( SimGetAge(SimAlias), SimGetAge(SpouseAlias) )
	
	local Childs 		= Rand(3)+1
	local	Birthday 	= Rand(16)+16
	local ChildAge
	local ChildAlias
	local	CreateChild
	local ChildWasCreated = false
	
	
	while Childs>0 and Birthday < Age do
		ChildAge = Age - Birthday
		
		CreateChild = true
		if Age > 18 then
			if Rand(100) < 50 and ChildWasCreated then
				CreateChild = false
			end
		end
		
		if CreateChild then
			ChildAlias = SimAlias.."_c"..Childs
			chr_CreateChild(HomeAlias, SimAlias, SpouseAlias, ChildAge, ChildAlias)
			chr_CreateFamily(ChildAlias)
			ChildWasCreated = true
		end
		Childs = Childs - 1
		Birthday = Rand(1)+Birthday + 1
	end
end

-- -----------------------
-- CreateChild
-- -----------------------
function CreateChild(Residence, Parent1, Parent2, Age, ChildAlias, Gender)

	if Gender==GL_GENDER_MALE then
		SimCreate(7, Residence, Residence, ChildAlias)
	elseif Gender==GL_GENDER_FEMALE then
		SimCreate(8, Residence, Residence, ChildAlias)
	else
		SimCreate(-1, Residence, Residence, ChildAlias)
	end

	-- Sets the child to the new family
	SimSetFamily(ChildAlias, Parent1, Parent2)

	-- Initialize more stuff in the code
	DoNewBornStuff(ChildAlias)
		
	SimSetAge(ChildAlias, Age)

	local fameparent1 = chr_SimGetFame(Parent1)
	local fameparent2 = chr_SimGetFame(Parent2)
	local famechild = math.floor((fameparent1 + fameparent2) / 4)
	SetProperty(ChildAlias,"Fame",famechild)
	
	if Age < GL_AGE_FOR_GROWNUP then
		SimSetBehavior(ChildAlias, "Childness")
		SetState(ChildAlias, STATE_CHILD, true)
	end
end

-- -----------------------
-- SocialReactCourtLover
-- -----------------------
function SocialReactCourtLover()
end

-- -----------------------
-- SocialReactNoCourtLover
-- -----------------------
function SocialReactNoCourtLover()
end

-- -----------------------
-- MultiAnim
-- Plays two animations on two sim and adjustes the distance between them.
-- A factor for the overall time until the function should return can be given. It must be between 0.0 and 1.0.
-- If the last parameter is given, the ReturnAfter value means the seconds after which the function should return. The minimum time here is 1.0 second
-- In any case the function returns the time until the animations are over.
-- -----------------------
function MultiAnim(Actor1, Anim1, Actor2, Anim2, Distance, ReturnAfter, Seconds)
	
	local time1 = PlayAnimationNoWait(Actor1, Anim1)
	local time2 = PlayAnimationNoWait(Actor2, Anim2)
	chr_AlignExact(Actor1, Actor2, Distance)
	
	if time1 == nil then
		time1 = 0
	end
	
	if time2 == nil then
		time2 = 0
	end
	
	local time3 = math.max(time1, time2)
	
	if Seconds then
		
		-- Sleep the given seconds
		if ReturnAfter> 0.0 and ReturnAfter<time3 then
			if ReturnAfter < 1.0 then
				ReturnAfter = 1.0
			end
		end
		
		Sleep(ReturnAfter)
		return time3 - ReturnAfter
		
	elseif ReturnAfter then
		
		-- Sleep the given factor
		if ReturnAfter<1.0 and ReturnAfter>0.0 then
			Sleep(time3 * ReturnAfter)
			return time3 * (1 - ReturnAfter)
		end
		
	end
	
	Sleep(time3)
	return 0
	
end

-- -----------------------
-- GainXP
-- -----------------------
function GainXP(SimAlias,XPAmount)
	local Multiplikator = 1
	local SchoeneRundeZahl = 5*math.floor(XPAmount*Multiplikator/5)
	IncrementXP(SimAlias, SchoeneRundeZahl)
	if DynastyIsPlayer(SimAlias) then
		PlaySound3D(SimAlias,"gainxp/gain_xp.ogg",1)
	end
end

function CheckSell()

	if BuildingGetType("")~=GL_BUILDING_TYPE_RESIDENCE then
		return true
	end

	local	Ok = false
	
	local	Count = DynastyGetBuildingCount2("")
	for l=0,Count-1 do
		if DynastyGetBuilding2("", l, "Check") then
			if BuildingGetType("Check")==GL_BUILDING_TYPE_RESIDENCE then
				if GetID("Check")~=GetID("") then
					if not BuildingGetForSale("Check") then
						Ok = true
					end
				end
			end
		end
	end
	
	if not Ok then
		MsgQuick("", "@L_GENERAL_MEASURES_075_SELLBUILDING_FAILURES_+0")
		return false
	end
	
	Count = DynastyGetMemberCount("")
	for l=0,Count-1 do
		if DynastyGetMember("", l, "Member") then
			if GetHomeBuildingId("Member")==GetID("") then
			
				if SimGetOfficeID("Member")~=-1 then
					MsgQuick("", "@L_GENERAL_MEASURES_075_SELLBUILDING_FAILURES_+1")
					return false
				end
				
				if SimIsAppliedForOffice("Member") then
					MsgQuick("", "@L_GENERAL_MEASURES_075_SELLBUILDING_FAILURES_+2")
					return false
				end
			end
		end
	end

	return true
end

function CheckDestroy()

	if BuildingGetType("")~=GL_BUILDING_TYPE_RESIDENCE then
		return true
	end

	local	Ok = false
	
	local	Count = DynastyGetBuildingCount2("")
	for l=0,Count-1 do
		if DynastyGetBuilding2("", l, "Check") then
			if BuildingGetType("Check")==GL_BUILDING_TYPE_RESIDENCE then
				if GetID("Check")~=GetID("") then
					if not BuildingGetForSale("Check") then
						Ok = true
					end
				end
			end
		end
	end
	
	if not Ok then
		MsgQuick("", "@L_INTERFACE_TEARDOWN_FAILURES_+0")
		return false
	end
	
	Count = DynastyGetMemberCount("")
	for l=0,Count-1 do
		if DynastyGetMember("", l, "Member") then
			if GetHomeBuildingId("Member")==GetID("") then
			
				if SimGetOfficeID("Member")~=-1 then
					MsgQuick("", "@L_INTERFACE_TEARDOWN_FAILURES_+1")
					return false
				end
				
				if SimIsAppliedForOffice("Member") then
					MsgQuick("", "@L_INTERFACE_TEARDOWN_FAILURES_+2")
					return false
				end
			end
		end
	end

	return true
end

function StartRage(SimAlias)

	local MeasureID = MeasureGetID("Rage")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local BaseXP = GetDatabaseValue("Measures", MeasureID, "basexp")
	
	local boost = 4
	
	SetRepeatTimer(SimAlias, GetMeasureRepeatName2("Rage"), TimeOut)
	
	GetPosition(SimAlias,"ParticleSpawnPos")
	PlaySound3D(SimAlias,"Effects/mystic_gift+0.wav", 1.0)
	StartSingleShotParticle("particles/rage.nif", "ParticleSpawnPos", 1, 2.0)
	AddImpact(SimAlias, "fighting", boost, duration)
	AddImpact(SimAlias, "IsOnRage", boost, duration)
	
	-- Find all units in the near range of the "Feldherr"
	local FightUnits = Find(SimAlias, "__F( (Object.GetObjectsByRadius(Sim) == 2000) AND (Object.CanBeControlled()))", "FightUnit", -1)
	chr_GainXP(SimAlias, BaseXP)
	if FightUnits == 0 then
		--No unit found
		return true
	end
	
	for i=0, FightUnits-1 do
		GetPosition("FightUnit"..i,"ParticleSpawnPos")
		PlaySound3D(SimAlias,"Effects/mystic_gift+0.wav", 1.0)
		StartSingleShotParticle("particles/rage.nif", "ParticleSpawnPos", 1, 2.0)
		AddImpact("FightUnit"..i, "fighting", boost, duration)
		AddImpact("FightUnit"..i, "IsOnRage", boost, duration)
	end
	return true
	
end

function CalculateBuildingBonus(SimAlias,workbuilding,hirefire)

	if not AliasExists(SimAlias) then
		return
	end
	if not AliasExists(workbuilding) then
		return
	end

	local constitutionmodify = 0
	local charismamodify = 0
	local fightingmodify = 0
	local shadow_artsmodify = 0
	local empathymodify = 0
	local movespeedmodify = 0
	
	local buildingtype = BuildingGetType(workbuilding)

	-- residence
	if buildingtype == 2 then
		if hirefire == "hire" then
			if BuildingHasUpgrade(workbuilding, "CrossedAxes") then
				fightingmodify = fightingmodify + 2
			end
			if BuildingHasUpgrade(workbuilding, "HarkingHorn") then
				empathymodify = empathymodify + 1
			end
			AddImpact(SimAlias,"fighting",fightingmodify,-1)
			AddImpact(SimAlias,"empathy",empathymodify,-1)
		else
			RemoveImpact(SimAlias, "fighting")
			RemoveImpact(SimAlias, "empathy")
		end
	
	-- robber
	elseif buildingtype == 15 then
		if hirefire == "hire" then
			if BuildingHasUpgrade(workbuilding, "CircleOfEquals") then
				constitutionmodify = constitutionmodify + 2
			end
			if BuildingHasUpgrade(workbuilding, "ChiefTent") then
				fightingmodify = fightingmodify + 2
			end
			if BuildingHasUpgrade(workbuilding, "RobberTent") then
				movespeedmodify = movespeedmodify + 1.2
			end
			AddImpact(SimAlias,"constitution",constitutionmodify,-1)
			AddImpact(SimAlias,"fighting",fightingmodify,-1)
			AddImpact(SimAlias,"MoveSpeed",movespeedmodify,-1)
		else
			RemoveImpact(SimAlias, "constitution")
			RemoveImpact(SimAlias, "fighting")
			RemoveImpact(SimAlias, "movespeed")		
		end

	-- thief
	elseif buildingtype == 22 then
		if hirefire == "hire" then
			if BuildingHasUpgrade(workbuilding, "TrickBox") then
				shadow_artsmodify = shadow_artsmodify + 1
			end
			if BuildingHasUpgrade(workbuilding, "ShadowCloak") then
				shadow_artsmodify = shadow_artsmodify + 2
			end
			AddImpact(SimAlias,"shadow_arts",shadow_artsmodify,-1)
		else
			RemoveImpact(SimAlias, "shadow_arts")
		end

	-- piratesnest
	elseif buildingtype == 36 then
		if hirefire == "hire" then
			if BuildingHasUpgrade(workbuilding, "MakeUpMirror") then
				charismamodify = charismamodify + 1
			end
			if BuildingHasUpgrade(workbuilding, "BathBowl") then
				charismamodify = charismamodify + 2
			end
			if BuildingHasUpgrade(workbuilding, "SexyClothes") then
				charismamodify = charismamodify + 3
			end
			AddImpact(SimAlias,"charisma",charismamodify,-1)
		else
			RemoveImpact(SimAlias, "charisma")
		end

	-- mercenary
	elseif buildingtype == 21 then
		if hirefire == "hire" then
			if BuildingHasUpgrade(workbuilding, "AlarmHorn") then
				fightingmodify = fightingmodify + 1
			end
			if BuildingHasUpgrade(workbuilding, "WarBanner") then
				fightingmodify = fightingmodify + 1
			end
			if BuildingHasUpgrade(workbuilding, "CircleOfEquals") then
				constitutionmodify = constitutionmodify + 1
			end
			if BuildingHasUpgrade(workbuilding, "WaterBottle") then
				movespeedmodify = movespeedmodify + 1.2
			end
			if BuildingHasUpgrade(workbuilding, "PlanOfSite") then
				empathymodify = empathymodify + 1
			end
			AddImpact(SimAlias,"constitution",constitutionmodify,-1)
			AddImpact(SimAlias,"fighting",fightingmodify,-1)
			AddImpact(SimAlias,"MoveSpeed",movespeedmodify,-1)
			AddImpact(SimAlias,"empathy",empathymodify,-1)
		else
			RemoveImpact(SimAlias, "constitution")
			RemoveImpact(SimAlias, "fighting")
			RemoveImpact(SimAlias, "movespeed")		
			RemoveImpact(SimAlias, "empathy")		
		end
	end
end

function CheckGuildMaster(SimAlias,GuildHouse)

	if GetSettlement(SimAlias, "city") then
		if (gameplayformulas_CheckPublicBuilding("city", GL_BUILDING_TYPE_BANK)[1]>0) then
			if not CityGetRandomBuilding("city", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "guildhouse") then
				return false
			end
		else
			return false
		end
	else
		return false
	end
	
	local Class

	if SimGetClass(SimAlias)==1 then
		Class = "PatronMaster"
	elseif SimGetClass(SimAlias)==2 then
		Class = "ArtisanMaster"
	elseif SimGetClass(SimAlias)==3 then
		Class = "ScholarMaster"
	elseif SimGetClass(SimAlias)==4 then
		Class = "ChiselerMaster"
	else
		return false
	end

	if GetID(SimAlias)==GetProperty(GuildHouse, Class) then
		return true
	else
		return false
	end

end

function GetAlderman()
	local alderman = GetData("#Alderman")
	if alderman~=nil then
		if (alderman>0) and GetAliasByID(alderman,"Alderman") and GetState("Alderman", STATE_DEAD)==false then
			return alderman
		else
			return 0
		end
	else
		return 0
	end
end

function GetKing()
	local Count = ScenarioGetObjects("cl_Settlement", 99, "Cities")

	for i=0,Count-1 do
		if CityGetOffice("Cities"..i, 7, 0, "OFFICE") then
			if OfficeGetHolder("OFFICE", "OfficeHolder") then
				return GetID("OfficeHolder")
			end
		end
	end

	return 0
end

function SimAddFame(SimAlias,value)
	
	if value == nil then
		return false
	end
	
	local upgrade = ""
	if SimGetClass(SimAlias)==1 then
		upgrade = "GuildSignetPatrons"
	elseif SimGetClass(SimAlias)==2 then
		upgrade = "GuildSignetArtisans"
	elseif SimGetClass(SimAlias)==3 then
		upgrade = "GuildSignetScholars"
	elseif SimGetClass(SimAlias)==4 then
		upgrade = "GuildSignetSchiselers"
	end

	if upgrade~="" then
		if GetHomeBuilding(SimAlias, "Home") then
			if BuildingHasUpgrade("Home", upgrade) then
				value = value + 1
			end
		end
	end

	if value < 0 then
		return false
	elseif not HasProperty(SimAlias, "Fame") then
		SetProperty(SimAlias,"Fame",value)
		feedback_OverheadFame(SimAlias, value)
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if not HasProperty("family", "Fame") then
				SetProperty("family","Fame",value)
			else
				local fame2 = GetProperty("family","Fame") + value
				SetProperty("family","Fame",fame2)
			end
		end
		return true
	else
		local fame = GetProperty(SimAlias,"Fame") + value
		SetProperty(SimAlias,"Fame",fame)
		feedback_OverheadFame(SimAlias, value)
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if not HasProperty("family", "Fame") then
				SetProperty("family","Fame",value)
			else
				local fame2 = GetProperty("family","Fame") + value
				SetProperty("family","Fame",fame2)
			end
		end
		return true
	end

	return false

end

function SimRemoveFame(SimAlias,value)

	if value == nil or value < 0 then
		return false
	elseif not GetProperty(SimAlias,"Fame") then
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if GetProperty("family","Fame") then
				local fame2 = GetProperty("family","Fame") - value
				if fame2 < 0 then
					SetProperty("family","Fame",0)
				else
					SetProperty("family","Fame",fame2)
				end
			end
		end
		return false
	else
		local fame = GetProperty(SimAlias,"Fame")
		fame = fame - value
		if fame < 0 then
			SetProperty(SimAlias,"Fame",0)
		else
			SetProperty(SimAlias,"Fame",fame)
		end
		feedback_OverheadFame(SimAlias, -value)
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if GetProperty("family","Fame") then
				local fame2 = GetProperty("family","Fame") - value
				if fame2 < 0 then
					SetProperty("family","Fame",0)
				else
					SetProperty("family","Fame",fame2)
				end
			end
		end
		return true
	end

	return false

end

function SimGetFame(SimAlias)

	local fame = 0

	if AliasExists(SimAlias) then
		if GetProperty(SimAlias,"Fame") then
			fame = GetProperty(SimAlias,"Fame")
		end
	end

	return fame

end

function SimGetFameLevel(SimAlias)

	local fame = 0

	if AliasExists(SimAlias) then
		if GetProperty(SimAlias,"Fame") then
			fame = GetProperty(SimAlias,"Fame")
		end
	end

	if fame == 0 then
		return 0
	elseif fame < 6 then
		return 1
	elseif fame < 11 then
		return 2
	elseif fame < 16 then
		return 3
	elseif fame < 21 then
		return 4
	else
		return 5
	end

	return 0

end

function DynastyGetFame(SimAlias)

	local fame = 0

	if AliasExists(SimAlias) then
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if GetProperty("family","Fame") then
				fame = GetProperty("family","Fame")
			end
		end
	end

	return fame

end

function DynastyGetFameLevel(SimAlias)

	local fame = 0

	if AliasExists(SimAlias) then
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if GetProperty("family","Fame") then
				fame = GetProperty("family","Fame")
			end
		end
	end

	if fame == 0 then
		return 0
	elseif fame < 21 then
		return 1
	elseif fame < 51 then
		return 2
	elseif fame < 101 then
		return 3
	elseif fame < 201 then
		return 4
	else
		return 5
	end

	return 0

end

function GetImperialOfficer()
	local ImperialOfficer = GetData("#ImperialOfficer")
	if ImperialOfficer~=nil then
		if (ImperialOfficer>0) and GetAliasByID(ImperialOfficer,"ImperialOfficer") and GetState("ImperialOfficer", STATE_DEAD)==false then
			return ImperialOfficer
		else
			return 0
		end
	else
		return 0
	end
end

function SimAddImperialFame(SimAlias,value)
	
	if value == nil then
		return false
	end
	
	local upgrade = "ImperialSignet"

	GetDynasty(SimAlias, "Dyn")
	local	Count = DynastyGetBuildingCount2("Dyn")
	for l=0,Count-1 do
		if DynastyGetBuilding2("Dyn", l, "Check") then
			if BuildingGetType("Check")==111 then
				if BuildingHasUpgrade("Check", upgrade) then
					value = value + 1
				end
			end
		end
	end

	if value < 0 then
		return false
	elseif not HasProperty(SimAlias, "ImperialFame") then
		SetProperty(SimAlias,"ImperialFame",value)
		feedback_OverheadImpFame(SimAlias, value)
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if not HasProperty("family", "ImperialFame") then
				SetProperty("family","ImperialFame",value)
			else
				local fame2 = GetProperty("family","ImperialFame") + value
				SetProperty("family","ImperialFame",fame2)
			end
		end
		return true
	else
		local fame = GetProperty(SimAlias,"ImperialFame") + value
		SetProperty(SimAlias,"ImperialFame",fame)
		feedback_OverheadImpFame(SimAlias, value)
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if not HasProperty("family", "ImperialFame") then
				SetProperty("family","ImperialFame",value)
			else
				local fame2 = GetProperty("family","ImperialFame") + value
				SetProperty("family","ImperialFame",fame2)
			end
		end
		return true
	end

	return false

end

function SimRemoveImperialFame(SimAlias,value)

	if value < 0 then
		return false
	elseif not GetProperty(SimAlias,"ImperialFame") then
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if GetProperty("family","ImperialFame") then
				local fame2 = GetProperty("family","ImperialFame") - value
				if fame2 < 0 then
					SetProperty("family","ImperialFame",0)
				else
					SetProperty("family","ImperialFame",fame2)
				end
			end
		end
		return false
	else
		local fame = GetProperty(SimAlias,"ImperialFame")
		fame = fame - value
		if fame < 0 then
			SetProperty(SimAlias,"ImperialFame",0)
		else
			SetProperty(SimAlias,"ImperialFame",fame)
		end
		feedback_OverheadImpFame(SimAlias, -value)
		if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
			if GetProperty("family","ImperialFame") then
				local fame2 = GetProperty("family","ImperialFame") - value
				if fame2 < 0 then
					SetProperty("family","ImperialFame",0)
				else
					SetProperty("family","ImperialFame",fame2)
				end
			end
		end
		return true
	end

	return false

end

function SimGetImperialFame(SimAlias)

	local fame = 0

	if GetProperty(SimAlias,"ImperialFame") then
		fame = GetProperty(SimAlias,"ImperialFame")
	end

	return fame

end

function SimGetImperialFameLevel(SimAlias)

	local fame = 0

	if GetProperty(SimAlias,"ImperialFame") then
		fame = GetProperty(SimAlias,"ImperialFame")
	end

	if fame == 0 then
		return 0
	elseif fame < 6 then
		return 1
	elseif fame < 11 then
		return 2
	elseif fame < 16 then
		return 3
	elseif fame < 21 then
		return 4
	else
		return 5
	end

	return 0

end

function DynastyGetImperialFame(SimAlias)

	local fame = 0

	if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
		if GetProperty("family","ImperialFame") then
			fame = GetProperty("family","ImperialFame")
		end
	end

	return fame

end

function DynastyGetImperialFameLevel(SimAlias)

	local fame = 0

	if IsDynastySim(SimAlias) and GetDynasty(SimAlias, "family") then
		if GetProperty("family","ImperialFame") then
			fame = GetProperty("family","ImperialFame")
		end
	end

	if fame == 0 then
		return 0
	elseif fame < 21 then
		return 1
	elseif fame < 51 then
		return 2
	elseif fame < 101 then
		return 3
	elseif fame < 201 then
		return 4
	else
		return 5
	end

	return 0

end

function DynastyGetWorkhopCount(SimAlias)
	local buildingcount = 0
	local Count = DynastyGetBuildingCount2(SimAlias)
	local Class
	for l=0,Count-1 do
		if DynastyGetBuilding2(SimAlias, l, "Check") then
			Class = BuildingGetClass("Check")
			if Class == GL_BUILDING_CLASS_WORKSHOP then
				buildingcount = buildingcount + 1
			end
		end
	end
	return buildingcount
end


function GetImperialFameLevelPoints(Level)

	if Level == 1 then
		return 1
	elseif Level == 2 then
		return 21
	elseif Level == 3 then
		return 51
	elseif Level == 4 then
		return 101
	else
		return 201
	end

	return 0

end

function GetWarRiskLevel(val)

	if val < 10 then
		return 0
	elseif val < 20 then
		return 1
	elseif val < 40 then
		return 2
	elseif val < 60 then
		return 3
	else
		return 4
	end

	return 0

end

function GetEnemyMoodLevel(val)

	if val < 5 then
		return 0
	elseif val < 10 then
		return 1
	elseif val < 26 then
		return 2
	elseif val < 50 then
		return 3
	else
		return 4
	end

	return 0

end

function decrementInfectionCount(InfectionName, CityAlias)
	if HasProperty(CityAlias,InfectionName) then
		local Infected = GetProperty(CityAlias,InfectionName) - 1
		if Infected < 1 then
			Infected = 0
		end
		SetProperty(CityAlias,InfectionName,Infected)
	else
		SetProperty(CityAlias,InfectionName,0)
	end
end

function incrementInfectionCount(InfectionName, CityAlias)
	if HasProperty(CityAlias,InfectionName) then
		local Infected = GetProperty(CityAlias,InfectionName) + 1
		SetProperty(CityAlias,InfectionName,Infected)
	else
		SetProperty(CityAlias,InfectionName,1)
	end
end

