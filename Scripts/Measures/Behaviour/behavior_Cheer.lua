function Run()

	AlignTo("Owner", "Actor")
	Sleep(1)
	if Rand(10)>5 then
		if SimGetGender("")==GL_GENDER_MALE then
			PlaySound3DVariation("","CharacterFX/male_cheer",1)
		else
			PlaySound3DVariation("","CharacterFX/female_cheer",1)
		end
		PlayAnimation("", "cheer_01")
	else
		PlayAnimation("", "cheer_02")
	end
end

function CleanUp()
	
end


