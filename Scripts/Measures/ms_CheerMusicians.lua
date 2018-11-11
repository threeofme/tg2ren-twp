function Run()
	local stage = GetData("#MusicStage")
	if GetAliasByID(stage,"stageobj") then
		if not HasProperty("stageobj","Versengold") then
			StopMeasure()
		elseif GetInsideBuildingID("")==GetID("stageobj") then
			local distance = Rand(150) + 220
			if not f_MoveTo("","#Musician1",GL_MOVESPEED_WALK, distance) then
				StopMeasure()
			end
		else
			StopMeasure()
		end
	else
		StopMeasure()
	end

	if IsPartyMember("") then
		if GetMoney("") < 100 then
			MsgQuick("", "@L_MEASURE_CheerMusicians_FAILURE_+0")
			StopMeasure()
		end
	end

	AlignTo("","#Musician1")
	SetProperty("","Tips",0)

	while true do
		if not HasProperty("stageobj","Versengold") then
	    PlayAnimationNoWait("","laud_02")
			break
		else
			local cheering = Rand(100)
			local AnimTime = 0

			if SimGetGender("") == GL_GENDER_MALE then

				if cheering<45 then
					PlayAnimation("","cheer_01")
				elseif cheering<90 then
					PlayAnimation("","cheer_02")
				elseif cheering<95 then
					PlayAnimation("","dance_male_1")
				else
					AnimTime = PlayAnimationNoWait("","clink_glasses")
					Sleep(1)
					CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
					Sleep(AnimTime-2)
					CarryObject("","",false)
					Sleep(1)
				end
				
			else
				if cheering<30 then
					PlayAnimation("","cheer_01")
				elseif cheering<60 then
					PlayAnimation("","cheer_02")
				elseif cheering<78 then
					PlayAnimation("","giggle")
				elseif cheering<97 then
					PlayAnimation("","dance_female_1")
				else
					local blackout = Rand(4)+2
					PlayAnimation("","unconscious_in")
					LoopAnimation("","unconscious_idle",blackout)
					PlayAnimation("","unconscious_out")
				end
			end

			local totTips = GetProperty("","Tips") + 1
			SetProperty("","Tips",totTips)

			Sleep(0.5)
		end
	end

end

function CleanUp()
	if HasProperty("","Tips") then
		local tips = GetProperty("","Tips")
		if tips>0 then
			if IsPartyMember("") then
				if GetMoney("") > tips then
					SpendMoney("",tips,"Versengold")
				end
			end
			
			local stage = GetData("#MusicStage")
			if GetAliasByID(stage,"stageobj") then
				if BuildingGetOwner("stageobj","BuildingOwner") then
					CreditMoney("BuildingOwner", tips, "Versengold")
					economy_UpdateBalance("stageobj", "Service", tips)
				end
			end
		end
		RemoveProperty("","Tips")
	end

	SatisfyNeed("", 2, 0.2)
	SatisfyNeed("", 8, 0.2)
end
