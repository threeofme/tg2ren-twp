function Run()
	SetState("",STATE_TOWNNPC,true)

	FindNearestBuilding("", GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_TOWNHALL, -1, false, "Townhall")
	BuildingGetCity("Townhall","DestCity")

	if not CityGetRandomBuilding("DestCity",0,GL_BUILDING_TYPE_DUELPLACE,-1,-1,FILTER_IGNORE,"InvisContainer") then
		StopMeasure()
	end

	FindNearestBuilding("", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, false, "myweddingchapel")
	GetLocatorByName("myweddingchapel","Sleeping","SleepPos")
	
	while true do
		std_orphan_CheckAge()
		-- try to walk to the wedding chapel
		if GetID("myweddingchapel")~=-1 then
			std_orphan_CheckAge()
			--if it is sleeping time...
			local sleeping = GetProperty("myweddingchapel", "Sleeping")
			if sleeping==1 then
				f_MoveTo("", "SleepPos")
				--SetState("", STATE_INVISIBLE, true)
				CityGetRandomBuilding("DestCity",0,GL_BUILDING_TYPE_DUELPLACE,-1,-1,FILTER_IGNORE,"InvisContainer")
				SimBeamMeUp("","InvisContainer",false)
				while sleeping==1 do
					Sleep(2)
					std_orphan_CheckAge()
					sleeping = GetProperty("myweddingchapel", "Sleeping")
				end
				--SetState("", STATE_INVISIBLE, false)
				SimBeamMeUp("","SleepPos",false)
			
			end
		
			if (GetProperty("myweddingchapel", "Orphan1")~=GetID("") or not GetProperty("myweddingchapel", "Adoption"))
				and (GetProperty("myweddingchapel", "Orphan2")~=GetID("") or not GetProperty("myweddingchapel", "GoldRing")) then
				local random = Rand(6) + 1
				if GetLocatorByName("myweddingchapel","Play"..random,"PlayPos") then
					f_BeginUseLocator("","PlayPos", GL_STANCE_STAND, true)
				end
				
				Sleep(1)

				SetExclusiveMeasure("", "StartDialog",EN_PASSIVE)

				--playing
				local Action = Rand(4)
				local idletime = 0
				if Action == 0 then	
					PlayAnimation("","child_play_02_in")
					LoopAnimation("","child_play_02_loop",10)
					PlayAnimation("","child_play_02_out")
					idletime = 2
				elseif Action == 1 then
					if Rand(100)>50 then
						PlayAnimation("","manipulate_middle_low_r")
						PlayAnimation("","eat_standing")
						idletime = 20
					else
						PlayAnimation("","cogitate")
						idletime = 20
					end
				elseif Action == 2 then
					idletime = 6
				else
					MoveSetStance("",GL_STANCE_SITGROUND)
					idletime = Rand(10)+10
				end

				for i=0,idletime,2 do
					if GetProperty("myweddingchapel", "Orphan1")==GetID("") then
						if GetProperty("myweddingchapel", "Adoption") then
							break
						end
					end
					if GetProperty("myweddingchapel", "Orphan2")==GetID("") then
						if GetProperty("myweddingchapel", "GoldRing") then
							break
						end
					end
					if GetProperty("myweddingchapel", "Sleeping") == 1 then
						break
					end
					Sleep(2)
				end

				f_EndUseLocator("","PlayPos",GL_STANCE_STAND)
			end
			Sleep(2)
		end
	end
end


function CheckAge()
	if SimGetAge("")>5 then
		SimSetAge("", 5)
	end
end


function CleanUp()
	if AliasExists("PlayPos") then
		f_EndUseLocator("","PlayPos",GL_STANCE_STAND)
	end
	SetInvisible("", false)
	AllowAllMeasures("")
end


