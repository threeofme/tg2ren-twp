function GetLocator()

	local LocatorArray = {
		"Cooking1", ms_022_producetavern_Cooking1, "",
		"Cooking2", ms_022_producetavern_Cooking2, "",
		"Cooking3", ms_022_producetavern_Cooking3, "",
		"Spice1", ms_022_producetavern_SpiceTheSpit, "",
		"Carrot", ms_022_producetavern_CookCarrot, "",
		"Brewer", ms_022_producetavern_LookAfterTheBeer, "",
	}
	local	LocatorCount = 6 

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function Cooking1()
	local Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
	Sleep(2)
	PlaySound3DVariation("","Locations/herbs",1)
	Sleep(Time-2)
end

function Cooking2()
	PlayAnimation("", "manipulate_bottom_r")
	if GetLocatorByName("WorkBuilding", "Cooking2b", "Cooking2bPos") then
		f_MoveTo("","Cooking2bPos")
		PlayAnimation("", "manipulate_middle_low_l")
	end
end

function Cooking3()
	
	local Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
	Sleep(2)
	PlaySound3DVariation("","Locations/herbs",1)
	Sleep(Time-2)
	if BuildingHasUpgrade("WorkBuilding", "CookingPot") and GetLocatorByName("WorkBuilding", "CookingPot", "CookingPotPos") then
		f_MoveTo("","CookingPotPos")
		Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
		Sleep(2)
		PlaySound3DVariation("","Locations/herbs",1)
		Sleep(Time-1)
		
		PlayAnimation("","cogitate")
	end
end

function SpiceTheSpit()
	--get some spice
	PlayAnimation("","manipulate_middle_low_r")
	local Time = 0
	--get some more spice
	if GetLocatorByName("WorkBuilding", "Spice2", "Spice2Pos") then
		f_MoveTo("","Spice2Pos")
		Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
		Sleep(2)
		PlaySound3DVariation("","Effects/digging_box",1)
		Sleep(Time-2)
	end
	
	--if there is an spit, go there an spice it
	if BuildingHasUpgrade("WorkBuilding", "Spit") and GetLocatorByName("WorkBuilding", "Spit", "SpitPos") then
		f_MoveTo("","SpitPos")
		PlayAnimation("","manipulate_middle_low_r")
		Sleep(2)
		PlayAnimation("","manipulate_middle_low_l")
		Sleep(1)
	end
	
	if GetLocatorByName("WorkBuilding", "Spice2", "Spice2Pos") then
		f_MoveTo("","Spice2Pos")
		Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
		Sleep(2)
		PlaySound3DVariation("","Effects/digging_shelf",1)
		Sleep(Time-2)
	end
	
	
end

function CookCarrot()
	local Time
	--get some carrots
	Time = PlayAnimationNoWait("","manipulate_middle_low_r")
	Sleep(1)
	CarryObject("","Handheld_Device/ANIM_carrot.nif",false)
	Sleep(Time-1)
	
	--move to the pot an drop carrot
	if GetLocatorByName("WorkBuilding", "Pot", "PotPos") then
		f_MoveTo("","PotPos")
		Time = PlayAnimationNoWait("","manipulate_middle_twohand")
		Sleep(3)
		CarryObject("","",false)
		Sleep(Time-3)
	end
	
	--move to the garbage
	if BuildingHasUpgrade("WorkBuilding", "GarbageTrap") and GetLocatorByName("WorkBuilding", "GarbageTrap", "GarbageTrapPos") then
		f_MoveTo("","GarbageTrapPos")
		PlayAnimation("","manipulate_middle_low_r")
	end
end

function LookAfterTheBeer()
	PlayAnimation("","manipulate_bottom_r")
	Sleep(2)
	local Time = PlayAnimationNoWait("", "manipulate_middle_twohand")
	Sleep(2)
	PlaySound3DVariation("","Effects/digging_box",1)
	Sleep(Time-2)
	
	--move to the barrel
	if GetLocatorByName("WorkBuilding", "Barrel", "BarrelPos") then
		f_MoveTo("","BarrelPos")
		PlayAnimation("","manipulate_middle_twohand")
		if SimGetProduceItemID("") == 40 then --alcohol
			CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
			PlayAnimationNoWait("","use_potion_standing")
			Sleep(6)
			CarryObject("","",false)
			LoopAnimation("","idle_drunk",5)
		end
	end
end




