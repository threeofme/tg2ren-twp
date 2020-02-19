function Run()

	if not GetOutdoorMovePosition("Owner", "Actor", "ExtPos") then
		return
	end
	
	if Rand(10)>5 then
		Sleep((Rand(10)+5)*0.1)
		if SimGetGender("")==GL_GENDER_MALE then
			PlaySound3DVariation("","CharacterFX/male_pain_long",1)
		else
			PlaySound3DVariation("","CharacterFX/female_pain_long",1)
		end
	end
	
	while GetState("Actor", STATE_BURNING) do
	
		if not GetState("Actor", STATE_BURNING) then
			break
		end
		local FoundWell = Find("Owner", "__F( (Object.GetObjectsByRadius(Building)==20000) AND (Object.IsType(24)) )", "Well", -1)
		if FoundWell == 0 then
--			MsgMeasure("Owner","Could not find a place to get water")
			break
		end
		
		local WellAlias = ""
		local OldDistance = GetDistance("","Well0")
		for i=0,FoundWell-1 do
			WellAlias = "Well"..i
			CurrentDistance = GetDistance("",WellAlias)
			if CurrentDistance < OldDistance then
				CopyAlias(WellAlias,"Well")
				OldDistance = CurrentDistance
			end
		end
		
		
		
			
--		MsgMeasure("Owner","Running to get some water")
		
		if not f_MoveTo("Owner", "Well", GL_MOVESPEED_RUN, "", 50) then
			StopMeasure()
		end
		
		if not GetState("Actor", STATE_BURNING) then
			break
		end
		
		if not(HasProperty("Owner", "HasBucket")) then
			CarryObject("Owner", "Handheld_Device/ANIM_Bucket_L.nif", true)
			SetProperty("Owner", "HasBucket", 1)
		end
				
--		MsgMeasure("Owner","running to the fire with some water")
		f_MoveTo("Owner", "ExtPos", GL_MOVESPEED_RUN, 200)
		
		if not GetState("Actor", STATE_BURNING) then
			break
		end
				
		--increase the end status of the burning building
		local ToDo = GetProperty("Actor", "BurningToDo")
		if not ToDo then
			break
		end
		SetProperty("Actor", "BurningToDo", ToDo - 5)
		local BurnToHP = GetProperty("Actor","BurnToHP")
		if not BurnToHP then
			break
		end
		local DestHPBurnModifier = (GetMaxHP("Actor")*0.05)+BurnToHP
		SetProperty("Actor", "BurnToHP", DestHPBurnModifier)
		AlignTo("","Actor")
		Sleep(0.65)
		
		local Time = PlayAnimationNoWait("Owner", "put_out_fire")
		Sleep(1)
		if Rand(100)<4 then
			diseases_BurnWound("",true)	
		end
		PlaySound3DVariation("","measures/putoutfire",1)
		Sleep(Time-1)
		
		
	end
end

function CleanUp()
		if HasProperty("Owner", "HasBucket") then
			CarryObject("Owner", "", true)
			RemoveProperty("Owner", "HasBucket")
		end		
end

