function Run()

	MoveStop("") 
	AlignTo("", "Actor")
	Sleep(2)
	--ShowOverheadSymbol("", false, true, "Data", "*deride*")
	local Value = Rand(3)
		if Value==0 then
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_anger",1)
			else
				PlaySound3DVariation("","CharacterFX/female_anger",1)
			end
			PlayAnimation("Owner", "insult_character")
		elseif Value==1 then
			PlayAnimation("Owner", "point_at")
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_joy_loop",1)
			else
				PlaySound3DVariation("","CharacterFX/female_joy_loop",1)
			end
			PlayAnimation("Owner", "threat")
		elseif Value==2 then
			CarryObject("", "Handheld_Device/ANIM_carrot.nif", false)
			PlayAnimationNoWait("", "throw")
			Sleep(2.1)
			CarryObject("", "" ,false)
			local fDuration = ThrowObject("", "Actor", "Handheld_Device/ANIM_carrot.nif",0.1,"carrot",30,150,0)
 			Sleep(fDuration)
 			GetPosition("Actor","ParticleSpawnPos")
 			StartSingleShotParticle("particles/veg.nif", "ParticleSpawnPos",1,5)
		end

end

