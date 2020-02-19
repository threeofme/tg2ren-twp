function Init()

    SetState("", STATE_LOCKED, true)
	SimSetMortal("", false)
	
end

function Run()

	local range = 1000
    GetPosition("","SimPosX")
	GetPosition("","SimPosY")
	
    while true do

	    GetPosition("SimPosY","SimPosX")
        local x,y,z = PositionGetVector("SimPosX")
        x = x + ((Rand(range)*2)-range)
        z = z + ((Rand(range)*2)-range)
        PositionModify("SimPosX",x,y,z)
	    SetPosition("SimPosX",x,y,z)
	    f_MoveToNoWait("","SimPosX",GL_MOVESPEED_WALK,100)	

        local idleArt = Rand(5)
        local idleWart = Rand(10)+10
	    local playtime
        if idleArt == 0 then
	        playtime = PlayAnimationNoWait("", "cogitate")
		    Sleep(playtime+idleWart)
        elseif idleArt == 1 then
		    if SimGetProfession("") == 71 or SimGetProfession("") == 72 then
		        CarryObject("","",false)
		        playtime = PlayAnimationNoWait("","clink_glasses")
		        Sleep(1)
		        CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
		        Sleep(playtime-2)
		        PlaySound3DVariation("","CharacterFX/male_belch",1)
		        CarryObject("","",false)
			else
			    local dowas = PlayAnimationNoWait("","use_potion_standing")
		        Sleep(1)
		        CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				PlaySound3DVariation("","CharacterFX/drinking",1.0)
		        Sleep(dowas-2)
		        CarryObject("","",false)			
			end
			    Sleep(idleWart)
        elseif idleArt == 2 then
		    CarryObject("","",false)
			if Rand(2) == 0 then
		        CarryObject("", "Handheld_Device/ANIM_Pretzel.nif", false)
			else
			    CarryObject("", "Handheld_Device/ANIM_carrot.nif", false)
			end
		    PlayAnimationNoWait("","eat_standing")
		    Sleep(6)
		    CarryObject("","",false)
		    Sleep(idleWart)
        elseif idleArt == 3 then
	        if SimGetProfession("") == 69 or SimGetProfession("") == 70 then
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
		    elseif SimGetProfession("") == 67 or SimGetProfession("") == 68 then
			    if Rand(2) == 0 then
	                if SimGetGender("") == 1 then
				        PlaySound3DVariation("","CharacterFX/male_friendly",1)
		                PlayAnimation("","talk_positive")
				    else
				        PlaySound3DVariation("","CharacterFX/female_joy_loop",1)
				        PlayAnimation("","dance_female_"..Rand(2)+1)
	                end
                else
				    local laeng = Rand(4)+4
		            local AnimaTime = PlayAnimationNoWait("","play_instrument_01_in")
		            Sleep(1)
		            CarryObject("","Handheld_Device/ANIM_Flute.nif",false)
		            Sleep(AnimaTime-1)
			        LoopAnimation("","play_instrument_01_loop",laeng)
		            AnimaTime = PlayAnimationNoWait("","play_instrument_01_out")
		            Sleep(1.5)
		            CarryObject("","",false)
		            Sleep(AnimaTime-1)
                end				
		    elseif SimGetProfession("") == 71 or SimGetProfession("") == 72 then
	            if Rand(3)==0 then
		            PlayAnimationNoWait("","sentinel_idle")
	            else
				    CarryObject("","",false)
		            CarryObject("","Handheld_Device/ANIM_telescope.nif",false)
		            PlayAnimation("","scout_object")
		            CarryObject("","",false)
			    end
			end
			Sleep(idleWart)
		else
		    if SimGetProfession("") == 71 or SimGetProfession("") == 72 then
	            if SimGetGender("") == 1 then
				    PlaySound3DVariation("","CharacterFX/male_anger",1)
				else
				    PlaySound3DVariation("","CharacterFX/female_anger",1)
	             end
                PlayAnimationNoWait("","propel")
			elseif SimGetProfession("") == 67 or SimGetProfession("") == 68 then
	            if SimGetGender("") == 1 then
				    PlaySound3DVariation("","CharacterFX/male_jolly",1)
				else
				    PlaySound3DVariation("","CharacterFX/female_jolly",1)
	             end
				PlayAnimation("","cheer_01")			
			else
	            if SimGetGender("") == 1 then
				    PlaySound3DVariation("","CharacterFX/male_neutral",1)
				else
				    PlaySound3DVariation("","CharacterFX/female_neutral",1)
	             end
				PlayAnimation("","talk")
			end
			Sleep(idleWart)
		end
        Sleep(2)
		local time = math.mod(GetGametime(),24)
		if time>23 or time<4 then
			std_dummysim_CheckNacht()
		end

    end
end

function CheckNacht()

    CarryObject("","Handheld_Device/ANIM_torchparticles.nif",false)

end