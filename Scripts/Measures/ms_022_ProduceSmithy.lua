function GetLocator()

	local LocatorArray = {
		"TakeToolPos", ms_022_producesmithy_UseAnvil, "",
		"AirPos", ms_022_producesmithy_UseBellow, "bellow",
		"Tool2Pos", ms_022_producesmithy_UseWeaponRack, "weaponrack",
		"Pedestral", ms_022_producesmithy_UsePedestral, "",
		"Shelf_in_the_wall", ms_022_producesmithy_UseShelf_in_the_wall, "",
		"Meltingpot",ms_022_producesmithy_UseMeltingpot, "",
		"MagnifyPos",ms_022_producesmithy_UseMagnify, "magnifyingglas",
		"Tool1Pos",ms_022_producesmithy_UseFineTools, "engravingtoolset",
		"Tool2Pos",ms_022_producesmithy_UseFineTools2, "fileshelf",
		"canonpos",ms_022_producesmithy_UseCannon, "cannonmold",
		"Forge2",ms_022_producesmithy_UseHammerInstallation, "",
		"Pedestral", ms_022_producesmithy_UsePedestral, "",
	}
	local	LocatorCount = 12

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function UsePedestral()
	PlayAnimation("", "manipulate_middle_twohand")
end

function UseAnvil()

	SetContext("", "smithy")

	local Time = PlayAnimationNoWait("", "manipulate_middle_up_l")
	Sleep(2)
	CarryObject("Owner", "Handheld_Device/Anim_Forceps_01.nif", true)
	Sleep(Time-2)

	if GetLocatorByName("WorkBuilding", "Forge", "Forge") then
		f_MoveTo("","Forge")
	end

	--take the metal from the forge
	PlayAnimation("", "hold_middle_in")
	CarryObject("Owner", "Handheld_Device/Anim_Forceps.nif", true)
	GetLocatorByName("WorkBuilding", "GlutPos", "GlutPos")
	StartSingleShotParticle("particles/glut_sparks.nif", "GlutPos",1,10)
	LoopAnimation("", "hold_middle_loop", 10)
	PlayAnimation("", "hold_middle_out")

	--get the hammer
	SetAvoidanceRange("",1)
	if GetLocatorByName("WorkBuilding", "GetHammer", "GetHammerPos") then
		f_MoveTo("","GetHammerPos")
		Time = PlayAnimationNoWait("", "manipulate_middle_low_r")
		Sleep(1)
		CarryObject("Owner", "Handheld_Device/Anim_Hammer.nif", false)
		HideObject("","Hammer_handheld")
		Sleep(Time-1)

		--start hammering
		if GetLocatorByName("WorkBuilding", "Anvil", "AnvilPos") then
			GetLocatorByName("WorkBuilding", "spark_anvil", "SparkAnvil")
			f_MoveTo("","AnvilPos")
			Time = PlayAnimationNoWait("", "hammer_loop")
			-- SFX loc_smithy_anvil_01 bis 03
			PlayAnimation("", "hammer_in")

			for i=0,10 do
				-- StartSingleShotParticle("particles/HammerSpark.nif", "SparkAnvil", 1,2)
				PlayAnimation("", "hammer_loop")
			end
			Time = PlayAnimationNoWait("", "hammer_out")
			PlayAnimation("", "hammer_out")
			Sleep(Time)
		end

	--
	elseif GetLocatorByName("WorkBuilding", "Anvil", "AnvilPos") then
		GetLocatorByName("WorkBuilding", "spark_anvil", "SparkAnvil")
		f_MoveTo("","AnvilPos")
		CarryObject("Owner", "Handheld_Device/Anim_Hammer.nif", false)
		-- SFX loc_smithy_anvil_01 bis 03
			PlayAnimation("", "hammer_in")
			for i=0,10 do
				PlayAnimation("", "hammer_loop")
				--StartSingleShotParticle("particles/HammerSpark.nif", "SparkAnvil")
			end
			PlayAnimation("", "hammer_out")
	end

	--if there is an waterbucket, go there and cool the metal
	if BuildingHasUpgrade("WorkBuilding", "Waterbucket") and GetLocatorByName("WorkBuilding", "Waterbucket", "BucketPos") then
		GetLocatorByName("WorkBuilding", "steam1", "Steam1Pos")
		f_MoveTo("","BucketPos")
		local Time = PlayAnimationNoWait("", "cool_l")
		Sleep(1)
		StartSingleShotParticle("particles/water_steam.nif", "Steam1Pos",1,3)
		Sleep(Time-1)
	end

	--move to hammer pos and lay down hammer
	if GetLocatorByName("WorkBuilding", "GetHammer", "GetHammerPos") then
		f_MoveTo("","GetHammerPos")
		Time = PlayAnimationNoWait("", "manipulate_middle_low_r")
		Sleep(1)
		CarryObject("Owner", "", false)
		ShowObject("","Hammer_handheld")
		Sleep(Time)
	end

	--move to the forge and lay down the metal
	if GetLocatorByName("WorkBuilding", "Forge", "ForgePos") then
		f_MoveTo("","ForgePos")
		PlayAnimation("", "hold_middle_in")
		GetLocatorByName("WorkBuilding", "GlutPos", "GlutPos")
		StartSingleShotParticle("particles/glut_sparks.nif", "GlutPos",1,1)		
		CarryObject("Owner", "Handheld_Device/Anim_Forceps_01.nif", true)
		PlayAnimation("", "hold_middle_out")
	end

	if GetLocatorByName("WorkBuilding", "TakeToolPos", "TakeToolPos") then
		f_MoveTo("","TakeToolPos")
		local Time = PlayAnimationNoWait("", "manipulate_middle_up_l")
		Sleep(2)
		CarryObject("Owner","",true)
		Sleep(Time-2)
	end
	SetAvoidanceRange("",-1)
end

function UseHammerInstallation()
  -- SFX loc_smithy_hammerwork_02
	PlayAnimation("", "hold_middle_in")
	CarryObject("Owner", "Handheld_Device/ANIM_iron_rod.nif", false)
	GetLocatorByName("WorkBuilding", "GlutPos", "GlutPos")
	StartSingleShotParticle("particles/glut_sparks.nif", "GlutPos",1,10)			
	LoopAnimation("", "hold_middle_loop", 10)
	PlayAnimation("", "hold_middle_out")
	CarryObject("Owner", "", false)
	CarryObject("Owner", "Handheld_Device/ANIM_iron_rod_L.nif", true)
	if GetLocatorByName("WorkBuilding", "HammerInstallation", "HammerPos") then
		GetLocatorByName("WorkBuilding", "spark_hammerinstallation", "SparkInstallation")
		f_MoveTo("","HammerPos")
		-- SFX loc_smithy_anvil_01 bis 03
		PlayAnimation("", "hold_middle_in")
		for i=0,10 do
			PlayAnimation("", "hold_middle_loop")
			StartSingleShotParticle("particles/HammerSpark.nif", "SparkInstallation",1,3)
		end
		PlayAnimation("", "hold_middle_out")
	end


	if BuildingHasUpgrade("WorkBuilding", "Waterbucket") and GetLocatorByName("WorkBuilding", "Waterbucket", "BucketPos") then
		GetLocatorByName("WorkBuilding", "steam1", "Steam1Pos")
		f_MoveTo("","BucketPos")
		local Time = PlayAnimationNoWait("", "cool_l")
		Sleep(1)
		StartSingleShotParticle("particles/water_steam.nif", "Steam1Pos",1,3)
		Sleep(Time)
	end

	--lay back the iron
	if GetLocatorByName("WorkBuilding", "Forge2", "ForgePos") then
		f_MoveTo("","ForgePos")
		PlayAnimation("", "hold_middle_in")
		GetLocatorByName("WorkBuilding", "GlutPos", "GlutPos")
		StartSingleShotParticle("particles/glut_sparks.nif", "GlutPos",1,1)				
		CarryObject("Owner", "Handheld_Device/Anim_Forceps_01.nif", true)
		PlayAnimation("", "hold_middle_out")
	end

	if GetLocatorByName("WorkBuilding", "TakeToolPos", "TakeToolPos") then
		f_MoveTo("","TakeToolPos")
		local Time = PlayAnimationNoWait("", "manipulate_middle_up_l")
		Sleep(2)
		CarryObject("Owner","",true)
		Sleep(Time-2)
	end

	CarryObject("Owner", "", true)
end


function UseBellow()
	PlayAnimation("", "crank_front_in_02")
	ms_022_producegoods_StartRoomAni("","U_bellow",0)
	LoopAnimation("", "crank_front_loop_02", 5)
	ms_022_producegoods_StopRoomAni("","U_bellow",-1)
	PlayAnimation("", "crank_front_out_02")
end

function UseShelf_in_the_wall()
	-- SFX loc_general_digging_shelf_01
	MoveSetActivity("","carry")
	Sleep(2)
	CarryObject("","Handheld_Device/ANIM_holzscheite.nif",false)
	Sleep(2)

	GetLocatorByName("WorkBuilding", "Forge2", "ForgePos")
	f_MoveTo("","ForgePos")
	Sleep(0.7)
	MoveSetActivity("","")
	Sleep(2)
	CarryObject("","",false)
	Sleep(2)


end

function UseWeaponRack()
	PlayAnimation("", "manipulate_middle_twohand")
end

function UseMagnify()
	PlayAnimation("", "manipulate_middle_twohand")
end

function UseFineTools()
	PlayAnimation("", "manipulate_middle_twohand")
end

function UseFineTools2()
	PlayAnimation("", "manipulate_top_r")
end

function UseCannon()
	PlayAnimation("", "wheel_in")
	ms_022_producegoods_StartRoomAni("","U_cannonmold",0)
	LoopAnimation("", "wheel_loop",14)
	PlayAnimation("", "wheel_out")
	Sleep(2)
	PlayAnimation("", "wheel_in")
	LoopAnimation("", "wheel_loop",8)
	ms_022_producegoods_StopRoomAni("","U_cannonmold",0)
	PlayAnimation("", "wheel_out")
end

function UseMeltingpot()
	-- SFX loc_smithy_meltingpot_01
	PlayAnimation("", "manipulate_middle_twohand")
end


