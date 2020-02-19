function GetLocator()

	local LocatorArray = {
		"LathePos", ms_022_producejoiner_UseLatheMachine, "Lathe",
		"SawPos", ms_022_producejoiner_UseSaw, "",
		"SawPos", ms_022_producejoiner_UseSaw, "",
		"FilePos", ms_022_producejoiner_UseFile, "",
		"PlanerPos", ms_022_producejoiner_UsePlaner, "Planer",
		"AutomaticSawPos", ms_022_producejoiner_UseAutomaticSaw, "AutomaticSaw",
		"AutomaticHammerOvenPos", ms_022_producejoiner_UseAutomaticHammer, "AutomaticHammer",
		"StrainPos", ms_022_producejoiner_UseStrainingMachine, "StrainingMachine",
	}
	local	LocatorCount = 8

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function UseSaw()
	local Time
	GetLocatorByName("WorkBuilding","SawDust1","SawDustPos1")
	GetLocatorByName("WorkBuilding","SawDust2","SawDustPos2")
	--use the saw
	Time = PlayAnimationNoWait("", "saw")
	ms_022_producegoods_StartRoomAni("","U_Saw",0)
	Sleep(3)
	
	for i=0,8 do
		StartSingleShotParticle("particles/sawdust.nif", "SawDustPos1", 1,2)
		Sleep(1)
		StartSingleShotParticle("particles/sawdust.nif", "SawDustPos2", 1,2)
	end
	Sleep(Time-12)
	ms_022_producegoods_StopRoomAni("","U_Saw",-1)
end

function UseFile()
	
	--take the file from the wall
	Time = PlayAnimationNoWait("", "manipulate_top_r")
	Sleep(Time-3)
	CarryObject("","Handheld_Device/Anim_File.nif",false)
	
	if BuildingHasUpgrade("WorkBuilding", "Toolcase") and GetLocatorByName("WorkBuilding", "ToolCasePos", "ToolCase") then
	--go to toolcase and drop the file
		f_MoveTo("","ToolCase")
		PlayAnimation("","crank_front_in")
		CarryObject("","",false)
		PlayAnimation("","crank_front_out")
		CarryObject("","",false)
	elseif GetLocatorByName("WorkBuilding", "ToolPos", "ToolsOnTheWall") then
	--go to the tools on the wall an hang em there
		f_MoveTo("","ToolsOnTheWall")
		Time = PlayAnimationNoWait("","manipulate_middle_up_r")
		Sleep(Time-2)
		CarryObject("","",false)
	end
	CarryObject("","",false)

end

function UsePlaner()
	--Planer animation
	if BuildingHasUpgrade("WorkBuilding", "Planer") then
		PlayAnimation("","manipulate_middle_twohand")
		Sleep(2)
	end

end

function UseAutomaticSaw()

	if BuildingHasUpgrade("WorkBuilding", "AutomaticSaw") then
		--manipulate something
		ms_022_producegoods_StartRoomAni("","U_AutomaticSaw",0)
		PlayAnimation("","manipulate_middle_twohand")
		ms_022_producegoods_StopRoomAni("","U_AutomaticSaw",-1)
	end

end

function UseAutomaticHammer()

	if BuildingHasUpgrade("WorkBuilding","AutomaticHammer") then
		--check the oven
		PlayAnimation("","manipulate_bottom_r")
		ms_022_producegoods_StartRoomAni("","U_AutomaticHammer",0)
		Sleep(1)
		
		--go to the hammer
		if GetLocatorByName("WorkBuilding", "AutomaticHammerPos", "TheHammer") then
			f_MoveTo("","TheHammer")
			PlayAnimation("","manipulate_middle_twohand")
			ms_022_producegoods_StopRoomAni("","U_AutomaticHammer",-1)
			PlayAnimation("", "cogitate")
		end
	end
	
end

function UseStrainingMachine()
	
	if BuildingHasUpgrade("WorkBuilding","StrainingMachine") then
		PlayAnimation("","manipulate_middle_low_r")
		PlayAnimation("", "cogitate")
	end
	
end


function UseLatheMachine()
	
	if BuildingHasUpgrade("WorkBuilding","Lathe") then
		ms_022_producegoods_StartRoomAni("","U_Lathe",0)
		PlayAnimation("","manipulate_middle_twohand")
		ms_022_producegoods_StopRoomAni("","U_Lathe",-1)
	end
	
end


function StartRoomAni(room,ani)
	SetData("RA_Room",room)
	SetData("RA_Ani",ani)
	SetRoomAnimationTime("WorkBuilding",room,ani,0)
	StartRoomAnimation("WorkBuilding",room,ani)
end


function StopRoomAni(room,ani)
	if HasData("RA_Room") then
		RemoveData("RA_Room")
		RemoveData("RA_Ani")
	end
	StopRoomAnimation("WorkBuilding",room,ani)
end


