function Run()

	MeasureSetNotRestartable()
	
	if not SquadGet("", "Squad") then
		return
	end
	
	if not SquadGetMeetingPlace("Squad", "Destination") then
		return
	end
	
	-- get the robber camp
	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_ROBBER, "MyRobbercamp") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("", GL_BUILDING_CLASS_WORKSHOP, GL_BUILDING_TYPE_ROBBER)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding, "MyRobbercamp")
		else
			return
		end
	end
		
	local	ToDo
	local	Success
	SetData("Tarnung", 0)
	
	while true do
		
		ToDo = ms_squadwaylaymember_WhatToDo()
		Success = false
		
		if HasProperty("","Plunder") then
			local victim = GetProperty("","Plunder")
			GetAliasByID(victim,"Victim")
			if AliasExists("Victim") then
				ToDo = "plunder"
			end
		end
		
		if ToDo == "return" then
			Success = ms_squadwaylaymember_ReturnToBase()
		elseif ToDo == "wait" then
			Success = ms_squadwaylaymember_Wait()
		elseif ToDo == "attack" then
			Success = ms_squadwaylaymember_Attack()
		elseif ToDo == "plunder" then
			Success = ms_squadwaylaymember_Plunder()
		elseif ToDo == "rest" then
			Success = ms_squadwaylaymember_Rest()
		end
		
		if not Success then
			Sleep(4)
		end
	end
end

function Wait()

	SetState("", STATE_ROBBERMEASURE, true)

	if HasProperty("Squad", "PrimaryTarget") then
		RemoveProperty("Squad", "PrimaryTarget")
	end
		
	-- normal wait behavior
	local	Distance = GetDistance("", "Destination")
	if Distance > 1000 then
		local Range = Rand(400)
		if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN, Range) then
			if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN) then
				return
			end
		end		
	end
	
	-- spawn the bush
	if GetData("Tarnung") == 0 then
		Sleep(1.5)
		PlayAnimation("","crouch_down")
		GetPosition("","standPos")
		if Rand(2) == 0 then
			GfxAttachObject("tarn","Outdoor/Bushes/bush_09_big.nif")
		else
			GfxAttachObject("tarn","Outdoor/Bushes/bush_10_big.nif")
		end
		GfxSetPositionTo("tarn","standPos")
		SetData("Tarnung",1)
	end
	
	PlayAnimationNoWait("","crouch_down")	
	SetState("", STATE_HIDDEN, true)
	ms_squadwaylaymember_IdleStuff()
	SetProperty("", "WaylayReady", 1)
	Sleep(1 + Rand(20)*0.1)
	RemoveProperty("", "WaylayReady")
end

function IdleStuff()
	if Rand(3) == 0 then
		PlayAnimationNoWait("", "sentinel_idle")
	elseif Rand(3) == 1 then
		CarryObject("", "Handheld_Device/ANIM_telescope.nif", false)
		PlayAnimation("", "scout_object")
		CarryObject("", "", false)
	end
	GfxSetRotation("", 0, Rand(360), 0, false)
	Sleep(1)
end

function WhatToDo()
	
	-- Check the inventory for stuff
	local Items = 0
	local Count = InventoryGetSlotCount("", INVENTORY_STD)
	
	for i=0, Count-1 do
		local ItemId
		local ItemCount 
			
		ItemId, ItemCount = InventoryGetSlotInfo("", i, INVENTORY_STD)
		if ItemId and ItemCount>0 then
			Items = ItemCount
			break
		end
	end
	
	if Items > 0 then
		return "return"
	end
	
	-- Check the building's inventory to add new stuff - no need to waylay if it is full. We use a dummy item
	if not CanAddItems("MyRobbercamp", "PoisonedCake", 1, INVENTORY_STD) then
		return "wait"
	end
	
	if not HasProperty("Squad", "PrimaryTarget") then
		
		local BootyFilterCart = "__F((Object.GetObjectsByRadius(Cart) == 2500)AND NOT(Object.BelongsToMe()))"
		local NumVictimCarts = Find("", BootyFilterCart, "VictimCart", -1)
		local ToDo 
		if NumVictimCarts >0 then
			for i=0, NumVictimCarts-1 do
				if CartGetOperator("VictimCart"..i, "Operator"..i) then
					if GetState("Operator"..i, STATE_DRIVERATTACKED) then
						CopyAlias("VictimCart"..i,"Victim")
						SetProperty("Squad", "PrimaryTarget", GetID("Victim"))
						ToDo = true
						break
					end
				end
			end
		end
		
		if ToDo == true then
			return "plunder"
		end
		
		if ToDo == false and GetHPRelative("") < 0.76 then
			return "rest"
		end
	
		local Target = ms_squadwaylaymember_Scan("")
		if Target then
			return "attack"
		end
		return "wait"
	end
	
	local TargetID = GetProperty("Squad", "PrimaryTarget")
	if TargetID < 1 then
		RemoveProperty("Squad", "PrimaryTarget")
		return "wait"
	end	
	
	if not GetAliasByID(TargetID, "Victim") then
		RemoveProperty("Squad", "PrimaryTarget")
		return "wait"
	end
	
	if chr_GetBootyCount("Victim", INVENTORY_STD) <= 150 then
		if GetState("Victim", STATE_CHECKFORSPINNINGS) then
			MsgSay("", "@L_MEASURE_ROBBER_WAYLAYFORBOOTY_SCAN_NOBOOTY")
		end
		RemoveProperty("Squad", "PrimaryTarget")
		return "wait"
	end
	
	if GetState("Victim", STATE_ACTIVE_ESCORT) then
		return "attack"
	end
	
	if CartGetOperator("Victim", "Operator") then
		if not GetState("Operator", STATE_DRIVERATTACKED) then
			RemoveProperty("Squad", "PrimaryTarget")
			return "wait"
		end
	end
	
	return "plunder"
end

function ReturnToBase()
	SetState("", STATE_ROBBERMEASURE, false)
	local TransitionTime
	if GetDistance("", "MyRobbercamp") > 500 then

		TransitionTime = MoveSetActivity("", "carry")
		Sleep(2)
		CarryObject("", "Handheld_Device/ANIM_Bag.nif", false)

		Sleep(TransitionTime - 2)

		GetOutdoorMovePosition("", "MyRobbercamp", "MovePos")

		if not f_MoveTo("", "MovePos") then
			return
		end
	end

	local ItemId
	local Found
	local RemainingSpace
	local Removed
	local Booty = false
	local MessageItem
	local MessageCount

	local Count = InventoryGetSlotCount("", INVENTORY_STD)
	for i=0,Count-1 do
		ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
		if ItemId and ItemId>0 and Found>0 then
			RemainingSpace = GetRemainingInventorySpace("MyRobbercamp",ItemId)
			while Found > RemainingSpace do
				MsgQuick("MyRobbercamp","@L_GENERAL_INFORMATION_INVENTORY_INVENTORY_FULL_+1",GetID("MyRobbercamp"),ItemGetLabel(ItemId,false))
				Sleep(15)
			end
			if CanAddItems("MyRobbercamp", ItemId, Found, INVENTORY_STD) then
				Removed = RemoveItems("", ItemId, Found)
				AddItems("MyRobbercamp", ItemId, Removed)
				MessageItem = ItemId
				MessageCount = Found
				if Booty == false then
					Booty = true
				end
			end
		end
	end
	
	-- send a message to the player (only 1 message every 2 hours)
	if Booty == true and GetImpactValue("MyRobbercamp", "BootyMsg")<1 then
		local Label = ItemGetLabel(MessageItem, false)
		if Found == 1 then
			Label = ItemGetLabel(MessageItem, true)
		end
		MsgNewsNoWait("MyRobbercamp", "MyRobbercamp", "", "building", -1, "@L_ROBBER_135_WAYLAYFORBOOTY_BOOTY_HEAD_+0", "@L_ROBBER_135_WAYLAYFORBOOTY_BOOTY_BODY_+0", GetID("MyRobbercamp"), MessageCount, Label)
		AddImpact("MyRobbercamp", "BootyMsg", 1, 2)
	end
	
	TransitionTime = MoveSetActivity("", "")
	Sleep(2)
	CarryObject("", "" ,false)
	Sleep(TransitionTime - 2)
	
	-- normal wait behavior
	local	Distance = GetDistance("", "Destination")
	if Distance > 1000 then
		local Range = Rand(400)
		if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN, Range) then
			if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN) then
				return
			end
		end		
	end
	return true
end


function Attack()
	SetState("", STATE_ROBBERMEASURE, true)

	GfxDetachAllObjects()
	SetData("Tarnung", 0)
	SetState("", STATE_HIDDEN, false)
	
	SetProperty("Squad", "PrimaryTarget", GetID("Victim"))
	SetProperty("", "Plunder", GetID("Victim"))
	
	if IsType("Victim","Cart") then
		-- spawn escorts if they have any, if not, nothing will happen by setting the state true
		SetState("Victim", STATE_ACTIVE_ESCORT, true)
		if GetImpactValue("Victim", "messagesent") == 0 then
			GetPosition("Victim", "ParticleSpawnPos")
			PlaySound3D("Victim", "fire/Explosion_01.wav", 1.0)
			StartSingleShotParticle("particles/Explosion.nif", "ParticleSpawnPos", 1, 5)
			CommitAction("attackcart", "", "Victim", "Victim")
			
			AddImpact("Victim", "messagesent", 1, 3)
			feedback_MessageMilitary("Victim",
				"@L_ROBBER_135_WAYLAYFORBOOTY_VICTIM_HEAD_+0",
				"@L_ROBBER_135_WAYLAYFORBOOTY_VICTIM_BODY_+0")
		
		end
		if CartGetOperator("Victim", "Operator") then
			SetState("Operator", STATE_DRIVERATTACKED, true)
		end
		
		return true
	end
end


function Plunder()
	SetState("", STATE_ROBBERMEASURE, true)
	
	GfxDetachAllObjects()
	SetData("Tarnung", 0)
	SetState("", STATE_HIDDEN, false)
	
	if CartGetOperator("Victim", "Operator") then
		if not GetState("Operator", STATE_DRIVERATTACKED) then
			if HasProperty("Squad", "PrimaryTarget") and GetID("Victim") == GetProperty("Squad", "PrimaryTarget") then
				RemoveProperty("Squad", "PrimaryTarget")
				return
			end
		end
	end

	if not f_MoveTo("", "Victim", GL_MOVESPEED_RUN, 75) then
		return
	end

	SetProperty("","DontLeave", 1)
	StopAction("attackcart", "")
	CommitAction("plunder", "", "Victim", "Victim")
	Sleep(2)
	
	if IsType("Victim","Cart") then
		ItemValue = Plunder("", "Victim",10)
		local XPValue = math.floor(10+(ItemValue*0.1))
		chr_GainXP("", XPValue)
		if ItemValue > 0 then
			--for the mission
			mission_ScoreCrime("Dynasty", ItemValue)
		end
	end
	
	StopAction("plunder", "")
	RemoveProperty("", "DontLeave")
	RemoveProperty("", "Plunder")

	return true
end

function Scan(Member)
	SetState(Member, STATE_ROBBERMEASURE, true)
	
	-- constants
	local MinBooty = 150
	local BootyRadius = 1000
	local RobberRadius = 1000
	
	local Count
	local BootyFilterCart = "__F((Object.GetObjectsByRadius(Cart) == "..BootyRadius..")AND NOT(Object.BelongsToMe())AND NOT(Object.HasImpact(Invisible))AND(Object.ActionAdmissible()))"

	local NumVictimCarts = Find("Destination", BootyFilterCart, "VictimCart", -1)
	local NumOwnRobbers = SquadGetMemberCount("")
	local Attack = 0
	
	if NumVictimCarts <= 0 then
		return
	end

	local CurrentTargetValue = 0
	local MaxTargetValue = 0
	
	for FoundObject=0, NumVictimCarts-1 do
		if GetDynastyID(Member) ~= GetDynastyID("VictimCart"..FoundObject) and GetState("VictimCart"..FoundObject, STATE_CHECKFORSPINNINGS) then
			if DynastyGetDiplomacyState("dynasty","VictimCart"..FoundObject) < DIP_NAP then -- check diplomatic state
				if GetFavorToDynasty("VictimCart"..FoundObject, "dynasty") < 80 then -- don't attack friends 
					CurrentTargetValue = chr_GetBootyCount("VictimCart"..FoundObject, INVENTORY_STD)
					if (CurrentTargetValue >= MaxTargetValue) then
						CopyAlias("VictimCart"..FoundObject, "Victim")
						MaxTargetValue = CurrentTargetValue
					end
				else
					AlignTo(Member, "VictimCart")
					MsgSay(Member, "@L_MEASURE_ROBBER_WAYLAYFORBOOTY_SCAN_DONT_ATTACK_FRIENDS")
				end
			else
				AlignTo(Member, "VictimCart")
				MsgSay(Member, "@L_MEASURE_ROBBER_WAYLAYFORBOOTY_SCAN_DONT_ATTACK_FRIENDS")
			end
		end
	end
	
	if not AliasExists("Victim") then
		return
	end
		
	--check if booty is enough
	if MaxTargetValue < MinBooty then
	--	if Rand(4) == 0 then
			AlignTo(Member, "Victim")
			MsgSay(Member, "@L_MEASURE_ROBBER_WAYLAYFORBOOTY_SCAN_NOBOOTY")
	--	end
		return
	end
	
	--check the forces
	local Check = ai_CheckForces("", "Victim", 2000)
	if Check == false then
		AlignTo(Member, "Victim")
		MsgSay(Member, "@L_MEASURE_ROBBER_WAYLAYFORBOOTY_SCAN_DONT_ATTACK_DANGER")
		return
	end

	--start attack

	AlignTo(Member, "Victim")
	Sleep(1)
	
	return "Victim"
end

function Rest()
	
	SetState("", STATE_ROBBERMEASURE, false)
	local duration = 4
	local CurrentHP = GetHP("")
	local MaxHP = (GetMaxHP(""))*0.96
	local ToHeal = (MaxHP - CurrentHP)
	local HealPerTic = ToHeal / (duration * 12)
	local UseLocator = false

	local Offset = 50+Rand(150)
	MsgMeasure("", "@L_MEASURE_ROBBER_WAYLAYFORBOOTY_MSGMEASURE_REST_+0")
	if not f_MoveTo("","MyRobbercamp",GL_MOVESPEED_RUN,(150+Offset)) then
		return
	end
	
	local CurrentTime = GetGametime()
	local EndTime = CurrentTime + duration
	local Time = MoveSetStance("",GL_STANCE_SITGROUND)
	Sleep(Time)
	while GetGametime()<EndTime do
		Sleep(5)
		if GetHP("") < MaxHP then
			ModifyHP("", HealPerTic,false)
		else
			break
		end
	end
	MsgMeasure("","")
	Time = MoveSetStance("",GL_STANCE_STAND)
	Sleep(Time)
	return true
end

function CleanUp()
	MsgMeasure("","")
	StopAction("plunder", "")
	CarryObject("","",false)
	RemoveProperty("", "WaylayReady")
	GfxDetachAllObjects()
	SetState("", STATE_HIDDEN, false)
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

	if not GetState("",STATE_FIGHTING) then
		if HasProperty("","Plunder") then
			local victim = GetProperty("","Plunder")
			GetAliasByID(victim,"Victim")
			if AliasExists("Victim") then
				if not IsType("Victim","Sim") then
					if CartGetOperator("Victim", "Operator") then
						if GetState("Operator",STATE_DRIVERATTACKED) then
							SetState("Operator", STATE_DRIVERATTACKED, false)
						end
					end
				end
			end
			RemoveProperty("","Plunder")
		end
	end
end

