function Run(SimAlias, ResourceAlias, mode)

	SetData("WorkMode", mode)

	local Type = ResourceGetScriptFunc(ResourceAlias)
	if not Type then
		return false
	end

	local Function_In
	local Function_Out
	local Function_Cleanup
	local Function_Prepare = gather_GotoResource

	if Type == "Herbs" then
		Function_In = gather_Herbs_In
		Function_Out = gather_Herbs_Out
	elseif Type == "Mine" then
		Function_In = gather_Mine_In
		Function_Out = gather_Mine_Out
	elseif Type == "Harvest" then
		Function_In = gather_Harvest_In
		Function_Out = gather_Harvest_Out
	elseif Type == "Beet" then
		Function_In = gather_Beet_In
		Function_Out = gather_Beet_Out
	elseif Type == "Animal" then
		Function_In = gather_Animal_In
		Function_Out = gather_Animal_Out
	elseif Type == "Take" then
		Function_In = gather_Take_In
		Function_Out = gather_Take_Out
	elseif Type == "Lumber" then
		Function_In = gather_Lumber_In
		Function_Out = gather_Lumber_Out
	elseif Type == "well" then
		Function_In = gather_Well_In
		Function_Out = gather_Well_Out
	elseif Type == "Charcoal" then
		Function_In = gather_Charcoal_In
		Function_Out = gather_Charcoal_Out
	elseif Type == "Fungi" then
		Function_In = gather_Beet_In
		Function_Out = gather_Beet_Out
	elseif Type == "Ton" then
		Function_In = gather_Ton_In
		Function_Out = gather_Ton_Out
	elseif Type == "Fruit" then
		Function_In = gather_Fruit_In
		Function_Out = gather_Fruit_Out
	elseif Type == "Honey" then
		Function_In = gather_Honey_In
		Function_Out = gather_Honey_Out
	elseif Type == "Fishing" then
		return false
	end

	if not Function_In and not Function_Out then
		return false
	end

	local ItemID = ResourceGetItemId(ResourceAlias)
	if ItemID == -1 then
		return false
	end

	local Time = ItemGetProductionTime(ItemID)
	local Count = ItemGetProductionAmount(ItemID)
	
	-- Change the count & time for some items without changing the value
	if ItemID == 160 then -- lavender
		Count = 5
	elseif ItemID == 161 then -- blackberry
		Count = 5
		Time = 2
	elseif ItemID == 164 then -- moonflower
		Count = 5
		Time = 2
	elseif ItemID == 166 then -- swamproot
		Count = 2
	elseif ItemID == 1 then -- wheat
		Time = 2.5
	elseif ItemID == 2 then -- flachs
		Time = 2.5
	elseif ItemID == 60 then -- Fruit
		Time = 3
	elseif ItemID == 64 then -- Honey
		Time = 3
	elseif ItemID == 72 then -- Dye
		Time = 3
	elseif ItemID == 130 then -- Clay
		Time = 1
		Count = 5
	elseif ItemID == 133 then -- Granite
		Count = 2
	elseif ItemID == 151 then -- Silver
		Time = 3
	elseif ItemID == 152 then -- Gold
		Time = 4.5
	elseif ItemID == 153 then -- Gemstone
		Time = 6.5
	elseif ItemID == 154 then -- Salt
		Count = 5
	elseif ItemID == 180 then -- HolyWater
		Count = 10
		Time = 1
	end
	
	local Value = GetImpactValue("", 34) -- 34 = GatherBonus
	if Value and Value > 0 then
		Time = Time - Time * Value * 0.01
	end

	if GetSeason() == 3 then
		Time =  math.floor(Time + ((Time / 100) * 25)) -- im Winter 25% langsamer
	end
	
	if Count < 1 or Time < 1 then
		-- this should never happen - the item seems to be buggy in the database
		return false
	end

	-- get the remaining progress of the last	gather action. this happend eg. at closing time
	local Label = ItemGetLabel(ItemID, true)
	local	PropName	= "Gather_"..ItemID
	if not GetProperty(SimAlias, PropName) then
		SetProperty(SimAlias, PropName, 0)
	end
	
	local	WorkerAlias
	
	while true do

		if GetRemainingInventorySpace(SimAlias,ItemID) < Count then
	 		break
		end
		
		if Function_Prepare then
			WorkerAlias = Function_Prepare(SimAlias, ResourceAlias, Name, ItemID)
		else
			WorkerAlias = SimAlias
		end
		
		if not WorkerAlias then
			break
		end

		if Function_In and Function_In(WorkerAlias, ResourceAlias, Label, ItemID) then

			local	Diff
			local	StartTime
			local	CurrentTime = GetGametime()
			StartTime = CurrentTime
			while true do
				Sleep(2)
				CurrentTime = GetGametime()
				Diff = (CurrentTime - StartTime)
				local Total = GetProperty(WorkerAlias, PropName)
				if not Total then
					Total = 0
				end
				Total = Total + SimGetProductivity("")*Diff
				SetProperty(WorkerAlias, PropName, Total)
				if Total > Time then
					RemoveProperty(WorkerAlias, PropName)
					break
				end
			end

			--Removed = RemoveItems(ResourceAlias, ItemID, Count)
			--if Removed>0 then
				AddItems(WorkerAlias, ItemID, Count)
			--end
			
		end

		if AliasExists("WorkPosition") then
			f_EndUseLocator(WorkerAlias, "WorkPosition", GL_STANCE_STAND)
		end
		
		local	Finish

		if GetRemainingInventorySpace(SimAlias,ItemID) < Count then
			Finish = 1
		else
			Finish = 0
		end
		
		if Function_Out then
			Function_Out(SimAlias, ResourceAlias, Label, Count, Finish, ItemID)
		end

		if Finish == 1 and BuildingGetAISetting("WorkBuilding", "Produce_Selection")>0 then
			if not IsPartyMember(WorkerAlias) then
				if GetInsideBuildingID(WorkerAlias) ~= GetID("WorkBuilding") then
					f_MoveTo(SimAlias, "WorkBuilding", GL_MOVESPEED_WALK)
				end
				SimSetProduceItemID(WorkerAlias, -1, -1)
				break
			end
		end
	end

	return true, ItemID
end

function GotoResource(SimAlias, ResourceAlias, Name, theitem)

	local	LocatorArray = {}
	local	LocCount = 0

	local	Level = ResourceGetLevel(ResourceAlias)

	local	Status
	 	
	if theitem == 133 then
		GetFreeLocatorByName(ResourceAlias,"Work",1,9,"WorkPosi")
		f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
	else
		for g=1, Level do
			for n=0, 9 do		
				Name = "work"..g..n
				Status = LocatorStatus(ResourceAlias, Name, true)
				if Status==-1 then
					break
				end
				if Status==1 then
					LocatorArray[LocCount] = Name
					LocCount = LocCount + 1
				end
			end
		end
	end
 	
	local Success = false
			
 	if LocCount>0 then
 		for trys=0,10 do
 			local LocatorName	= LocatorArray[ Rand(LocCount) ]
			GetLocatorByName(ResourceAlias, LocatorName, "WorkPosition")
 			Success = f_BeginUseLocator(SimAlias, "WorkPosition", GL_STANCE_STAND, true, GL_MOVESPEED_RUN)
 			if Success then
 				break
 			end
 		end
 	end

	
 	if not Success then
 		-- Removed because it looks bad in some Recources (specialy the wood) when the sim go to the center of the  resource
 		--
 		-- (cs) removed the remove of the feedback, it's so much the worse that a resource cannot be collected at all
		Success = f_MoveTo(SimAlias, ResourceAlias, GL_MOVESPEED_RUN,150)
	end


	if not Success then
		-- the sim was unable to go to the resource, so return error
		return nil
	end
	
	return SimAlias
	 		
end

-- ***************************************
--
--                   Honey
--
-- ***************************************

function Honey_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_MINE_+0", Label)

	CarryObject(SimAlias,"Handheld_Device/ANIM_torchparticles.nif", false)
	GetPosition(SimAlias,"PartPos")
	PlayAnimation(SimAlias,"fetch_water_in")
	GfxStartParticle("rauch", "particles/Schornsteinrauch.nif", "PartPos",1.0)
	GfxStartParticle("bees", "particles/flies.nif", "PartPos",0.5)
	LoopAnimation(SimAlias,"fetch_water_loop",0)
	
	return true
end

function Honey_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"fetch_water_out")
	GfxStopParticle("bees")
	GfxStopParticle("rauch")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
		MoveSetActivity(SimAlias,"carry")
		Sleep(2)
		CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket_honey.nif", false)
	end
end

-- ***************************************
--
--                   Fruit
--
-- ***************************************

function Fruit_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_GATHER_+0", Label)

	LoopAnimation("", "knee_work_loop",2.5)
	PlayAnimation("", "knee_work_out")
	Sleep(1.5)
	LoopAnimation("", "manipulate_top_r",2.5)
	LoopAnimation("", "manipulate_top_l",2.5)
	
	return true
end

function Fruit_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias, "knee_work_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
		MoveSetActivity(SimAlias,"carry")
		Sleep(2)
		CarryObject(SimAlias,"Handheld_Device/ANIM_Fruitbasket.nif", false)
	end
end

-- ***************************************
--
--                   Sand
--
-- ***************************************

function Ton_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_GATHER_+0", Label)

	CarryObject(SimAlias,"Handheld_Device/ANIM_Pitchfork.nif", false)
	PlayAnimation(SimAlias,"churn")
	CarryObject(SimAlias,"", false)
	CarryObject(SimAlias,"Handheld_Device/ANIM_scheffel.nif", false)
	PlayAnimation(SimAlias,"knee_work_in")
	LoopAnimation(SimAlias,"knee_work_loop",0)
	
	return true
end

function Ton_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"knee_work_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
		MoveSetActivity(SimAlias,"carry")
		Sleep(2)
		CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket_carry.nif", false)
	end
end


-- ***************************************
--
--                   Herbs
--
-- ***************************************

function Herbs_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_GATHER_+0", Label)

	CarryObject(SimAlias,"Handheld_Device/ANIM_Sickel.nif", false)
	PlayAnimation(SimAlias,"knee_work_in")
	LoopAnimation(SimAlias,"knee_work_loop",0)
	
	return true
end

function Herbs_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"knee_work_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
		MoveSetActivity(SimAlias,"carry")
		Sleep(2)
		CarryObject(SimAlias,"Handheld_Device/ANIM_Herbbox.nif", false)
	end
end


-- ***************************************
--
--                  Mine
--
-- ***************************************

function Mine_In(SimAlias, ResourceAlias, Label)
	SetContext("", "mine")
	MsgMeasure("","@L_GENERAL_MSGMEASURE_MINE_+0", Label)
	CarryObject(SimAlias,"Handheld_Device/ANIM_Pick.nif", false)
	PlayAnimation(SimAlias,"chop_in")
	LoopAnimation(SimAlias, "chop_loop", 0)
	
	return true
end

function Mine_Out(SimAlias, ResourceAlias, Label, Removed, Finish,ITID)
	PlayAnimation(SimAlias,"chop_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
	
		MoveSetActivity(SimAlias,"carry")
		Sleep(2)
		if ITID == 133 then
			CarryObject(SimAlias,"Handheld_Device/ANIM_Granite.nif", false)
		else
			CarryObject(SimAlias,"Handheld_Device/ANIM_Metalbar.nif", false)
		end
	end
end


-- ***************************************
--
--                  Harvest
--
-- ***************************************

function Harvest_In(SimAlias, ResourceAlias, Label)
	SetContext("", "harvest")
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_HARVEST_+0", Label)
	CarryObject(SimAlias,"Handheld_Device/ANIM_Scythe.nif", false)
	PlayAnimation(SimAlias,"hoe_in")
	LoopAnimation(SimAlias, "hoe_loop", 0)
	
	return true
end

function Harvest_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"hoe_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
		MoveSetActivity(SimAlias,"carry")
		Sleep(2)
		CarryObject(SimAlias,"Handheld_Device/ANIM_Bag.nif", false)
	end
end


-- ***************************************
--
--                   Beet
--
-- ***************************************
function Beet_In(SimAlias, ResourceAlias, Label)
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_HARVEST_+0", Label)
	PlayAnimation(SimAlias,"knee_work_in")
	LoopAnimation(SimAlias,"knee_work_loop",0)
	
	return true
end

function Beet_Out(SimAlias, ResourceAlias, Label, Removed, Finish, ITID)
	PlayAnimation(SimAlias,"knee_work_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
		MoveSetActivity(SimAlias,"carry")
		Sleep(2)
		if ITID == 204 then
			CarryObject(SimAlias,"Handheld_Device/ANIM_Fungibasket.nif", false)
		else
			CarryObject(SimAlias,"Handheld_Device/ANIM_weideaeste.nif", false)
		end
	end
end


-- ***************************************
--
--                   Animal
--
-- ***************************************

function Animal_In(SimAlias, ResourceAlias, Label,ITID)
	Sleep(10)
	SetContext(SimAlias, "sow")
	CarryObject(SimAlias,"Handheld_Device/ANIM_Seed.nif", true)
	PlayAnimation(SimAlias,"sow_field_in")
	LoopAnimation(SimAlias, "sow_field_loop", 6)
	PlayAnimation(SimAlias,"sow_field_out")
	CarryObject(SimAlias,"",true)
	Sleep(1)
	PlayAnimationNoWait(SimAlias,"fetch_store_obj_R")
	Sleep(1)
	PlayAnimation(SimAlias,"knee_work_out")
	PlayAnimationNoWait(SimAlias,"fetch_store_obj_R")
	Sleep(1)
	CarryObject(SimAlias,"",false)
	Sleep(1)
	
	return true
end

function Animal_Out(SimAlias, ResourceAlias, Label, Removed, Finish,ITID)
	if Finish == 1 then
		CarryObject(SimAlias,"",false)
		MoveSetActivity(SimAlias,"carry")
		Sleep(2)
		CarryObject(SimAlias,"Handheld_Device/ANIM_haunch.nif", false)
	end
end


-- ***************************************
--
--                Take (Chest)
--
-- ***************************************

function Take_In(SimAlias, ResourceAlias, Label)
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_TAKE_+0", Label)

	LoopAnimation(SimAlias, "manipulate_bottom_r", 0)
	return true
end

function Take_Out(SimAlias, ResourceAlias, Label)
end

-- ***************************************
--
--                  Charcoal
--
-- ***************************************

function Charcoal_In(SimAlias, ResourceAlias, Label)

	MsgMeasure("", "@L_GENERAL_MSGMEASURE_MINE_+0", Label)
	MoveSetActivity(SimAlias,"carrypeel")
	Sleep(1.7)
	CarryObject(SimAlias,"Handheld_Device/ANIM_peel_iron.nif",false)
	AlignTo(SimAlias,ResourceAlias)
	PlayAnimation(SimAlias,"peel_bread_out_oven")
	LoopAnimation(SimAlias, "peel_idle", 0)
	
	return true
end

function Charcoal_Out(SimAlias, ResourceAlias, Label, Removed, Finish)

	if (Finish == 1) then
	    MoveSetActivity(SimAlias,"")
		CarryObject(SimAlias,"", false)
		MoveSetActivity(SimAlias,"carry")
		Sleep(2)
		CarryObject(SimAlias,"Handheld_Device/ANIM_Bag.nif", false)
	end
end

-- ***************************************
--
--                  Lumber
--
-- ***************************************

function Lumber_In(SimAlias, ResourceAlias, Label)
	SetContext("","rangerhut")
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_MINE_+0", Label)
	CarryObject(SimAlias,"weapons/axe_01.nif", false)
	PlayAnimation(SimAlias,"chop_in")
	LoopAnimation(SimAlias, "chop_loop", 0)
	
	return true
end

function Lumber_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	PlayAnimation(SimAlias,"chop_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
		MoveSetActivity(SimAlias,"carrywood")
		Sleep(1.5)
		CarryObject(SimAlias,"Handheld_Device/ANIM_Woodlog.nif", false)
	end
end

-- ***************************************
--
--                  Well
--
-- ***************************************

function Well_In(SimAlias, ResourceAlias, Label)
	MsgMeasure("", "@L_GENERAL_MSGMEASURE_MINE_+0", Label)
	CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket.nif", false)
	PlayAnimation(SimAlias,"fetch_water_in")
	LoopAnimation(SimAlias, "fetch_water_loop", 0)
	
	return true
end

function Well_Out(SimAlias, ResourceAlias, Label, Removed, Finish)
	CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket_full.nif", false)
	PlayAnimation(SimAlias,"fetch_water_out")
	if (Finish == 1) then
		CarryObject(SimAlias,"", false)
		Sleep(2)
		CarryObject(SimAlias,"Handheld_Device/ANIM_Bucket_full.nif", false)
	end
end

