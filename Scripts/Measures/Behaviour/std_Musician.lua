function Run()
	SetState("",STATE_TOWNNPC,true)

	while true do
		std_musician_ResetComeOver()
		
		if GetData("#MusicStage")>0 then
			SetData("#RestPlace",0)
			std_musician_StartConcert()
		elseif GetData("#RestPlace")>0 then
			std_musician_Rest()
		elseif GetID("#Musician1")==GetID("") then
			if HasProperty("","MusicStage") then
				RemoveProperty("","MusicStage")
			end
			if HasProperty("","StartConcert") then
				RemoveProperty("","StartConcert")
			end

			math.randomseed(GetGametime())

			local CurrentTime = math.mod(GetGametime(),24)
			local decision = Rand(100)+1
			local cities = ScenarioGetObjects("Settlement", 10, "City")
			local ccx = Rand(cities)
			local count, count2
			local round = GetRound()

			if round >0 and (decision>5) and (CurrentTime > 4 and CurrentTime < 14) then
				if Rand(2)==0 then
			    count = CityGetBuildings("city"..ccx, GL_BUILDING_CLASS_WORKSHOP, GL_BUILDING_TYPE_TAVERN, -1, -1, FILTER_HAS_DYNASTY, "obj")
			    count2 = CityGetBuildings("city"..ccx, GL_BUILDING_CLASS_WORKSHOP, GL_BUILDING_TYPE_PIRAT, -1, -1, FILTER_HAS_DYNASTY, "obj2")
				else
			    count = CityGetBuildings("city"..ccx, GL_BUILDING_CLASS_WORKSHOP, GL_BUILDING_TYPE_PIRAT, -1, -1, FILTER_HAS_DYNASTY, "obj")
			    count2 = CityGetBuildings("city"..ccx, GL_BUILDING_CLASS_WORKSHOP, GL_BUILDING_TYPE_TAVERN, -1, -1, FILTER_HAS_DYNASTY, "obj2")
				end

				if count > 0 or count2 > 0 then
					local curFee = 0
					local bestFee = 0
					for l=0,count-1 do
						Alias	= "obj"..l
						if HasProperty(Alias,"MusiciansFee") then
							curFee = GetProperty(Alias,"MusiciansFee")
						else
							curFee = 0
						end
						
						if not AliasExists("bestDest") then
							CopyAlias(Alias, "bestDest")
							if HasProperty(Alias,"MusiciansFee") then
								bestFee = GetProperty(Alias,"MusiciansFee")
							else
								bestFee = 0
							end
						elseif GetID(Alias)~=GetID("bestDest") then
							if curFee > bestFee then
								bestFee = curFee
								CopyAlias(Alias, "bestDest")
							elseif curFee == bestFee then
								if Rand(10)<5 then
									bestFee = curFee
									CopyAlias(Alias, "bestDest")
								end
							end
						end
					end

					for m=0,count2-1 do
						Alias	= "obj2"..m
						if HasProperty(Alias,"MusiciansFee") then
							curFee = GetProperty(Alias,"MusiciansFee")
						else
							curFee = 0
						end
						
						if not AliasExists("bestDest") then
							CopyAlias(Alias, "bestDest")
							if HasProperty(Alias,"MusiciansFee") then
								bestFee = GetProperty(Alias,"MusiciansFee")
							else
								bestFee = 0
							end
						elseif GetID(Alias)~=GetID("bestDest") then
							if curFee > bestFee then
								bestFee = curFee
								CopyAlias(Alias, "bestDest")
							elseif curFee == bestFee then
								if Rand(10)<5 then
									bestFee = curFee
									CopyAlias(Alias, "bestDest")
								end
							end
						end
					end

					BuildingGetOwner("bestDest","BuildingOwner")
					if GetMoney("BuildingOwner")>bestFee then
						if bestFee>0 then
							f_SpendMoney("BuildingOwner",bestFee,"Versengold")
							SetProperty("bestDest","MusiciansFee",0)
						end
						CopyAlias("bestDest","Destination")
					end
					RemoveAlias("bestDest")
	
					if AliasExists("Destination") then
						SetData("#MusicStage",GetID("Destination"))
						feedback_MessageWorkshop("BuildingOwner",
							"@L_MESSAGES_UPCOMING_CONCERT_OWNER_HEADER_+0",
							"@L_MESSAGES_UPCOMING_CONCERT_OWNER_BODY_+0",
								GetID("Destination"))
					end
				end
			else
				if CityGetRandomBuilding("city"..ccx, -1, GL_BUILDING_TYPE_LINGERPLACE, -1, -1, FILTER_IGNORE, "Destination") then
				--if CityGetNearestBuilding("city"..ccx, "#Musician1", -1, GL_BUILDING_TYPE_LINGERPLACE, -1, -1, FILTER_IGNORE, "Destination") then
					SetData("#RestPlace",GetID("Destination"))
				end
			end
			
		else
			if HasProperty("","MusicStage") then
				RemoveProperty("","MusicStage")
			end
		end
		
		Sleep(Rand(3)+1)
	end
end


function Rest()
	local season = GetSeason()
	local Stance = 2

	local place = GetData("#RestPlace")
	GetAliasByID(place,"placeobj")

	if AliasExists("placeobj") then

		Sleep(Rand(3)+1)
	
		SetProperty("","Moving",1)
		if not f_MoveTo("","placeobj",GL_MOVESPEED_RUN) then

			GetFleePosition("","placeobj",150,"MovePos")
			if f_MoveTo("", "MovePos", nil, 150) then
				LogMessage(GetID("").." can't move to "..GetID("placeobj"));
				--SimBeamMeUp("", "MovePos")
			end
		end
		RemoveProperty("","Moving")

		--0=sitground, 1=sitbench, 2=stand
		if ((season == EN_SEASON_WINTER) and (Rand(10) > 3)) then
			if GetFreeLocatorByName("placeobj","idle_Stand",1,5,"SitPos") then
				Stance = 2
				f_BeginUseLocator("","SitPos",GL_STANCE_STAND,true)
			end
		else
			if GetFreeLocatorByName("placeobj","idle_Sit",1,5,"SitPos") then
				f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true)
				Stance = 1
				if GetLocatorByName("placeobj","campfire","CampFirePos") then
					if GetImpactValue("placeobj","torch")==0 then
						AddImpact("placeobj","torch",1,1)
						GfxStartParticle("Campfire","particles/Campfire2.nif","CampFirePos",3)
					end
				end
			elseif GetFreeLocatorByName("placeobj","idle_SitGround",1,5,"SitPos") then
				Stance = 0
				f_BeginUseLocator("","SitPos",GL_STANCE_SITGROUND,true)
			elseif GetFreeLocatorByName("placeobj","idle_Stand",1,5,"SitPos") then
				Stance = 2
				f_BeginUseLocator("","SitPos",GL_STANCE_STAND,true)
			end
		end
		
		local TimeToRest = 2
		local RestEndTime = GetGametime() + TimeToRest
	
		while true do
			if GetGametime() >= RestEndTime or GetData("#MusicStage")>0 or GetData("#RestPlace")==0 or GetData("#RestPlace")~=GetID("placeobj") then
				std_musician_ResetComeOver()
				if GetID("")==GetID("#Musician1") then
					SetData("#RestPlace",0)
				end
				break
			end

			if not HasProperty("","KissMe") then
				std_musician_CheckForGroupie()
			end
			
			if HasProperty("","KissMe") and std_musician_CheckComeOver()==true then
				f_EndUseLocator("","SitPos",GL_STANCE_STAND)

				std_musician_ComeOver()
				
				while true do
					if GetData("#MusicStage")>0 or GetData("#RestPlace")==0 or GetData("#RestPlace")~=GetID("placeobj") then
						std_musician_ResetComeOver()
						break
					end
					--0=sitground, 1=sitbench, 2=stand
					if ((season == EN_SEASON_WINTER) and (Rand(10) > 3)) then
						if GetFreeLocatorByName("placeobj","idle_Stand",1,5,"SitPos") then
							Stance = 2
							f_BeginUseLocator("","SitPos",GL_STANCE_STAND,true)
							break
						end
					else
						if GetFreeLocatorByName("placeobj","idle_Sit",1,5,"SitPos") then
							f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true)
							Stance = 1
							if GetLocatorByName("placeobj","campfire","CampFirePos") then
								if GetImpactValue("placeobj","torch")==0 then
									AddImpact("placeobj","torch",1,1)
									GfxStartParticle("Campfire","particles/Campfire2.nif","CampFirePos",3)
								end
							end
							break
						elseif GetFreeLocatorByName("placeobj","idle_SitGround",1,5,"SitPos") then
							Stance = 0
							f_BeginUseLocator("","SitPos",GL_STANCE_SITGROUND,true)
							break
						elseif GetFreeLocatorByName("placeobj","idle_Stand",1,5,"SitPos") then
							Stance = 2
							f_BeginUseLocator("","SitPos",GL_STANCE_STAND,true)
							break
						end
					end
					Sleep(5)
				end

			elseif Stance ~= 2 then
				Sleep(2)
				local AnimTime = 0
				local idx = Rand(7)
				if idx == 0 and Stance ~= 0 then
					PlaySound3DVariation("","CharacterFX/male_anger",1)
					PlayAnimation("","bench_sit_offended")
				elseif idx == 1 and Stance ~= 0 then
					PlaySound3DVariation("","CharacterFX/male_amazed",1)
					PlayAnimation("","bench_sit_talk_short")
				elseif idx == 2 and Stance ~= 0 then
					PlaySound3DVariation("","CharacterFX/male_neutral",1)
					PlayAnimation("","bench_talk")
				elseif idx == 3 then
					MoveSetStance("",GL_STANCE_STAND)
					Sleep(1)
					AnimTime = PlayAnimationNoWait("","clink_glasses")
					Sleep(1)
					CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
					Sleep(AnimTime-2)
					PlaySound3DVariation("","CharacterFX/male_belch",1)
					CarryObject("","",false)
					Sleep(1)
					if Stance == 0 then
						MoveSetStance("",GL_STANCE_SITGROUND)
					elseif Stance == 1 then
						MoveSetStance("",GL_STANCE_SITBENCH)
					end
				
				else
					MoveSetStance("",GL_STANCE_STAND)	
					Sleep(1)
					local idx_advanced = Rand(5)
					if idx_advanced==0 then
						PlaySound3DVariation("","CharacterFX/male_anger_loop",1)
						PlayAnimation("","propel")
					elseif idx_advanced==1 then
						PlayAnimation("","shake_head")
					elseif idx_advanced==2 then
						PlaySound3DVariation("","CharacterFX/male_anger_loop",1)
						PlayAnimation("","insult_character")
					elseif idx_advanced==3 then
						PlaySound3DVariation("","CharacterFX/male_joy_loop",1)
						PlayAnimation("","talk_2")
					else
						PlaySound3DVariation("","CharacterFX/male_anger_loop",1)
						PlayAnimation("","threat")
					end
					
					if Stance == 0 then
						MoveSetStance("",GL_STANCE_SITGROUND)
					elseif Stance == 1 then
						MoveSetStance("",GL_STANCE_SITBENCH)
					end
					
				end
			else
				if season == EN_SEASON_WINTER then
					local FightPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==1500)AND NOT(Object.HasDynasty())AND NOT(Object.GetState(townnpc)))","FightPartner", -1)
					if FightPartners>0 then
						AlignTo("","FightPartner")
						Sleep(1)
						idlelib_SnowballBattle("FightPartner")
						Sleep(1)
					end
				end
			end
			Sleep(Rand(12)+6)
		end
		
		if GetImpactValue("placeobj","torch")==0 then
			GfxStopParticle("Campfire")
		end
		
		f_EndUseLocator("","SitPos",GL_STANCE_STAND)
		
		if GetID("")==GetID("#Musician1") then
			SetData("#RestPlace",0)
		end
	end
		
	Sleep(3)
end


function StartConcert()
	local stage = GetData("#MusicStage")
	local type = -1

	if GetAliasByID(stage,"stageobj") then
		if BuildingGetType("stageobj")==GL_BUILDING_TYPE_TAVERN then
			type = 0
		elseif BuildingGetType("stageobj")==GL_BUILDING_TYPE_PIRAT then
			type = 1
		else
			type = -1		
		end
	end

	if type==-1 then
		if GetID("")==GetID("#Musician1") then
			SetData("#MusicStage",0)
		end
		Sleep(3)
	else
		SetProperty("","Moving",1)
		if not f_MoveTo("","stageobj",GL_MOVESPEED_RUN) then
			LogMessage(GetID("").." can't move to "..GetID("placeobj"));
			--SimBeamMeUp("", "stageobj")
		end
		RemoveProperty("","Moving")
	
		if GetID("")==GetID("#Musician1") then
			local CurrentTime = math.mod(GetGametime(),24)
			local StartTime = 0
			local TimeToWait = Rand(2)+3
			local DestTime = 0
			local Round = GetRound()

			if (CurrentTime>9 and CurrentTime<15) or (CurrentTime>0 and CurrentTime<2) then
				StartTime = CurrentTime + TimeToWait
				DestTime = CurrentTime + TimeToWait
			elseif CurrentTime>2 and CurrentTime<9 then
				StartTime = 9 + TimeToWait
				DestTime = 9 + TimeToWait
			else --CurrentTime>15
				StartTime = TimeToWait
				DestTime = 24 - CurrentTime + TimeToWait
				Round = Round + 1			
			end

			local ID = "Event"..GetID("")
		
			BuildingGetCity("stageobj","City")
			
			MsgNewsNoWait("All","stageobj","@C[@L_MESSAGES_UPCOMING_CONCERT_COOLDOWN_+0,%4i,%5l]","default",-1,
					       "@L_MESSAGES_UPCOMING_CONCERT_HEADER_+0",
					       "@L_MESSAGES_UPCOMING_CONCERT_BODY_+0",
					       GetID("City"),"@L_MESSAGES_UPCOMING_CONCERT_STAGE_+"..type, GetID("stageobj"),DestTime,ID)

			SetData("#HaveFunTime",StartTime)
			
			SetProperty("#Musician1","HaveFun",Round)
			SetProperty("#Musician2","HaveFun",Round)
			SetProperty("#Musician3","HaveFun",Round)
			SetProperty("#Musician4","HaveFun",Round)
			SetProperty("#Musician5","HaveFun",Round)
			
		end
	
		while true do
			if HasProperty("","HaveFun") then
				local havefuntime = GetData("#HaveFunTime")
				if type==0 then
					std_musician_HaveFunInTavern("stageobj",havefuntime-0.5)
				else
					std_musician_HaveFunInDivehouse("stageobj",havefuntime-0.5)
				end
				break
			else
				Sleep(2)
			end
		end
	
		if GetID("")==GetID("#Musician1") then
			GetLocatorByName("stageobj","Musician1","PlayPos")
			f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true)
	
		elseif GetID("")==GetID("#Musician2") then
			GetLocatorByName("stageobj","Musician2","PlayPos")
			f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true)
	
		elseif GetID("")==GetID("#Musician3") then
			GetLocatorByName("stageobj","Musician3","PlayPos")
			f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true)
	
		elseif GetID("")==GetID("#Musician4") then
			GetLocatorByName("stageobj","Musician4","PlayPos")
			f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true)
	
		elseif GetID("")==GetID("#Musician5") then
			GetLocatorByName("stageobj","Musician5","PlayPos")
			f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true)
	
		end
	
		SetProperty("","MusicStage",stage)
		
		while true do
			if GetID("")==GetID("#Musician1") then
				if (HasProperty("#Musician2","MusicStage") and GetProperty("#Musician2","MusicStage")==stage) and
					 (HasProperty("#Musician3","MusicStage") and GetProperty("#Musician3","MusicStage")==stage) and
					 (HasProperty("#Musician4","MusicStage") and GetProperty("#Musician4","MusicStage")==stage) and
					 (HasProperty("#Musician5","MusicStage") and GetProperty("#Musician5","MusicStage")==stage) then
					Sleep(3)
	
					if not IsMultiplayerGame() then
						if CameraIndoorGetBuilding("BuildingCam") then
							if GetID("stageobj")==GetID("BuildingCam") then
								ResetGamespeed()
								gameplayformulas_BlockMusicForConcert(1)
							end
						end
					end

					math.randomseed(GetGametime())
					
					local tmprand = Rand(100)+1
					SetProperty("","StartConcert",tmprand) --choose a random song
					break
				end
			elseif HasProperty("#Musician1","StartConcert") then
				break
			end
			Sleep(3)
		end
	
		if GetID("")==GetID("#Musician1") then
			SetProperty("stageobj","Versengold",1)
		end
	
		--play the song
		local thesong = GetProperty("#Musician1","StartConcert")
		if thesong<34 then
			std_musician_Drey_Weyber()
		elseif thesong<67 then
			std_musician_Immer_schoen_nach_unten_treten()
		else
			std_musician_Ich_und_ein_Fass_voller_Wein()
		end
	
		RemoveProperty("","MusicStage")
	
		while true do
			if GetID("")==GetID("#Musician1") then
				if not HasProperty("#Musician2","MusicStage") and 
					 not HasProperty("#Musician3","MusicStage") and
					 not HasProperty("#Musician4","MusicStage") and
					 not HasProperty("#Musician5","MusicStage") then
	
					RemoveProperty("","StartConcert")
					RemoveProperty("stageobj","Versengold")
					break
				end
			elseif not HasProperty("#Musician1","StartConcert") then
				break
			end
			Sleep(1)
		end

		if GetID("")==GetID("#Musician1") then
			PlaySound3D("", "CharacterFX/applause_loop/applause_loop+0.ogg", 2.0)
		end

		PlayAnimation("","bow")
		Sleep(1)
		PlayAnimation("","bow")
		
		f_EndUseLocator("","PlayPos")
	end
end

function Drey_Weyber()
	local TimeToPlay = 3.54
	local StartTime = GetGametime()
	local EndTime = StartTime + TimeToPlay
	local stage = GetData("#MusicStage")
	local theend = false

	if GetID("")==GetID("#Musician1") then
		PlaySound3D("", "versengold/Versengold__Drey_Weiber__TG2Ren_Special.wav", 2.0)
	end

	while true do
		if GetID("")==GetID("#Musician1") then
			if GetGametime() > EndTime then
				gameplayformulas_BlockMusicForConcert(0)
				SetData("#MusicStage",0)
				break
			elseif (GetGametime() > (StartTime + 2.48)) and (GetGametime() < (StartTime + 2.96)) then
				--Solo
				PlayAnimation("", "dance_male_1")
			elseif ((GetGametime() > (StartTime + 0.48)) and (GetGametime() < (StartTime + 0.62))) or
			       ((GetGametime() > (StartTime + 1.32)) and (GetGametime() < (StartTime + 1.38))) or
			       ((GetGametime() > (StartTime + 1.07)) and (GetGametime() < (StartTime + 1.13))) or
			       (GetGametime() > (StartTime + 3.31)) then
				--sleep
				Sleep(1)
			elseif ((GetGametime() > (StartTime + 0.98)) and (GetGametime() < (StartTime + 1.33))) or
			       ((GetGametime() > (StartTime + 1.75)) and (GetGametime() < (StartTime + 2.08))) or
			       ((GetGametime() > (StartTime + 2.95)) and (GetGametime() < (StartTime + 3.32))) then
				PlayAnimation("", "talk_2")
			else
				local variation = Rand(3)+1
				if variation==1 then
					PlayAnimation("", "talk_short")
				else
					PlayAnimation("", "talk")
				end
			end

		elseif GetID("")==GetID("#Musician2") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(27.5)
				local AnimTime = PlayAnimationNoWait("","play_instrument_02_in")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_Drum.nif",true)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.32)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_02_out")
					Sleep(1.5)
					CarryObject("","",true)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_02_loop")
			end

		elseif GetID("")==GetID("#Musician3") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(27.5)
				local AnimTime = PlayAnimationNoWait("","play_instrument_01_in")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_Flute.nif",false)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.32)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_01_out")
					Sleep(1.5)
					CarryObject("","",false)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_01_loop")
			end
			
		elseif GetID("")==GetID("#Musician4") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(27.5)
				local AnimTime = PlayAnimationNoWait("","play_instrument_03_in")
				Sleep(1)
	  		CarryObject("","Handheld_Device/ANIM_Violinestock.nif",false)
				CarryObject("","Handheld_Device/ANIM_Violine.nif",true)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.32)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_03_out")
					Sleep(1.5)
		  		CarryObject("","",false)
					CarryObject("","",true)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_03_loop")
			end

		elseif GetID("")==GetID("#Musician5") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(2.5)
				local AnimTime = PlayAnimationNoWait("","play_instrument_03_in")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_laute.nif",true)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.32)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_03_out")
					Sleep(1.5)
					CarryObject("","",true)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_03_loop")
			end
		end
	end
end

function Immer_schoen_nach_unten_treten()
	local TimeToPlay = 3.44
	local StartTime = GetGametime()
	local EndTime = StartTime + TimeToPlay
	local stage = GetData("#MusicStage")
	local theend = false


	if GetID("")==GetID("#Musician1") then
		PlaySound3D("", "versengold/Versengold__Immer_schoen_nach_unten_treten__TG2Ren_Special.wav", 2.0)
	end

	while true do
		if GetID("")==GetID("#Musician1") then
			if GetGametime() > EndTime then
				gameplayformulas_BlockMusicForConcert(0)
				SetData("#MusicStage",0)
				break
			elseif ((GetGametime() > (StartTime + 0.23)) and (GetGametime() < (StartTime + 0.33))) or
			       ((GetGametime() > (StartTime + 0.55)) and (GetGametime() < (StartTime + 0.65))) or
			       ((GetGametime() > (StartTime + 1.07)) and (GetGametime() < (StartTime + 1.13))) or
			       ((GetGametime() > (StartTime + 1.33)) and (GetGametime() < (StartTime + 1.43))) or
			       ((GetGametime() > (StartTime + 1.65)) and (GetGametime() < (StartTime + 1.75))) or
			       ((GetGametime() > (StartTime + 2.17)) and (GetGametime() < (StartTime + 2.23))) or
			       ((GetGametime() > (StartTime + 2.43)) and (GetGametime() < (StartTime + 2.5))) or
			       (GetGametime() > (StartTime + 3.42)) then
				--Sleep
				Sleep(1)
			elseif ((GetGametime() > (StartTime + 0.64)) and (GetGametime() < (StartTime + 1.08))) or
			       ((GetGametime() > (StartTime + 1.74)) and (GetGametime() < (StartTime + 2.18))) or
			       ((GetGametime() > (StartTime + 3)) and (GetGametime() < (StartTime + 3.15))) then
				--Refrain
				PlayAnimation("", "sing_for_peace")
			elseif ((GetGametime() > (StartTime + 3.14)) and (GetGametime() < (StartTime + 3.43))) then
				--Finale
				PlayAnimation("", "cheer2")
			else
				local variation = Rand(3)+1
				if variation==1 then
					PlayAnimation("", "talk_short")
				else
					PlayAnimation("", "talk")
				end
			end

		elseif GetID("")==GetID("#Musician2") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(10)
				local AnimTime = PlayAnimationNoWait("","play_instrument_02_in")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_Drum.nif",true)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.42)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_02_out")
					Sleep(1.5)
					CarryObject("","",true)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_02_loop")
			end

		elseif GetID("")==GetID("#Musician3") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(10)
				local AnimTime = PlayAnimationNoWait("","play_instrument_01_in")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_Flute.nif",false)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.42)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_01_out")
					Sleep(1.5)
					CarryObject("","",false)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_01_loop")
			end
			
		elseif GetID("")==GetID("#Musician4") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(8.0)
				local AnimTime = PlayAnimationNoWait("","play_instrument_03_in")
				Sleep(1)
	  		CarryObject("","Handheld_Device/ANIM_Violinestock.nif",false)
				CarryObject("","Handheld_Device/ANIM_Violine.nif",true)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.42)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_03_out")
					Sleep(1.5)
		  		CarryObject("","",false)
					CarryObject("","",true)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_03_loop")
			end

		elseif GetID("")==GetID("#Musician5") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.01)) then
				--Start
				local AnimTime = PlayAnimationNoWait("","play_instrument_03_in")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_laute.nif",true)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.42)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_03_out")
					Sleep(1.5)
					CarryObject("","",true)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_03_loop")
			end
		end
	end
end

function Ich_und_ein_Fass_voller_Wein()
	local TimeToPlay = 3.37
	local StartTime = GetGametime()
	local EndTime = StartTime + TimeToPlay
	local stage = GetData("#MusicStage")
	local theend = false

	if GetID("")==GetID("#Musician1") then
		PlaySound3D("", "versengold/Versengold__Ich_und_ein_Fass_voller_Wein__TG2Ren_Special.wav", 2.0)
	end

	while true do
		if GetID("")==GetID("#Musician1") then
			if GetGametime() > EndTime then
				gameplayformulas_BlockMusicForConcert(0)
				SetData("#MusicStage",0)
				break
			elseif (GetGametime() < (StartTime + 0.06)) or (GetGametime() > (StartTime + 3.38)) then
				--Start & End
				Sleep(1)
			elseif (GetGametime() > (StartTime + 1.24)) and (GetGametime() < (StartTime + 1.28)) then
				--Cheer
				PlayAnimation("", "cheer_2")
			elseif (GetGametime() > (StartTime + 1.27)) and (GetGametime() < (StartTime + 1.31)) then
				--Cheer sleep
				Sleep(1)
			elseif ((GetGametime() > (StartTime + 0.68)) and (GetGametime() < (StartTime + 0.98))) or
			       ((GetGametime() > (StartTime + 1.66)) and (GetGametime() < (StartTime + 1.96))) or
			       ((GetGametime() > (StartTime + 2.61)) and (GetGametime() < (StartTime + 2.91))) then
				PlayAnimation("", "talk_2")
				PlayAnimation("", "talk_2")
			elseif ((GetGametime() > (StartTime + 2.98)) and (GetGametime() < (StartTime + 3.13))) then
				PlayAnimation("", "talk_2")
			else
				local variation = Rand(3)+1
				if variation==1 then
					PlayAnimation("", "talk_short")
				else
					PlayAnimation("", "talk")
				end
			end

		elseif GetID("")==GetID("#Musician2") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(2.5)
				local AnimTime = PlayAnimationNoWait("","play_instrument_02_in")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_Drum.nif",true)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.16)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_02_out")
					Sleep(1.5)
					CarryObject("","",true)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_02_loop")
			end

		elseif GetID("")==GetID("#Musician3") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(39.5)
				local AnimTime = PlayAnimationNoWait("","play_instrument_01_in")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_Flute.nif",false)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_01_out")
					Sleep(1.5)
					CarryObject("","",false)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_01_loop")
			end
			
		elseif GetID("")==GetID("#Musician4") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(39.5)
				local AnimTime = PlayAnimationNoWait("","play_instrument_03_in")
				Sleep(1)
	  		CarryObject("","Handheld_Device/ANIM_Violinestock.nif",false)
				CarryObject("","Handheld_Device/ANIM_Violine.nif",true)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3.35)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_03_out")
					Sleep(1.5)
		  		CarryObject("","",false)
					CarryObject("","",true)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_03_loop")
			end

		elseif GetID("")==GetID("#Musician5") then
			if theend and (GetData("#MusicStage")==0 or GetData("#MusicStage")~=stage) then
				break

			elseif (GetGametime() < (StartTime + 0.05)) then
				--Start
				Sleep(2.5)
				local AnimTime = PlayAnimationNoWait("","play_instrument_03_in")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_laute.nif",true)
				Sleep(AnimTime-1)

			elseif (GetGametime() > (StartTime + 3)) then
				--end
				if theend then
					Sleep(1)
				else
					local AnimTime = PlayAnimationNoWait("","play_instrument_03_out")
					Sleep(1.5)
					CarryObject("","",true)
					Sleep(AnimTime-1.5)
					theend = true
				end

			else
				PlayAnimation("","play_instrument_03_loop")
			end
		end
	end
end

function HaveFunInTavern(stageobj,EndTime)

	if HasProperty("","HaveFun") then

		if GetFreeLocatorByName(stageobj,"SitInn",1,12,"SitPos") and f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then

			while true do
				if GetProperty("","HaveFun")==GetRound() and math.mod(GetGametime(), 24)>=EndTime then
					std_musician_ResetComeOver()
					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
					break
				end
	
				if not HasProperty("","KissMe") then
					std_musician_CheckForGroupie()
				end
				
				if HasProperty("","KissMe") and std_musician_CheckComeOver()==true then
					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
				
					std_musician_ComeOver()
					
					while true do
						if GetProperty("","HaveFun")==GetRound() and math.mod(GetGametime(), 24)>=EndTime then
							break
						elseif GetFreeLocatorByName(stageobj,"SitInn",1,12,"SitPos") and f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
							break
						end
						Sleep(5)
					end
					
				else
					local AnimTime
					local AnimType = Rand(6)
					PlaySound3DVariation("","Locations/tavern_people",1)
		
					if AnimType==0 or AnimType==1 then
						AnimTime = PlayAnimationNoWait("","sit_drink")
						Sleep(1)
						CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
						Sleep(1)
						PlaySound3DVariation("","CharacterFX/drinking",1)
						Sleep(AnimTime-1.5)
						CarryObject("","",false)
						PlaySound3DVariation("","CharacterFX/male_belch",1)
						Sleep(1.5)
					
					elseif AnimType==2 then
						PlayAnimation("","sit_eat")
		
					elseif AnimType==3 then
						PlayAnimation("","sit_talk")
		
					elseif AnimType==4 then
						AnimTime = PlayAnimationNoWait("","sit_cheer")
						Sleep(1)
						PlaySound3D("","Locations/tavern/cheers_01.wav",1)
						CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
						Sleep(1)
						PlaySound3DVariation("","CharacterFX/drinking",1)
						Sleep(AnimTime-1.5)
						CarryObject("","",false)
						Sleep(1.5)
						
					else
						PlayAnimationNoWait("","sit_laugh")
						Sleep(2)
						if Rand(2)==0 then
							PlaySound3D("","Locations/tavern/laugh_01.wav",1)
						else
							PlaySound3D("","Locations/tavern/laugh_02.wav",1)
						end
						Sleep(5)
					end
				end
			end
		
		else
			while true do
				if GetProperty("","HaveFun")==GetRound() and math.mod(GetGametime(), 24)>=EndTime then
					std_musician_ResetComeOver()
					break
				end
	
				if not HasProperty("","KissMe") then
					std_musician_CheckForGroupie()
				end
				
				if HasProperty("","KissMe") and std_musician_CheckComeOver()==true then
					std_musician_ComeOver()
				else
					Sleep(5)
				end
			end
		end
	else
		Sleep(2)
	end
	
end

function HaveFunInDivehouse(stageobj,EndTime)

	if HasProperty("","HaveFun") then

		if GetFreeLocatorByName(stageobj,"Sit",1,11,"SitPos") and f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then

			while true do
				if GetProperty("","HaveFun")==GetRound() and math.mod(GetGametime(), 24)>=EndTime then
					std_musician_ResetComeOver()
					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
					break
				end
	
				if not HasProperty("","KissMe") then
					std_musician_CheckForGroupie()
				end
				
				if HasProperty("","KissMe") and std_musician_CheckComeOver()==true then
					f_EndUseLocator("","SitPos",GL_STANCE_STAND)
				
					std_musician_ComeOver()
					
					while true do
						if GetProperty("","HaveFun")==GetRound() and math.mod(GetGametime(), 24)>=EndTime then
							break
						elseif GetFreeLocatorByName(stageobj,"Sit",1,11,"SitPos") and f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true) then
							break
						end
						Sleep(5)
					end

				else
					local AnimTime
					local AnimType = Rand(6)
					PlaySound3DVariation("","Locations/tavern_people",1)
		
					if AnimType==0 or AnimType==1 then
						AnimTime = PlayAnimationNoWait("","sit_drink")
						Sleep(1)
						CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
						Sleep(1)
						PlaySound3DVariation("","CharacterFX/drinking",1)
						Sleep(AnimTime-1.5)
						CarryObject("","",false)
						PlaySound3DVariation("","CharacterFX/male_belch",1)
						Sleep(1.5)
					
					elseif AnimType==2 then
						PlayAnimation("","sit_eat")
		
					elseif AnimType==3 then
						PlayAnimation("","sit_talk")
		
					elseif AnimType==4 then
						AnimTime = PlayAnimationNoWait("","sit_cheer")
						Sleep(1)
						PlaySound3D("","Locations/tavern/cheers_01.wav",1)
						CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
						Sleep(1)
						PlaySound3DVariation("","CharacterFX/drinking",1)
						Sleep(AnimTime-1.5)
						CarryObject("","",false)
						Sleep(1.5)
						
					else
						PlayAnimationNoWait("","sit_laugh")
						Sleep(2)
						if Rand(2)==0 then
							PlaySound3D("","Locations/tavern/laugh_01.wav",1)
						else
							PlaySound3D("","Locations/tavern/laugh_02.wav",1)
						end
						Sleep(5)
					end
				end
			end
		
		else
			while true do
				if GetProperty("","HaveFun")==GetRound() and math.mod(GetGametime(), 24)>=EndTime then
					break
				end
	
				if not HasProperty("","KissMe") then
					std_musician_CheckForGroupie()
				end
				
				if HasProperty("","KissMe") and std_musician_CheckComeOver()==true then
					std_musician_ComeOver()
				else
					Sleep(5)
				end
			end
		end
	else
		Sleep(2)
	end
	
end

function ResetComeOver()
	if HasProperty("","KissMe") then
		local Honey = GetProperty("","KissMe")
		if GetAliasByID(Honey,"Honey") then
			if HasProperty("Honey","KissMeHoney") then
				RemoveProperty("Honey","KissMeHoney")
			end
		end
		RemoveProperty("","KissMe")
	end
end

function CheckComeOver()
	local Honey = GetProperty("","KissMe")
	if GetAliasByID(Honey,"Honey") then
		if GetDistance("", "Honey")<550 then
			SimLock("Honey", 1)
			return true
		else
			return false
		end
	end
end

function CheckForGroupie()
	local GroupieCnt = Find("","__F((Object.GetObjectsByRadius(Sim)==6000) AND(Object.HasDifferentSex()) AND(Object.MinAge(16)) AND NOT(Object.HasProperty(KissMeHoney)))","Groupie", -1)
	if(GroupieCnt>0) then
		SetProperty("Groupie0","KissMeHoney",GetID(""))
	end
end

function ComeOver()
	local Honey = GetProperty("","KissMe")
	if GetAliasByID(Honey,"Honey") then
		if HasProperty("Honey","KissMeHoney") and GetProperty("Honey","KissMeHoney")==GetID("") then
			if f_MoveTo("Honey", "", GL_MOVESPEED_WALK, 128) then
				SimLock("Honey", 1)
				
				AlignTo("","Honey")
				AlignTo("Honey","")
	
				SetAvoidanceGroup("", "Honey")
				MoveSetActivity("", "converse")
				MoveSetActivity("Honey", "converse")
	
				Sleep(0.5)
	
				if SimGetSpouse("Honey", "Spouse") then
					MsgSay("Honey","@L_VERSENGOLD_COMEOVER_HONEY_MARRIED_SAY",GetID(""),GetID("Spouse"))
				else
					MsgSay("Honey","@L_VERSENGOLD_COMEOVER_HONEY_SINGLE_SAY",GetID(""))
				end
	
				Sleep(0.5)
	
				MsgSay("","@L_VERSENGOLD_COMEOVER_MUSICIAN_REACTION")
	
				Sleep(0.5)
	
				if Rand(10)<8 then
					chr_AlignExact("","Honey",128,1)
	
					chr_MultiAnim("", "kiss_male", "Honey", "kiss_female", 128)
				else
					chr_AlignExact("","Honey",50,1)
	
					PlayAnimationNoWait("","seduce_m_in")
					PlayAnimation("Honey","seduce_f_in")
					PlaySound3DVariation("Honey","CharacterFX/female_jolly",1)
					LoopAnimation("","seduce_m_idle_01",0)
					PlaySound3DVariation("","CharacterFX/male_jolly",1)
					LoopAnimation("Honey","seduce_f_idle_03",10)
					PlayAnimationNoWait("","seduce_m_out")
					PlayAnimation("Honey","seduce_f_out")
				end
		
				ReleaseAvoidanceGroup("")
				MoveSetActivity("")
				StopAnimation("")
				MoveSetActivity("Honey")
				StopAnimation("Honey")
			end
		end
	end
	
	std_musician_ResetComeOver()
end

function CleanUp()

	if GetID("#Musician1")==GetID("") then
		if GetData("#MusicStage")>0 then
			local stage = GetData("#MusicStage")
			GetAliasByID(stage,"stageobj")
			if HasProperty("","Versengold") then
				RemoveProperty("","Versengold")
			end
	
			SetData("#MusicStage",0)
		end
		
		if GetData("#RestPlace")>0 then
			SetData("#RestPlace",0)
		end

		if HasProperty("","StartConcert") then
			RemoveProperty("","StartConcert")
		end
		if HasProperty("","MusicStage") then
			RemoveProperty("","MusicStage")
		end
		if HasProperty("","HaveFun") then
			RemoveProperty("","HaveFun")
		end
	
	else
		if HasProperty("","MusicStage") then
			RemoveProperty("","MusicStage")
		end
		if HasProperty("","HaveFun") then
			RemoveProperty("","HaveFun")
		end
	end

	std_musician_ResetComeOver()

end
