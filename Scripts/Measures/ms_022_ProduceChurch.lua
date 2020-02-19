function GetLocator()

	local LocatorArray = {
		"ChairA", ms_022_producechurch_SitAround, "",
		"ChairD", ms_022_producechurch_ReadBook, "",
		"ShelfA", ms_022_producechurch_ControlBooks, "",
		"ShelfD", ms_022_producechurch_CarryBooks, "SetOfBookShelves",
		"Desk", ms_022_producechurch_WriteBooks, "",}
	local	LocatorCount = 5

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function SitAround() --ChairA,ChairB,ShelfB
	MoveSetStance("",GL_STANCE_SIT)
	CarryObject("","Handheld_Device/ANIM_ink_feather.nif",false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","sit_write_in")
	for i=0,10 do
		PlaySound3DVariation("","Locations/nib_write_loop",1)
		PlayAnimation("","sit_write_loop")
	end
	PlayAnimation("","sit_write_out")
	CarryObject("","",false)
	
	MoveSetStance("",GL_STANCE_STAND)
	GetLocatorByName("WorkBuilding","ChairB","ChairPos")
	f_BeginUseLocator("","ChairPos",GL_STANCE_SIT,true)
	CarryObject("","Handheld_Device/ANIM_ink_feather.nif",false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","sit_write_in")
	for i=0,10 do
		PlaySound3DVariation("","Locations/nib_write_loop",1)
		PlayAnimation("","sit_write_loop")
	end
	PlayAnimation("","sit_write_out")
	CarryObject("","",false)
	f_EndUseLocator("","ChairPos",GL_STACE_STAND)
	Sleep(1)
	GetLocatorByName("WorkBuilding","ShelfB","ShelfPos")
	f_BeginUseLocator("","ShelfPos",GL_STANCE_STAND,true)
	Sleep(0.5)
	PlayAnimation("","cogitate")
	local Time = PlayAnimationNoWait("","manipulate_top_r")
	Sleep(2.5)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
	Sleep(Time-2.5)
	CarryObject("","Handheld_Device/ANIM_book.nif", false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","use_book_standing")
	CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	Time = PlayAnimationNoWait("","manipulate_top_r")
	Sleep(2.5)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","",false)
	Sleep(Time)
	f_EndUseLocator("","ShelfPos",GL_STACE_STAND)
end

function ReadBook() --ChairC,ShelfC,ChairD
	MoveSetStance("",GL_STANCE_SIT)
	CarryObject("","Handheld_Device/ANIM_ink_feather.nif",false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","sit_write_in")
	for i=0,10 do
		PlaySound3DVariation("","Locations/nib_write_loop",1)
		PlayAnimation("","sit_write_loop")
	end
	PlayAnimation("","sit_write_out")
	CarryObject("","",false)
	MoveSetStance("",GL_STANCE_STAND)
	GetLocatorByName("WorkBuilding","ShelfC","ShelfPos")
	f_BeginUseLocator("","ShelfPos",GL_STANCE_STAND,true)
	Sleep(0.5)
	PlayAnimation("","cogitate")
	local Time = PlayAnimationNoWait("","manipulate_top_r")
	Sleep(2.5)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
	Sleep(Time-2.5)
	CarryObject("","Handheld_Device/ANIM_book.nif", false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","use_book_standing")
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
	Time = PlayAnimationNoWait("","manipulate_top_r")
	Sleep(2.5)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","",false)
	Sleep(Time)
	f_EndUseLocator("","ShelfPos",GL_STACE_STAND)
	GetLocatorByName("WorkBuilding","ChairD","ChairPos")
	f_BeginUseLocator("","ChairPos",GL_STANCE_SIT,true)
	CarryObject("","Handheld_Device/ANIM_ink_feather.nif",false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","sit_write_in")
	for i=0,10 do
		PlaySound3DVariation("","Locations/nib_write_loop",1)
		PlayAnimation("","sit_write_loop")
	end
	PlayAnimation("","sit_write_out")
	CarryObject("","",false)
	f_EndUseLocator("","ChairPos",GL_STACE_STAND)
	Sleep(1)
end

function ControlBooks() --ShelfA,ShelfE,ChairE
	PlayAnimation("","cogitate")
	local Time = PlayAnimationNoWait("","manipulate_middle_up_r")
	Sleep(2.5)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
	Sleep(Time-2.5)
	CarryObject("","Handheld_Device/ANIM_book.nif", false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","use_book_standing")
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
	Time = PlayAnimationNoWait("","manipulate_middle_up_r")
	Sleep(2.5)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","",false)
	Sleep(Time)
	GetLocatorByName("WorkBuilding","ShelfE","ShelfPos")
	f_BeginUseLocator("","ShelfPos",GL_STANCE_STAND,true)
	Sleep(0.5)
	PlayAnimation("","cogitate")
	local Time = PlayAnimationNoWait("","manipulate_top_r")
	Sleep(2.5)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
	Sleep(Time-2.5)
	CarryObject("","Handheld_Device/ANIM_book.nif", false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","use_book_standing")
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
	Time = PlayAnimationNoWait("","manipulate_top_r")
	Sleep(2.5)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","",false)
	Sleep(Time)
	f_EndUseLocator("","ShelfPos",GL_STACE_STAND)
	GetLocatorByName("WorkBuilding","ChairE","ChairPos")
	f_BeginUseLocator("","ChairPos",GL_STANCE_SIT,true)
	CarryObject("","Handheld_Device/ANIM_ink_feather.nif",false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","sit_write_in")
	for i=0,10 do
		PlaySound3DVariation("","Locations/nib_write_loop",1)
		PlayAnimation("","sit_write_loop")
	end
	PlayAnimation("","sit_write_out")
	CarryObject("","",false)
	f_EndUseLocator("","ChairPos",GL_STACE_STAND)
	Sleep(1)
end

function CarryBooks() --ShelfD,ShelfF,ShelfG
	MoveSetActivity("","carry")
	Sleep(2)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","Handheld_Device/ANIM_bookpile.nif",false)
	Sleep(2)
	GetLocatorByName("WorkBuilding", "ShelfF", "ShelfPos")
	f_MoveTo("","ShelfPos")
	Sleep(0.7)
	MoveSetActivity("","")
	Sleep(2)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","",false)
	Sleep(2)
	GetLocatorByName("WorkBuilding", "ShelfG", "ShelfPos")
	f_MoveTo("","ShelfPos")
	MoveSetActivity("","carry")
	Sleep(2)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	CarryObject("","Handheld_Device/ANIM_bookpile.nif",false)
	Sleep(2)
	GetLocatorByName("WorkBuilding", "ShelfD", "ShelfPos")
	f_MoveTo("","ShelfPos")
	Sleep(0.7)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	MoveSetActivity("","")
	Sleep(2)
	CarryObject("","",false)
	Sleep(2)
end

function WriteBooks() --Desk
	PlayAnimation("", "manipulate_middle_twohand")
	PlayAnimation("","cogitate")
	PlayAnimation("", "manipulate_middle_twohand")
end


