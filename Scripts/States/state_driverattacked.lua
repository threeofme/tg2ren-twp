function Init()
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_measure_start")	
	SetStateImpact("no_action")	
end

function Run()

	if not (GetVehicle("", "MyCart")) then
		return
	end 

	if not ExitCurrentVehicle("MyCart") then
		return
	end

	if not GetEvadePosition("", 1500, "fleepos") then
	 	return
	end
	
	SetProperty("MyCart","BeeingPlundered",1)

 	f_MoveTo("", "fleepos",GL_MOVESPEED_RUN)
	AlignTo("", "MyCart")
	Sleep(1)

	PlayAnimation("","insult_character")
	PlayAnimation("","threat")
	local Empty
	local ItemID
	local ItemCount
	local Slots
	local Robbers
	local DynastyRobbers
	
	--scan for enemies
	local Enemies = 1
	while (Enemies > 0) do
		Sleep(5)
		Enemies = 0
	
		Robbers = Find("MyCart","__F( (Object.GetObjectsByRadius(Sim)==2000)AND(Object.GetProfession()==15))", "Robber",-1)
		DynastyRobbers = Find("MyCart","__F( (Object.GetObjectsByRadius(Sim)==2000)AND(Object.IsDynastySim())AND(Object.IsClass(4))AND(Object.MinAge(16)))", "DynastyRobber", -1)
		
		if Robbers + DynastyRobbers == 0 then
			break
		end
		
		for CheckRobbers=0, Robbers-1 do
			if GetDynastyID("MyCart") ~= GetDynastyID("Robber"..CheckRobbers) then
				if DynastyGetDiplomacyState("MyCart","Robber"..CheckRobbers) ~= DIP_ALLIANCE then
					if GetCurrentMeasureID("Robber"..CheckRobbers)==3505 or GetState("Robber"..CheckRobbers, STATE_FIGHTING) then  --SquadWaylayMember
						Enemies = Enemies +1
					end
				end
			end
		end
		
		for CheckRobber=0, DynastyRobbers-1 do
			if GetDynastyID("MyCart") ~= GetDynastyID("DynastyRobber"..CheckRobber) then
				if DynastyGetDiplomacyState("MyCart","DynastyRobber"..CheckRobber) ~= DIP_ALLIANCE then
					if GetCurrentMeasureID("DynastyRobber"..CheckRobber)==3505 or GetState("DynastyRobber"..CheckRobber, STATE_FIGHTING) then  --SquadWaylayMember
						Enemies = Enemies +1
					end
				end
			end
		end
		
		if Enemies == 0 then
			break
		end
		
		Slots = InventoryGetSlotCount("MyCart", INVENTORY_STD)
		Empty = true
		for s=0,Slots-1 do
			ItemID, ItemCount = InventoryGetSlotInfo("MyCart", INVENTORY_STD, s)
			if ItemID and ItemCount and ItemID>0 then
				Empty = false
				break
			end
		end
		
		if Empty then
			break
		end
		
		Sleep(4)
	end
	
	Sleep(10)
		
	--return to cart
	if not AliasExists("MyCart") then
		if not (GetVehicle("", "MyCart")) then
			return
		end
	end

	local radius = GetRadius("MyCart")
	f_MoveTo("", "MyCart", GL_MOVESPEED_RUN, radius )
	AlignTo("", "MyCart")	
	if (GetHPRelative("MyCart") < 0.30) then
		PlayAnimation("", "crank_front_in")
	end
	while (GetHPRelative("MyCart") < 0.30) do
		PlayAnimation("", "crank_front_loop")
		ModifyHP("MyCart", 1, false)
	end
	
end

function CleanUp()
	--return to cart
	if not AliasExists("MyCart") then
		if not (GetVehicle("", "MyCart")) then
			return
		end
	end
	EnterVehicle("", "MyCart")
end

