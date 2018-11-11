-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

-- -----------------------
-- GetActivity
-- The main acivity facor
-- 0 = no activity, 100 = full activity of the sims
-- -----------------------
function GetActivity()
	if not GetSettlement("","MyCity") then
		return 0
	end

	local CityLevel = CityGetLevel("MyCity")
	local res = 0
	
	if CityLevel<=2 then
		res = 99
	elseif CityLevel==3 then
		res = 94
	elseif CityLevel==4 then
		res = 89
	elseif CityLevel==5 then
		res = 84
	else
		res = 80
	end

	return res
end

-- -----------------------
-- CheckWeather
-- -----------------------
function CheckWeather()
	local RainValue = Weather_GetValue(0)
	local CloudValue = Weather_GetValue(1)
	local WindValue = Weather_GetValue(3)
	
	local Weather = (RainValue*7) + CloudValue + (WindValue*2) --0(good) - 10(bad)
	local Activity = 0
	if Weather <=1  then		--sun is shining, everything is allright
		Activity = 100
	elseif Weather <=3 then	--cloudy sky
		Activity = 70
	elseif Weather <=7 then	--rain or snow
		Activity = 35
	else				--stormy weather, bah
		Activity = 10
	end
	
	if Rand(100) < Activity then
		return true
	else
		return false
	end
end

-- -----------------------
-- Sleep
-- -----------------------
function Sleep(SleepStart, SleepEnd)
	MsgDebugMeasure("Sleeping...")
	if not GetHomeBuilding("", "HomeBuilding") then
		Sleep(Gametime2Realtime(1))
		return false
	end

	if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
		if not f_MoveTo("", "HomeBuilding", GL_MOVESPEED_RUN) then
			Sleep(3)
			return false
		end
	end

	if GetLocatorByName("HomeBuilding", "Bed1", "SleepPosition") then
		if not f_BeginUseLocator("", "SleepPosition", GL_STANCE_LAY, true) then
			RemoveAlias("SleepPosition")
			if IsDynastySim("") then
				if GetHPRelative("")<1 then
					GetSettlement("","MyCity")
					if CityGetRandomBuilding("MyCity", GL_BUILDING_CLASS_PUBLIC, 32, -1, -1, FILTER_IGNORE, "Destination") then
						if f_MoveTo("","Destination") then
							MeasureRun("","Destination","Linger",true)
							return
						end
					end
				else
					return
				end
			end
		end
	end
	
	local SleepTime = Gametime2Realtime(EN_RECOVERFACTOR_HOME/60)
	local	ContinueSleeping = true
	SetState("",STATE_SLEEPING,true)
	while ContinueSleeping do
	
		ContinueSleeping = false
		
		Sleep(SleepTime)

		if GetHPRelative("") < 1 then
			ModifyHP("", 1)
			ContinueSleeping = true
		end
		
		local time = math.mod(GetGametime(),24)
		if SleepStart <= time and time<SleepEnd then
			ContinueSleeping = true
		end
		Sleep(1)
	end
	SetState("",STATE_SLEEPING,false)
	if AliasExists("SleepPosition") then
		f_EndUseLocatorNoWait("", "SleepPosition", GL_STANCE_STAND)
		RemoveAlias("SleepPosition")
	end
end

-- -----------------------
-- ThiefIdle
-- -----------------------
function ThiefIdle(Workbuilding)
	SimGetWorkingPlace("", "WorkingPlace")
	-- AI controlled thiefs should not go idle
	local Time = math.mod(GetGametime(), 24)
	if BuildingGetAISetting("WorkingPlace", "Enable") > 0 then
		if GetHPRelative("") < 0.7 then
			roguelib_Heal("", "WorkingPlace")
		elseif 5 <= Time and Time <= 21 then
			-- pickpocket or look for sales counters during the day
			if Rand(10) < 7 then
				roguelib_Pickpocket("", "WorkingPlace")
			else
				roguelib_StealFromCounter("", "WorkingPlace")
			end
		else
			roguelib_BurgleBuilding("", "WorkingPlace")
		end 
	end

	local WhatToDo = Rand(5)
	if WhatToDo == 0 then
		if GetFreeLocatorByName("WorkingPlace", "Chair",1,4, "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_SIT, true) then
				RemoveAlias("ChairPos")
				return
			end
			while true do
				local WhatToDo2 = Rand(4)
				if WhatToDo2 == 0 then
					Sleep(12) 
				elseif WhatToDo2 == 1 then
					return
				elseif WhatToDo2 == 2 then
					PlayAnimation("","sit_talk")
				else
					PlayAnimation("","sit_laugh")					
				end
				Sleep(3)
			end
		end
	elseif WhatToDo == 1 then
		if GetLocatorByName("WorkingPlace", "Chair_Cellwatch", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_SIT, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","sit_laugh")
			Sleep(Rand(12)+1)
		end
	elseif WhatToDo == 2 then
		if GetLocatorByName("WorkingPlace", "Fistfight", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","point_at")
			PlayAnimation("","fistfight_in")
			PlayAnimation("","fistfight_punch_01")
			PlayAnimation("","fistfight_punch_05")
			PlayAnimation("","fistfight_punch_02")
			PlayAnimation("","fistfight_punch_06")
			PlayAnimation("","fistfight_punch_03")
			PlayAnimation("","fistfight_punch_07")
			PlayAnimation("","fistfight_punch_04")
			PlayAnimation("","fistfight_punch_08")
			PlayAnimation("","fistfight_out")
		end
	elseif WhatToDo == 3 then
		if GetLocatorByName("WorkingPlace", "Pickpocket", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","pickpocket")
		end
	else
		if GetLocatorByName("WorkingPlace", "Cell_Outside", "ChairPos") then
			if not f_BeginUseLocator("", "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation("","sentinel_idle")
		end
	end
end

-- -----------------------
-- RobberIdle
-- -----------------------
function RobberIdle(Workbuilding)
	SimGetWorkingPlace("", "WorkingPlace")
	GetLocatorByName("WorkingPlace", "Entry1", "WaitingPos")
	
	Sleep(10)
	
	if GetDistance("", "WaitingPos") > 500 then
		local dist = Rand(100)+10	
		f_MoveTo("Sim","WaitingPos",GL_MOVESPEED_RUN, dist)
	end

	Sleep(5)
end

-- -----------------------
-- GoHome
-- -----------------------
function GoHome()
	MsgDebugMeasure("Going Home")
	if not GetHomeBuilding("", "HomeBuilding") then
		Sleep(5)
		return
	end
	
	if SimIsCourting("") and not GetState("", STATE_BLACKDEATH) then
		return
	end

	if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
		if GetImpactValue("", "Sickness") > 0 then
			f_MoveTo("", "HomeBuilding", GL_MOVESPEED_WALK)
		else
			f_MoveTo("", "HomeBuilding", GL_MOVESPEED_RUN)
		end
	end
	Sleep(Rand(30)+30)
	
	local FireChance = BuildingGetLevel("HomeBuilding")*200
	if Rand(FireChance) == 1 then
		SetState("HomeBuilding", STATE_BURNING, true)
	end
end

-- -----------------------
-- DoNothing
-- -----------------------
function DoNothing()
	MsgDebugMeasure("I'm really bored")
	if GetInsideBuildingID("") ~= -1 then
		if Rand(12) == 0 then
			CarryObject("","Handheld_Device/ANIM_besen.nif", false)
			PlayAnimation("","hoe_in")	
			for i=0,5 do
				local waite = PlayAnimationNoWait("","hoe_loop")
				Sleep(0.5)
				PlaySound3DVariation("","Locations/herbs",1.0)
				Sleep(waite-0.5)
			end
			PlayAnimation("","hoe_out")
			CarryObject("","",false)
			Sleep((Rand(10)+2))
		else
			Sleep((Rand(15)+5))
		end
		return
	end
	
	local ThingsToDo = Rand(5)
	if ThingsToDo == 0 then
		PlayAnimation("","cogitate")
		Sleep(3)
	elseif ThingsToDo == 1 then
		CarryObject("", "Handheld_Device/ANIM_Pretzel.nif", false)
		PlayAnimationNoWait("","eat_standing")
		Sleep(6)
		CarryObject("","",false)
		Sleep(Rand(8)+2)
	elseif ThingsToDo == 2 then
		CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
		PlayAnimationNoWait("","use_potion_standing")
		Sleep(6)
		CarryObject("","",false)
		Sleep(Rand(8)+2)
	elseif ThingsToDo == 3 then
		if IsDynastySim("") and not GetInsideBuilding("","inside") then
			-- talk to someone
			Sleep(4)
			local TalkPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==1500)AND NOT(Object.GetStateImpact(no_idle))AND(Object.IsDynastySim())AND(Object.CanBeInterrupted(StartDialog))AND NOT(Object.HasImpact(Hidden))AND NOT(Object.GetInsideBuilding()))","TalkPartner", -1)
			if TalkPartners>0 then
				MeasureRun("", "TalkPartner"..Rand(TalkPartners), "StartDialog" )
				return
			else
				Sleep(6)
				if Rand(3) == 0 then
					local RandAnim = Rand(4)
					if RandAnim == 0 then
						PlayAnimation("","cogitate")
					elseif RandAnim == 1 then
						PlayAnimation("","cough")
					elseif RandAnim == 2 then
						PlayAnimation("","guard_object")
					elseif RandAnim == 3 then
						PlayAnimation("","talk_short")
					else
						PlayAnimation("","nod")
					end
				end
				Sleep(4)
			end
		end
	else
		Sleep((Rand(15)+5))
	end
end

-- -----------------------
-- GoToRandomPosition
-- -----------------------
function GoToRandomPosition()
	MsgDebugMeasure("Walking around...")
	local class
	local offset = 75+Rand(250)
	if GetSettlement("", "City") then
		local	RandVal = Rand(7)
		if RandVal < 2 then
			class = GL_BUILDING_CLASS_MARKET
		elseif RandVal < 4 then
			class = GL_BUILDING_CLASS_PUBLIC
		else
			class = GL_BUILDING_CLASS_WORKSHOP
		end
		
		if CityGetRandomBuilding("City", class, -1, -1, -1, FILTER_IGNORE, "Destination") then
			if GetOutdoorMovePosition("", "Destination", "MoveToPosition") then
				-- Don't move there if it is too far
				if GetDistance("","Destination")>12000 then
					SatisfyNeed("", 5, 0.25)
					Sleep((Rand(6)+1))
					return
				end
				
				f_MoveTo("", "MoveToPosition", GL_MOVESPEED_WALK, offset)
				-- Satisfy the need
				SatisfyNeed("", 5, 0.5)
				-- Add some XP
				IncrementXPQuiet("", 5)
				Sleep((Rand(10)+1))
			end
		end
	end
end

-- -----------------------
-- ForceAFight
-- -----------------------
function ForceAFight(Enemy)
	if BattleIsFighting(Enemy) then
		return
	end
	MsgDebugMeasure("Force a Fight")
	SimStopMeasure(Enemy)
	StopAnimation(Enemy) 
	MoveStop(Enemy)
	AlignTo("",Enemy)
	AlignTo(Enemy,"")
	Sleep(1)
	-- Satisfy the need
	SatisfyNeed("",5,0.5)
	-- Add some XP
	IncrementXPQuiet("",25)
	PlayAnimationNoWait("","threat")
	PlayAnimation(Enemy,"insult_character")
	SetProperty(Enemy,"Berserker",1)
	SetProperty("","Berserker",1)
	BattleJoin("",Enemy,false,false)
end

-- -----------------------
-- SitDown
-- -----------------------
function SitDown()
	MsgDebugMeasure("Sit down and enjoy the season")
	local season = GetSeason()
	
	if season == EN_SEASON_SPRING or season == EN_SEASON_SUMMER or season == EN_SEASON_AUTUMN then
		if GetSettlement("", "City") then
			if CityGetRandomBuilding("City", GL_BUILDING_CLASS_PUBLIC, 32, -1, -1, FILTER_IGNORE, "Destination") then
				-- Don't move there if it is too far
				if GetDistance("","Destination")>12000 then
					SatisfyNeed("", 2, 0.25)
					Sleep((Rand(10)+1))
					return
				end
				f_MoveTo("", "Destination", GL_MOVESPEED_WALK, (Rand(100)+45))
				local Stance = 2
				--0=sitground, 1=sitbench, 2=stand
				if GetFreeLocatorByName("Destination","idle_Sit",1,5,"SitPos") then
					f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true)
					Stance = 1
					if GetLocatorByName("Destination","campfire","CampFirePos") then
						if GetImpactValue("Destination","torch")==0 then
							AddImpact("Destination","torch",1,1)
							GfxStartParticle("Campfire","particles/Campfire2.nif","CampFirePos",3)
							--GfxStartParticle("Camplight","Lights/candle_M_01.nif","CampFirePos",6)		
						end
					end
				elseif GetFreeLocatorByName("Destination","idle_SitGround",1,5,"SitPos") then
					Stance = 0
					f_BeginUseLocator("","SitPos",GL_STANCE_SITGROUND,true)
				elseif GetFreeLocatorByName("Destination","idle_Stand",1,5,"SitPos") then
					Stance = 2
					f_BeginUseLocator("","SitPos",GL_STANCE_STAND,true)
				end
				local EndTime = GetGametime()+1
				while GetGametime() < EndTime do				
					if Stance == 1 then
						Sleep(2)
						local AnimTime = 0
						local idx = Rand(3)
						if idx == 0 then
							PlaySound3DVariation("","CharacterFX/male_anger",1)
							PlayAnimation("","bench_sit_offended")
						elseif idx == 1 then
							PlaySound3DVariation("","CharacterFX/male_amazed",1)
							PlayAnimation("","bench_sit_talk_short")
						else
							PlaySound3DVariation("","CharacterFX/male_neutral",1)
							PlayAnimation("","bench_talk")						
						end
					end
					Sleep(Rand(15)+6)
				end
				-- Satisfy the Need
				SatisfyNeed("",2,0.7)
				-- Add some XP
				IncrementXPQuiet("",10)
				if GetImpactValue("Destination","torch")==0 then
					GfxStopParticle("Campfire")
					--GfxStopParticle("Camplight")
				end
				
				f_EndUseLocator("","SitPos",GL_STANCE_STAND)
				
				Sleep(Rand(5)+1)
			end
		end
	else
		if Rand(100) > 65 then
			local FightPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==2000)AND NOT(Object.HasDynasty()))","FightPartner", -1)
			if FightPartners > 0 then
				idlelib_SnowballBattle("FightPartner")
				return
			else
				Sleep(4)
			end
		end
	end
end

-- -----------------------
-- Graveyard
-- -----------------------
function Graveyard()
	MsgDebugMeasure("Cry around at the Graveyard")
	if GetSettlement("", "City") then
		if not CityGetRandomBuilding("City", -1, 98, -1, -1, FILTER_IGNORE, "Destination") then
			return
		end
		if GetState("Destination",2) == true then
			return
		end
		if GetState("Destination",5) == true then
			return
		end
		
		-- Don't move there if it is too far
		if GetDistance("","Destination")>15000 then
			SatisfyNeed("", 4, 0.25)
			Sleep(Rand(10)+1)
			return
		end
		
		local offset = 50+Rand(200)
		if not f_MoveTo("","Destination", GL_MOVESPEED_RUN, offset) then
			return
		end
		f_Stroll("", 200, 3)
		MoveSetStance("", GL_STANCE_KNEEL)
		Sleep(5+Rand(11))
		PlayAnimationNoWait("","knee_pray")
		
		-- check for item gravestone
		if GetImpactValue("Destination", "Gravestone")>0 then
			-- some favor for the gravestone owner
			chr_ModifyFavor("Destination","",5)
		end
		
		Sleep(5+Rand(11))
		MoveSetStance("",GL_STANCE_STAND)
		-- Satisfy the need
		SatisfyNeed("",4,0.5)
		-- Add some XP
		IncrementXPQuiet("", 10)
		if BuildingGetOwner("Destination","Sitzer") then
			local Rang = (SimGetRank("")*5)+SimGetLevel("")
			local Money = 5+Rand(Rang)
			if GetImpactValue("Destination","Gravestone")>0 then
				Money = Money*2
			end
			CreditMoney("Destination",Money,"tip") -- Fajeth Mod, default Rand(5)
			economy_UpdateBalance("Destination", "Service", Money)
		end
		Sleep(Rand(6)+1)
	end
end

-- -----------------------
-- GetCorn
-- -----------------------
function GetCorn()
	MsgDebugMeasure("Get Corn from the farm")
	if GetSettlement("", "City") then
		if CityGetRandomBuilding("City", -1, 3, -1, -1, FILTER_IGNORE, "Destination") then
			if not f_MoveTo("","Destination", GL_MOVESPEED_RUN) then
				return
			end
			if not GetHomeBuilding("", "HomeBuilding") then	
				return
			end
			if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
				Sleep(2)
				
				local Carry = 0
				if GetItemCount("Destination","Wheat",INVENTORY_STD)>4 then
					Carry = 1
					RemoveItems("Destination","Wheat",5,INVENTORY_STD)
					local Payment = ItemGetBasePrice("Wheat")*10
					CreditMoney("Destination",Payment,"misc")
				end
				if Carry == 1 then
					MsgSayNoWait("","@L_GETCORN_MESSAGE")
					-- Satisfy the need
					SatisfyNeed("",5,0.7)
					PlayAnimation("","talk")
					MoveSetActivity("","carry")
					Sleep(4)
					CarryObject("","Handheld_Device/ANIM_Bag.nif",false)	
					if not f_MoveTo("", "HomeBuilding") then
						MoveSetActivity("","")
						CarryObject("","",false)
						return
					end
					MoveSetActivity("","")
					CarryObject("","",false)
				else
					if not f_MoveTo("", "HomeBuilding") then
						return
					end
				end
				
			end
			Sleep(5+Rand(11))
		end
	end
end

-- -----------------------
-- CollectWater
-- -----------------------
function CollectWater()
	MsgDebugMeasure("Collecting Water from a Well")
	if GetSettlement("", "City") then
		if FindNearestBuilding("", -1,24,-1,false, "Destination") then
			if not f_MoveTo("","Destination", GL_MOVESPEED_RUN, 170) then
				return
			end
			PlayAnimationNoWait("","manipulate_middle_low_r")
			Sleep(2)
			
			if not GetHomeBuilding("", "HomeBuilding") then	
				return
			end
			if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
				PlaySound3DVariation("","measures/putoutfire",1)
				CarryObject("Owner", "Handheld_Device/ANIM_Bucket.nif", false)
				Sleep(2)
				-- Satisfy the need
				SatisfyNeed("",5,0.5)
				-- Add some XP
				IncrementXPQuiet("",5)
				if not f_MoveTo("", "HomeBuilding", GL_MOVESPEED_WALK) then
					return
				end
				CarryObject("","",false)
			end
			Sleep(Rand(10)+5)
		end
	end
end

-- -----------------------
-- BuyReligion
-- -----------------------
function BuyReligion()
	MsgDebugMeasure("Buying religious stuff at the market")
	if GetSettlement("", "City") then
		local Market = Rand(5)+1
		if CityGetRandomBuilding("City", 5,14,Market,-1, FILTER_IGNORE, "Destination") then
			if not f_MoveTo("","Destination",GL_WALKSPEED_RUN, 250) then
				return
			end
			PlayAnimation("","cogitate")
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation("","CharacterFX/female_neutral",1)
			end
			Sleep(Rand(5)+2)
			
			local ToBuy = ""
			if SimGetReligion("")==0 then
				ToBuy = "Chaplet"
			else
				ToBuy = "Schnitzi"
			end
			SatisfyNeed("",4,0.5)
			if GetItemCount("Destination", ToBuy, INVENTORY_STD)>0 then
				Transfer(nil,nil,INVENTORY_STD,"Destination",INVENTORY_STD,ToBuy,1)
				MsgSayNoWait("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_COMMENT")
				IncrementXPQuiet("",5)
			end
		end
	end
end

-- -----------------------
-- BuySomething
-- -----------------------
function BuySomethingAtTheMarket(Type)
	MsgDebugMeasure("Buying Stuff at the Market")
	if GetSettlement("", "City") then
		local Market = Rand(5)+1
		if CityGetRandomBuilding("City", 5,14,Market,-1, FILTER_IGNORE, "Destination") then
			-- Don't move there if it is too far
			if GetDistance("","Destination")>15000 then
				Sleep(Rand(10)+2)
				return
			end
			local RandPos = Rand(150)
			GetFleePosition("","Destination",(250+RandPos),"DestPos")
			if not f_MoveTo("","DestPos",GL_WALKSPEED_RUN) then
				return
			end
			PlayAnimation("","cogitate")
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation("","CharacterFX/female_neutral",1)
			end
			Sleep(Rand(5)+2)

			if not GetHomeBuilding("", "HomeBuilding") then	
				return
			end
			if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
				
				-- Satisfy the need
				if Type == 1 then
					SatisfyNeed("",1,0.5) -- eat
				elseif Type == 7 then
					SatisfyNeed("",7,0.5) -- konsum
				elseif Type == 9 then
					SatisfyNeed("",9,0.5) -- financial
				end
				
				local Choice = Rand(3)+1
				if IsDynastySim("") then
					Choice = SimGetRank("")
				end
				local Ware
				local Itemchoice
				local zItem
				
				if Choice == 1 then -- destitute
					zItem = Rand(8)
					Ware = "Handheld_Device/ANIM_Boxvegetable.nif"
					
					if Type == 1 then
						if Rand(2) == 0 then
							Itemchoice = "GrainPap"
						else
							Itemchoice = "Stew"
						end
					elseif Type == 9 then
						Itemchoice = "Siegelring"
					else
					
						if zItem == 0 then
							Itemchoice = "HerbTea"
						elseif zItem == 1 then
							Itemchoice = "Grindingbrick"
						elseif zItem == 2 then
							Itemchoice = "Housel"
						elseif zItem == 3 then
							Itemchoice = "Soap"
						elseif zItem == 4 then
							Itemchoice = "Torch"
						elseif zItem == 5 then
							Itemchoice = "Schadelkerze"
						elseif zItem == 6 then
							Itemchoice = "Kerzen"
						elseif zItem == 7 then
							Itemchoice = "Oil"
						end
					end
				elseif Choice == 2 then -- poor
					Ware = "Handheld_Device/ANIM_Breadbasket.nif"
					zItem = Rand(6)
					
					if Type == 1 then
						Itemchoice = "Wheatbread"
					elseif Type == 9 then
						Itemchoice = "Schuldenbrief"
					else
					
						if zItem == 0 then
							Itemchoice = "SilverRing"
						elseif zItem == 1 then
							Itemchoice = "MoneyBag"
						elseif zItem == 2 then
							Itemchoice = "Blanket"
						elseif zItem == 3 then
							Itemchoice = "FarmersClothes"
						elseif zItem == 4 then
							Itemchoice = "Schnitzi"
						elseif zItem == 5 then
							Itemchoice = "Perle"
						end
					end
				elseif Choice == 3 then --middle
					zItem = Rand(5)
					Ware = "Handheld_Device/ANIM_Tailorbasket.nif"
					if Type == 1 then
						Itemchoice = "BreadRoll"
					elseif Type == 9 then
						Itemchoice = "Urkunde"
					else
						if zItem == 0 then
							Itemchoice = "SalmonFilet"
						elseif zItem == 1 then
							Itemchoice = "GoldChain"
						elseif zItem == 2 then
							Itemchoice = "CitizensClothes"
						elseif zItem == 3 then
							Itemchoice = "Chaplet"
						elseif zItem == 4 then
							Itemchoice = "Phiole"
						end
					end
				elseif Choice == 4 then --rich
					zItem = Rand(3)
					Ware = "Handheld_Device/ANIM_holzscheite.nif"
					if Type == 1 then
						if Rand(2) == 0 then
							Itemchoice = "RoastBeef"
						else
							Itemchoice = "Pretzel"
						end
					elseif Type == 9 then
						Itemchoice = "Optieisen"
					else
						if zItem == 0 then
							Itemchoice = "NoblesClothes"
						elseif zItem == 1 then
							Itemchoice = "Pearlchain"
						elseif zItem == 2 then
							Itemchoice = "statue"
						end
					end
				elseif Choice == 5 then -- wealthy
					zItem = Rand(3)
					Ware = "Handheld_Device/ANIM_Bottlebox.nif"
					if Type == 1 then
						Itemchoice = "CreamPie"
					elseif Type == 9 then
						Itemchoice = "Optisilber"
					else
						if zItem == 0 then
							Itemchoice = "RubinStaff"
						elseif zItem == 1 then
							Itemchoice = "Optigold"
						elseif zItem == 2 then
							Itemchoice = "GemRing"
						end
					end
				else -- undefined
					Ware = "Handheld_Device/ANIM_Barrel.nif"
				    	if zItem == 0 then
						Itemchoice = "Wool"
					elseif zItem == 1 then
						Itemchoice = "Wheat"
					elseif zItem == 2 then
						Itemchoice = "Iron"
					elseif zItem == 3 then
						Itemchoice = "Leather"
					elseif zItem == 4 then
						Itemchoice = "Oakwood"
					elseif zItem == 5 then
						Itemchoice = "Clay"
					elseif zItem == 6 then
						Itemchoice = "Gemstone"
					end
				end
					
				CopyAlias("Destination","Market")
				if GetItemCount("Market", Itemchoice, INVENTORY_STD)>1 then
					MoveSetActivity("","carry")
					Sleep(1)
					Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,Itemchoice,2)
					PlaySound3DVariation("","Effects/digging_box",1)
					local Label = ItemGetLabel(Itemchoice, false)
					MsgSay("","@L_MEASURE_IDLE_BUYSOMETHING_LABEL",Label)
					IncrementXPQuiet("",10)
					CarryObject("",Ware,false)
				end
				
				if not f_MoveTo("", "HomeBuilding") then
					MoveSetActivity("","")
					CarryObject("","",false)
					return
				end
				MoveSetActivity("","")
				CarryObject("","",false)
			end
			Sleep(Rand(10)+5)
		end
	end
end
-- -----------------------
-- SnowballBattle
-- -----------------------
function SnowballBattle(Target)
	if not AliasExists(Target) then
		return
	end
	MsgDebugMeasure("Throwing Snowballs...")
	AlignTo("",Target)
	Sleep(1.7)
	PlayAnimationNoWait("","manipulate_bottom_r")
	Sleep(1.5)
	SimStopMeasure(Target)
	MoveStop(Target)
	StopAnimation(Target)
	
	CarryObject("", "Handheld_Device/ANIM_snowball.nif", false)
	Sleep(1)
	PlayAnimationNoWait("", "throw")
	Sleep(1.8)
	CarryObject("", "" ,false)
	local fDuration = ThrowObject("", Target, "Handheld_Device/ANIM_snowball.nif",0.1,"snowball",0,150,0)
	Sleep(fDuration)
	GetPosition(Target,"ParticleSpawnPos")
	
	StartSingleShotParticle("particles/snowball.nif", "ParticleSpawnPos",1,5)
	AlignTo(Target,"")
	Sleep(0.7)
	PlayAnimation(Target,"threat")
	IncrementXPQuiet("",10)
end

-- -----------------------
-- GoTownhall
-- -----------------------
function GoTownhall()
	MsgDebugMeasure("Watching, whats going on in the townhall")
	if GetSettlement("", "City") then
		if CityGetRandomBuilding("City", 3,23,-1,-1, FILTER_IGNORE, "Destination") then
			if f_MoveTo("","Destination", GL_MOVESPEED_RUN) then
				-- Satisfy the need
				SatisfyNeed("",5,0.5)
				-- Add some XP
				IncrementXPQuiet("", 4)
				Sleep(Rand(4)+1)
				if not GetFreeLocatorByName("Destination","Wait",1,8,"SitPos") then
					f_Stroll("",300,10)
					return
				end
				
				if f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true) then
					local anim = { "bench_talk","bench_talk_short","bench_talk_offended" }
					Sleep(Rand(5)+5)
					PlayAnimation("",anim[(Rand(3)+1)])
				   	Sleep(Rand(5)+5)
					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
					f_Stroll("", 400,10)
					if Rand(5) == 1 then
						idlelib_GoToRandomPosition()
					end
					return
				else
					f_Stroll("", 400,10)
					return
				end
			end			
		end
	end
end

-- -----------------------
-- Illness
-- -----------------------
function Illness()
	MsgDebugMeasure("Buying HerbTea or Blanket or Soap")
	if GetSettlement("", "City") then
		CityGetLocalMarket("City","Market")
		--buy herbtea
		if GetImpactValue("","Caries")==1 or GetImpactValue("","Cold")==1 then
			if CityGetRandomBuilding("City", 5,14,-1,-1, FILTER_IGNORE, "Destination") then
				f_MoveTo("","Destination", GL_MOVESPEED_RUN, 100)
				if GetItemCount("Market","HerbTea",INVENTORY_STD)>0 then
					Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,"HerbTea",1)
					MsgSay("","@L_IDLE_ILLNESS_BUY_TEA")
					IncrementXPQuiet("",5)
				else
					MsgSay("","@L_IDLE_ILLNESS_NO_TEA")
					Sleep(Rand(5)+1)
					idlelib_GoToRandomPosition()
					return
				end
			end
		--or blanket
		elseif  GetImpactValue("","Fever")==1 or GetImpactValue("","Pneumonia")==1 or GetImpactValue("","Influenza")==1 then
			if CityGetRandomBuilding("City", 5,14,-1,-1, FILTER_IGNORE, "Destination") then
				f_MoveTo("","Destination", GL_MOVESPEED_RUN, 100)
				if GetItemCount("Market","Blanket",INVENTORY_STD)>0 then
					Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,"Blanket",1)
					MsgSay("","@L_IDLE_ILLNESS_BUY_BLANKET")
					IncrementXPQuiet("",5)
				else
					MsgSay("","@L_IDLE_ILLNESS_NO_BLANKET")
					Sleep(Rand(5)+1)
					idlelib_GoToRandomPosition()
					return
				end
			end
		-- soap
		else
			if CityGetRandomBuilding("City", 5,14,-1,-1, FILTER_IGNORE, "Destination") then
				f_MoveTo("","Destination", GL_MOVESPEED_RUN, 100)
				if GetItemCount("Destination","Soap",INVENTORY_STD)>0 then
					Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,"Soap",1)
					MsgSay("","@L_IDLE_ILLNESS_BUY_SOAP")
					IncrementXPQuiet("",5)
				else
					MsgSay("","@L_IDLE_ILLNESS_NO_SOAP")
					Sleep(Rand(5)+1)
					idlelib_GoToRandomPosition()
					return
				end
			end		
		end
		Sleep(Rand(8)+3)
		idlelib_GoHome()
		return
	end
end

-- -----------------------
-- CheckInsideStore
-- -----------------------
function CheckInsideStore(Type)
	-- TODO include type in filter 
	local Workshop = "Workshop" 
	if not GetHomeBuilding("", "HomeBld") then
		return
	end
	if not BuildingGetCity("HomeBld", "City") then
		return
	end
	
	economy_GetRandomBuildingByRanking("City", Workshop)
	--GetRandomBuildingByRanking(CityAlias, ResultAlias, Ranking, Type)
	
	-- Don't move there if it is too far
	if GetDistance("",Workshop) > 15000 then
		return
	end
	
	-- move near the shop
	local offset = 50 + Rand(101)
	if not f_MoveTo("", Workshop, GL_MOVESPEED_RUN, offset) then -- Move
		return
	end
	
	-- calculate available budget (up to 10% of current money)
	local Budget
	if IsDynastySim("") then
		math.min(2000, math.floor(GetMoney("") / 10))
	else
		Budget = SimGetRank("") * 100
	end
	-- Buy items up to budget, but no more than 10 (prevents outsales of lower items)
	local ItemId, ItemCount = economy_BuyRandomItems(Workshop, "", Budget, Rand(10)+1)
	
	if ItemCount <= 0 then
	-- nothing available for my budget -- lets shout
		local ProdType
		if Type == 1 then 
			ProdType = "GETGOOD" 
		else 
			ProdType = "GETFOOD" 
		end 
		local ProdName = ItemGetLabel(ItemId, ItemCount == 1)
		PlayAnimationNoWait("","propel")
		if Rand(2) == 0 then
			MsgSay("","@L_HPFZ_IDLELIB_"..ProdType.."_SPRUCH_+2",ProdName)
		else
			MsgSay("","@L_HPFZ_IDLELIB_"..ProdType.."_SPRUCH_+3",ProdName)
		end
		if GetProperty(Workshop,"MsgSell")~=0 then
			MsgNewsNoWait("ShopOwner","","","building",-1,
			"@L_MEASURES_BUYSTUFF_HEAD",
			"@L_MEASURES_BUYSTUFF_FAIL",ProdName, GetID(""), GetID(Workshop))
		end
		Sleep(Rand(4)+1) -- cool down before you leave ;)
		return
	end

	BuildingGetOwner(Workshop, "BldOwner")
	local ProdType
	if GL_CLASS_PATRON == SimGetClass("BldOwner") then
		ProdType = "GETFOOD"
		SatisfyNeed("", 1, 0.5)
	else
		ProdType = "GETGOOD"
		SatisfyNeed("", 7, 0.5)
	end
	if Rand(2) == 0 then
		PlayAnimationNoWait("","manipulate_middle_twohand")
		MsgSay("","@L_HPFZ_IDLELIB_"..ProdType.."_SPRUCH_+0",ProdName)
	else
		if ProdType == "GETFOOD" then -- only eat food
			MsgSayNoWait("","@L_HPFZ_IDLELIB_GETFOOD_SPRUCH_+1",ProdName)
			CarryObject("", "Handheld_Device/ANIM_Pretzel.nif", false)
			PlayAnimationNoWait("","eat_standing")
			Sleep(6)
			CarryObject("","",false)
		else
			MsgSayNoWait("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",ProdName)
		end
	end
	IncrementXPQuiet("",10)
	Sleep(Rand(4)+1)
end

-- -----------------------
-- GoToTavern
-- -----------------------
function GoToTavern(Need)
	-- is Versengold around? Then go there!
	local TavernAlias
	local stage = GetData("#MusicStage")
	if stage and GetAliasByID(stage,"stageobj") and GetSettlement("", "City") then
		BuildingGetCity("stageobj","stageCity")
		if GetID("City")==GetID("stageCity") and (Rand(100)>39) then
			if BuildingGetType("stageobj")==GL_BUILDING_TYPE_PIRAT then
				idlelib_GoToDivehouse()
				return
			else
				TavernAlias = "stageobj"
			end
		end
	end
	
	local Destination = "Destination"
	--LogMessage("::TOM::idlelib:1061 Looking for a tavern...")
	if not GetHomeBuilding("", "HomeBld") then
		return
	end
	if not BuildingGetCity("HomeBld", "City") then
		return
	end
	economy_GetRandomBuildingByRanking("City", Destination, 0, GL_BUILDING_TYPE_TAVERN)
	if not AliasExists(Destination) then
		--LogMessage("::TOM::idlelib:1064 Could not find a tavern in range.")
		-- no Tavern found
		SatisfyNeed("", Need, 0.25)
		return
	end
	
	-- need pleasure, could I take a bath?
	if Need == 2 and not BuildingHasUpgrade(Destination, "BathingRoom") then
		-- no bath found
		SatisfyNeed("",Need,0.5)
		return
	end
	
	-- move to the tavern
	--LogMessage("::TOM::idlelib:1078 Going to the tavern now...")
	if not f_MoveTo("", Destination, GL_MOVESPEED_RUN) then
		return
	end

	-- wtf?
	if Rand(6)==0 then
		if HasProperty(Destination,"Versengold") then
			MeasureRun("", nil, "CheerMusicians")
		else
			if (SimGetGender("")==GL_GENDER_FEMALE) then
				idlelib_KissMeHonza()
				return
			end
		end
	end
	
	--LogMessage("::TOM::idlelib:1095 Let's hang out in tavern...")
	idlelib_TavernHangout("", Destination, Need)
end

function TavernHangout(SimAlias, Tavern, Need)
	if not GetInsideBuilding(SimAlias,"DummyAlias") then
		return
	end
	
	-- sit down somewhere
	local SitPosition, EndNo
	if IsDynastySim(SimAlias) then
		SitPosition, EndNo = "SitRich", 5
	else
		SitPosition, EndNo = "SitInn", 12
	end
	--LogMessage("::TOM::idlelib:1125 Looking for a seat to sit down. "..SitPosition)
	if GetFreeLocatorByName(Tavern, SitPosition, 1, EndNo, "SitPos") then
		f_BeginUseLocator(SimAlias, "SitPos", GL_STANCE_SIT, true)
	elseif GetFreeLocatorByName(Tavern, SitPosition, EndNo, 1, "SitPos") then
		f_BeginUseLocator(SimAlias,"SitPos",GL_STANCE_SIT,true)
	else
		-- full
		--LogMessage("::TOM::idlelib:1132 Tavern is full, I'm leaving.")
		local CurrentRanking = GetProperty(Tavern, "SalescounterRanking") or 0
		SetProperty(Tavern, "SalescounterRanking", math.floor(CurrentRanking*0.9))
		f_ExitCurrentBuilding(SimAlias)
		idlelib_GoToTavern(Need)
		return
	end

	local verweile = idlelib_GetTimeToStayAtTavern(SimAlias, Tavern)
	--LogMessage("::TOM::idlelib:1141 I will stay for a bit: "..verweile)
	-- stay a bit longer if Versengold is here
	if HasProperty(Tavern,"Versengold") then
		verweile = verweile + 2
		CreditMoney(Tavern, 100, "Versengold")
		economy_UpdateBalance(Tavern, "Service", 100)
	end
	
	while verweile > 0 do
		verweile = verweile - 1
		--LogMessage("::TOM::idlelib:1150 Another round for me! Remaining = "..verweile)
		-- no Need to stay any longer? okay, last round for me!
		if SimGetNeed(SimAlias,Need)<0.15 then
			verweile = 0
		end
		
		-- watch musicians
		if HasProperty(Tavern,"Versengold") and Rand(10)>7 then
			f_EndUseLocator(SimAlias,"SitPos",GL_STANCE_STAND)
			SatisfyNeed(SimAlias,2,0.5)
			MeasureRun(SimAlias, nil, "CheerMusicians")
		end
	
		PlaySound3DVariation(SimAlias,"Locations/tavern_people",0.8)
		if Need == 2 then -- satisfy pleasure
			SatisfyNeed(SimAlias, Need,0.15)
		end
		
		--LogMessage("::TOM::idlelib:1169 Do some talking.")
		-- starting animation, nothing bought yet
		if Rand(3) == 0 then
			PlayAnimation(SimAlias,"sit_talk_02")
		else
			PlayAnimation(SimAlias,"sit_talk")
		end
		
		-- Buy something from the building's inventory
		local SimRank = SimGetRank(SimAlias)
		--LogMessage("::TOM::idlelib:1169 Calculating budget, Rank = "..SimRank)
		local MaxItems = Rand(2)
		local Budget = 40 * SimRank + Rand(60*SimRank)
		if HasProperty(Tavern,"DanceShow") then
			MaxItems = MaxItems + Rand(2) -- buy more when entertainment is nice
		end
		
		--LogMessage("::TOM::idlelib:1180 I'd like to buy something, Budget = "..Budget)
		local ItemId, ItemCount, Price = economy_BuyDrinkOrFood(Tavern, SimAlias, Budget, MaxItems)
		
		if ItemId then
			IncrementXPQuiet(SimAlias,5)
			-- some animation based on what we bought
			if Need == 1 then -- eat
				PlaySound3D(SimAlias,"CharacterFX/eating/eating+2.ogg",1.0)
				PlayAnimation(SimAlias,"sit_eat")
				Sleep(1)
				if Rand(2) == 0 then
					PlayAnimation(SimAlias,"sit_talk_02")
				else
					PlayAnimation(SimAlias,"sit_talk_short")
				end
				Sleep(1)
				PlaySound3D(SimAlias,"CharacterFX/eating/eating+2.ogg",1.0)
				PlayAnimation(SimAlias,"sit_eat")
				Sleep(1)
				if Rand(4) == 0 then
					PlayAnimationNoWait(SimAlias,"sit_laugh")
					Sleep(1)
					if Rand(2)==0 then
						PlaySound3D(SimAlias,"Locations/tavern/laugh_01.wav",0.75)
					else
						PlaySound3D(SimAlias,"Locations/tavern/laugh_02.wav",0.75)
					end
				end
				Sleep(2)
			elseif Need == 8 then -- drink
				local AnimTime
				if Rand(3) == 0 then
					AnimTime = PlayAnimationNoWait(SimAlias,"sit_drink")
					Sleep(1.5)
					CarryObject(SimAlias,"Handheld_Device/ANIM_beaker_sit_drink.nif",false)
					Sleep(1)
					if Rand(2) == 0 then
						PlaySound3DVariation(SimAlias,"CharacterFX/drinking",0.75)
					else
						PlaySound3D(SimAlias,"CharacterFX/drinking/drinking+2.ogg",0.75)
					end
					Sleep(AnimTime-1.5)
					CarryObject(SimAlias,SimAlias,false)
					if SimGetGender(SimAlias)==GL_GENDER_MALE then
						PlaySound3DVariation(SimAlias,"CharacterFX/male_belch",0.7)
					else
						PlaySound3DVariation(SimAlias,"CharacterFX/female_belch",0.7)
					end
				else
					AnimTime = PlayAnimationNoWait(SimAlias,"sit_cheer")
					Sleep(1.5)
					PlaySound3D(SimAlias,"Locations/tavern/cheers_01.wav",0.75)
					CarryObject(SimAlias,"Handheld_Device/ANIM_beaker_sit_drink.nif",false)
					Sleep(1)
					PlaySound3DVariation(SimAlias,"CharacterFX/drinking",0.75)
					Sleep(AnimTime-1.5)
					CarryObject(SimAlias,SimAlias,false)
				end
				Sleep(2)
			end
			SatisfyNeed(SimAlias,Need,0.15)
			if HasProperty(Tavern,"ServiceActive") then
				-- TODO increase tip for higher charisma of service
				local Tip = math.floor(Price * 0.15)
				CreditMoney(Tavern, Tip, "Misc")
				economy_UpdateBalance(Tavern, "Service", Tip)
			end
		end
	end -- end while; verweile == 0
	
	-- stand up
	f_EndUseLocator(SimAlias, "SitPos" ,GL_STANCE_STAND)
	-- Get drunk?
	local Hour = math.mod(GetGametime(), 24)
	if 21 <= Hour or Hour < 4 then
		if Rand(100) >= 95 then
			--LoopAnimation(SimAlias,"idle_drunk",10)
			AddImpact(SimAlias, "totallydrunk", 1 ,6)
			AddImpact(SimAlias, "MoveSpeed", 0.7, 6)
			SetState(SimAlias, STATE_TOTALLYDRUNK, true)
			StopMeasure()
		end
	end
	f_ExitCurrentBuilding(SimAlias)
end

function GetTimeToStayAtTavern(SimAlias, Tavern)
	local Hour = math.mod(GetGametime(), 24)
	local verweile = 0

	if 6 <= Hour and Hour < 18 then
		verweile = 2+Rand(3) -- 2 - 4
	else
		verweile = 3+Rand(4) -- 3 - 6
	end
	
	if IsDynastySim(SimAlias) then
		verweile = verweile + 2
	end
	
	if HasProperty(Tavern,"DanceShow") then
		verweile = verweile + 2
		CreditMoney(Tavern,50,"Versengold")
		economy_UpdateBalance(Tavern, "Service", 50)
	end
	
	if HasProperty(Tavern,"ServiceActive") then
		verweile = verweile + 2
	end
	return verweile
end

-- -----------------------
-- UseCocotte
-- -----------------------
function UseCocotte()

	MsgDebugMeasure("Search a cocotte to fullfill your need")
	-- leave current building
	if GetInsideBuilding("","Inside") then
		f_ExitCurrentBuilding("")
	end
	
	-- search cocotte in range
	local CocottsCnt = Find("","__F((Object.GetObjectsByRadius(Sim)==20000) AND (Object.GetProfession() == 30) AND (Object.Property.CocotteProvidesLove == 1) AND (Object.Property.CocotteHasClient == 0) AND (Object.HasDifferentSex()))","Cocotte", -1)
	if(CocottsCnt == 0) then
		Sleep(Rand(8)+3)
		return false
	end

	-- go to random cocotte
	ChangeAlias("Cocotte"..Rand(CocottsCnt),"Target")
	if AliasExists("Target") then
		MeasureCreate("UseLaborOfLove")
		MeasureStart("UseLaborOfLove","","Target","UseLaborOfLove",true)
		return
	end
end

-- -----------------------
-- KissMeHonza
-- -----------------------
function KissMeHonza()
	if HasProperty("","KissMeHoney") then
		local Musician = GetProperty("","KissMeHoney")
		if GetAliasByID(Musician,"Musician") then
			if not HasProperty("Musician","Moving") and not HasProperty("Musician","KissMe") and (GetDistance("","Musician")<6001) then
				SetProperty("Musician","KissMe",GetID(""))

				if f_MoveTo("", "Musician", GL_MOVESPEED_RUN, (400+Rand(200))) then
					if not HasProperty("Musician","Moving") and not HasProperty("Musician","MusicStage") then
						
						while true do
							if not HasProperty("Musician","KissMe") or HasProperty("Musician","Moving") or HasProperty("Musician","MusicStage") then
								RemoveProperty("","KissMeHoney")
								SatisfyNeed("", 2, 0.2)
								IncrementXP("", 15)
								break
							end
							if Rand(100)<5 then
								local AnimTime = PlayAnimationNoWait("","giggle")
								Sleep(1)
								MsgSay("",GetName("Musician"))
								Sleep(AnimTime)
							else
								Sleep(2+Rand(5))
							end
						end
						
					end
				else
					RemoveProperty("","KissMeHoney")
					RemoveProperty("Musician","KissMe")
				end
			else
				RemoveProperty("","KissMeHoney")
			end
		else
			RemoveProperty("","KissMeHoney")
		end
	end
end

-- -----------------------
-- RepairHome
-- -----------------------
function RepairHome(Building)
	if not AliasExists(Building) then
		return
	end

	MsgDebugMeasure("Buying Buildmaterial at the Market")
	if not GetSettlement("", "City") then
		return
	end
	local Market = Rand(5)+1
	if not CityGetRandomBuilding("City", 5,14,Market,-1, FILTER_IGNORE, "Destination") then
		return
	end
	if not f_MoveTo("","Destination",GL_WALKSPEED_RUN, 200) then
		return
	end
	GetOutdoorMovePosition("",Building,"WorkPos2")
	if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID(Building) then
	
		if Rand(100)<50 then
			Transfer(nil,nil,INVENTORY_STD,"Destination",INVENTORY_STD,"BuildMaterial",1)
		else
			Transfer(nil,nil,INVENTORY_STD,"Destination",INVENTORY_STD,"Tool",1)
		end
		
		MoveSetActivity("","carry")
		Sleep(2)
		CarryObject("","Handheld_Device/ANIM_holzscheite.nif",false)

		if not f_MoveTo("", "WorkPos2",GL_WALKSPEED_RUN, 200) then
			return
		end
		MoveSetActivity("","")
		Sleep(2)
		CarryObject("","",false)
	end
	MsgDebugMeasure("Repairing My Home")
	if not GetFreeLocatorByName(Building,"bomb",1,3,"WorkPos",true) then
		return
	end
	
	if not f_BeginUseLocator("","WorkPos",GL_STANCE_STAND,true) then
		if not f_MoveTo("","WorkPos2") then
			return
		end
	end
	AlignTo("",Building)
	Sleep(0.7)
	SetContext("","rangerhut")
	CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	PlayAnimation("","chop_in")
	local RepairPerTick = GetMaxHP(Building)/400
	for i=0,20 do
		PlayAnimation("","chop_loop")
		ModifyHP(Building,RepairPerTick,false)
	end
	f_EndUseLocator("","WorkPos",GL_STANCE_STAND)
	PlayAnimation("","chop_out")
	CarryObject("","",false)
		
	
end

-- -----------------------
-- MyrmidonIdle
-- -----------------------
function MyrmidonIdle(Workbuilding)
	SimGetWorkingPlace("", "WorkingPlace")
	if GetFreeLocatorByName("WorkingPlace", "backroom_sit_",1,3, "ChairPos") then
		if not f_BeginUseLocator("", "ChairPos", GL_STANCE_SIT, true) then
			RemoveAlias("ChairPos")
			return
		end
		while true do
			local WhatToDo2 = Rand(4)
			if WhatToDo2 == 0 then
				Sleep(10) 
			elseif WhatToDo2 == 1 then
				Sleep(Rand(20)+4)
			elseif WhatToDo2 == 2 then
				PlayAnimation("","sit_talk")
			else
				PlayAnimation("","sit_laugh")					
			end
			Sleep(1)
		end
	end
	Sleep(3)
end

-- -----------------------
-- VisitDoc
-- -----------------------
function VisitDoc(HospitalID)
	if gameplayformulas_CheckMoneyForTreatment("")==0 then
		if GetInsideBuilding("","CurrentBuilding") then
			if BuildingGetType("CurrentBuilding") == GL_BUILDING_TYPE_HOSPITAL then
				f_ExitCurrentBuilding("")
			end
		end
		return
	end

	if GetInsideBuilding("","CurrentBuilding") then
		if BuildingGetType("CurrentBuilding") == GL_BUILDING_TYPE_HOSPITAL then
			if HasProperty("","WaitingForTreatment") then
				return
			end
		end
		GetSettlement("CurrentBuilding","City")

	elseif not GetNearestSettlement("", "City") then
		return
	end
	
	if HospitalID then
		GetAliasByID(HospitalID,"Destination")
	else
		RemoveAlias("Destination")
	end
	
	local MinLevel = 1
	
	if GetImpactValue("", "Influenza") > 0 or GetImpactValue("", "Pox") > 0 or GetImpactValue("", "BurnWound") > 0  then
		MinLevel = 2
	elseif GetImpactValue("", "Pneumonia") > 0 or GetImpactValue("", "Blackdeath") > 0 or GetImpactValue("", "Caries") > 0 or GetImpactValue("", "Fracture") > 0 then
		MinLevel = 3
	end

	if not AliasExists("Destination") then	
		economy_GetRandomBuildingByRanking("City", "Destination", 0, GL_BUILDING_TYPE_HOSPITAL)
		if not AliasExists("Destination") then
			return
		end
		
		local IgnoreID
		if HasProperty("", "IgnoreHospital") then
			local Time = GetProperty("", "IgnoreHospitalTime")
			if Time < GetGametime() then
				RemoveProperty("", "IgnoreHospital")
				RemoveProperty("", "IgnoreHospitalTime")
			else
				IgnoreID = GetProperty("", "IgnoreHospital")
			end
		end 
		
		if IgnoreID and IgnoreID == GetID("Destination") then
			-- go home and sleep
			if GetHomeBuilding("", "HomeBuilding") and GetFreeLocatorByName("HomeBuilding", "Bed",1,3, "SleepPosition") then
				MeasureRun("",nil,"GoToSleep")
				return
			else
				return
			end
		end
	end
		
	if not f_MoveTo("","Destination", GL_MOVESPEED_RUN) then
		return
	end
	--go home if there are too many sick sims
	if not DynastyIsPlayer("") then
		local SickSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000) AND (Object.Property.WaitingForTreatment==1))"
		local NumSickSims = Find("", SickSimFilter,"SickSim", -1)
		if NumSickSims > 10 then
			f_ExitCurrentBuilding("")
			return
		end
	end
		
	if GetFreeLocatorByName("Destination", "bench",1,6, "BenchPos") then
		f_BeginUseLocator("","BenchPos",GL_STANCE_SITBENCH,true)
	end
		
	if ((GetImpactValue("","Sickness")>0) or (GetHP("") < GetMaxHP(""))) then
		RemoveOverheadSymbols("")
			
		SetProperty("","WaitingForTreatment",1)
		
		-- Send a message if no healer is working right now
		if BuildingGetOwner("Destination", "MasterDoc") and DynastyIsPlayer("MasterDoc") then
			if BuildingGetProducerCount("Destination", PT_MEASURE, "MedicalTreatment") == 0 then
				if GetImpactValue("MasterDoc", "SuppressMedicalMessage")==0 then
					MsgNewsNoWait("MasterDoc", "Destination", "", "building", -1,
								"@L_IDLE_VISITDOC_NODOC_HEAD", "@L_IDLE_VISITDOC_NODOC_BODY",GetID(""),
								GetID("Destination"))
					AddImpact("MasterDoc", "SuppressMedicalMessage", 1, 1)
				end
			end
		end
		
		local Waittime = GetGametime() + 6
		while GetGametime()<Waittime do
			if HasProperty("", "StartTreat") then
				Sleep(25)
			else
				Sleep(Rand(10)+1*5)
				if AliasExists("BenchPos") then
					if (LocatorGetBlocker("BenchPos") ~= GetID("")) then
						if GetFreeLocatorByName("Destination", "bench",1,6, "BenchPos") then
							f_BeginUseLocator("","BenchPos",GL_STANCE_SITBENCH,true)
						end
					end
				else
					if GetFreeLocatorByName("Destination", "bench",1,6, "BenchPos") then
						f_BeginUseLocator("","BenchPos",GL_STANCE_SITBENCH,true)
					end
				end
			end
		end
			
		if HasProperty("","WaitingForTreatment") then
			RemoveProperty("","WaitingForTreatment")
		end
	end
		
	--go home if you were not treated
	if not DynastyIsPlayer("") then
		f_ExitCurrentBuilding("")
		idlelib_GoToRandomPosition()
		return
	end
end

-- -----------------------
-- ChangeReligion
-- -----------------------
function ChangeReligion(FinalReligion)
	MsgDebugMeasure("Changing my religion")
	if not AliasExists("MyCity") then
		AddImpact("","WasInChurch",1,4)
		return
	end
	local ChurchType = 19
	if FinalReligion == RELIGION_CATHOLIC then
		ChurchType = 20
	end
	if not CityGetRandomBuilding("MyCity",-1,ChurchType,2,-1,FILTER_IGNORE,"Church") then
		AddImpact("","WasInChurch",1,4)
		return
	end
	if not f_MoveTo("","Church", GL_MOVESPEED_RUN) then
		AddImpact("","WasInChurch",1,4)
		return
	end
	MeasureRun("","Church","ChangeFaith",true)
	return
	
end

-- -----------------------
-- GoToDivehouse
-- -----------------------
function GoToDivehouse()
	local DistanceBest = -1
	local Attractivity
	local Distance
	
	MsgDebugMeasure("Have some drink in a Divehouse")
	if GetSettlement("", "City") then

		local stage = GetData("#MusicStage")
		if stage~=nil and GetAliasByID(stage,"stageobj") then
			BuildingGetCity("stageobj","stageCity")
			if GetID("City")==GetID("stageCity") and (Rand(100)>39) then
				if BuildingGetType("stageobj")==GL_BUILDING_TYPE_TAVERN then
					idlelib_GoToTavern(8)
					return
				end
			end
		end
		
		local IgnoreID
	
		if HasProperty("","IgnoreDivehouse") then
			IgnoreID = GetProperty("","IgnoreDivehouse")
		end

		local NumTaverns = CityGetBuildings("City",2,36,-1,-1,FILTER_HAS_DYNASTY,"Divehouse")
		if NumTaverns > 0 then
			
			for i=0,NumTaverns-1 do
				if not IgnoreID or (IgnoreID and IgnoreID ~= GetID("Divehouse")) then
					Attractivity	= GetImpactValue("Divehouse"..i,"Attractivity")

					if HasProperty("Divehouse"..i,"Versengold") then
						Attractivity = Attractivity + 1.5
					end

					Distance = GetDistance("","Divehouse"..i)
					
					if Distance == -1 then
						Distance = 50000
					end
					
					Distance = Distance / (0.5 + Attractivity)
					if DistanceBest==-1 or Distance<DistanceBest then
						CopyAlias("Divehouse"..i,"Destination")
						DistanceBest = Distance
					end
				end
			end
		end

		if DistanceBest==-1 then
			-- not exist Divehouse
			SatisfyNeed("", 8, 0.5)
			SatisfyNeed("", 2, 0.5)
			return
		end
		
		-- Don't move there if it is too far
		if GetDistance("","Destination")>15000 then
			SetProperty("", "IgnoreDivehouse", GetID("Destination"))
			Sleep(2+Rand(4))
			SatisfyNeed("", 8, 0.25)
			return
		end
		
		if not f_MoveTo("","Destination", GL_MOVESPEED_RUN) then
			return
		end

		if GetState("Destination",STATE_BUILDING) then
			return
		end

		if Rand(5)==0 then
			if HasProperty("Destination","Versengold") then
				MeasureRun("", nil, "CheerMusicians")
				return
			else
				idlelib_KissMeHonza()
				return
			end
		end
				
		local lokalPos = 0
		
		if HasProperty("", "IgnoreDivehouse") then
			RemoveProperty("", "IgnoreDivehouse")
		end
		
		if Rand(3) == 0 then
			if GetFreeLocatorByName("Destination","Bar",1,4,"StehPos") then
				f_BeginUseLocator("","StehPos",GL_STANCE_STAND,true)
				lokalPos = 1
			else
				if GetFreeLocatorByName("Destination","appeal",1,4,"StehPos") then
					f_BeginUseLocator("","StehPos",GL_STANCE_STAND,true)
					lokalPos = 1
				else
					local posPlatz = Rand(3)
					if posPlatz == 0 then
						GetFreeLocatorByName("Destination","Sit",1,4,"SitPos")
					elseif posPlatz == 1 then
						GetFreeLocatorByName("Destination","Sit",5,7,"SitPos")
					else
						GetFreeLocatorByName("Destination","Sit",8,11,"SitPos")
					end
					if not AliasExists("SitPos") or not f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
						-- full
						SetProperty("", "IgnoreDivehouse", GetID("Destination"))
						f_ExitCurrentBuilding("")
						idlelib_GoToDivehouse()
						return
					end
				end
			end
		else
			local posPlatz = Rand(3)
			if posPlatz == 0 then
				if not GetFreeLocatorByName("Destination","Sit",1,4,"SitPos") then
					SetProperty("", "IgnoreDivehouse", GetID("Destination"))
					f_ExitCurrentBuilding("")
					idlelib_GoToDivehouse()
					return
				end
			else
				if not GetFreeLocatorByName("Destination","Sit",5,7,"SitPos") then
					SetProperty("", "IgnoreDivehouse", GetID("Destination"))
					f_ExitCurrentBuilding("")
					idlelib_GoToDivehouse()
					return
				end
				
				if not f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
					SetProperty("", "IgnoreDivehouse", GetID("Destination"))
					f_ExitCurrentBuilding("")
					idlelib_GoToDivehouse()
					return
				end
			end			
		end
		
		local Hour = math.mod(GetGametime(), 24)
		local verweile = 0
		local basicvalue = 1

		if 6 < Hour and Hour < 20 then
			verweile = Rand(2)+3
		else
		  verweile = Rand(4)+4
		end
		if HasProperty("Destination","DanceShow") then
		  verweile = verweile + 3
		end
		if HasProperty("Destination","ServiceActive") then
		  verweile = verweile + 2
		end
		if HasProperty("Destination","Versengold") then
			basicvalue = basicvalue + 1
			verweile = verweile + 3
		end

	    local simstand = math.max(1, SimGetRank(""))
	    local grundBetrag = simstand * 5
	
		if HasProperty("Destination","ServiceActive") then
			grundBetrag = grundBetrag + Rand(simstand*5)
		end
		
		if HasProperty("Destination","Versengold") then
			grundBetrag = grundBetrag + 15
		end
		
		while verweile > 0 do

			if HasProperty("Destination","Versengold") and Rand(10)>7 then
				if lokalPos == 0 then
					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
				else
					f_EndUseLocator("","StandPos",GL_STANCE_STAND)
				end
				MeasureRun("", nil, "CheerMusicians")
			end
		
			local AnimTime
			local AnimType = Rand(4)
			if AnimType == 0 then
		    if lokalPos == 0 then
			    AnimTime = PlayAnimationNoWait("","sit_drink")
			    Sleep(1)
			    CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				else
			    AnimTime = PlayAnimationNoWait("","use_potion_standing")
			    Sleep(1)
			    CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				end
				CreditMoney("Destination",grundBetrag,"Offering")
				economy_UpdateBalance("Destination", "Service", grundBetrag)
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject("","",false)
				PlaySound3DVariation("","CharacterFX/nasty",1)
				Sleep(1.5)
			elseif AnimType == 1 then
		    if lokalPos == 0 then
			    PlayAnimation("","sit_talk")
				else
			    PlayAnimation("","talk")
				end
			elseif AnimType == 2 then
		    if lokalPos == 0 then
			    AnimTime = PlayAnimationNoWait("","sit_cheer")
			    Sleep(1)
			    PlaySound3D("","Locations/tavern/cheers_01.wav",1)
			    CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				else
			    AnimTime = PlayAnimationNoWait("","cheer_01")
			    Sleep(1)
			    PlaySound3D("","Locations/tavern/cheers_01.wav",1)
			    CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				end
				CreditMoney("Destination",grundBetrag,"Offering")
				economy_UpdateBalance("Destination", "Service", grundBetrag)
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject("","",false)
				Sleep(1.5)
			elseif AnimType == 3 then
		    if lokalPos == 0 then
			    PlayAnimationNoWait("","sit_laugh")
				else
			    PlayAnimationNoWait("","laud_02")
				end
				Sleep(2)
				if Rand(2)==0 then
					PlaySound3D("","Locations/tavern/laugh_01.wav",1)
				else
					PlaySound3D("","Locations/tavern/laugh_02.wav",1)
				end
				Sleep(2)
			end
			SatisfyNeed("", 8, 0.1)
			
--			if SimGetNeed("", 8) > 0.2 then
				local NumItems = Rand(2)+1
				if HasProperty("Destination","DanceShow") then
					NumItems = Rand(3)+2
				end
				local	Items = { "SmallBeer", "WheatBeer", "PiratenGrog", "Schadelbrand" }
				local Choice = Items[Rand(4)+1]	
				local Success = false
				local TavernAttractivity = GetImpactValue("Destination", "Attractivity")	
				local Value = math.floor((ItemGetBasePrice(Choice)*(0.9+(TavernAttractivity)/2)+Rand((5*SimGetRank(""))))*NumItems)
				local SpecialValue = math.floor((40*(0.9+(TavernAttractivity)/2)+Rand((5*SimGetRank(""))))*NumItems)
				
				if HasProperty("Destination","ServiceActive") then
					Value = Value*1.5
					SpecialValue = SpecialValue*1.5
				end
				
				local ItemId = ItemGetID(Choice)
				local ItemCount = economy_BuyItems("Destination", "", ItemId, NumItems)
				
				if ItemCount > 0 then
					-- special prices for grog and rum
					if Choice == "PiratenGrog" then
						Value = SpecialValue
					elseif Choice == "Schadelbrand" then
						Value = SpecialValue * 2 
					end
					CreditMoney("Destination", Value, "WaresSold")
					economy_UpdateBalance("Destination", "Salescounter", Value)
				end
--			end
			verweile = verweile - 1
		end
		if lokalPos == 0 then
		    f_EndUseLocator("","SitPos",GL_STANCE_STAND)
		else
		    f_EndUseLocator("","StandPos",GL_STANCE_STAND)
		end
		
		local Hour = math.mod(GetGametime(), 24)
		if Hour > 21 or Hour < 4 then
			if Rand(100) > 70 then
				AddImpact("","totallydrunk",1,8)
				AddImpact("","MoveSpeed",0.7,6)
				SetState("",STATE_TOTALLYDRUNK,true)
				StopMeasure()
			end
		end
	end
end

-- -----------------------
-- TakeACredit
-- -----------------------
function TakeACredit()
	MsgDebugMeasure("Visit the bank and do financial stuff")
	
	if not GetSettlement("", "City") then
		return
	end
	
	economy_GetRandomBuildingByRanking("City", "Destination", 0, GL_BUILDING_TYPE_BANKHOUSE)
	
	if not AliasExists("Destination") then
		-- no bank found
		SatisfyNeed("", 9, 1)
		return
	end
	
	if not BuildingGetOwner("Destination","MyBoss") then
		return
	end
		
	if AliasExists("Destination") then
		
		GetLocatorByName("Destination", "exit1", "MoveTo")
	
		if not f_MoveTo("","MoveTo") then
			return
		end
		
		if not GetFreeLocatorByName("Destination","wait",1,2,"SitPos") then
			-- all full, buy something at the market to satisfy the need or look for a new Bank
			SetProperty("","IgnoreBank",GetID("Destination"))
			if Rand(3) == 0 then
				idlelib_BuySomethingAtTheMarket(9)
				return
			else
				idlelib_TakeACredit()
				return
			end
		end
		
		-- remove ignore prop
		if HasProperty("","IgnoreBank") then
			RemoveProperty("","IgnoreBank")
		end
		
		if AliasExists("SitPos") then
			if (LocatorGetBlocker("SitPos") ~= GetID("")) then
				if GetFreeLocatorByName("Destination","wait",1,2,"SitPos") then
					f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true)
				end
			end
		else
			if GetFreeLocatorByName("Destination","wait",1,2,"SitPos") then
				f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true)
			else
				SetProperty("", "IgnoreBank", GetID("Destination"))
				return
			end
		end
		
		SetProperty("", "WaitForCredit", 1)
		local WaitTime = GetGametime() + 3
		while GetGametime()<WaitTime do
			Sleep(5)
		end
			
		-- wait is over, stand up
		f_EndUseLocator("","SitPos",GL_STANCE_STAND)
			
		if HasProperty("", "WaitForCredit") then
			RemoveProperty("", "WaitForCredit")
		end
		
		f_ExitCurrentBuilding("")
	end
	Sleep(2)
end

-- -----------------------
-- BeADrunkChamp
-- -----------------------
function BeADrunkChamp()

	if GetSettlement("", "City") then
		if CityGetRandomBuilding("City", 2,36,-1,-1, FILTER_HAS_DYNASTY, "Destination") then
			if f_MoveTo("","Destination") then
			    if not GetFreeLocatorByName("Destination","Bar",1,4,"StehPos") then
				    f_Stroll("",300,10)
				    return
			    end
			    if not f_BeginUseLocator("","StehPos",GL_STANCE_STAND,true) then
				    return
				else
	        		Sleep(1)
				    local dowas = PlayAnimationNoWait("","clink_glasses")
				    Sleep(1)
				    CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				    Sleep(dowas-2)
					if SimGetGender("") == 1 then
						PlaySound3DVariation("","CharacterFX/male_belch",1)
					else
						PlaySound3DVariation("","CharacterFX/female_belch",1)
					end
				    CarryObject("","",false)
				    local tip = Rand(90)+10
					CreditMoney("Destination", tip, "tip")
					economy_UpdateBalance("Destination", "Service", tip)
					local newwinner = GetName("")
					if HasProperty("Destination","BestDrunkPlayer") then
					    local altpoint = GetProperty("Destination","BestDrunkPoints")
						if altpoint > 90 then
							return
						else
							RemoveProperty("Destination","BestDrunkPlayer")
							RemoveProperty("Destination","BestDrunkPoints")
						    local bonus = {2,5,10}
						    local newpoints = altpoint + bonus[Rand(3)+1]
							SetProperty("Destination","BestDrunkPlayer",newwinner)
							SetProperty("Destination","BestDrunkPoints",newpoints)
						end
					else
						local bonus = {10,30,50}
						local newpoints = bonus[Rand(3)+1]
			          	SetProperty("Destination","BestDrunkPlayer",newwinner)
				        SetProperty("Destination","BestDrunkPoints",newpoints)
		          	end
					f_EndUseLocator("","StandPos",GL_STANCE_STAND)
				end
			end			
		end
	end
end

-- -----------------------
-- BeADiceChamp
-- -----------------------
function BeADiceChamp()

	if GetSettlement("", "City") then
		if CityGetRandomBuilding("City", 2,36,-1,-1, FILTER_HAS_DYNASTY, "Destination") then
			if f_MoveTo("","Destination") then
				-- get the position
				if not GetFreeLocatorByName("Destination","DiceCEO",-1,-1,"StandPos") then
					f_Stroll("",300,10)
					return
				end
				
				if not f_BeginUseLocator("Owner","StandPos",GL_STANCE_STAND,true) then
					return
				end
				
				Sleep(1)
				PlaySound3D("","measures/shake_dices/shake_dices+0.wav", 1.0)
				local wfallen = PlayAnimationNoWait("","manipulate_middle_low_r")
				Sleep(wfallen-1)
				PlaySound3D("","measures/throw_dices/throw_dices+0.wav", 1.0)
				
				local tip = Rand(20)+5
				CreditMoney("Destination", tip, "tip")
				economy_UpdateBalance("Destination", "Service", tip)
				local newwinner = GetName("")
				local bonus
				
				if HasProperty("Destination","BestDicePlayer") then
					local OldRecord = GetProperty("Destination","BestDicePott")
					bonus = { 2, 5, 10 }
					local neuPott = OldRecord + ((OldRecord / 100) * bonus[Rand(3)+1])
					if neuPott >40000 then
						neuPott = 40000
					end
					RemoveProperty("Destination","BestDicePlayer")
					RemoveProperty("Destination","BestDicePott")

					SetProperty("Destination","BestDicePlayer",newwinner)
					SetProperty("Destination","BestDicePott",neuPott)
				else
					bonus = {50,300,700}
					local newpoints = Rand(300) + bonus[Rand(3)+1]
					SetProperty("Destination","BestDicePlayer",newwinner)
					SetProperty("Destination","BestDicePott",newpoints)
				end
				f_EndUseLocator("","StandPos",GL_STANCE_STAND)
			end
		end			
	end
end

-- -----------------------
-- LeibwacheIdle
-- -----------------------
function LeibwacheIdle(Workbuilding)
	SimGetWorkingPlace("", "WorkingPlace")
	while true do
	  if Rand(2) == 0 then
	    if GetFreeLocatorByName("WorkingPlace", "GuardPos",1,4, "WachPos") then
		    if not f_BeginUseLocator("", "WachPos", GL_STANCE_STAND, true) then
			    RemoveAlias("WachPos")
			  	return
		    end
			  if Rand(2) == 0 then
					Sleep(10) 
			  else
					PlayAnimationNoWait("","sentinel_idle")
			  end
			else
				f_Stroll("",300,10)
			end
		else	
	    if GetFreeLocatorByName("WorkingPlace", "Walledge",1,4, "WachPos") then
		  	if not f_BeginUseLocator("", "WachPos", GL_STANCE_STAND, true) then
			  	RemoveAlias("WachPos")
			    return
		    end
			  local WhatToDo2 = Rand(3)
			  if WhatToDo2 == 0 then
					Sleep(10) 
			  elseif WhatToDo2 == 1 then
				  PlayAnimationNoWait("","sentinel_idle")
			  else
				  CarryObject("","",false)
		      CarryObject("","Handheld_Device/ANIM_telescope.nif",false)
		      PlayAnimation("","scout_object")
		      CarryObject("","",false)					
			  end
			else
			  f_Stroll("",300,10)
		  end
    end
    Sleep(3)
		f_EndUseLocator("", "WachPos", GL_STANCE_STAND)
	end

end

-- -----------------------
-- DinnerAtEstate
-- -----------------------
function DinnerAtEstate()

	if DynastyGetRandomBuilding("",8,111,"Schlossie") then
	  if not GetState("Schlossie",STATE_BURNING) and not GetState("Schlossie",STATE_FIGHTING) then
	    if f_MoveTo("","Schlossie", GL_MOVESPEED_RUN) then
        if GetFreeLocatorByName("Schlossie", "Sit",2,12, "DoDinner") then
          if not f_BeginUseLocator("", "DoDinner", GL_STANCE_SIT, true) then
            RemoveAlias("DoDinner")
            return
          end
					local duration = Rand(2)+1
          local CurrentTime = GetGametime()
          local EndTime = CurrentTime + duration
					local AnimTime, dinner
          local CurrentHP = GetHP("")
          local MaxHP = GetMaxHP("")
          local ToHeal = MaxHP - CurrentHP
          local HealPerTic = ToHeal / (duration * 12)	
					while GetGametime()<EndTime do
					  dinner = Rand(4)
						if dinner == 0 then
		          AnimTime = PlayAnimationNoWait("","sit_drink")
		          Sleep(1)
		          CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
		          Sleep(1)
		          PlaySound3DVariation("","CharacterFX/drinking",1)
		          Sleep(AnimTime-1.5)
		          CarryObject("","",false)
		          if SimGetGender("")==GL_GENDER_MALE then
		            PlaySound3DVariation("","CharacterFX/male_belch",1)
		          else
		            PlaySound3DVariation("","CharacterFX/female_belch",1)
		          end
		          SatisfyNeed("", 8, 0.2)
		          Sleep(1.5)
			      elseif dinner == 1 then
							if Rand(2) == 0 then
		            PlayAnimation("","sit_eat")
		            SatisfyNeed("", 1, 0.2)
							else
						    PlayAnimation("","sit_talk")
							end
	          elseif dinner == 2 then			
	            AnimTime = PlayAnimationNoWait("","sit_cheer")
	            Sleep(1)
	            PlaySound3D("","Locations/tavern/cheers_01.wav",1)
	            CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
	            Sleep(1)
	            PlaySound3DVariation("","CharacterFX/drinking",1)
	            Sleep(AnimTime-1.5)
	            CarryObject("","",false)
	            Sleep(1.5)
	          else
	            PlayAnimationNoWait("","sit_laugh")
	            Sleep(2)
	            if Rand(2)==0 then
		            PlaySound3D("","Locations/tavern/laugh_01.wav",1)
	            else
		            PlaySound3D("","Locations/tavern/laugh_02.wav",1)
	            end
	            Sleep(5)					
				    end
						
					  if GetHP("") < MaxHP then
				    	ModifyHP("", HealPerTic,false)
		        end
					end
					f_EndUseLocator("", "DoDinner", GL_STANCE_STAND)
		    end
		  end
		end
	end
	Sleep(2)

end

-- -----------------------
-- BuySomeCoin
-- -----------------------
function BuySomeCoin(SplitNumber)
	local bankID=GetID("CurrentBuilding")
	GetAliasByID(bankID,"Destination")
	if BuildingGetOwner("Destination","Glaubiger") then
		local zinsA = GetSkillValue("Glaubiger",BARGAINING)
		local percent = 50 + (zinsA * 3)
		if Rand(100) < percent then
			-- Fajeth Mod new items
			local Items = { "Siegelring", "Urkunde", "Schuldenbrief" }
			local Choice
			local schuldner = SimGetRank("")
			local lrand = Rand(100)
			if schuldner <= 1 then
				Choice=1
			elseif schuldner == 2 then
				if lrand > 75 then
					Choice=2
				else
					Choice=1
				end
			elseif schuldner == 3 then
				if lrand > 85 then
					Choice=3
				elseif lrand > 30 and lrand < 84 then
					Choice=2
				else
					Choice=1
				end
			elseif schuldner == 4 then
				if lrand > 85 then
					Choice=2
				elseif  lrand > 30 and lrand < 84 then
					Choice=3
				else
					Choice=1
				end
			else
				if lrand > 25 then
					Choice=3
				else
					Choice=2
				end
			end
			Choice=Items[Choice]
			if GetItemCount("Destination", Choice, INVENTORY_STD)>0 then
				CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
				local playTime = PlayAnimationNoWait("","use_object_standing")
				local prodNam = ItemGetLabel(Choice,true)
				if Rand(2) == 0 then
					MsgSay("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
				else
					MsgSayNoWait("","@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
				end
					PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
	
				if BuildingGetOwner("Destination","Glaubiger") then
					RemoveItems("Destination",Choice,1,INVENTORY_STD)
					local bonus = (GetSkillValue("Glaubiger", BARGAINING)/10)*ItemGetBasePrice(Choice)+ItemGetBasePrice(Choice)
					Sleep(0.5)
					CreditMoney("Destination",bonus,"tip")
					economy_UpdateBalance("Destination", "Service", bonus)
					-- Fajeth Mod more Favor def 1
					chr_ModifyFavor("","Glaubiger",5)					
				end
				Sleep(playTime-1)
			else
				if SplitNumber then
					return "c"
				else
					if BuildingGetOwner("Destination","Glaubiger") then
						chr_ModifyFavor("","Glaubiger",-5)-- def 1					
					end
					SetProperty("", "IgnoreBank", "Destination")
					SetProperty("", "IgnoreBankTime", GetGametime()+36)
				end
			end
		end
	end

	SatisfyNeed("", 9, 1)
end
