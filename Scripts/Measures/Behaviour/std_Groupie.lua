function Run()
	SetState("",STATE_TOWNNPC,true)
	SimSetMortal("",false)

	FindNearestBuilding("", GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_TOWNHALL, -1, false, "Townhall")
	BuildingGetCity("Townhall","DestCity")

	if not CityGetRandomBuilding("DestCity",0,GL_BUILDING_TYPE_DUELPLACE,-1,-1,FILTER_IGNORE,"InvisContainer") then
		StopMeasure()
	end

	SetInvisible("", true)
	SimBeamMeUp("","InvisContainer",false)
	
	while true do
		std_groupie_CheckAge()
		
		local beamback = false
		local stage = GetData("#MusicStage")
		if stage > 0 then
			if GetAliasByID(stage,"stageobj") then
				if HasProperty("stageobj","Versengold") then
					SimBeamMeUp("","stageobj",false)
					SetInvisible("", false)

					local distance = Rand(150) + 220
					if f_MoveTo("","#Musician1",GL_MOVESPEED_WALK, distance) then

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
					
					if HasProperty("","Tips") then
						local tips = GetProperty("","Tips")
						if tips>0 then
							if BuildingGetOwner("stageobj","BuildingOwner") then
								CreditMoney("BuildingOwner", tips, "Versengold")
								economy_UpdateBalance("stageobj", "Service", tips)
							end
						end
						RemoveProperty("","Tips")
					end

					f_ExitCurrentBuilding("")
					SetInvisible("", true)
					SimBeamMeUp("","InvisContainer",false)
				end
			end
		end

		Sleep(20)
	end
end


function CheckAge()
	if SimGetAge("")>32 then
		SimSetAge("", 16)
	end
end


function CleanUp()
	SetInvisible("", false)
end


