function GetLocator()

	local LocatorArray = {
		"Chair1", ms_022_producehospital_SitAround, "",
		"Balance", ms_022_producehospital_MakeMedicine, "",
		"Study", ms_022_producehospital_WatchStudy, "",
		"MedicTable", ms_022_producehospital_MedicTable, "",
		"Bowl", ms_022_producehospital_Bowl, ""
		}
	local	LocatorCount = 5

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function MedicTable()
	PlayAnimation("","manipulate_middle_twohand")
	GetLocatorByName("WorkBuilding","Instruments","InstrumentPos")
	f_BeginUseLocator("","InstrumentPos",GL_STANCE_STAND,true)
	PlayAnimation("","manipulate_middle_low_r")
end

function Bowl()
	PlayAnimation("","manipulate_middle_twohand")
end

function SitAround() 
	MoveSetStance("",GL_STANCE_SITBENCH)
	Sleep(10)
	f_EndUseLocator("","ShelfPos",GL_STACE_STAND)
end

function MakeMedicine() 
	PlayAnimation("","manipulate_middle_twohand")
	GetLocatorByName("WorkBuilding","Board","BoardPos")
	f_BeginUseLocator("","BoardPos",GL_STANCE_STAND,true)
	if Rand(100)<70 then
		PlayAnimation("","cogitate")
	end
	local AnimTime = PlayAnimationNoWait("","manipulate_middle_up_r")
	Sleep(1)
	PlaySound3DVariation("","Effects/digging_shelf",1)
	Sleep(AnimTime-1)
	GetLocatorByName("WorkBuilding","Balance","BalancePos")
	f_BeginUseLocator("","BalancePos",GL_STANCE_STAND,true)
	PlayAnimation("","manipulate_middle_twohand")
end

function WatchStudy() 
	PlayAnimation("","cogitate")
	
	CarryObject("","Handheld_Device/ANIM_book.nif", false)
	PlaySound3D("","CharacterFX/open_book+0.wav",1)
	PlayAnimation("","use_book_standing")
	PlaySound3D("","CharacterFX/open_book+0.wav",1)	
	CarryObject("","",false)
	
	Sleep(0.5)
	
end



