	function GetLocator()

	local LocatorArray = {
		"IronMachine_fire", ms_022_producetailor_UseIronMachine, "IronMachine",
		"SewingMachine_cloth", ms_022_producetailor_UseSewingMachine, "SewingMachine",	
		"Bobbin", ms_022_producetailor_UseBobbin, "",
		"Dressform2", ms_022_producetailor_UseDressform, "Dressform",
		"Hallstand_01", ms_022_producetailor_UseHallstand_01, "",
		"Hallstand_02", ms_022_producetailor_UseHallstand_02, "jerkinnailer",
		"Thimble", ms_022_producetailor_UseThimble, "Thimble",
	}
	local	LocatorCount = 7
	
	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end


function UseBobbin()
	PlayAnimation("", "manipulate_middle_twohand")	
	GetLocatorByName("WorkBuilding", "Bobbin2", "BobbinPos")
	f_MoveTo("","BobbinPos")
	local Time = MoveSetActivity("","carrywood")
	Sleep(1.5)
	PlaySound3DVariation("","Locations/wear_clothes", 1.0)
	CarryObject("","Handheld_Device/ANIM_Cloth.nif", false)
	Sleep(Time-1.5)
	GetLocatorByName("WorkBuilding", "Bobbin", "BobbinPos")
	f_MoveTo("","BobbinPos")
	Time = MoveSetActivity("","")
	Sleep(1.5)
	PlaySound3DVariation("","Locations/wear_clothes", 1.0)
	CarryObject("","",false)
	Sleep(Time-1.5)
end

function UseDressform()
	PlayAnimation("","manipulate_middle_twohand")
	if BuildingHasUpgrade("WorkBuilding", "Dressform") and GetLocatorByName("WorkBuilding", "Dressform", "DressPos1") then
		f_MoveTo("","DressPos1")
		local Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
		Sleep(2)
		PlaySound3DVariation("","Locations/wear_clothes", 1.0)
		Sleep(Time-2)
		GetLocatorByName("WorkBuilding", "Dressform2", "DressPos2")
		f_MoveTo("","DressPos2")
	end
	PlayAnimation("", "manipulate_middle_twohand")	
end

function UseHallstand_01()
	local Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
	Sleep(2)
	PlaySound3DVariation("","Locations/wear_clothes", 1.0)
	Sleep(Time-2)
	GetLocatorByName("WorkBuilding", "Hallstand_01_2", "Hallstand_012")
	f_MoveTo("","Hallstand_012")
	GetLocatorByName("WorkBuilding", "Hallstand_01_3", "Hallstand_013")
	f_MoveTo("","Hallstand_013")
	PlayAnimation("", "cogitate")
	GetLocatorByName("WorkBuilding", "Hallstand_01_4", "Hallstand_014")
	f_MoveTo("","Hallstand_014")
	GetLocatorByName("WorkBuilding", "Hallstand_01", "Hallstand_011")
	f_MoveTo("","Hallstand_011")
	Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
	Sleep(2)
	PlaySound3DVariation("","Locations/wear_clothes", 1.0)
	Sleep(Time-2)	
end

function UseHallstand_02()
	local Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
	Sleep(2)
	PlaySound3DVariation("","Locations/wear_clothes", 1.0)
	Sleep(Time-2)
	GetLocatorByName("WorkBuilding", "Hallstand_02_2", "Hallstand_022")
	f_MoveTo("","Hallstand_022")
	Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
	Sleep(2)
	PlaySound3DVariation("","Locations/wear_clothes", 1.0)
	Sleep(Time-2)
	GetLocatorByName("WorkBuilding", "Hallstand_02", "Hallstand_021")
	f_MoveTo("","Hallstand_021")
	Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
	Sleep(2)
	PlaySound3DVariation("","Locations/wear_clothes", 1.0)
	Sleep(Time-2)	
end

function UseThimble()
	local Time = PlayAnimationNoWait("", "manipulate_middle_low_r")
	Sleep(1)
	PlaySound3DVariation("","Effects/digging_box",1)
	Sleep(Time-1)	
	if BuildingHasUpgrade("WorkBuilding", "Pattern") and GetLocatorByName("WorkBuilding", "Pattern", "PatternPos") then
		f_MoveTo("","PatternPos")
		PlayAnimation("", "cogitate")
	end
	if BuildingHasUpgrade("WorkBuilding", "Thimble") and GetLocatorByName("WorkBuilding", "Thimble", "ThimblePos") then
		f_MoveTo("","ThimblePos")
		Time = PlayAnimationNoWait("", "manipulate_middle_low_r")
		Sleep(1)
		PlaySound3DVariation("","Effects/digging_box",1)
		Sleep(Time-1)		
		GetLocatorByName("WorkBuilding", "ChairSewing", "ChairPos")
		f_BeginUseLocator("","ChairPos",GL_STANCE_SIT,true)
		PlayAnimation("","sew_in")
		for i=0,10 do
			PlayAnimation("","sew_loop")
		end
		PlayAnimation("","sew_out")
		f_EndUseLocator("","ChairPos",GL_STANCE_STAND)
		f_MoveTo("","ThimblePos")
		Time = PlayAnimationNoWait("", "manipulate_middle_low_r")
		Sleep(1)
		PlaySound3DVariation("","Effects/digging_box",1)
		Sleep(Time-1)
	end
end

function UseIronMachine()
	PlayAnimation("", "knee_work_in")
	LoopAnimation("", "knee_work_loop",2)
	PlayAnimation("", "knee_work_out")
	if BuildingHasUpgrade("WorkBuilding", "IronMachine") and GetLocatorByName("WorkBuilding", "IronMachine_fire", "FirePos") then
		GetLocatorByName("WorkBuilding", "IronMachine_manipulate", "ManipulatePos")
		f_MoveTo("","ManipulatePos")
		PlayAnimation("", "manipulate_middle_twohand")
		ms_022_producegoods_StartRoomAni("","U_ironmachine",0)
		local Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
		Sleep(1.5)
		PlaySound3DVariation("","Effects/digging_shelf",1)
		Sleep(Time-1.5)
		ms_022_producegoods_StopRoomAni("","U_ironmachine",-1)
		PlayAnimation("", "manipulate_middle_twohand")
	end
end

function UseSewingMachine()
	local Time = MoveSetActivity("","carry")
	Sleep(2)
	CarryObject("","Handheld_Device/ANIM_Cloth.nif",false)
	PlaySound3DVariation("","Locations/wear_clothes", 1.0)
	Sleep(Time-2)
	if BuildingHasUpgrade("WorkBuilding", "SewingMachine") and GetLocatorByName("WorkBuilding", "SewingMachine", "MachinePos") then
		f_MoveTo("","MachinePos")
		Time = MoveSetActivity("","")
		Sleep(1.5)
		PlaySound3DVariation("","Locations/wear_clothes", 1.0)
		CarryObject("","",false)
		Sleep(Time-1.5)
		f_BeginUseLocator("","MachinePos",GL_STANCE_SIT,true)
		ms_022_producegoods_StartRoomAni("","U_sewingmachine",0)
		Sleep(10)
		ms_022_producegoods_StopRoomAni("","U_sewingmachine",-1)
		f_EndUseLocator("","MachinePos",GL_STANCE_STAND)
	else
		PlayAnimation("", "manipulate_bottom_l")
	end
end

