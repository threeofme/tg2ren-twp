function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	SetData("Distance", 2000)
	if Rand(10)>5 then
		if SimGetGender("")==GL_GENDER_MALE then
			PlaySound3DVariation("","CharacterFX/male_pain_short",1)
		else
			PlaySound3DVariation("","CharacterFX/female_pain_short",1)
		end
		diseases_BurnWound("",true)	
	end
	return "Flee"
end

