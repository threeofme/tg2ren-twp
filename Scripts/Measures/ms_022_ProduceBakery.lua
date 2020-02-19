function GetLocator()

	--put all possible sequences into and array (StartingPossition,place_functionname,important neccessary Upgrade)
	local LocatorArray = {
		"Pump", ms_022_producebakery_PumpWater, "waterbarrel",
		"Peel", ms_022_producebakery_PutBreadsOutOfOven, "",
		"Churn", ms_022_producebakery_MakeButter, "",
		"Peel", ms_022_producebakery_CheckBreads, "ovenbig",
		"GetFlour", ms_022_producebakery_Pretzel, "",
		"BakedBreads", ms_022_producebakery_MoveBakedBread, "",
		"SaleCake", ms_022_producebakery_MoveCakeToSale, "",
		"SitBag", ms_022_producebakery_TakeARest, "",
		"GetFlour", ms_022_producebakery_Cookies, "",
		"GetRoller", ms_022_producebakery_MakeBreads, "",
		"SaleTable", ms_022_producebakery_SaleSomething, "",
	}
	
	--count of sequences
	local	LocatorCount = 11

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function Pretzel()
	--take some flour
	PlayAnimation("", "manipulate_bottom_r")
	
	--if own mixer then put the flour in the mixer, else but it in the dish on the table
	if BuildingHasUpgrade("WorkBuilding", "mixerhandheld") and GetLocatorByName("WorkBuilding", "MixerPut", "MixerPos") then
		f_MoveTo("","MixerPos")
		PlayAnimation("","manipulate_middle_low_l")
	else GetLocatorByName("WorkBuilding", "MakeCake", "MakeCakePos")
		f_MoveTo("","MakeCakePos")
		PlayAnimation("","manipulate_middle_low_l")
	end
	
	--get dough
--	if GetLocatorByName("WorkBuilding", "Dough", "GetDoughPos") then
--		f_MoveTo("","GetDoughPos")
		PlayAnimation("","manipulate_middle_low_r")
--	end
	
		
	
	--if own mixer then use the mixer to pund the dough, else make it by hand in the dish
	if BuildingHasUpgrade("WorkBuilding", "mixerhandheld") and GetLocatorByName("WorkBuilding", "Mixer", "MixerPos") then
--		f_MoveTo("","MixerPos")
		Sleep(1)
		PlayAnimation("","crank_side_in")
		ms_022_producegoods_StartRoomAni("","U_mixerhandheld",0)
		for i=0,10 do	
			PlaySound3D("","Locations/oilsqueezer+0.wav",1)
			PlayAnimation("", "crank_side_loop")
		end
		ms_022_producegoods_StopRoomAni("","U_mixerhandheld",-1)
		PlayAnimation("","crank_side_out")
		
	else GetLocatorByName("WorkBuilding", "DougPound", "DougPoundPos")
--		f_MoveTo("","DougPoundPos")
		
		--pound it one time, make a small break and pound it again
		local Time
		Time = PlayAnimationNoWait("","manipulate_middle_twohand")		
		SingleTime = (Time/10)
		Sleep(2)
		for i=0,4 do
			PlaySound3DVariation("","Locations/dough_knead_loop")
			Sleep(SingleTime)
		end 
		Sleep(SingleTime)
		PlayAnimation("", "cogitate")
		Time = PlayAnimationNoWait("","manipulate_middle_twohand")		
		SingleTime = (Time/10)
		Sleep(2)
		for i=0,4 do
			PlaySound3DVariation("","Locations/dough_knead_loop")
			Sleep(SingleTime)
		end 
		Sleep(SingleTime)
	end
	
	--if own mixer then get the poundet dough out of the mixer , else get it out of the dish
	if BuildingHasUpgrade("WorkBuilding", "mixerhandheld") and GetLocatorByName("WorkBuilding", "MixerPut", "MixerPutPos") then
--		f_MoveTo("","MixerPutPos")
		PlayAnimation("","manipulate_middle_low_l")
	elseif BuildingHasUpgrade("WorkBuilding", "workingareabig") and GetLocatorByName("WorkBuilding", "MakeCake", "MakeCakePos") then
		f_MoveTo("","MakeCakePos")
		PlayAnimation("","manipulate_middle_low_l")
	end	

	--if own workingareabig upgrade put it the poundet dough there
	if BuildingHasUpgrade("WorkBuilding", "workingareabig") and GetLocatorByName("WorkBuilding", "WorkingAreaBig", "WorkingAreaBigPos") then
		f_MoveTo("","WorkingAreaBigPos")
		PlayAnimation("","manipulate_middle_low_l")
	end	
	
	--if own workingareabig form the prezel
	if BuildingHasUpgrade("WorkBuilding", "workingareabig") and GetLocatorByName("WorkBuilding", "WorkingAreaBig2", "WorkingAreaBig2Pos") then
		f_MoveTo("","WorkingAreaBig2Pos")
		PlayAnimation("","manipulate_middle_twohand")
	end	
	
	--idle a bit
	PlayAnimation("", "cogitate")
end

function Cookies()
	--take some flour
	PlayAnimation("", "manipulate_bottom_r")
	
	--if own mixer then put the flour in the mixer, else but it in the dish on the table
	if BuildingHasUpgrade("WorkBuilding", "mixerhandheld") and GetLocatorByName("WorkBuilding", "MixerPut", "MixerPos") then
		f_MoveTo("","MixerPos")
		PlayAnimation("","manipulate_middle_low_l")
	else GetLocatorByName("WorkBuilding", "MakeCake", "MakeCakePos")
		f_MoveTo("","MakeCakePos")
		PlayAnimation("","manipulate_middle_low_l")
	end
	
	--get dough
--	if GetLocatorByName("WorkBuilding", "Dough", "GetDoughPos") then
--		f_MoveTo("","GetDoughPos")
		PlayAnimation("","manipulate_middle_low_r")
--	end
	
		
	
	--if own mixer then use the mixer to pund the dough, else make it by hand in the dish
	if BuildingHasUpgrade("WorkBuilding", "mixerhandheld") and GetLocatorByName("WorkBuilding", "Mixer", "MixerPos") then
--		f_MoveTo("","MixerPos")
		Sleep(1)
		PlayAnimation("","crank_side_in")
		ms_022_producegoods_StartRoomAni("","U_mixerhandheld",0)
		for i=0,10 do	
			PlaySound3D("","Locations/oilsqueezer+0.wav",1)
			PlayAnimation("", "crank_side_loop")
		end
		ms_022_producegoods_StopRoomAni("","U_mixerhandheld",-1)
		PlayAnimation("","crank_side_out")
	else GetLocatorByName("WorkBuilding", "DougPound", "DougPoundPos")
		f_MoveTo("","DougPoundPos")
		--pound it one time, make a small break and pound it again
		local Time
		Time = PlayAnimationNoWait("","manipulate_middle_twohand")		
		SingleTime = (Time/10)
		Sleep(2)
		for i=0,4 do
			PlaySound3DVariation("","Locations/dough_knead_loop")
			Sleep(SingleTime)
		end 
		Sleep(SingleTime)
		PlayAnimation("", "cogitate")
		Time = PlayAnimationNoWait("","manipulate_middle_twohand")		
		SingleTime = (Time/10)
		Sleep(2)
		for i=0,4 do
			PlaySound3DVariation("","Locations/dough_knead_loop")
			Sleep(SingleTime)
		end 
		Sleep(SingleTime)
	end
	
	--if own mixer then get the poundet dough out of the mixer , else get it out of the dish
	if BuildingHasUpgrade("WorkBuilding", "mixerhandheld") and GetLocatorByName("WorkBuilding", "MixerPut", "MixerPutPos") then
--		f_MoveTo("","MixerPutPos")
		PlayAnimation("","manipulate_middle_low_l")
	else GetLocatorByName("WorkBuilding", "MakeCake", "MakeCakePos")
		f_MoveTo("","MakeCakePos")
		PlayAnimation("","manipulate_middle_low_l")
	end		
	
	--if own AutomaticDoughRoller then put the dough in the AutomaticDoughRoller, else but i on the table next to the DoughRoller and take the Doughroller
	if BuildingHasUpgrade("WorkBuilding", "automaticdoughroller") and GetLocatorByName("WorkBuilding", "AutomaticDoughRoller", "AutomaticDoughRollerPos") then
		f_MoveTo("","AutomaticDoughRollerPos")
		PlayAnimation("","manipulate_middle_twohand")
	else GetLocatorByName("WorkBuilding", "GetRoller", "GetRollerPos")
		f_MoveTo("","GetRollerPos")
		local Time = PlayAnimationNoWait("","manipulate_middle_low_r")
		Sleep(1.5)
--		HideObject("", "DoughRoller_handheld")
		CarryObject("","Handheld_Device/Anim_doughroller.nif",false)
		Sleep(Time-1.5)
	end
	
	--if doesnt own AutomaticDoughRoller then get some flour
	if not BuildingHasUpgrade("WorkBuilding", "automaticdoughroller") and GetLocatorByName("WorkBuilding", "GetFlour", "GetFlourPos") then
		f_MoveTo("","GetFlourPos")
		PlayAnimation("","manipulate_middle_low_l")
	end

	--if doesnt own AutomaticDoughRoller then go back to the table and use the DoughRoller
	if not BuildingHasUpgrade("WorkBuilding", "automaticdoughroller") and GetLocatorByName("WorkBuilding", "RollerWork", "RollerWorkPos") then
		f_MoveTo("","RollerWorkPos")
		PlayAnimation("","manipulate_middle_twohand")
	end
	
	--if doesnt own AutomaticDoughRoller then put the DoughRoller back
	if not BuildingHasUpgrade("WorkBuilding", "automaticdoughroller") and GetLocatorByName("WorkBuilding", "GetRoller", "RollerPos") then
		f_MoveTo("","RollerPos")
		local Time = PlayAnimationNoWait("","manipulate_middle_low_r")
		Sleep(1)
--		ShowObject("", "DoughRoller_handheld")
		CarryObject("","",false)
		Sleep(Time-1)
	end	
	
	--if own AutomaticDoughRoller then use it
	if BuildingHasUpgrade("WorkBuilding", "automaticdoughroller") and GetLocatorByName("WorkBuilding", "AutomaticDoughRollerWork", "AutomaticDoughRollerWorkPos") then
		f_MoveTo("","AutomaticDoughRollerWorkPos")
		PlayAnimation("","crank_front_in_02")
		ms_022_producegoods_StartRoomAni("","U_automaticdoughroller",0)
		LoopAnimation("","crank_front_loop_02", 10)
		ms_022_producegoods_StopRoomAni("","U_automaticdoughroller",-1)
		PlayAnimation("","crank_front_out_02")
	end
	
	--if own AutomaticDoughRoller then get the Dough out of the AutomaticDoughRoller
	if BuildingHasUpgrade("WorkBuilding", "automaticdoughroller") and GetLocatorByName("WorkBuilding", "AutomaticDoughRoller", "AutomaticDoughRollerPos") then
		f_MoveTo("","AutomaticDoughRollerPos")
		PlayAnimation("","manipulate_middle_twohand")
	end	
	
	--if own AutomaticDoughRoller then put the Rough on the Tale next to the DoughRoller
	if BuildingHasUpgrade("WorkBuilding", "automaticdoughroller") and GetLocatorByName("WorkBuilding", "GetRoller", "RollerPos") then
		f_MoveTo("","RollerPos")
		PlayAnimation("","manipulate_middle_low_r")
	end	
	
	--if own PastryEquipment then get some Equipments
	if BuildingHasUpgrade("WorkBuilding", "pastryequipment") and GetLocatorByName("WorkBuilding", "PastryEquipment", "PastryEquipmentPos") then
		f_MoveTo("","PastryEquipmentPos")
		PlayAnimation("","manipulate_middle_twohand")
	end
	
	--if own PastryEquipment then use it on the Dough on the table
	if BuildingHasUpgrade("WorkBuilding", "pastryequipment") and GetLocatorByName("WorkBuilding", "RollerWork", "RollerWorkPos") then
		f_MoveTo("","RollerWorkPos")
		PlayAnimation("","manipulate_middle_twohand")
	end	
	
	--if own PastryEquipment then previously used equipment back
	if BuildingHasUpgrade("WorkBuilding", "pastryequipment") and GetLocatorByName("WorkBuilding", "PastryEquipment", "PastryEquipmentPos") then
		f_MoveTo("","PastryEquipmentPos")
		PlayAnimation("","manipulate_middle_twohand")
	end
	
	--if own PastryEquipment then get the cuted Dough of the Table
	if BuildingHasUpgrade("WorkBuilding", "pastryequipment") and GetLocatorByName("WorkBuilding", "RollerWork", "RollerWorkPos") then
		f_MoveTo("","RollerWorkPos")
		PlayAnimation("","manipulate_middle_twohand")
	end		

	--if own workingareabig upgrade put it the poundet dough there
	if BuildingHasUpgrade("WorkBuilding", "workingareabig") and GetLocatorByName("WorkBuilding", "WorkingAreaBig", "WorkingAreaBigPos") then
		f_MoveTo("","WorkingAreaBigPos")
		PlayAnimation("","manipulate_middle_low_l")
	end	
	
	--if own workingareabig form the prezel
	if BuildingHasUpgrade("WorkBuilding", "workingareabig") and GetLocatorByName("WorkBuilding", "WorkingAreaBig2", "WorkingAreaBig2Pos") then
		f_MoveTo("","WorkingAreaBig2Pos")
		PlayAnimation("","manipulate_middle_twohand")
	end	
	
	PlayAnimation("", "cogitate")
end

function MoveBakedBread()
	-- Take allready baked breads and Put it on the Shelf to the other alrleady baked breads in the sale area
	local Time = PlayAnimationNoWait("", "manipulate_middle_low_l")
	Sleep(1.6)
	CarryObject("","Locations/Bakery/Bread_round.nif",true)
	Sleep(Time-1.6)
	MoveSetActivity("","carrypeel")
	if GetLocatorByName("WorkBuilding", "BreadsShelf", "BreadsShelfPos") then
		f_MoveTo("","BreadsShelfPos")
		local Time = PlayAnimationNoWait("", "manipulate_middle_up_l")
		Sleep(1.6)
		CarryObject("","",true)
		Sleep(Time-1.6)
		MoveSetActivity("","")
	end
	CarryObject("","",true)
end

function CheckBreads()
	MoveSetActivity("","carrypeel")
	Sleep(1.7)			
--	HideObject("", "Bread_pusher")
	CarryObject("","Handheld_Device/ANIM_peel.nif",false)	
	Sleep(3.45-1.7)					
	if GetLocatorByName("WorkBuilding", "Oven", "OvenPos") then
		f_MoveTo("","OvenPos")
		local Time
		Time = PlayAnimationNoWait("","peel_take_bread_put_oven")
		Sleep(3)
		CarryObject("","Handheld_Device/ANIM_peel_bread_dough.nif",false)
		Sleep(4)
		CarryObject("","Handheld_Device/ANIM_peel.nif",false)
		Sleep(Time-7)
	end
	if GetLocatorByName("WorkBuilding","Peel", "PeelPos") then
		f_MoveTo("","PeelPos")
		Sleep(2.9)
		MoveSetActivity("","")
		Sleep(1.9)
--		ShowObject("", "Bread_pusher")
		CarryObject("","",false)
		PlayAnimation("","cogitate")
	end
	CarryObject("","",false)
	MoveSetActivity("","")
end


function PutBreadsOutOfOven()
	MoveSetActivity("","carrypeel")
	Sleep(1.7)		
--	HideObject("", "Bread_pusher")	
	CarryObject("","Handheld_Device/ANIM_peel.nif",false)	
	Sleep(3.45-1.7)
	local Time = 0				
	if GetLocatorByName("WorkBuilding", "Oven2", "Oven2Pos") then
		f_MoveTo("","Oven2Pos")
		Sleep(1)
		Time = PlayAnimationNoWait("","peel_bread_out_oven")
		Sleep(4.5)
		CarryObject("","Handheld_Device/ANIM_peel_bread.nif",false)
		Sleep(3.5)
		CarryObject("","Handheld_Device/ANIM_peel.nif",false)
		Sleep(Time-7)
	end
	if GetLocatorByName("WorkBuilding", "Peel", "PeelPos") then
		f_MoveTo("","PeelPos")
		Sleep(1)
		MoveSetActivity("","")
		Sleep(1.9)
--		ShowObject("", "Bread_pusher")
		CarryObject("","",false)
		Sleep(2)
	end
	CarryObject("","",false)
end

function MakeBreads()
	--get the doughroller
	local Time = PlayAnimationNoWait("","manipulate_middle_low_r")
	Sleep(1.5)
--	HideObject("", "DoughRoller_handheld")
	CarryObject("","Handheld_Device/Anim_doughroller.nif",false)
	Sleep(Time-1.5)
	
	--get some flour
	if GetLocatorByName("WorkBuilding", "GetFlour", "GetFlourPos") then
		f_MoveTo("","GetFlourPos")
		PlayAnimation("","manipulate_middle_low_l")
	end
	
	--make some bread
	if GetLocatorByName("WorkBuilding", "MakeCake", "MakeCakePos") then
		f_MoveTo("","MakeCakePos")
		PlayAnimation("","manipulate_middle_twohand")
	end
	
	--lay back the roller
	if GetLocatorByName("WorkBuilding", "GetRoller", "RollerPos") then
		f_MoveTo("","RollerPos")
		local Time = PlayAnimationNoWait("","manipulate_middle_low_r")
		Sleep(1)
--		ShowObject("", "DoughRoller_handheld")
		CarryObject("","",false)
		Sleep(Time-1)
	end
	CarryObject("","",false)
end

function SaleSomething()
	--stand around for some time
	Sleep(8)
	
	--take a look at the prezel in the board
	if GetLocatorByName("WorkBuilding", "SaleBoard", "SaleBoardPos") then
		f_MoveTo("","SaleBoardPos")
		PlayAnimation("","manipulate_middle_twohand")
		Sleep(2)
	end
	
	--take a look at the cakes on the table
	if GetLocatorByName("WorkBuilding", "SaleCake", "SaleCakePos") then
		f_MoveTo("","SaleCakePos")
		PlayAnimation("","manipulate_middle_twohand")
		Sleep(2)
	end	
	
	PlayAnimation("", "cogitate")
	
	--take a look at the bread in the board
	if GetLocatorByName("WorkBuilding", "BreadsSale", "BreadsSalePos") then
		f_MoveTo("","BreadsSalePos")
		PlayAnimation("","manipulate_middle_up_l")
		Sleep(2)
	end	
end


function TakeARest()
	-- take a rest on the flourbags
	PlayAnimation("","sit_down")
	LoopAnimation("", "sit_idle", 10)
	PlayAnimation("","stand_up")
	PlayAnimation("", "cogitate")
end

function MoveCakeToSale()
	--take a look at the cakes on the table
	PlayAnimation("","manipulate_middle_twohand")
	
	--if own SpicarySave get Cake from there, else get it from the Shelf beside
	if BuildingHasUpgrade("WorkBuilding", "spicerysafe") and GetLocatorByName("WorkBuilding", "SpicerySafe", "SpicerySafePos") then
		f_MoveTo("","SpicerySafePos")
		PlayAnimation("", "manipulate_middle_twohand")
	elseif GetLocatorByName("WorkBuilding", "CakeShelf", "CakeShelfPos") then
		f_MoveTo("","CakeShelfPos")
		PlayAnimation("", "manipulate_middle_twohand")
	end
	
	--but Cake on the SaleTable
	if GetLocatorByName("WorkBuilding", "SaleCake", "SaleCakePos") then
		f_MoveTo("","SaleCakePos")
		PlayAnimation("", "manipulate_middle_twohand")
	end
end


function MakeButter()
	--do the churn!
	local time = PlayAnimationNoWait("","churn")
	ms_022_producegoods_StartRoomAni("","U_Buttertub",0)
	Sleep(time)
	ms_022_producegoods_StopRoomAni("","U_Buttertub",-1)
end

function PumpWater()
	--PUMP IT
	PlayAnimation("","pumping_in")
	LoopAnimation("","pumping_loop",-1)
	ms_022_producegoods_StartRoomAni("","U_waterbarrel",0)
	Sleep(5)
	ms_022_producegoods_StopRoomAni("","U_waterbarrel",-1)
	PlayAnimation("","pumping_out")
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
