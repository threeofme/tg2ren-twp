function GetLocator()

	local    LocatorArray = {
	  "Work1", ms_022_producebankier_UsePultA,"",
		"Work2", ms_022_producebankier_UsePultB,"",
		"Work4", ms_022_producebankier_UseThresenA,"",
		"Work5", ms_022_producebankier_UseThresenB,"",
		"Work6", ms_022_producebankier_UseThresenC,"",
		"Work7", ms_022_producebankier_UseThresenD,"",
		"Work8", ms_022_producebankier_UseRegal,"",
		"Work9", ms_022_producebankier_UseTresor,"",
		"Work10", ms_022_producebankier_UsePultC,"",
		"Work11", ms_022_producebankier_UsePultD,"",
	    }
	
	local LocatorCount = 10
  local Position = (Rand(LocatorCount))*3+1
	
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function UseSchreibt()

	GetLocatorByName("WorkBuilding","Work3","ChairPos")
	f_BeginUseLocator("","ChairPos",GL_STANCE_SIT,true)
	
	while true do
		local doWork = Rand(4)
		if doWork == 0 then
			PlayAnimation("","sit_talk")
		elseif doWork == 1 then
		  PlayAnimation("","sit_talk_02")
		elseif doWork == 2 then
		  PlayAnimation("","sit_laugh")
		else
      PlayAnimation("","sit_idle")
    end	
	  Sleep(3)
	end
end

function UsePultA()

	GetLocatorByName("WorkBuilding","Work1","ChairPos")
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

function UsePultB()

	GetLocatorByName("WorkBuilding","Work2","ChairPos")
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

function UsePultC()

	GetLocatorByName("WorkBuilding","Work10","ChairPos")
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

function UsePultD()

	GetLocatorByName("WorkBuilding","Work11","ChairPos")
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

function UseThresenA()

	GetLocatorByName("WorkBuilding","Work4","ThresPos")
	f_BeginUseLocator("","ThresPos",GL_STANCE_STAND,true)
	
	PlayAnimation("","manipulate_middle_up_r")
	
	local aniTime = PlayAnimationNoWait("","use_book_standing") 
	Sleep(1)
	if Rand(2) == 0 then
	    CarryObject("","Handheld_Device/ANIM_book.nif",false)
	else
		CarryObject("","Handheld_Device/ANIM_openscroll.nif",false)
	end
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(aniTime-2)
	CarryObject("","",false)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)

end

function UseThresenB()

	GetLocatorByName("WorkBuilding","Work5","ThresPos")
	f_BeginUseLocator("","ThresPos",GL_STANCE_STAND,true)

    if Rand(2) == 0 then	
	    PlayAnimation("","manipulate_bottom_r")
	else
	    PlayAnimation("","manipulate_middle_low_l")
	end
	
	local aniTime = PlayAnimationNoWait("","use_book_standing") 
	Sleep(1)
	if Rand(2) == 0 then
	    CarryObject("","Handheld_Device/ANIM_book.nif",false)
	else
		CarryObject("","Handheld_Device/ANIM_openscroll.nif",false)
	end
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(aniTime-2)
	CarryObject("","",false)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)

end

function UseThresenC()
	
	GetLocatorByName("WorkBuilding","Work6","ThresPos")
	f_BeginUseLocator("","ThresPos",GL_STANCE_STAND,true)

    if Rand(2) == 0 then	
	    PlayAnimation("", "cogitate")
	else
	    PlayAnimation("","manipulate_middle_up_r")
	end
	
	if HasProperty("WorkBuilding","BankKundschaft") then
	    if GetProperty("WorkBuilding","BankKundschaft") == 1 then
            local beweg = PlayAnimationNoWait("","talk") 
		    if SimGetGender("") == 1 then
			    PlaySound3DVariation("","CharacterFX/male_neutral",1)
		    else
			    PlaySound3DVariation("","CharacterFX/female_neutral",1)
	        end
		    Sleep(beweg)
		end
    end

end

function UseThresenD()

	GetLocatorByName("WorkBuilding","Work7","ThresPos")
	f_BeginUseLocator("","ThresPos",GL_STANCE_STAND,true)

    if Rand(2) == 0 then	
	    PlayAnimation("", "cogitate")
	else
	    PlayAnimation("","manipulate_middle_low_l")
	end
	
	if HasProperty("WorkBuilding","BankKundschaft") then
	    if GetProperty("WorkBuilding","BankKundschaft") == 1 then
            local beweg = PlayAnimationNoWait("","talk") 
		    if SimGetGender("") == 1 then
			    PlaySound3DVariation("","CharacterFX/male_neutral",1)
		    else
			    PlaySound3DVariation("","CharacterFX/female_neutral",1)
	        end
		    Sleep(beweg)
		end
    end

end

function UseRegal()

	GetLocatorByName("WorkBuilding","Work8","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	PlayAnimation("", "cogitate")
	local animat = Rand(3)
	if animat == 0 then
	    local aniTime = PlayAnimationNoWait("","use_book_standing") 
	    Sleep(1)
	    CarryObject("","Handheld_Device/ANIM_book.nif",false)
	    PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	    Sleep(aniTime-2)
	    CarryObject("","",false)
	    PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	elseif animat == 1 then
	    PlayAnimation("","manipulate_middle_up_l")
	else
	    PlayAnimation("","manipulate_top_r")
	end	

end

function UseTresor()

    if BuildingGetOwner("WorkBuilding","Meister") then
	    if GetFavorToSim("","Meister") < 30 then
		    if Rand(20) > 16 then
			    PlayAnimation("", "pickpocket")
				f_SpendMoney("Meister", Rand(50)+10, "bank")
			end
		end
	end
	GetLocatorByName("WorkBuilding","Work9","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	PlayAnimation("", "cogitate")
	PlayAnimation("","manipulate_bottom_r")
	
end
