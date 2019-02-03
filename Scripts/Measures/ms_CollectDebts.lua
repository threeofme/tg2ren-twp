-- ms_CollectDebts.lua
-- Collect Credits from Debtors who decided not to pay back in time (bank measure)
-- By Fajeth

function Run()
	
	if not AliasExists("Destination") then
		StopMeasure()
		return
	end

	local Choice = MsgNews("","Destination","@P@B[1,@L_MEASURE_COLLECTDEBTS_BUTTON_+0,]"..
			"@B[2,@L_MEASURE_COLLECTDEBTS_BUTTON_+1,]",ms_collectdebts_AIDecide,"politics",1,
			"@L_MEASURE_COLLECTDEBTS_BUTTON_HEAD_+0",
			"@L_MEASURE_COLLECTDEBTS_BUTTON_BODY_+0",GetID("Destination"))
			
	if Choice == 2 or Choice =="C" then
		StopMeasure()
	end
	
	-- No cancel? So then let's get started
	
	if GetInsideBuilding("Destination","Inside") then
		if BuildingGetType("Inside")==1 then -- check if target is inside worker's hut 
			f_ExitCurrentBuilding("Destination")
			GetFleePosition("Destination","Inside",1000,"FleePos")
			f_MoveTo("Destination","FleePos")
		end
	end
	-- The distance between both sims to interact with each other
	local InteractionDistance=112

	if not ai_StartInteraction("", "Destination", 1000, InteractionDistance) then
		StopMeasure()
		return
	end
	
	local StolenSum = GetProperty("Destination","StolenSum")
	local Bonus = GetSkillValue("",BARGAINING)*50
	local BankID = GetProperty("Destination","CreditBank")
	GetAliasByID(BankID,"Bank")
	if not AliasExists("Bank") then
		SimGetWorkingPlace("","Bank")
	end
	BuildingGetOwner("Bank","MyBoss")
	
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","destination")
	CutsceneCameraCreate("cutscene","")
	
	SetAvoidanceGroup("", "Destination")
	MoveSetActivity("", "converse")
	MoveSetActivity("Destination", "converse")
	
	AlignTo("","Destination")
	AlignTo("Destination","")
	
	-- Start the dialog
	camera_CutscenePlayerLock("cutscene", "")
	Sleep(0.2)
	PlayAnimationNoWait("","talk_negative")
	MsgSay("","@L_MEASURE_COLLECTDEBTS_GREETINGS",GetID("Destination"))
	Sleep(0.2)
	StopAnimation("")
	camera_CutscenePlayerLock("cutscene", "Destination")
	PlayAnimationNoWait("Destination", "devotion")
	MsgSay("Destination","@L_MEASURE_COLLECTDEBTS_GREETINGS_ANSWER")
	StopAnimation("Destination")
	Sleep(0.2)
	camera_CutsceneBothLock("cutscene", "")
	PlayAnimationNoWait("","talk_negative")
	MsgSay("","@L_MEASURE_COLLECTDEBTS_ENFORCE",StolenSum,Bonus)
	Sleep(0.2)
	camera_CutscenePlayerLock("cutscene", "Destination")
	
	-- Decide whether the destination wants to pay or not
	local PayChance = Rand(10)
	if PayChance <3 then -- 30%
		PlayAnimationNoWait("Destination","nod")
		MsgSay("Destination","@L_MEASURE_COLLECTDEBTS_DESTINATION_PAYNOW")
		camera_CutsceneBothLock("cutscene", "")
		
		-- handover animation
		PlayAnimationNoWait("Destination", "use_object_standing")
		Sleep(1)
		PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
		Sleep(0.5)
		CarryObject("Destination","",false)
		CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
		PlayAnimationNoWait("","fetch_store_obj_R")
		Sleep(1.2)	
		StopAnimation("")
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)
		
		-- XP for the collector
		chr_GainXP("",25)
		local OldAccount = GetProperty("Bank","BankAccount")
		local OldSum = GetProperty("Destination","StolenSum")
		-- set the new account
		SetProperty("Bank","BankAccount",(OldAccount+StolenSum))
		-- giveout the bonus Money directly
		Sleep(0.25)
		f_CreditMoney("",Bonus,"Credit")
		economy_UpdateBalance("Bank", "Service", Bonus)
		
		-- Set the balance
		
		local BalanceReturnCount = 0
		if HasProperty("Bank","BalanceReturnCount") then
			BalanceReturnCount = GetProperty("Bank","BalanceReturnCount")
		end
		
		local BalanceReturn = 0
		if HasProperty("Bank","BalanceReturn") then
			BalanceReturn = GetProperty("Bank","BalanceReturn")
		end
		
		local BalanceReturnCollect = 0
		if HasProperty("Bank","BalanceReturnCollect") then
			BalanceReturnCollect = GetProperty("Bank","BalanceReturnCollect")
		end
		
		local OldSum = GetProperty("Destination","OldSum")
		local Plus = StolenSum-OldSum
		
		SetProperty("Bank","BalanceReturnCount",(BalanceReturnCount+1))
		SetProperty("Bank","BalanceReturn", (BalanceReturn+Plus))
		SetProperty("Bank","BalanceReturnCollect", (BalanceReturnCollect+Bonus))
		
		-- Remove destination's properties
		RemoveProperty("Destination","StolenSum")
		RemoveProperty("Destination","CreditBank")
		RemoveProperty("Destination","CreditInterest")
		RemoveProperty("Destination","OldSum")
		if HasProperty("Destination","ReturnTime") then
			RemoveProperty("Destination","ReturnTime")
		end
		local StolenCount = GetProperty("Bank","StolenCount")
		SetProperty("Bank","StolenCount",(StolenCount-1))
		
		-- in case you're a worker, send a message to the boss
		if GetID("")~=GetID("MyBoss") then
			if GetProperty("Bank","MsgCollect")==1 then
				MsgNewsNoWait("MyBoss","Destination","","building",-1,"@L_MEASURE_OfferCredit_HEAD_+1",
					"@L_MEASURE_COLLECTDEBTS_RETURNMONEY_BODY_+0",GetID("Destination"),GetID("Bank"),StolenSum,Bonus)
			end
		end
	else
		-- plz give me more time!
		MoveSetStance("Destination",GL_STANCE_KNEEL)
		MsgSay("Destination","@L_MEASURE_COLLECTDEBTS_BEG")
	
		-- Interaction,
		-- 1. give the guy more time to pay (means stolensum will be even higher next day but they might to 
		-- refuse it again),
		-- 2. leave him the money (means you gain favor but you lose the money)
		-- 3. demand the money with physical force (means you lose the favor but gain the money right now)
		-- AI will choose randomly
		local Interact = MsgSayInteraction("","","","@P@B[1,@L_MEASURE_COLLECTDEBTS_BEG_BUTTON_+0,]"..
			"@B[2,@L_MEASURE_COLLECTDEBTS_BEG_BUTTON_+1,]"..
			"@B[3,@L_MEASURE_COLLECTDEBTS_BEG_BUTTON_+2,]",
			ms_collectdebts_AIEnforce, "@L_MEASURE_COLLECTDEBTS_BEG_REACTION_+0",GetID("Destination"))
			
		if Interact == 1 then 
			StopAnimation("Destination")
			MoveSetStance("Destination",GL_STANCE_STAND)
			camera_CutscenePlayerLock("cutscene", "")
			PlayAnimationNoWait("","nod")
			MsgSay("","@L_MEASURE_COLLECTDEBTS_BEG_REACTION_WAIT")
			Sleep(0.25)
			camera_CutscenePlayerLock("cutscene", "Destination")
			PlayAnimationNoWait("Destination","laud_02")
			MsgSay("Destination","@L_MEASURE_COLLECTDEBTS_THANKS")
			Sleep(0.25)
			StopAnimation("Destination")
			camera_CutsceneBothLock("cutscene", "")
			MsgSay("","@L_MEASURE_COLLECTDEBTS_THANKS_REACTION")
			Sleep(0.25)
			
			-- Change Properties accordingly. 
			SetProperty("Destination","CreditSum",(StolenSum+Bonus))
			if HasProperty("Destination","ReturnTime") then
				local OldTime = GetProperty("Destination","ReturnTime")
				SetProperty("Destination","ReturnTime",(OldTime+12))
			else
				SetProperty("Destination","ReturnTime",36)
			end
			RemoveProperty("Destination","StolenSum")
			-- create scriptcall, hopefully he will pay it back now
			CreateScriptcall("OrderCredit_End",12,"Measures/ms_OrderCredit.lua","ReturnCredit","Destination","MyBoss")
		elseif Interact == 2 then
			StopAnimation("Destination")
			MoveSetStance("Destination",GL_STANCE_STAND)
			camera_CutscenePlayerLock("cutscene", "")
			PlayAnimationNoWait("","laud")
			MsgSay("","@L_MEASURE_COLLECTDEBTS_BEG_REACTION_GOODGUY")
			Sleep(0.25)
			StopAnimation("")
			camera_CutscenePlayerLock("cutscene", "Destination")
			PlayAnimationNoWait("Destination","cheer_01")
			MsgSay("Destination","@L_MEASURE_COLLECTDEBTS_GRATEFUL")
			StopAnimation("Destination")
			--Modify the Favor
			Sleep(0.5)
			chr_ModifyFavor("Destination","MyBoss",15)
			Sleep(0.5)
			-- get nice XP
			chr_GainXP("",50)
			-- Set the balance
		
			local BalanceReturnCount = 0
			if HasProperty("Bank","BalanceReturnCount") then
				BalanceReturnCount = GetProperty("Bank","BalanceReturnCount")
			end
			
			local BalanceReturn = 0
			if HasProperty("Bank","BalanceReturn") then
				BalanceReturn = GetProperty("Bank","BalanceReturn")
			end
			
			local BalanceReturnCollect = 0
			if HasProperty("Bank","BalanceReturnCollect") then
				BalanceReturnCollect = GetProperty("Bank","BalanceReturnCollect")
			end
			
			local OldSum = GetProperty("Destination","OldSum")
			local Plus = StolenSum-OldSum
			
			SetProperty("Bank","BalanceReturnCount",(BalanceReturnCount+1))
			SetProperty("Bank","BalanceReturn", (BalanceReturn+Plus))
			SetProperty("Bank","BalanceReturnCollect", (BalanceReturnCollect+Bonus))
			
			-- Remove destination's properties
			RemoveProperty("Destination","StolenSum")
			RemoveProperty("Destination","CreditBank")
			RemoveProperty("Destination","CreditInterest")
			RemoveProperty("Destination","OldSum")
			if HasProperty("Destination","ReturnTime") then
				RemoveProperty("Destination","ReturnTime")
			end
			local StolenCount = GetProperty("Bank","StolenCount")
			SetProperty("Bank","StolenCount",(StolenCount-1))
			
		elseif Interact == 3 or Interact == "C" then
			StopAnimation("Destination")
			MoveSetStance("Destination",GL_STANCE_STAND)
			camera_CutscenePlayerLock("cutscene", "")
			PlayAnimationNoWait("","threat")
			MsgSay("","@L_MEASURE_COLLECTDEBTS_BEG_REACTION_THREAT")
			Sleep(0.25)
			camera_CutscenePlayerLock("cutscene", "Destination")
			-- Does he have the money or not?
			if Rand(10)<7 then -- yes 66%
				PlayAnimation("Destination","devotion")
				MsgSay("Destination","@L_MEASURE_COLLECTDEBTS_GIVEITBACK")
				Sleep(0.25)
				StopAnimation("Destination")
				camera_CutsceneBothLock("cutscene", "Destination")
				-- handover animation
				PlayAnimationNoWait("Destination", "use_object_standing")
				Sleep(1)
				PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
				CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
				Sleep(0.5)
				CarryObject("Destination","",false)
				CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
				PlayAnimationNoWait("","fetch_store_obj_R")
				Sleep(1.2)	
				StopAnimation("")
				PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
				CarryObject("","",false)
				camera_CutsceneBothLock("cutscene", "")
				MsgSay("","@L_MEASURE_COLLECTDEBTS_GIVEITBACK_REACTION")
				Sleep(0.25)
				-- nice XP for the collector
				chr_GainXP("",50)
				local OldAccount = GetProperty("Bank","BankAccount")
				-- set the new account
				SetProperty("Bank","BankAccount",(OldAccount+StolenSum))
				-- giveout the bonus Money directly
				Sleep(0.5)
				f_CreditMoney("",Bonus,"Credit")
				economy_UpdateBalance("Bank", "Service", Bonus)
				
				-- Set the balance
		
				local BalanceReturnCount = 0
				if HasProperty("Bank","BalanceReturnCount") then
					BalanceReturnCount = GetProperty("Bank","BalanceReturnCount")
				end
				
				local BalanceReturn = 0
				if HasProperty("Bank","BalanceReturn") then
					BalanceReturn = GetProperty("Bank","BalanceReturn")
				end
				
				local BalanceReturnCollect = 0
				if HasProperty("Bank","BalanceReturnCollect") then
					BalanceReturnCollect = GetProperty("Bank","BalanceReturnCollect")
				end
				
				local OldSum = GetProperty("Destination","OldSum")
				local Plus = StolenSum-OldSum
				
				SetProperty("Bank","BalanceReturnCount",(BalanceReturnCount+1))
				SetProperty("Bank","BalanceReturn", (BalanceReturn+Plus))
				SetProperty("Bank","BalanceReturnCollect", (BalanceReturnCollect+Bonus))
				
				-- Remove destination's properties
				RemoveProperty("Destination","StolenSum")
				RemoveProperty("Destination","CreditBank")
				RemoveProperty("Destination","CreditInterest")
				RemoveProperty("Destination","OldSum")
				if HasProperty("Destination","ReturnTime") then
					RemoveProperty("Destination","ReturnTime")
				end
				local StolenCount = GetProperty("Bank","StolenCount")
				SetProperty("Bank","StolenCount",(StolenCount-1))
				
				-- in case you're a worker, send a message to the boss
				if GetID("")~=GetID("MyBoss") then
					if GetProperty("Bank","MsgCollect")==1 then
						MsgNewsNoWait("MyBoss","Destination","","building",-1,"@L_MEASURE_OfferCredit_HEAD_+1",
							"@L_MEASURE_COLLECTDEBTS_RETURNMONEY_BODY_+0",GetID("Destination"),GetID("Bank"),StolenSum,Bonus)
					end
				end
			else -- no
				PlayAnimationNoWait("Destination","shake_head")
				MsgSay("Destination","@L_MEASURE_COLLECTDEBTS_HAVENTENOUGH")
				Sleep(0.25)
				camera_CutsceneBothLock("cutscene", "")
				PlayAnimationNoWait("","propel")
				MsgSay("","@L_MEASURE_COLLECTDEBTS_HAVENTENOUGH_REACTION")
				PlayAnimation("","pickpocket")
				PlayAnimationNoWait("","give_a_slap")
				PlayAnimationNoWait("Destination","got_a_slap")
				-- only part of money is available
				-- for the text message
				local StolenSum = math.floor(StolenSum*(0.3+(Rand(6)/10)))+Bonus
				-- for the balance
				local StolenSum2 = StolenSum-Bonus
				camera_CutscenePlayerLock("cutscene", "")
				MsgSay("","@L_MEASURE_COLLECTDEBTS_SLAP",StolenSum)
				Sleep(0.25)
				-- nice XP for the collector
				chr_GainXP("",50)
				Sleep(0.5)
				-- giveout the whole sum in cash
				f_CreditMoney("",StolenSum,"Credit")
				-- Set the balance
		
				local BalanceReturnCount = 0
				if HasProperty("Bank","BalanceReturnCount") then
					BalanceReturnCount = GetProperty("Bank","BalanceReturnCount")
				end
				
				local BalanceReturn = 0
				if HasProperty("Bank","BalanceReturn") then
					BalanceReturn = GetProperty("Bank","BalanceReturn")
				end
				
				local BalanceReturnCollect = 0
				if HasProperty("Bank","BalanceReturnCollect") then
					BalanceReturnCollect = GetProperty("Bank","BalanceReturnCollect")
				end
				
				local OldSum = GetProperty("Destination","OldSum")
				local Plus = StolenSum2-OldSum
				
				SetProperty("Bank","BalanceReturnCount",(BalanceReturnCount+1))
				SetProperty("Bank","BalanceReturn", (BalanceReturn+Plus))
				SetProperty("Bank","BalanceReturnCollect", (BalanceReturnCollect+Bonus))
				
				-- Remove destination's properties
				RemoveProperty("Destination","StolenSum")
				RemoveProperty("Destination","CreditBank")
				RemoveProperty("Destination","CreditInterest")
				RemoveProperty("Destination","OldSum")
				if HasProperty("Destination","ReturnTime") then
					RemoveProperty("Destination","ReturnTime")
				end
				local StolenCount = GetProperty("Bank","StolenCount")
				SetProperty("Bank","StolenCount",(StolenCount-1))
			end
			Sleep(0.5)
			-- Modify the Favor
			chr_ModifyFavor("Destination","MyBoss",-10)
		end	
	end
end

function AIDecide()
	return 1
end

function AIEnforce()
	return 3
end

function CleanUp()
	DestroyCutscene("cutscene")
	
	ReleaseAvoidanceGroup("")
	MoveSetActivity("")
	StopAnimation("")
	
	if AliasExists("Destination") then
		StopAnimation("Destination")
		MoveSetActivity("Destination")
		SimLock("Destination", 0.4)
	end	
end