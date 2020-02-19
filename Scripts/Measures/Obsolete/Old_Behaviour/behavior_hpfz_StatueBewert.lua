function Run()

	GetFleePosition("Owner", "Actor", (Rand(50)+200), "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)
	BuildingGetOwner("Actor","GebChef")

    if GetFavorToSim("","GebChef")<11 then
		local spruch = Rand(3)
		if spruch == 0 then
		    MsgSayNoWait("","@L_HPFZ_STATUE_SPRUCH_+0")
		elseif spruch == 1 then
		    MsgSayNoWait("","@L_HPFZ_STATUE_SPRUCH_+1")
		elseif spruch == 2 then
		    MsgSayNoWait("","@L_HPFZ_STATUE_SPRUCH_+2")
		end
	end

    if GetFavorToSim("","GebChef")>79 then
		local spruch = Rand(3)
		if spruch == 0 then
		    MsgSayNoWait("","@L_HPFZ_STATUE_SPRUCH_+3")
		elseif spruch == 1 then
		    MsgSayNoWait("","@L_HPFZ_STATUE_SPRUCH_+4")
		elseif spruch == 2 then
		    MsgSayNoWait("","@L_HPFZ_STATUE_SPRUCH_+5")
		end
	end	
	
    if GetFavorToSim("","GebChef")<6 then
		CarryObject("", "Handheld_Device/ANIM_carrot.nif", false)
        Sleep(1)
	    PlayAnimationNoWait("", "throw")
	    Sleep(1.8)
	    CarryObject("", "" ,false)
	    local wurfZeit = ThrowObject("", "GebChef", "Handheld_Device/ANIM_carrot.nif",0.1,"veg",0,150,0)
	    Sleep(wurfZeit)
	    GetPosition("GebChef","ParticleSpawnPos")
	    StartSingleShotParticle("particles/veg.nif", "ParticleSpawnPos",1,5)
	    Sleep(0.7)
    elseif GetFavorToSim("","GebChef")<11 and GetFavorToSim("","GebChef")>6 then
		if SimGetGender("")==GL_GENDER_MALE then
	        PlaySound3DVariation("","CharacterFX/male_anger",1)
	    else
	        PlaySound3DVariation("","CharacterFX/female_anger",1)
	    end
	    PlayAnimation("", "propel")
	elseif GetFavorToSim("","GebChef")>79 and GetFavorToSim("","GebChef")<100 then
		if SimGetGender("")==GL_GENDER_MALE then
	        PlaySound3DVariation("","CharacterFX/male_cheer",1)
	    else
	        PlaySound3DVariation("","CharacterFX/female_cheer",1)
	    end
	    PlayAnimation("", "cheer_01")
	elseif GetFavorToSim("","GebChef")==100 then
		if SimGetGender("")==GL_GENDER_MALE then
	        PlaySound3DVariation("","CharacterFX/male_cheer",1)
	    else
	        PlaySound3DVariation("","CharacterFX/female_cheer",1)
	    end
        PlayAnimation("", "pray_standing")
	end

end

function CleanUp()
   	CarryObject("", "", false)
	CarryObject("", "", true)
    MoveSetActivity("")
	SimResumePreFightMeasure("")
end
