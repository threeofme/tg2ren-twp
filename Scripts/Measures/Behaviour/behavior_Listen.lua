function Run()

	-- etwa Abstand vom Geschehen, und gaffen
	GetFleePosition("Owner", "Actor", Rand(50)+200, "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)

	local ActionName = GetData("Action_Name")
	
	local Gender = SimGetGender("Owner")
	local TimeLeft = -1

	SetRepeatTimer("Owner", "Listen2Bard", 180)
	
	while not ActionIsStopped("Action") do

		if TimeLeft < 0 then
			local Value
			if Gender==0 then
				Value = Rand(2)+1
			else
				Value = Rand(2)
			end

			if Value==0 then
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_cheer",1)
				else
					PlaySound3DVariation("","CharacterFX/female_cheer",1)
				end
				TimeLeft = PlayAnimation("Owner", "cheer_01")
			elseif Value==1 then
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_cheer",1)
				else
					PlaySound3DVariation("","CharacterFX/female_cheer",1)
				end
				TimeLeft = PlayAnimation("Owner", "cheer_02")
			elseif Value==2 then
				TimeLeft = PlayAnimationNoWait("Owner", "dance_female")
			end

			if GetState("Actor",STATE_HPFZ_HYPNOSE) == true then
        if SimGetOfficeID("Actor") > 0 then
	        if SimGetOfficeID("Owner") > 0 then
	          chr_ModifyFavor("","Actor",-5)
	        end
				end
			end
			
		end
		Sleep(1)
		TimeLeft = TimeLeft - 1
	end
end

