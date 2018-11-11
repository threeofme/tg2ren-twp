Include("Measures/ms_022_producebakery.lua")
Include("Measures/ms_022_producetavern.lua")
Include("Measures/ms_022_producejoiner.lua")
Include("Measures/ms_022_producesmithy.lua")
Include("Measures/ms_022_producechurch.lua")
Include("Measures/ms_022_producetailor.lua")
Include("Measures/ms_022_producealchemist.lua")
Include("Measures/ms_022_producefisher.lua")
Include("Measures/ms_022_producehospital.lua")
Include("Measures/ms_022_gather.lua")
Include("Measures/ms_022_producebankier.lua")
Include("Measures/ms_022_producenekro.lua")
Include("Measures/ms_022_producemill.lua")
Include("Measures/ms_022_producestonemason.lua")
Include("Measures/ms_022_producegaukler.lua")
--Include("Measures/ms_022_producewoodcutter.lua")
Include("Measures/ms_022_producegunsmithy.lua")
Include("Measures/ms_022_producefarmer.lua")
Include("Measures/ms_022_gathernew.lua")
Include("Measures/ms_002_Gather.lua")
Include("Measures/ms_022_Fishing.lua")

function Run() 
	local ActiveMovement = true

	if not AliasExists("WorkBuilding") then
		if not SimGetWorkingPlace("","WorkBuilding") then
			return
		end
	end
	
	if SimGetAge("") < 16 then
		f_ExitCurrentBuilding("")
		return
	end
	
	-- special case for "force production"
	if HasProperty("","ForceProd") then
		SimSetProduceItemID("",GetProperty("","ForceProd"),GetID("WorkBuilding"))
	end

	-- special case for dynasty sims
	if IsDynastySim("Owner") and AliasExists("Destination") then
		if IsType("Destination", "Building") then
			CopyAlias("Destination", "WorkBuilding")
			RemoveAlias("Destination")
		end

		local ItemID = SimGetProduceItemID("")
		if ItemGetType(ItemID )~=ITEM_TYPE_GATHERING then
			if GetInsideBuildingID("")~=GetID("WorkBuilding") then
				if not f_MoveTo("", "WorkBuilding", GL_MOVESPEED_RUN) then
					return
				end
			end
		end
	end
		
	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end
	if (GetImpactValue("WorkBuilding",126)==1) then -- toadexcrements
		StopProduction("")
		Sleep(5)
		StopMeasure()
	end

	local GetLocatorFunction
	local ItemID = -1
	while true do
		if not AliasExists("WorkBuilding") then
			return
		end
		
		if (GetImpactValue("WorkBuilding",126)==1) then -- toadexcrements
			StopProduction("")
			Sleep(5)
			StopMeasure()
		end
		
		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end	
	
		if ItemID==-1 or ItemID ~= SimGetProduceItemID("") then
			ItemID = SimGetProduceItemID("")
			if not ItemID or ItemID==-1 or ItemID==0 then
				LogError("ms_022_ProduceGoods: Fatal - No produceable item found")
	 			return
			end
			SetData("ItemID", ItemID)
			
			local Type = BuildingGetType("WorkBuilding")
			GetLocatorFunction = ms_022_producegoods_GetLocator
			if (Type == GL_BUILDING_TYPE_SMITHY) then
				GetLocatorFunction = ms_022_producesmithy_GetLocator
			elseif (Type == GL_BUILDING_TYPE_PIRATESNEST) then
				GetLocatorFunction = ms_022_producegunsmithy_GetLocator
			elseif (Type == GL_BUILDING_TYPE_ALCHEMIST) then
				GetLocatorFunction = ms_022_producealchemist_GetLocator
			elseif (Type == GL_BUILDING_TYPE_TAILORING) then
				GetLocatorFunction = ms_022_producetailor_GetLocator
			elseif (Type == GL_BUILDING_TYPE_BAKERY) then
				GetLocatorFunction = ms_022_producebakery_GetLocator
			elseif (Type == GL_BUILDING_TYPE_TAVERN) then
				GetLocatorFunction = ms_022_producetavern_GetLocator
			elseif (Type == GL_BUILDING_TYPE_JOINERY) then
				GetLocatorFunction = ms_022_producejoiner_GetLocator
			elseif (Type == GL_BUILDING_TYPE_CHURCH_EV) or (Type == GL_BUILDING_TYPE_CHURCH_CATH) then
				GetLocatorFunction = ms_022_producechurch_GetLocator
			elseif (Type == GL_BUILDING_TYPE_FISHINGHUT) then
				GetLocatorFunction = ms_022_producefisher_GetLocator
			elseif (Type == GL_BUILDING_TYPE_HOSPITAL) then
				GetLocatorFunction = ms_022_producehospital_GetLocator
			-- Steinmetz
			elseif (Type == 110) then
				GetLocatorFunction = ms_022_producestonemason_GetLocator
			-- Gaukler
			elseif (Type == 102) then
				GetLocatorFunction = ms_022_producegaukler_GetLocator
			-- Bänker
			elseif (Type == 43) then
				GetLocatorFunction = ms_022_producebankier_GetLocator
			-- Holzfäller
--			elseif (Type == 18) then
--				GetLocatorFunction = ms_022_producewoodcutter_GetLocator
			-- Farmer
			elseif (Type == 3) then
				GetLocatorFunction = ms_022_producefarmer_GetLocator
			end
		end
		
		-- check the inventory for raw material and give it to workbuilding if possible
		local Count = InventoryGetSlotCount("", INVENTORY_STD)
		local ItemFound, Found
		for i=0,Count-1 do
			ItemFound, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
			if ItemFound and ItemFound>0 and Found>0 then
				if ItemGetType(ItemFound)==ITEM_TYPE_GATHERING  then
					if ItemGetID(ItemID)~=ItemFound then
						if CanAddItems("WorkBuilding", ItemFound, Found, INVENTORY_STD) then
							RemoveItems("", ItemFound, Found, INVENTORY_STD)
							AddItems("WorkBuilding", ItemFound, Found, INVENTORY_STD)
						end
					end
				end
			end
		end
		
    
		-- Necromancer
		if BuildingGetType("WorkBuilding") == 98 then
			StartProduction("","WorkBuilding")
			if SimGetProduceItemID("") == 220 or SimGetProduceItemID("") == 221 or SimGetProduceItemID("") == 226 then
				if not ms_022_producenekro_KnochenGraben() then
					SimSetProduceItemID("", 0, -1)
					StopMeasure()
					Sleep(0.1)
					return
				end
			else
				GetLocatorFunction = ms_022_producenekro_GetLocator
			end
		end
		
		-- fruitfarmer and specials for woodcutter and miner
		local ProduceID = SimGetProduceItemID("")
	--	if ProduceID == 64 or -- honey
	--		ProduceID == 60 or -- fruit
			if ProduceID == 62 or -- beet
			ProduceID == 63 or -- lettuce
			ProduceID == 144 or -- tar
			ProduceID == 154 then -- salt
			
			StartProduction("","WorkBuilding")
			if not ms_022_gathernew_Gather() then
				SimSetProduceItemID("", 0, -1)
				StopMeasure()
				Sleep(0.1)
				return
			end
			
		end
		
		-- Mill
		if (BuildingGetType("WorkBuilding") == GL_BUILDING_TYPE_MILL) and ItemGetType(ItemID)~=ITEM_TYPE_GATHERING then
			SetData("muehle", 1)
			if not ms_022_producemill_MehlMahlen() then
				SimSetProduceItemID("", 0, -1)
				StopMeasure()
				Sleep(0.1)
				return
			end
		elseif ItemGetType(ItemID)==ITEM_TYPE_GATHERING then
			StartProduction("", "WorkBuilding") -- Start production (internal state)
			SetData("Gathering", 1)
			if not ms_022_gather_Run(ItemID) then
				SimSetProduceItemID("", 0, -1)
				StopMeasure()
				Sleep(0.1)
				return
			end
			Sleep(1)
			if BuildingGetAISetting("WorkBuilding", "Produce_Selection")>0 and not IsDynastySim("") then
				break
			end
		elseif ActiveMovement then
			local	LocatorName = ""
			local AnimationFunction
			local UpgradeName
			
			if not AliasExists("WorkBuilding") then
				return
			end
			
			if GetInsideBuildingID("") ~= GetID("WorkBuilding") then
				f_MoveTo("", "WorkBuilding", GL_MOVESPEED_RUN)
			end

			StartProduction("", "WorkBuilding") -- Start production (internal state)
			Assert(GetLocatorFunction~=nil, "Illegal locator function found !")
	
			LocatorName, AnimationFunction, UpgradeName = GetLocatorFunction()
			if (LocatorName=="") then
				LogError("ms_022_ProduceGoods: Critical error - empty locator name")
				return
			end
			if UpgradeName and UpgradeName~="" and not BuildingHasUpgrade("WorkBuilding", UpgradeName) then
				Sleep(0.25)
			elseif GetFreeLocatorByName("WorkBuilding", LocatorName, -1, -1, "WorkPosition") then
				BlockLocator("Owner","WorkPosition")
				if not f_MoveTo("","WorkPosition") then
					Sleep(0.5)
				else
					AnimationFunction()
				end
				ReleaseLocator("Owner","WorkPosition")
				RemoveAlias("WorkPosition")
			else
				Sleep(0.5)
			end
		else
			f_MoveTo("","WorkBuilding")
			StartProduction("", "WorkBuilding") 
			Sleep(Rand(10)+20)
		end
	end
end

function OnInterrupt()
	SetData("OnInt", 1)
end

function CleanUp()
	feedback_OverheadActionName("Owner")

	if HasProperty("","ForceProd") then
		RemoveProperty("","ForceProd")
	end

	if AliasExists("WorkPosition") then
		ReleaseLocator("Owner","WorkPosition")
		RemoveAlias("WorkPosition")
	end
	
	if GetData("Gathering")==1 then
		ms_022_gather_CleanUp()
	end

	if GetData("muehle")==1 then
	    ms_022_producemill_CleanUp()
	end
	
	if GetData("fruitfarmer")==1 then
	    ms_022_producefruitfarmer_CleanUp()
	end
	
	if AliasExists("WorkBuilding") then
		ms_022_producegoods_StopRoomAni(GetData("RA_Room"),GetData("RA_Ani"),-1)
	end
	
	StopAnimation("")
	CarryObject("","",false)
	CarryObject("","",true)
	MoveSetStance("",GL_STANCE_STAND)
	MoveSetActivity("","")
	StopProduction("")
	
	if IsDynastySim("") then
		if GetData("OnInt")~=1 then
			SimSetProduceItemID("", -1, -1)
		end
	end
end

function GetLocator()

	local LocatorArray = {
		"Work_01", ms_022_producegoods_UseLocator, "",
		"Work_02", ms_022_producegoods_UseLocator, "",
		"Work_03", ms_022_producegoods_UseLocator, "",
		"Work_04", ms_022_producegoods_UseLocator, "",
		"Work_05", ms_022_producegoods_UseLocator, "",
		"Work_06", ms_022_producegoods_UseLocator, "",
		"Work_07", ms_022_producegoods_UseLocator, "",
		"Work_08", ms_022_producegoods_UseLocator, "",
	}
	local	LocatorCount = 8

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function UseLocator()
	CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	LoopAnimation("", "hammer_loop", 15)
	CarryObject("", "", false)
end

-- GUI Listeners --
function OnButtonPressed(x,y,device,key)
	-- Set the choosen Product
	Interface = FindNode("\\application\\game\\MSProducePanel")
	if(Interface) then
		SimStopMeasure("")
		ItemID = this:GetValueInt("ItemID")
		Interface:SetValueInt("ProduceItemId",ItemID)
	end
	-- Close the Panel
	Game = FindNode("\\application\\game")
	if(Game) then
		Game:DetachModule("MSProducePanel")
	end
end


function StartEffect(RunTime)
	while(1) do
		this:SetValueInt("VISIBILITY",1)
		Sleep(0.5)
		this:SetValueInt("VISIBILITY",0)
		Sleep(0.5)
	end
end

function StartRoomAni(room,ani,resettime)
	SetData("RA_Room",room)
	SetData("RA_Ani",ani)
	if (resettime ~= -1) then
		SetRoomAnimationTime("WorkBuilding",room,ani,resettime)
	end
	StartRoomAnimation("WorkBuilding",room,ani)
end

function StopRoomAni(room,ani,resettime)
	if HasData("RA_Room") then
		RemoveData("RA_Room")
		RemoveData("RA_Ani")
		
		StopRoomAnimation("WorkBuilding",room,ani)
		if (resettime ~= -1) then
			SetRoomAnimationTime("WorkBuilding",room,ani,resettime)
		end			
	end
end


