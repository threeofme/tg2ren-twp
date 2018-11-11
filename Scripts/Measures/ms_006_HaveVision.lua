-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_006_HaveVision"
----
----	with this measure the player can invent new artefacts
----
-------------------------------------------------------------------------------


function Run()
	if not GetInsideBuilding("", "Building") then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	-- What recipes and results do you already know?
	
	local output, output2, difficulty
	local DefaultLabel = "@L_MEASURE_HAVEVISION_UNKOWN_+0"
	local NewLabel = "@L_MEASURE_HAVEVISION_NEWRECIPE_+0"
	local Rec1 = DefaultLabel
	local Res1 = DefaultLabel
	local Rec2 = DefaultLabel
	local Res2 = DefaultLabel
	local Rec3 = DefaultLabel
	local Res3 = DefaultLabel
	local Rec4 = DefaultLabel
	local Res4 = DefaultLabel
	local Rec5 = DefaultLabel
	local Res5 = DefaultLabel
	local Rec6 = DefaultLabel
	local Res6 = DefaultLabel
	local Rec7 = DefaultLabel
	local Res7 = DefaultLabel
	local Rec8 = DefaultLabel
	local Res8 = DefaultLabel
	local Rec9 = DefaultLabel
	local Res9 = DefaultLabel
	local Rec10 = DefaultLabel
	local Res10 = DefaultLabel
	local Rec11 = DefaultLabel
	local Res11 = DefaultLabel
	local Rec12 = DefaultLabel
	local Res12 = DefaultLabel
	local Rec13 = DefaultLabel
	local Res13 = DefaultLabel
	
	if HasProperty("Building","Rec1") then
		Rec1 = ItemGetLabel("Oakwood",true)
		Res1 = ItemGetLabel("WalkingStick",true)
		
		-- easy
	end
	
	if HasProperty("Building","Rec2") then
		Rec2 = ItemGetLabel("Pinewood",true)
		Res2 = ItemGetLabel("CrossOfProtection",true)
		
		-- hard
	end
	
	if HasProperty("Building","Rec3") then
		Rec3 = ItemGetLabel("Fat",true)
		Res3 = ItemGetLabel("CartBooster",true)
		
		-- easy
	end
	
	if HasProperty("Building","Rec4") then
		Rec4 = ItemGetLabel("Iron",true)
		Res4 = ItemGetLabel("BoobyTrap",true)
		
		-- medium
	end
	
	if HasProperty("Building","Rec5") then
		Rec5 = ItemGetLabel("Silver",true)
		Res5 = ItemGetLabel("CamouflageCloak",true)
		-- medium
	end
	
	if HasProperty("Building","Rec6") then
		Rec6 = ItemGetLabel("Gold",true)
		Res6 = ItemGetLabel("GoldChain",true)
		-- medium
	end
	
	if HasProperty("Building","Rec7") then
		Rec7 = ItemGetLabel("Gemstone",true)
		Res7 = ItemGetLabel("BeltOfMetaphysic",true)
		-- hard
	end
	
	if HasProperty("Building","Rec8") then
		Rec8 = ItemGetLabel("Leather",true)
		Res8 = ItemGetLabel("GlovesOfDexterity",true)
		-- medium
	end
	
	if HasProperty("Building","Rec9") then
		Rec9 = "@L_VISION_HERRING_OR_SALMON_+0"
		Res9 = ItemGetLabel("PearlChain")
		-- medium
	end
	
	if HasProperty("Building","Rec10") then
		Rec10 = ItemGetLabel("Clay",true)
		Res10 = ItemGetLabel("Stonerotary",true)
		-- easy
	end
	
	if HasProperty("Building","Rec11") then
		Rec11 = ItemGetLabel("Granite",true)
		Res11 = ItemGetLabel("Gargoyle",true)
		-- medium
	end
	
	if HasProperty("Building","Rec12") then
		Rec12 = ItemGetLabel("Spiderleg",true)
		Res12 = ItemGetLabel("PoisonedCake",true)
		-- easy
	end
	
	if HasProperty("Building","Rec13") then
		Rec13 = ItemGetLabel("Wool",true)
		Res13 = ItemGetLabel("Spindel",true)
		-- easy
	end
	
	-- starting menu
	
	local result = MsgNews("","Building","@P"..
				"@B[0,@L_MEASURE_HAVEVISION_RECIPES_+0]"..
				"@B[1,@L_MEASURE_HAVEVISION_DOIT_+0]"..
				"@B[2,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
				1,
				"economie",-1,"@L_MEASURE_HAVEVISION_HEAD_+0",
				"@L_MEASURE_HAVEVISION_BODY_+0")
	
	-- recipes
	if result == 0 then
		
		local result2 = MsgNews("","Building","@P"..
				"@B[0,@L_MEASURE_HAVEVISION_DOIT_+0]"..
				"@B[1,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
				1,
				"economie",-1,"@L_MEASURE_HAVEVISION_HEAD_+0",
				"@L_MEASURE_HAVEVISION_RECIPES_BODY_+0", Rec1,Res1,
				Rec2,Res2,Rec3,Res3,Rec4,Res4,Rec5,Res5,Rec6,Res6,
				Rec7,Res7,Rec8,Res8,Rec9,Res9,Rec10,Res10,Rec11, Res11,
				Rec12,Res12,Rec13,Res13)
		
		-- do it
		if result2 == 0 then
			ms_006_havevision_DoIt("","Building")
		end
		
	-- do it	
	elseif result == 1 then
		ms_006_havevision_DoIt("","Building")
	end
end

function DoIt(Sim,Building)

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	--check if tool is available
	if GetItemCount(Sim,"Tool",INVENTORY_STD)==0 then 	
		MsgBoxNoWait(Sim,Building,"@L_GENERAL_ERROR_HEAD","@L_ALCHEMIST_006_HAVEVISION_FAILURES_+1")
		StopMeasure()
	end
			
	-- check if you have some ressources
	local Count = InventoryGetSlotCount(Sim, INVENTORY_STD)
	local ItemFound, Found
	local Success = false
	for i=0,Count-1 do
		ItemFound, Found = InventoryGetSlotInfo(Sim, i, INVENTORY_STD)
		if ItemFound and ItemFound>0 and Found>0 then
			if ItemGetType(ItemFound)==ITEM_TYPE_GATHERING or ItemGetType(ItemFound)==2 then
				Success = true
				break
			end
		end
	end
			
	if Success == false then
		MsgBoxNoWait(Sim,Building,"@L_GENERAL_ERROR_HEAD","@L_ALCHEMIST_006_HAVEVISION_FAILURES_+0")
		StopMeasure()
	end
			
	local Item
			
	if RemoveItems(Sim,ItemFound,1,INVENTORY_STD)>0 then
				
		RemoveItems(Sim,"Tool",1,INVENTORY_STD)
		-- block and TimeOut
		MeasureSetNotRestartable()
		SetMeasureRepeat(TimeOut)
		SetState(Sim,STATE_DUEL, true)
		MeasureSetStopMode(STOP_NOMOVE)
	
		-- do the visual stuff here
		GetLocatorByName(Building,"Telescope","MovePos")
		f_MoveTo(Sim,"MovePos")
		PlayAnimation(Sim,"manipulate_middle_twohand")
		PlayAnimation(Sim,"cogitate")
		for i=1,3 do
			GetLocatorByName(Building,"ThinkPos"..i,"MovePos")
			f_MoveTo(Sim,"MovePos")
			if Rand(100)> 60 then
				PlayAnimation(Sim,"cogitate")
			else
				PlayAnimation(Sim,"shake_head")
			end
		end
	
		Sleep(0.2)
				
		local RecID
		local difficulty
		if ItemGetName(ItemFound) == "Oakwood" then
			difficulty = 3
			Item = "WalkingStick"
			RecID = 1
		elseif ItemGetName(ItemFound) == "Pinewood" then
			difficulty = 9
			Item = "CrossOfProtection"
			RecID = 2
		elseif ItemGetName(ItemFound) == "Fat" then
			difficulty = 3
			Item = "CartBooster"
			RecID = 3
		elseif ItemGetName(ItemFound) == "Iron" then
			difficulty = 6
			Item = "BoobyTrap"
			RecID = 4
		elseif ItemGetName(ItemFound) == "Silver" then
			difficulty = 6
			Item = "CamouflageCloak"
			RecID = 5
		elseif ItemGetName(ItemFound) == "Gold" then
			difficulty = 6
			Item = "GoldChain"
			RecID = 6
		elseif ItemGetName(ItemFound) == "Gemstone" then
			difficulty = 9
			Item = "BeltOfMetaphysic"
			RecID = 7
		elseif ItemGetName(ItemFound) == "Leather" then
			difficulty = 6
			Item = "GlovesOfDexterity"
			RecID = 8
		elseif ItemGetName(ItemFound) == "Perle" or ItemGetName(ItemFound) == "Shell" then
			difficulty = 6
			Item = "PearlChain"
			RecID = 9
		elseif ItemGetName(ItemFound) == "Clay" then
			difficulty = 3
			Item = "Stonerotary"
			RecID = 10
		elseif ItemGetName(ItemFound) == "Granite" then
			difficulty = 6
			Item = "Gargoyle"
			RecID = 11
		elseif ItemGetName(ItemFound) == "Spiderleg" then
			difficulty = 3
			Item = "PoisonedCake"
			RecID = 12
		elseif ItemGetName(ItemFound) == "Wool" then
			difficulty = 3
			Item = "Spindel"
			RecID = 13
		else
			difficulty = 0
		end
				
		if diffulty == 0 then
			--vision failed, wrong item
			StartSingleShotParticle("particles/toadexcrements_hit.nif","ParticleSpawnPos",3,5)
			MsgBoxNoWait(Sim,Building,"@L_ALCHEMIST_006_HAVEVISION_END_HEAD_+0",
						"@L_ALCHEMIST_006_HAVEVISION_WRONG_BODY_+0",ItemGetLabel(ItemFound,true))
			StopMeasure()
		else
				
			local CurrentTime = math.mod(GetGametime(),24)
			local EvocationSkill = GetSkillValue("",SECRET_KNOWLEDGE)
			-- modifications
			if (CurrentTime > 22) or (CurrentTime < 6) then
				EvocationSkill = EvocationSkill + 2
			end
			if Weather_GetValue(1) < 0.5 then
				EvocationSkill = EvocationSkill + 1
			end
					
			if EvocationSkill > difficulty then --vision successful
				GetPosition(Sim,"ParticleSpawnPos")
				StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos",2,15)
				PlayAnimation(Sim,"nod")
		
				if CanAddItems(Sim, Item,1, INVENTORY_STD) then
					AddItems(Sim, Item, 1,INVENTORY_STD)
				elseif CanAddItems(Building,Item,1,INVENTORY_STD) then
					AddItems(Building,Item,1,INVENTORY_STD)
				else
					--vision failed, not enough space
					StartSingleShotParticle("particles/toadexcrements_hit.nif","ParticleSpawnPos",3,5)
					MsgBoxNoWait(Sim,Building,"@L_ALCHEMIST_006_HAVEVISION_END_HEAD_+0",
								"@L_ALCHEMIST_006_HAVEVISION_END_BODY_+0")
					StopMeasure()
				end
				
				-- if this is the first time you made the item, you get nice XP
				if not HasProperty(Building,"Rec"..RecID) then
					SetProperty(Building,"Rec"..RecID,1)
					chr_GainXP(Sim,GetData("BaseXP"))
				end
						
				MsgBoxNoWait(Sim,Building,"@L_ALCHEMIST_006_HAVEVISION_START_HEAD_+0",
							"@L_ALCHEMIST_006_HAVEVISION_START_BODY_+0",ItemGetLabel(Item,true))
					
			else
				--vision failed, bad skill
					StartSingleShotParticle("particles/toadexcrements_hit.nif","ParticleSpawnPos",3,5)
					MsgBoxNoWait(Sim,Building,"@L_ALCHEMIST_006_HAVEVISION_END_HEAD_+0",
								"@L_ALCHEMIST_006_HAVEVISION_END_BODY_+0")
					StopMeasure()
			end
		end
	else
		StopMeasure()
	end
end

function CleanUp()
	MsgMeasure("","")
	SetState("",STATE_DUEL,false)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

