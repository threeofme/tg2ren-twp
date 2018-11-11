function Gather()

	while true do
	
		local ItemID = SimGetProduceItemID("")
		local platzSim = 0
		local platzGeb = 0
		local ProdCount = 0
		local ProdTime = 0
		
		if ItemID == 64 then -- Honey
			platzSim = GetRemainingInventorySpace("","Honey",INVENTORY_STD)
			platzGeb = GetRemainingInventorySpace("WorkBuilding","Honey",INVENTORY_STD)
			ProdCount = ItemGetProductionAmount("Honey")
			ProdTime = ItemGetProductionTime("Honey")
		elseif ItemID == 60 then -- Fruit
			platzSim = GetRemainingInventorySpace("","Fruit",INVENTORY_STD)
			platzGeb = GetRemainingInventorySpace("WorkBuilding","Fruit",INVENTORY_STD)
			ProdCount = ItemGetProductionAmount("Fruit")
			ProdTime = ItemGetProductionTime("Fruit")
		elseif ItemID == 63 then -- lettuce
			platzSim = GetRemainingInventorySpace("","Salat",INVENTORY_STD)
			platzGeb = GetRemainingInventorySpace("WorkBuilding","Salat",INVENTORY_STD)
			ProdCount = ItemGetProductionAmount("Salat")
			ProdTime = ItemGetProductionTime("Salat")
		elseif ItemID == 144 then -- tar
			platzSim = GetRemainingInventorySpace("","Pech",INVENTORY_STD)
			platzGeb = GetRemainingInventorySpace("WorkBuilding","Pech",INVENTORY_STD)
			ProdCount = ItemGetProductionAmount("Pech")
			ProdTime = ItemGetProductionTime("Pech")
		elseif ItemID == 154 then -- salt
			platzSim = GetRemainingInventorySpace("","Salt",INVENTORY_STD)
			platzGeb = GetRemainingInventorySpace("WorkBuilding","Salt",INVENTORY_STD)
			ProdCount = ItemGetProductionAmount("Salt")
			ProdTime = ItemGetProductionTime("Salt")
		end
	
		if platzSim < ProdCount and platzGeb < ProdCount then
			MsgQuick("","_HPFZ_PRODUCENEKRO_FEHLER_+0")
			return false
		end 
		
		-- animation
			
		-- spawn the resource object
		if ItemID~= 154 then
			local RandomPlace = Rand(3)
			if RandomPlace==0 then
				GetFleePosition("", "WorkBuilding", (1200+Rand(1000)), "MovePos")
			elseif RandomPlace==1 then
				GetFreeLocatorByName("WorkBuilding","walledge",4,4,"MovePos")
			else
				GetFreeLocatorByName("WorkBuilding","walledge",3,3,"MovePos")
			end

			if not AliasExists("MovePos") then
				GetFleePosition("", "WorkBuilding", 1500, "MovePos")
			end
			local x = 0-Rand(300)
			local z = 0-Rand(750)
			PositionModify("MovePos",x,0,z)
				
			if not f_MoveTo("","MovePos",GL_MOVESPEED_WALK) then
				PositionModify("MovePos",-200,0,-200)
				if GetDistance("","WorkBuilding")>1500 then
					CopyAlias("WorkBuilding","MovePos")
					f_MoveTo("","MovePos",GL_MOVESPEED_WALK,750)
				else
					f_MoveTo("","MovePos",GL_MOVESPEED_WALK)
				end
			end
		end
		
		if ItemID == 64 then -- for honey
			CarryObject("","Handheld_Device/ANIM_torchparticles.nif", false)
			GfxAttachObject("resource", "buildings/resources/field_2_honey1.nif")
			GfxSetPositionTo("resource", "MovePos")
			GfxStartParticle("rauch", "particles/Schornsteinrauch.nif", "MovePos",1.0)
			GfxStartParticle("bees", "particles/flies.nif", "MovePos",0.5)
			
			-- return when full
			while GetRemainingInventorySpace("","Honey",INVENTORY_STD)>=ProdCount do
				SetData("Endtime",(math.mod(GetGametime(),24)+(ProdTime/2)))
				PlayAnimation("","fetch_water_in")
				while true do
					LoopAnimation("","fetch_water_loop",4)
					if (math.mod(GetGametime(),24)>GetData("Endtime")) then
						break
					end
				end
				AddItems("","Honey",ProdCount,INVENTORY_STD)
			end
			
			PlayAnimation("","fetch_water_out")
			GfxStopParticle("bees")
			GfxStopParticle("rauch")
			GfxDetachObject("resource")
			CarryObject("","", false)
	
			MoveSetActivity("","carry")
			Sleep(1.5)
			CarryObject("","Handheld_Device/ANIM_Bucket_honey.nif", false)
			Sleep(1.0)
			
		elseif ItemID == 60 then -- for fruit
			GfxAttachObject("resource", "buildings/resources/field_2_Orchard1.nif")
			GfxSetPositionTo("resource", "MovePos")
			
			-- return when full
			while GetRemainingInventorySpace("","Fruit",INVENTORY_STD)>=ProdCount do
				SetData("Endtime",(math.mod(GetGametime(),24)+(ProdTime/2)))
				PlayAnimation("","knee_work_in")
				while true do
					LoopAnimation("","knee_work_loop",3)
					PlayAnimation("","knee_work_out")
					Sleep(2)
					LoopAnimation("","manipulate_top_r",3)
					LoopAnimation("","manipulate_top_l",3)
					if (math.mod(GetGametime(),24)>GetData("Endtime")) then
						break
					end
				end
				AddItems("","Fruit",ProdCount,INVENTORY_STD)
			end
			
			GfxDetachObject("resource")
			CarryObject("","", false)
	
			MoveSetActivity("","carry")
			Sleep(1.5)
			CarryObject("","Handheld_Device/ANIM_Fruitbasket.nif", false)
			Sleep(1.0)
		elseif ItemID == 63 then -- for lettuce
			GfxAttachObject("resource", "Outdoor/plants/grass.nif")
			GfxSetPositionTo("resource", "MovePos")
			
			-- return if full
			while GetRemainingInventorySpace("","Salat",INVENTORY_STD)>=ProdCount do
				SetData("Endtime",(math.mod(GetGametime(),24)+(ProdTime/2)))
				CarryObject("","Handheld_Device/ANIM_Seed.nif", true)
				PlayAnimation("","sow_field_in")
				for i=0,2 do
					local wait = PlayAnimationNoWait("","sow_field_loop")
					Sleep(0.5)
					PlaySound3DVariation("", "measures/sowfield")
					Sleep(wait-0.5)
				end
				PlayAnimation("","sow_field_out")
				CarryObject("","", true)
				Sleep(2)
				PlayAnimation("","knee_work_in")
				while true do
					LoopAnimation("","knee_work_loop",5)
					if (math.mod(GetGametime(),24)>GetData("Endtime")) then
						break
					end
				end
				PlayAnimation("","knee_work_out")
				Sleep(1)
				AddItems("","Salat",ProdCount,INVENTORY_STD)
			end
			
			GfxDetachObject("resource")
			CarryObject("","", false)
	
			MoveSetActivity("","carry")
			Sleep(1.5)
			CarryObject("","Handheld_Device/ANIM_Boxvegetable.nif", false)
			Sleep(1.0)
		elseif ItemID == 144 then -- for tar
			CarryObject("","Handheld_Device/ANIM_torchparticles.nif", false)
			Sleep(1)
			PositionModify("MovePos",0,0,100)
			GfxAttachObject("resource", "Outdoor/Handmade/woodstash.nif")
			GfxSetPositionTo("resource", "MovePos")
			PlayAnimation("","manipulate_bottom_r")
			GfxStartParticle("feuer", "particles/bonfire.nif", "MovePos",2.0)
			GfxStartParticle("rauch", "particles/Schornsteinrauch.nif", "MovePos",1.0)
			
			-- return if full
			while GetRemainingInventorySpace("","Pech",INVENTORY_STD)>=ProdCount do
				SetData("Endtime",(math.mod(GetGametime(),24)+(ProdTime/2)))
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_torchparticles.nif", false)
				Sleep(2)
				PlayAnimationNoWait("","knee_work_in")
				Sleep(0.75)
				while true do
					LoopAnimation("","knee_work_loop",3)
					PlayAnimation("","knee_work_out")
					CarryObject("","",false)
					Sleep(1)
					CarryObject("","Handheld_Device/ANIM_Bucket.nif", false)
					PlayAnimationNoWait("","fetch_water_in")
					Sleep(1)
					LoopAnimation("","fetch_water_loop",3)
					if (math.mod(GetGametime(),24)>GetData("Endtime")) then
						break
					end
				end
				AddItems("","Pech",ProdCount,INVENTORY_STD)
				CarryObject("","",false)
				Sleep(2)
			end
			
			MoveSetActivity("","")
			GfxStopParticle("feuer")
			Sleep(2)
			GfxDetachObject("resource")
			GfxStopParticle("rauch")
	
			Sleep(1.5)
			CarryObject("","Handheld_Device/ANIM_Bucket_full.nif", false)
			Sleep(1.0)
		elseif ItemID == 154 then -- for salt
			-- Use the locator of the mine 
			GetFreeLocatorByName("WorkBuilding","bomb",1,1,"MovePos")
			f_MoveToSilent("","MovePos",GL_MOVESPEED_WALK,true) 
			CarryObject("","Handheld_Device/ANIM_Pick.nif", false)
			while GetRemainingInventorySpace("","Salt",INVENTORY_STD)>=ProdCount do
				SetData("Endtime",(math.mod(GetGametime(),24)+(ProdTime/2)))
				PlayAnimation("","chop_in")
				while true do
					LoopAnimation("", "chop_loop", 5)
					if (math.mod(GetGametime(),24)>GetData("Endtime")) then
						break
					end
				end
				PlayAnimation("","chop_out")
				AddItems("","Salt",ProdCount,INVENTORY_STD)
			end
			CarryObject("","",false)
			Sleep(2)
			MoveSetActivity("","carry")
			Sleep(2)
			CarryObject("","Handheld_Device/ANIM_Bag.nif", false)
		end
		
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

	if AliasExists("resource") then
		GfxDetachObject("resource")
	end
	
	if AliasExists("resource2") then
		GfxDetachObject("resource2")
		GfxDetachObject("resource3")
		GfxDetachObject("resource4")
	end
	
	if AliasExists("bees") then
		GfxStopParticle("bees")
		GfxStopParticle("rauch")
	end
	
	MoveSetActivity("","")
	CarryObject("","",false)
	
	if AliasExists("WorkBuilding") and DynastyIsAI("") then
		ms_022_gather_ReturnItems("", "WorkBuilding")
	end
end