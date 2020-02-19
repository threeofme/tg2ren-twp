function Run()

	if not AliasExists("Action") then
		StopMeasure("Owner")
	end
	ActionLock("Action", 1)
	
	local Distance
	if HasData("Distance") then	
		Distance = GetData("Distance")
		if not Distance or Distance < 50 then
			Distance = 300
		end
	else
		Distance = 300
	end
	
	local	AutoFollow = true
	if HasData("NoAutoFollow") then
		AutoFollow = false
	end
	
	local TimeOut
	MeasureSetNotRestartable()

	while true do
	
		if not AliasExists("Action") then
			break
		end
	
		if not ActionIsEvidence("Action") and ActionIsStopped("Action") then
			break
		end
	
		if not AliasExists("Actor") then
			break
		end
	
		local DistanceCurrent = GetDistance("Owner", "Actor")
		if DistanceCurrent < 0 then
			break
		end

		if ActionIsStopped("Action") then
			if not TimeOut then
				WaitTime = 0.25
				TimeOut = GetGametime() + WaitTime
			else
				if TimeOut < GetGametime() then
					break
				end
			end
			
			if DistanceCurrent > 3000 then
				break
			end
		else
			-- calculate the distance between the combat and the gaper 
			if DistanceCurrent < Distance-50 or DistanceCurrent > Distance+200 then
				if AutoFollow then
					GetFleePosition("Owner", "Actor", Rand(150)+Distance, "Away")
					f_MoveTo("Owner", "Away", GL_MOVESPEED_RUN)
					AlignTo("Owner", "Actor")
					Sleep(1)
				else
					break
				end
			end
		end

		if not AliasExists("Action") then
			break
		end
		
		local Value = 0
		
		if not ActionIsEvidence("Action") then
			Value = Rand(15)
			if Value == 0 then
				GetFleePosition("Owner", "Actor", Rand(400)+800, "Away")
				f_MoveTo("Owner","Away")
				return
			end
		end
		
		Value = Rand(2)
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
		Sleep(1)
	end
end

function CleanUp()
	AlignTo("")
	if AliasExists("Action") then
		ActionLock("Action", -1)
	end
end

