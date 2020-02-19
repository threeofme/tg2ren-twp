function GetLocator()

	local LocatorArray = {
		"Distillery", ms_022_producealchemist_UseDistillery, "Distillery",
		"Oilsqueezer", ms_022_producealchemist_UseOilsqueezer, "Oilsqueezer",
		"Herbs_Table", ms_022_producealchemist_UseHerbs_Table, "",
		"Scales", ms_022_producealchemist_UseScales, "",
		"Mandrake", ms_022_producealchemist_UseMandrake, "",
		"DryingMachine", ms_022_producealchemist_UseDryingMachine, "DryingMachine",
		"CopperCaldron",ms_022_producealchemist_UseCopperCaldron, "",
		"AutomaticSprinkler",ms_022_producealchemist_Useautomaticsprinkler,"automaticsprinkler",
		"AutomaticExhauser",ms_022_producealchemist_UseautomaticExhauser,"automaticexhauser"
	}
	local	LocatorCount = 9

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function UseDistillery()
  -- SFX loc_alchemist_destillery_02 bis 04
	PlayAnimation("", "manipulate_middle_twohand")
	if GetLocatorByName("WorkBuilding", "Distillery2", "DestPos") then
		f_MoveTo("","DestPos")
		local Time = PlayAnimation("", "manipulate_middle_twohand")
		Sleep(2)
		PlaySound3DVariation("","Locations/destillery",1)
		Sleep(0.5)
		PlaySound3DVariation("","Locations/destillery",1)
		Sleep(0.5)
		PlaySound3DVariation("","Locations/destillery",1)
		Sleep(Time-2)
	end
end

function UseOilsqueezer()
	PlayAnimation("", "crank_front_in")
	ms_022_producegoods_StartRoomAni("","U_oilsqueezer",0)
	for i=0,10 do
		PlaySound3D("","Locations/oilsqueezer+0.wav",1)
		PlayAnimation("", "crank_front_loop")
	end
	ms_022_producegoods_StopRoomAni("","U_oilsqueezer",-1)
	PlayAnimation("", "crank_front_out")
end

function UseHerbs_Table()
	PlayAnimation("", "manipulate_bottom_r")
	if GetLocatorByName("WorkBuilding", "Herbs_Table2", "HerbsPos") then
		f_MoveTo("","HerbsPos")
		local Time = PlayAnimation("", "manipulate_middle_low_l")
		PlaySound3DVariation("","Locations/herbs",1)
	end
end

function UseScales()
	PlayAnimation("", "manipulate_middle_low_l")
	if GetLocatorByName("WorkBuilding", "Scales2", "ScalesPos") then
		f_MoveTo("","ScalesPos")
		local Time = PlayAnimation("", "manipulate_middle_low_l")
		PlaySound3DVariation("","Locations/herbs",1)
	end
end

function UseMandrake()
	PlayAnimation("", "cogitate")
	-- SFX loc_general_digging_shelf_01
	if GetLocatorByName("WorkBuilding", "Shelf", "ShelfPos") then
		f_MoveTo("","ShelfPos")
		PlayAnimation("", "cogitate")
		local Time = PlayAnimation("", "manipulate_middle_low_l")
		Sleep(2)
		PlaySound3DVariation("","Effects/digging_shelf",1)
		Sleep(0.5)
		PlaySound3DVariation("","Effects/digging_shelf",1)
		Sleep(0.5)
		PlaySound3DVariation("","Effects/digging_shelf",1)
		Sleep(Time-2)
	end
end

function UseDryingMachine()
  -- SFX loc_alchemist_drying_01
	if GetLocatorByName("WorkBuilding", "DryingMachine2", "DryPos") then
		f_MoveTo("","DryPos")
		PlayAnimation("", "manipulate_bottom_l")
	end
	if GetLocatorByName("WorkBuilding", "DryingMachine", "DryPos2") then
		f_MoveTo("","DryPos2")
		PlayAnimation("", "crank_front_in_02")
		ms_022_producegoods_StartRoomAni("","U_dryingmachine",0)
		LoopAnimation("", "crank_front_loop_02",10)
		for i=0,10 do
			PlaySound3D("","Locations/driveshaft_loop+0.wav",1)
		end
		ms_022_producegoods_StopRoomAni("","U_dryingmachine",-1)
		PlayAnimation("", "crank_front_out_02")
	end
end

function UseCopperCaldron()
	-- SFX loc_alchemist_caldron_02
	PlayAnimation("", "manipulate_middle_twohand")
	CarryObject("","Handheld_Device/ANIM_scoop.nif",false)
	PlayAnimation("", "stir_in")
	LoopAnimation("", "stir_loop", 10)
	PlayAnimation("", "stir_out")
	CarryObject("","",false)
end

function Useautomaticsprinkler()
	PlayAnimation("", "pumping_in")
	ms_022_producegoods_StartRoomAni("","U_automaticsprinkler",0)
	for i=0,10 do
		PlaySound3D("","Locations/driveshaft_loop+0.wav",1)
		PlayAnimation("", "pumping_loop")
	end
	ms_022_producegoods_StopRoomAni("","U_U_automaticsprinkler",-1)
	PlayAnimation("", "pumping_out")
end

function UseautomaticExhauser()
	PlayAnimation("", "crank_front_in_02")
	ms_022_producegoods_StartRoomAni("","U_automaticexhauser",0)
	LoopAnimation("", "crank_front_loop_02",-1)
	ms_022_producegoods_StopRoomAni("","U_automaticexhauser",-1)
	PlayAnimation("", "crank_front_out_02")	
end


