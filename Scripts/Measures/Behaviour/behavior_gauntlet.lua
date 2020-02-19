function Run()

	if GetEvadePosition("Owner", 400, "Away") then
		f_MoveTo("Owner", "Away", GL_MOVESPEED_RUN)
	end

	AlignTo("Owner", "Actor")
	Sleep(1)
	
	while not ActionIsStopped("Action") and GetDistance("Owner", "Actor") <= 600 do
		
--		MsgMeasure("Owner","gaping at "..GetName("Actor"))

		local Value = Rand(2)
		if Value==0 then
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_cheer",1)
			else
				PlaySound3DVariation("","CharacterFX/female_cheer",1)
			end
			PlayAnimation("Owner", "cheer_02")
		elseif Value==1 then
			PlayAnimation("Owner", "cheer_01")
		end
	end
end

