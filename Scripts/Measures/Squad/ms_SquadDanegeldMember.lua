function Run()

	Sleep(0.5)
	MeasureSetNotRestartable()
	local	Member = GetData("Member")
	if not Member or Member==-1 then
		return
	end
	
	if not SquadGet("", "Squad") then
		return
	end
	
	if not SquadGetMeetingPlace("Squad", "Destination") then
		return
	end
	
	if not SimGetWorkingPlace("","MyMercenarycamp") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_MERCENARY)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"MyMercenarycamp")
		else
			StopMeasure()
		end
	end
		
	local	ToDo
	local	Success
	local	IdleStep = 3
		
	while true do
	
		ToDo = ms_squaddanegeldmember_WhatToDo()
		Success = false
		
		if ToDo=="return" then
			Success = ms_squaddanegeldmember_Wait(IdleStep)
			IdleStep = IdleStep + 1
		elseif ToDo=="wait" then
			Success = ms_squaddanegeldmember_Wait(IdleStep)
			IdleStep = IdleStep + 1
		elseif ToDo=="Danegeld" then
			Success = ms_squaddanegeldmember_Danegeld()
		end
		
		if not Success then
			Sleep(4)
		end
		
	end
end

function Wait(IdleStep)

		if HasProperty("Squad", "PrimaryTarget") then
			RemoveProperty("Squad", "PrimaryTarget")
		end
		
		-- normal wait behavior
		local	Distance = GetDistance("", "Destination")
		if Distance > 500 then
			local Range = Rand(50)
			if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,Range) then
				return
			end		
		end
		
		if (IdleStep>2) then
			ms_squaddanegeldmember_IdleStuff()
			IdleStep = 0
		end

		Sleep(1 + Rand(20)*0.1)
end

function IdleStuff()
	if Rand(3)==0 then
		PlayAnimationNoWait("","sentinel_idle")
	elseif Rand(3)==1 then
		CarryObject("","Handheld_Device/ANIM_telescope.nif",false)
		PlayAnimation("","scout_object")
		CarryObject("","",false)
	end
	GfxSetRotation("",0,Rand(360),0,false)
end

function WhatToDo()

	if not HasProperty("Squad", "PrimaryTarget") then
		local Target = ms_squaddanegeldmember_Scan("")
		if Target then
			return "Danegeld"
		end
		return "wait"
	end
	
	local	TargetID = GetProperty("Squad", "PrimaryTarget")
	if TargetID < 1 then
		return "wait"
	end	
	
	if not GetAliasByID(TargetID, "Victim") then
		return "wait"
	end
	
--	if chr_GetBootyCount("Victim", INVENTORY_STD) <= 0 then
--		return "wait"
--	end
	
	return "wait"
end


function Danegeld()	

	local	TargetID = GetID("Victim")
	if TargetID < 1 then
		return false
	end	
	
	local money = math.floor((chr_GetBootyCount("Victim", INVENTORY_STD) / 100)*15)
	--if money <= 0 then
	--	return false
	if money < 10 then
		money = 25
	end

	local favourloss = 5

	if not SimGetWorkingPlace("","MyMercenarycamp") then
		if IsPartyMember("") then
			CopyAlias("","MercOwner")
		else
			return false
		end
	else
		BuildingGetOwner("MyMercenarycamp", "MercOwner")
	end

	if GetImpactValue("Victim","HaveBeenPickpocketed")>0 then
		return false
	end
	
	if GetHomeBuilding("Victim", "workingplace") then
		if BuildingGetOwner("workingplace", "VictimOwner") then
			
			AddImpact("Victim", "HaveBeenPickpocketed", 1, 12)
			
			if f_SpendMoney("VictimOwner", money, "CostBribes", false) then
				chr_ModifyFavor("VictimOwner","MercOwner",-favourloss)
			end

			AlignTo("", "Victim")
			PlayAnimationNoWait("", "use_object_standing")
			CarryObject("","Handheld_Device/Anim_Bag.nif",false)
			PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
			Sleep(1)	

			--money = money + (SimGetLevel("") * 10)

			f_CreditMoney("MercOwner", money, "IncomeBribes")
			economy_UpdateBalance("workingplace", "Theft", money)
			IncrementXPQuiet("",15)

			PlayAnimationNoWait("","fetch_store_obj_R")
			Sleep(1)	
			PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
			CarryObject("","",false)	
			
			PlayAnimationNoWait("","cheer_02")
			local random = Rand(5)
			if IsPartyMember("") then
				MsgSay("","@L_MEASURE_danegeld_THANKS_NO_OWNER_+"..random)
			else
				if SimGetGender("MercOwner")==GL_GENDER_MALE then
					MsgSay("","@L_MEASURE_danegeld_THANKS_OWNER_MALE_+"..random, GetID("MercOwner"))				
				else
					MsgSay("","@L_MEASURE_danegeld_THANKS_OWNER_FEMALE_+"..random, GetID("MercOwner"))				
				end
			end
			
		else
			return false
		end
	else
		return false
	end

	return true
end


function Scan(Member)
	
	-- constants
	--local MinDanegeld = 50
	local DanegeldRadius = 1000
	local MercenaryRadius = 1000
	
	local Count
	local DanegeldFilterSim = "__F((Object.GetObjectsByRadius(Sim) == "..DanegeldRadius..")AND NOT(Object.BelongsToMe())AND(Object.ActionAdmissible())AND NOT(Object.HasImpact(HaveBeenPickpocketed)))"
	local DanegeldFilterCart = "__F((Object.GetObjectsByRadius(Cart) == "..DanegeldRadius..")AND NOT(Object.BelongsToMe())AND(Object.ActionAdmissible())AND NOT(Object.HasImpact(HaveBeenPickpocketed)))"
	
	-- Danegeld on sims deactivated
	local NumVictimSims = 0 --Find("Destination",DanegeldFilterSim,"VictimSim", -1)
	local NumVictimCarts = Find("Destination",DanegeldFilterCart,"VictimCart", -1)
	local NumOwnMercenaries = SquadGetMemberCount("")
	
	if NumVictimSims <= 0 and NumVictimCarts <= 0 then
		return
	end

	local CurrentTargetValue = 0
	local MaxTargetValue = 0
	local	Num
	local	TargetAlias
	
	for check=0,1 do
		if check==0 then
			--check the Danegeld from the sims
			Num = NumVictimSims
			TargetAlias = "VictimSim"
		else
		--check the Danegeld from the carts
			Num = NumVictimCarts
			TargetAlias = "VictimCart"
		end
		
		for FoundObject=0,Num-1 do
			if DynastyGetDiplomacyState("Dynasty",TargetAlias..FoundObject)<=DIP_NEUTRAL then --no attack agreement, no booty
				CurrentTargetValue = chr_GetBootyCount(TargetAlias..FoundObject,INVENTORY_STD)
				if (CurrentTargetValue > MaxTargetValue) then
					CopyAlias(TargetAlias..FoundObject,"Victim")
					MaxTargetValue = CurrentTargetValue
				end
			end
		end
	end
		
	--check if Danegeld is enough
	--Sleep(0.7)
		
	--if MaxTargetValue < MinDanegeld then
	--	return
	--end
	
	AlignTo("","Victim")
	Sleep(1)
	
	return "Victim"
end

function CleanUp()
	RemoveProperty("", "DanegeldReady")
	StopAnimation("")
	MoveSetActivity("","")
	if not HasProperty("","DontLeave") then
		SquadRemoveMember("", true)
		if AliasExists("Squad") then
			if SquadGetMemberCount("Squad", true)<1 then
				SquadDestroy("Squad")
			end
		end
	else
		RemoveProperty("","DontLeave")
	end
end

