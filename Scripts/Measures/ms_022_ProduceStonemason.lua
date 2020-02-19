function GetLocator()

	local LocatorArray = {
		"Work1", ms_022_producestonemason_UseKnight,"",
		"Work2", ms_022_producestonemason_UseHead,"",
		"Work3", ms_022_producestonemason_UseRavenA,"",
		"Work5", ms_022_producestonemason_UseRavenB,"",
		"Work4", ms_022_producestonemason_UseDudeA,"",
	--	"Work6", ms_022_producestonemason_UseDudeB,"",
		"Work7", ms_022_producestonemason_UsePodest,"plaene",
		"Work8", ms_022_producestonemason_UseMarmorA,"",
		"Work9", ms_022_producestonemason_UseMarmorB,"",
	}
	local	LocatorCount = 8

	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function UseKnight()

	GetLocatorByName("WorkBuilding","Work1","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
		
	CarryObject("","Handheld_Device/ANIM_metahammer.nif", false)
	Sleep(0.5)
	PlayAnimation("","chop_in")
	for i=0,8 do
		local waite = PlayAnimationNoWait("","chop_loop")
		Sleep(0.5)
		PlaySound3DVariation("","Locations/hammer_stone",1.0)
		Sleep(waite-0.5)
	end
	PlayAnimation("","chop_out")
	CarryObject("","",false)

	if Rand(10) <= 1 then
	    CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	    PlayAnimation("","hoe_in")	
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hoe_loop")
		    Sleep(0.5)
		    PlaySound3DVariation("","Locations/herbs",1.0)
		    Sleep(waite-0.5)
	    end
		PlayAnimation("","hoe_out")
		CarryObject("","",false)
    end	
	
end

function UseHead()

	GetLocatorByName("WorkBuilding","Work2","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	CarryObject("","Handheld_Device/ANIM_metahammer.nif", false)
	Sleep(0.5)
	PlayAnimation("","chop_in")
	for i=0,8 do
		local waite = PlayAnimationNoWait("","chop_loop")
		Sleep(0.5)
		PlaySound3DVariation("","Locations/hammer_stone",1.0)
		Sleep(waite-0.5)
	end
	PlayAnimation("","chop_out")
	CarryObject("","",false)

	if Rand(10) <= 1 then
	    CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	    PlayAnimation("","hoe_in")	
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hoe_loop")
		    Sleep(0.5)
		    PlaySound3DVariation("","Locations/herbs",1.0)
		    Sleep(waite-0.5)
	    end
		PlayAnimation("","hoe_out")
		CarryObject("","",false)
    end		
	
end

function UseRavenB()

	GetLocatorByName("WorkBuilding","Work5","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
    PlayAnimation("", "manipulate_middle_twohand")

	if Rand(10) <= 1 then
	    CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	    PlayAnimation("","hoe_in")	
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hoe_loop")
		    Sleep(0.5)
		    PlaySound3DVariation("","Locations/herbs",1.0)
		    Sleep(waite-0.5)
	    end
		PlayAnimation("","hoe_out")
		CarryObject("","",false)
    end		
	
end

function UseRavenA()

	GetLocatorByName("WorkBuilding","Work3","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	local Time = PlayAnimationNoWait("", "saw")
	CarryObject("","Handheld_Device/Anim_File_A.nif",false)
	Sleep(3)
	for i=0,8 do
		PlaySound3DVariation("","Locations/handsaw",1.0)
		Sleep(1)
	end
	Sleep(Time-12)
	CarryObject("","",false)

	if Rand(10) <= 1 then
	    CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	    PlayAnimation("","hoe_in")	
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hoe_loop")
		    Sleep(0.5)
		    PlaySound3DVariation("","Locations/herbs",1.0)
		    Sleep(waite-0.5)
	    end
		PlayAnimation("","hoe_out")
		CarryObject("","",false)
    end		
	
end

function UseDudeA()

	GetLocatorByName("WorkBuilding","Work4","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	local Time = PlayAnimationNoWait("", "saw")
	CarryObject("","Handheld_Device/Anim_File_A.nif",false)
	Sleep(3)
	for i=0,8 do
		PlaySound3DVariation("","Locations/handsaw",1.0)
		Sleep(1)
	end
	Sleep(Time-12)
	CarryObject("","",false)

	if Rand(10) <= 1 then
	    CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	    PlayAnimation("","hoe_in")	
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hoe_loop")
		    Sleep(0.5)
		    PlaySound3DVariation("","Locations/herbs",1.0)
		    Sleep(waite-0.5)
	    end
		PlayAnimation("","hoe_out")
		CarryObject("","",false)
    end		
	
end

function UseDudeB()

	GetLocatorByName("WorkBuilding","Work6","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	CarryObject("","Handheld_Device/ANIM_metahammer.nif", false)
	Sleep(0.5)
	PlayAnimation("","hammer_in")
	for i=0,8 do
		local waite = PlayAnimationNoWait("","hammer_loop")
		Sleep(1)
		PlaySound3DVariation("","Locations/hammer_stone",1.0)
		Sleep(waite-1)
	end
	PlayAnimation("","hammer_out")
	CarryObject("","",false)

	if Rand(10) <= 1 then
	    CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	    PlayAnimation("","hoe_in")	
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hoe_loop")
		    Sleep(0.5)
		    PlaySound3DVariation("","Locations/herbs",1.0)
		    Sleep(waite-0.5)
	    end
		PlayAnimation("","hoe_out")
		CarryObject("","",false)
    end	
	
end

function UsePodest()

	GetLocatorByName("WorkBuilding","Work7","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

    local Time = PlayAnimationNoWait("","use_book_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/Anim_openscroll.nif",false)
	Sleep(Time-3)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(0.5)
	CarryObject("","",false)

end

function UseMarmorA()

	GetLocatorByName("WorkBuilding","Work8","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	local Time = PlayAnimationNoWait("", "saw")
	CarryObject("","Handheld_Device/Anim_File_A.nif",false)
	Sleep(3)
	for i=0,8 do
		PlaySound3DVariation("","Locations/handsaw",1.0)
		Sleep(1)
	end
	Sleep(Time-12)
	CarryObject("","",false)

	if Rand(10) <= 1 then
	    CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	    PlayAnimation("","hoe_in")	
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hoe_loop")
		    Sleep(0.5)
		    PlaySound3DVariation("","Locations/herbs",1.0)
		    Sleep(waite-0.5)
	    end
		PlayAnimation("","hoe_out")
		CarryObject("","",false)
    end		
	
end

function UseMarmorB()

	GetLocatorByName("WorkBuilding","Work9","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

    CarryObject("","Handheld_Device/Anim_File.nif",false)	
	PlayAnimation("","knee_work_in")
	LoopAnimation("","knee_work_loop",10)
	PlayAnimation("","knee_work_out")
	CarryObject("","",false)

	if Rand(10) <= 1 then
	    CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	    PlayAnimation("","hoe_in")	
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hoe_loop")
		    Sleep(0.5)
		    PlaySound3DVariation("","Locations/herbs",1.0)
		    Sleep(waite-0.5)
	    end
		PlayAnimation("","hoe_out")
		CarryObject("","",false)
    end		
	
end
