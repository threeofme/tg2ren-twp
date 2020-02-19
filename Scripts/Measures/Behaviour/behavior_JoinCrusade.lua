function Run()

	-- etwa Abstand vom Geschehen, und gaffen
	GetFleePosition("Owner", "Actor", Rand(50)+200, "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)

	local ActionName = GetData("Action_Name")
	local TimeLeft = -1
	local	TimeOut = GetGametime()+0.5
	SetRepeatTimer("Owner", "Listen2Preacher", 4)
	
	local OwnReligion = SimGetReligion("")
	local ActorReligion = SimGetReligion("Actor")
	if OwnReligion ~= ActorReligion then
		StopMeasure()
	end

	--listen
	while not ActionIsStopped("Action") do

		if GetGametime() > TimeOut then
			break
		end
			
		if TimeLeft < 0 then

			local Value = Rand(100)
			if Value < 50 then
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_cheer",1)
				else
					PlaySound3DVariation("","CharacterFX/female_cheer",1)
				end
				TimeLeft = PlayAnimation("Owner", "cheer_01")
			else
				TimeLeft = PlayAnimation("Owner", "cheer_02")
			end
		end
		Sleep(1)
		TimeLeft = TimeLeft - 1
	end
	
	Sleep(2.0)	
	
	local ActorID = GetID("Actor")
	SetProperty("","CrusadeLeaderID",ActorID)
	
	local NumCrusaders = GetProperty("Actor","NumCrusaders")
	if NumCrusaders then
		if NumCrusaders >= GL_MAX_CRUSADERS then
			StopMeasure()
		else
			NumCrusaders = NumCrusaders + 1
			SetProperty("Actor","NumCrusaders",NumCrusaders)
		end
	end	
	
	SetState("",STATE_CRUSADE,true)
end

