function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_control")
	SetStateImpact("no_hire")
	SetStateImpact("no_enter")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_measure_start")
	SetStateImpact("NoCameraJump")
end

function Run()
	if not FindNearestBuilding("", -1, GL_BUILDING_TYPE_SOLDIERPLACE, -1, false, "Soldierplace") then
		SetState("",STATE_GLOBALTRAVELLING,false)
	end
	
	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")
	local enemy = GetProperty("WarChooser","WarEnemy")

	local distance 
	
	-- weapon and armor for the landsquenet
	if HasProperty("", "officer") then
		Sleep(2)
		CarryObject("","weapons/langsword_02.nif", false)
		SetProperty("","Weapon",5)
		if not IsDynastySim("") then
			SetProperty("","Weapon",1)
			AddItems("","Platemail",1,INVENTORY_EQUIPMENT) -- Plate
		end
		distance = 0

	elseif HasProperty("", "trooper") then	
		local Armor = Rand(8)
		if Armor > 2 then
			AddItems("","LeatherArmor",1,INVENTORY_EQUIPMENT) -- Leather
		elseif Armor > 6 then
			AddItems("","Platemail",1,INVENTORY_EQUIPMENT) -- Plate
		end
		local Weapon = Rand(2)
		if Weapon == 0 then
			MoveSetActivity("","carrypeel")
			CarryObject("","weapons/Pike.nif",false)
		else
			CarryObject("","weapons/ANIM_Pike2.nif",false)
		end		
		SetProperty("","Weapon",2)
		distance = 300
		Sleep(4)

	elseif HasProperty("", "arkebusier") then
		local Armor = Rand(2)
		if Armor == 0 then
			AddItems("","LeatherArmor",1,INVENTORY_EQUIPMENT) -- Leather
		end
		if Rand(2) == 1 then
			MoveSetActivity("","carrypeel")
			CarryObject("","weapons/arkebuse.nif",false)
		else
			CarryObject("","weapons/ANIM_arke.nif",false)
		end		
		SetProperty("","Weapon",3)
		Sleep(8)
		distance = 600

	elseif HasProperty("", "cannon") then
		CarryObject("","weapons/langsword_01.nif",false)
		SetProperty("","Weapon",4)
		Sleep(12)
		distance = 200
		AddItems("","Platemail",1,INVENTORY_EQUIPMENT) -- Plate
	end
			
	GetPosition("Soldierplace", "Position")
	if IsDynastySim("") then
		f_WeakMoveTo("","Position",GL_MOVESPEED_RUN,distance)
	else
		f_WeakMoveTo("","Position",GL_MOVESPEED_WALK,distance)
	end
	MoveSetActivity("","")
	
	local x,y,z =  PositionGetVector("Position")
	if HasProperty("", "officer") and HasProperty("", "captain") then
		RemoveProperty("", "officer")
	end
	
	x = Rand(distance) + x - distance / 2
	z = Rand(distance) + z - distance / 2
	
	PositionSetVector("Position",x,y,z)
	
	x = Rand(600) + x - 300
	z = Rand(600) + z - 300
	if x < 70 and x > 0 then
		x = 70
	elseif x > -70 and x < 0 then
		x = -70
	end
	
	if y < 70 and x > 0 then
		y = 70
	elseif y > -70 and y < 0 then
		y = -70
	end
	
	PositionSetVector("Position",x,y,z)
	
	f_WeakMoveTo("","Position",GL_MOVESPEED_WALK, 100)

	while true do
		local RandomTalk = Rand(8)
		if GetProperty("WarChooser","WarPhase")==2 then
			MoveSetStance("",GL_STANCE_STAND)
			break
		end
		if Rand(10) > 7 then
			MoveSetStance("",GL_STANCE_STAND)
			if Rand(10) > 8 then
				MsgSayNoWait("","@L_SCENARIO_WAR_RANDOMTALK_+"..RandomTalk, "@L_SCENARIO_WAR_"..enemy.."_+2")
			end
			
			x = Rand(600) + x - 300
			z = Rand(600) + z - 300
			
			if x < 70 and x > 0 then
				x = 70
			elseif x > -70 and x < 0 then
				x = -70
			end
			
			if y < 70 and x > 0 then
				y = 70
			elseif y > -70 and y < 0 then
				y = -70
			end
			
			PositionSetVector("Position",x,y,z)
			
			f_WeakMoveTo("","Position",GL_MOVESPEED_WALK, 100)
		elseif Rand(6) > 3 then
			MoveSetStance("",GL_STANCE_STAND)
		else
			MoveSetStance("",GL_STANCE_SITGROUND)
		end
			
		local CurrentTime = math.mod(GetGametime(), 24)
		if (CurrentTime > 20 or CurrentTime < 6) and (Rand(13) == 1 or HasProperty("", "TorchlightCarrier")) then
			if not HasProperty("", "TorchlightCarrier") then
				SetProperty("", "TorchlightCarrier",1)
			end
			CarryObject("","Handheld_Device/ANIM_torch.nif",false)
		else
			state_globaltravelling_GetMyWeapon()
		end
		if Rand(10) < 8 then
			if Rand(10) > 7 then
				MsgSayNoWait("","@L_SCENARIO_WAR_RANDOMTALK_+"..RandomTalk, "@L_SCENARIO_WAR_"..enemy.."_+2")
			end
			MoveSetStance("",GL_STANCE_SITGROUND)
		end
		Sleep(Rand(5)+15)
	end
	
	state_globaltravelling_GetMyWeapon()

	local count = GetOutdoorLocator("WarWay",-1,"FarFarAway")
	local Location = nil
	if (count==0) or (count==nil) then
		GetOutdoorLocator("MapExit1",-1,"FarFarAway")
		Location = "FarFarAway"
	else
		local	Alias
		local	Dist = -1
		local BestDist = 99999
		
		for l=0,count-1 do
			Alias = "FarFarAway"..l
			Dist = GetDistance("Position", Alias)
			
			if not Location or Dist < BestDist then
				Location = Alias
				BestDist = Dist
			end
		end
	end

	if HasProperty("", "officer") then
		Sleep(2)
	elseif HasProperty("", "trooper") then
		Sleep(4)
	elseif HasProperty("", "arkebusier") then
		Sleep(8)
	elseif HasProperty("", "cannon") then
		Sleep(12)
	end

	f_MoveTo("",Location,GL_MOVESPEED_RUN)

	SetInvisible("", true)
	AddImpact("", "Hidden", 1 , -1)

	while true do
		if HasProperty("WarChooser","WarWon") and (GetProperty("WarChooser","WarWon")>0) then
			break
		end
		Sleep(5)
	end

	local fame = 0
	local death
	if GetProperty("WarChooser","WarWon")==1 then
		if HasProperty("", "captain") then
			fame = 5
			death = 2 
		elseif HasProperty("", "officer") then
			fame = 3
			death = 3 
		else
			death = 7 
		end
	else
		if HasProperty("", "captain") then
			fame = 8
			death = 1 
		elseif HasProperty("", "officer") then
			fame = 5
			death = 2 
		else
			death = 4 
		end
	end
	
	local armor = GetArmor("") / 10
	local randdeath = Rand(10+armor) + 1
	local willDie = false
	if death > randdeath then
		if fame > 0 then
			chr_SimAddImperialFame("",fame)

			if DynastyIsPlayer("") then
				feedback_MessageCharacter("","@L_WAR_END_DEAD_HEAD_+0","@L_WAR_END_DEAD_BODY_+0",GetID(""))
			end
		end

		SetProperty("","WarVictim",1)

	else
	
		SetInvisible("", false)
		RemoveImpact("", "Hidden")
	
		f_MoveTo("","Position",GL_MOVESPEED_RUN)
	
		if fame > 0 then
			chr_SimAddImperialFame("",fame)
			Sleep(2)
			chr_GainXP("",fame*20)
	
			if DynastyIsPlayer("") then
				feedback_MessageCharacter("","@L_WAR_END_ALIVE_HEAD_+0","@L_WAR_END_ALIVE_BODY_+0",GetID(""))
			end

		else
			FindNearestBuilding("", -1, GL_BUILDING_TYPE_SCHOOL, -1, false, "Arsenal")
			GetLocatorByName("Arsenal", "Entry1", "MoveToPosition")
			f_MoveTo("","MoveToPosition",GL_MOVESPEED_WALK)
		end
	end
	
	SetState("",STATE_GLOBALTRAVELLING,false)
end

function GetMyWeapon()
	local Weapon = GetProperty("","Weapon")
	if Weapon == 1 then
		CarryObject("","weapons/langsword_02.nif", false)
	elseif Weapon == 2 then
		CarryObject("","weapons/ANIM_Pike2.nif",false)
	elseif Weapon == 3 then
		CarryObject("","weapons/ANIM_arke.nif",false)
	elseif Weapon == 4 then
		CarryObject("","weapons/langsword_02.nif", false)
	else
		CarryObject("","weapons/warhammer_01.nif",false)
	end
end

function CleanUp()
	if HasProperty("","TorchlightCarrier") then
		RemoveProperty("","TorchlightCarrier")
	end
	if HasProperty("","Weapon") then
		RemoveProperty("","Weapon")
	end
	if HasProperty("", "AtWar") then
		RemoveProperty("", "AtWar")
	end
	
	CarryObject("","", false)

	RemoveImpact("", "Hidden")
	SetInvisible("", false)

	if HasProperty("", "WarVictim") then
		RemoveProperty("", "WarVictim")
		InternalDie("")
		InternalRemove("")
		Kill("")
	elseif HasProperty("", "captain") then
		RemoveProperty("", "captain")
	elseif HasProperty("", "officer") then
		RemoveProperty("", "officer")
	elseif HasProperty("", "trooper") then
		RemoveProperty("", "trooper")
		InternalDie("")
		InternalRemove("")
		Kill("")
	elseif HasProperty("", "arkebusier") then
		RemoveProperty("", "arkebusier")
		InternalDie("")
		InternalRemove("")
		Kill("")
	elseif HasProperty("", "cannon") then
		RemoveProperty("", "cannon")
		InternalDie("")
		InternalRemove("")
		Kill("")
	end
	
	SetState("",STATE_LOCKED,false)

end

