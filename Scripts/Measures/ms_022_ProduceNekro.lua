function GetLocator()

	local LocatorArray = {
		"Work1", ms_022_producenekro_UseSargA,"",
		"Work2", ms_022_producenekro_UseLager,"",
		"Work3", ms_022_producenekro_UseAltar,"",
		"Work4", ms_022_producenekro_UseKessel,"",
		"Work5", ms_022_producenekro_UseSargB,"",
		"Work6", ms_022_producenekro_UseWerktisch,"",
		"Work7", ms_022_producenekro_UseWerkhilfe,"werkhilfe",
		}
	local	LocatorCount = 7

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function UseSargA()

	GetLocatorByName("WorkBuilding","Work1","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
		
	CarryObject("","Handheld_Device/ANIM_spatula.nif", false)
	Sleep(0.5)
	PlayAnimation("","manipulate_middle_twohand")
	Sleep(2)
	PlayAnimation("","manipulate_middle_up_l")

	CarryObject("","",false)
	
end

function UseLager()

	GetLocatorByName("WorkBuilding","Work2","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	PlayAnimation("", "cogitate")
	local animat = Rand(3)
	if animat == 0 then
		if BuildingHasUpgrade("WorkBuilding",943) == true then -- zutaten
			PlayAnimation("","manipulate_bottom_r")
		else
			PlayAnimation("","manipulate_top_r")
		end
	elseif animat == 1 then
		PlayAnimation("","manipulate_middle_up_l")
	else
		PlayAnimation("","manipulate_top_r")
	end	
	
end

function UseAltar()

	GetLocatorByName("WorkBuilding","Work3","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
	
	CarryObject("","Handheld_Device/ANIM_fishknife.nif", false)
	PlayAnimation("", "manipulate_middle_twohand")
	CarryObject("","",false)
	PlayAnimation("", "cogitate")
	if Rand(2) == 0 then
		CarryObject("","Handheld_Device/ANIM_metahammer.nif", false)
		Sleep(0.5)
		PlayAnimation("","hammer_in")
		for i=0, 5 do
			local waite = PlayAnimationNoWait("","hammer_loop")
			Sleep(1)
			PlaySound3DVariation("","Locations/hammer_stone",1.0)
			Sleep(waite-1)
		end
		PlayAnimation("","hammer_out")
		CarryObject("","",false)
	else
		local Time = PlayAnimationNoWait("", "saw")
		CarryObject("","Handheld_Device/Anim_handsaw.nif",false)
		Sleep(3)
		for i=0, 5 do
			PlaySound3DVariation("","Locations/handsaw",1.0)
			Sleep(1)
		end
		Sleep(Time-12)
		CarryObject("","",false)
	end
	
end

function UseKessel()

	GetLocatorByName("WorkBuilding","Work4","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	PlayAnimation("", "cogitate")
	if Rand(2) == 0 then
		PlayAnimation("", "manipulate_middle_twohand")
	else
		PlayAnimation("","manipulate_middle_low_r")
	end
	CarryObject("","Handheld_Device/ANIM_scoop.nif",false)
	PlayAnimation("", "stir_in")
	LoopAnimation("", "stir_loop", 10)
	PlayAnimation("", "stir_out")
	CarryObject("","",false)	
end

function UseSargB()

	GetLocatorByName("WorkBuilding","Work5","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	if Rand(2) == 0 then
		PlayAnimation("","manipulate_middle_low_l")
	else
		PlayAnimation("","manipulate_middle_low_r")
	end
end

function UseWerktisch()

	GetLocatorByName("WorkBuilding","Work6","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
	
	CarryObject("","Handheld_Device/ANIM_fishknife.nif", false)
	PlayAnimation("", "manipulate_middle_twohand")
	CarryObject("","",false)
	
end

function UseWerkhilfe()

	GetLocatorByName("WorkBuilding","Work7","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
	PlayAnimation("","manipulate_bottom_r")
end

function KnochenGraben()

	while true do
		local ItemID = SimGetProduceItemID("")
		local platzSim = 0
		local platzGeb = 0
		local ProdCount = 0
		local ProdTime = 0
		
		if ItemID == 220 then -- Bones
			platzSim = GetRemainingInventorySpace("","Knochen",INVENTORY_STD)
			platzGeb = GetRemainingInventorySpace("WorkBuilding","Knochen",INVENTORY_STD)
			ProdCount = ItemGetProductionAmount("Knochen")
			ProdTime = ItemGetProductionTime("Knochen")
		elseif ItemID == 221 then -- Skulls
			platzSim = GetRemainingInventorySpace("","Schadel",INVENTORY_STD)
			platzGeb = GetRemainingInventorySpace("WorkBuilding","Schadel",INVENTORY_STD)
			ProdCount = ItemGetProductionAmount("Schadel")
			ProdTime = ItemGetProductionTime("Schadel")
		elseif ItemID == 226 then -- Leichenhemd
			platzSim = GetRemainingInventorySpace("","Leichenhemd",INVENTORY_STD)
			platzGeb = GetRemainingInventorySpace("WorkBuilding","Leichenhemd",INVENTORY_STD)
			ProdCount = ItemGetProductionAmount("Leichenhemd")
			ProdTime = ItemGetProductionTime("Leichenhemd")
		end
		
		if platzSim < ProdCount and platzGeb < ProdCount then
			MsgQuick("","_HPFZ_PRODUCENEKRO_FEHLER_+0")
			return false
		elseif platzSim < ProdCount then
			TransferItems("","WorkBuilding")
		end
		
		-- animation
		-- spawn the resource object
		local RandomPlace = Rand(3)
		if RandomPlace==0 then
			GetFleePosition("", "WorkBuilding", (1200+Rand(1000)), "MovePos")
		elseif RandomPlace==1 then
			GetFreeLocatorByName("WorkBuilding","walledge",4,4,"MovePos")
		else
			GetFreeLocatorByName("WorkBuilding","walledge",3,3,"MovePos")
		end
		local x = 0-Rand(300)
		local z = 0-Rand(750)
		PositionModify("MovePos",x,0,z)
			
		if not f_MoveTo("","MovePos",GL_MOVESPEED_WALK) then
			local Rand1 = -200 +Rand(400)
			local Rand2 = 200 -Rand(400)
			PositionModify("MovePos",Rand1,0,Rand2)
			if GetDistance("","WorkBuilding")>1500 then
				CopyAlias("WorkBuilding","MovePos")
				f_MoveTo("","MovePos",GL_MOVESPEED_WALK,750)
			else
				f_MoveTo("","MovePos",GL_MOVESPEED_WALK)
			end
		end
		
		CarryObject("","Handheld_Device/ANIM_torchparticles.nif", false)
		PositionModify("MovePos",-50,0,50)
		GfxAttachObject("resource", "buildings/graveyard/graveyard.nif")
		GfxSetPositionTo("resource", "MovePos")
		
		PlayAnimationNoWait("","watch_for_guard")
		local spruch = Rand(4)
		if spruch == 1 then
		MsgSay("","_HPFZ_PRODUCENEKRO_SPRUCH_+0")
		elseif spruch == 2 then
			MsgSay("","_HPFZ_PRODUCENEKRO_SPRUCH_+1")
		elseif spruch == 3 then
			MsgSay("","_HPFZ_PRODUCENEKRO_SPRUCH_+2")
		else
			MsgSay("","_HPFZ_PRODUCENEKRO_SPRUCH_+3")
		end
			
		-- return when full
		while GetRemainingInventorySpace("",ItemID,INVENTORY_STD)>=ProdCount do
			SetData("Endtime",(math.mod(GetGametime(),24)+(ProdTime/2)))
			PlayAnimation("","knee_work_in")
			while true do
				LoopAnimation("","knee_work_loop",5)
				if (math.mod(GetGametime(),24)>GetData("Endtime")) then
					break
				end
			end
			AddItems("",ItemID,ProdCount,INVENTORY_STD)
		end
		
		CarryObject("","",false)		
		PlayAnimation("","knee_work_out")
		MoveSetActivity("","carry")
		GfxDetachObject("resource")
		Sleep(2)
		CarryObject("","Handheld_Device/ANIM_Bag.nif", false)
		
		-- add the items to the building
		GetOutdoorMovePosition("","WorkBuilding","LagerPos")
		if not f_MoveToSilent("","LagerPos",GL_MOVESPEED_WALK) then
			SimBeamMeUp("","LagerPos",false)
		end
		
		TransferItems("","WorkBuilding")
		MoveSetActivity("","")
		Sleep(2)
		CarryObject("","",false)
	end
end

function CleanUp()
	if AliasExists("WorkBuilding") and DynastyIsAI("WorkBuilding") then
		ms_022_gather_ReturnItems("", "WorkBuilding")
	end
end
