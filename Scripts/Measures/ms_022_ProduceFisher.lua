function GetLocator()

	local LocatorArray = {
		"work1", ms_022_producefisher_GutFish, "",
		"work2", ms_022_producefisher_GutFish, "",
		"work3", ms_022_producefisher_GutFish, "",
		"work4", ms_022_producefisher_GutFish, ""
		
	}
	local	LocatorCount = 4

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end


function GutFish()
	f_Stroll("",200,3)
	GetPosition("","MovePos")
	GfxAttachObject("fishbucket", "city/harbor/fishtable.nif")
	GfxSetPositionTo("fishbucket", "MovePos")
	PlayAnimation("","prep_fish_in")
	CarryObject("","Handheld_Device/ANIM_fish_L.nif",true)
	CarryObject("","Handheld_Device/ANIM_fishknife.nif",false)
	LoopAnimation("","prep_fish_loop",0)
	local Endtime = GetGametime() + 1
	
	while GetGametime() < Endtime do
		Sleep(1)
		--StartSingleShotParticle("particles/bloodsplash.nif","MovePos",0.5,3)	
	end
	CarryObject("","",false)
	CarryObject("","",true)
	PlayAnimation("","prep_fish_out")
	GfxDetachObject("fishbucket")
end


