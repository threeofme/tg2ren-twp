function Run()
	if not GetInsideBuilding("","PartyLocation") then
		if HasProperty("","InvitedBy") then
			local HostID = GetProperty("","InvitedBy")
			if GetAliasByID(HostID,"Host") then
				if not GetHomeBuilding("Host","PartyLocation") then
					StopMeasure()
				end
			end
		end
	end
	--i am the host
	if GetProperty("","Host") then
		behavior_feast_Host()
		--i am musician	
	elseif GetProperty("","Musician1") or GetProperty("","Musician2") or GetProperty("","Musician3") then
		behavior_feast_Musician()
	--i am a guest	
	else
		behavior_feast_Guest()
	end
end

function Host()
	if not GetHomeBuilding("","PartyLocation") then
		StopMeasure()
	end
	if not GetState("PartyLocation",STATE_FEAST) then
		StopMeasure()
	end
	GetLocatorByName("PartyLocation","HostWelcome","HostWelcomePos")
	f_BeginUseLocator("","HostWelcomePos",GL_STANCE_STAND,true)
	while not HasProperty("PartyLocation","AllGuestsThere") do
		Sleep(1)
	end
	--count the guests
	local HostID = GetID("")
	GetLocatorByName("PartyLocation","HostWelcome","SearchPos")
	local GuestFilter = "__F((Object.GetObjectsByRadius(Sim)==20000) AND(Object.Property.InvitedBy=="..HostID..")) )"
	local NumGuests = Find("SearchPos",GuestFilter,"Guest",-1)
	
	if NumGuests == 0 then		--no guests here. stop the feast
		SetState("PartyLocation",STATE_FEAST,false)
		StopMeasure()
	end
	
	
	--camera
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	for i=1,6 do
		if HasProperty("PartyLocation","Guest"..i) then
			local GuestID = GetProperty("PartyLocation","Guest"..i)
			if GetAliasByID(GuestID,"Guest"..i) then
				if GetInsideBuilding("Guest"..i,"CurrentBuilding") then
					if GetID("CurrentBuilding")==GetID("PartyLocation") then
						CutsceneAddSim("cutscene","Guest"..i)
					else
						if HasProperty("PartyLocation","Guest"..i) then
							RemoveProperty("PartyLocation","Guest"..i)
						end
						if HasProperty("Guest"..i,"InvitedBy") then
							RemoveProperty("Guest"..i,"InvitedBy")
						end
					end
				else
					if HasProperty("PartyLocation","Guest"..i) then
						RemoveProperty("PartyLocation","Guest"..i)
					end
					if HasProperty("Guest"..i,"InvitedBy") then
						RemoveProperty("Guest"..i,"InvitedBy")
					end
				end
			end
		end
	end
	CutsceneCameraCreate("cutscene","")		
	camera_CutsceneBothLock("cutscene", "")
	
	
	MsgSay("","@L_FEAST_3_FEAST_A_HELLO_GO_EVERYTHINGOK")
	for i=0,NumGuests-1 do
		chr_ModifyFavor("Guest"..i,"",2)
	end
			
	MsgSay("","@L_FEAST_3_FEAST_B_DANCE_INTRO")
	GetLocatorByName("PartyLocation","CameraTotal","CamPos")
	CutsceneCameraSetAbsolutePosition("cutscene","CamPos")
	
	SetProperty("PartyLocation","GoDance",1)
	SetProperty("PartyLocation","DanceFinished",0)
	gameplayformulas_StartHighPriorMusic(MUSIC_PARTY)
	if GetFreeLocatorByName("PartyLocation","Dance",1,7,"DancePos") then
		if f_BeginUseLocator("","DancePos",GL_STANCE_STAND,true) then
			if SimGetGender("")==GL_GENDER_MALE then
				PlayAnimation("","dance_male_1")
				PlayAnimation("","dance_male_2")
			else
				PlayAnimation("","dance_female_1")
				PlayAnimation("","dance_female_2")
			end
		else
			PlayAnimation("","cogitate")
		end
	end
	local Finished = GetProperty("PartyLocation","DanceFinished")
	Finished = Finished + 1
	SetProperty("PartyLocation","DanceFinished",Finished)
	while true do
		NumGuests = Find("SearchPos",GuestFilter,"Guest",-1)
		Finished = GetProperty("PartyLocation","DanceFinished")
		if NumGuests == Finished -1 then
			break
		end
		Sleep(1)
	end
	
	RemoveProperty("PartyLocation","GoDance")
	RemoveProperty("PartyLocation","DanceFinished")
	--finished with dance
	local MusicQuality = GetProperty("PartyLocation","MusicLevel")
	for i=1,6 do
		if HasProperty("PartyLocation","Guest"..i) then
			local GuestID = GetProperty("PartyLocation","Guest"..i)
			if GetAliasByID(GuestID,"Guest") then
				local GuestWealth = SimGetRank("Guest")
				GuestWealth = GuestWealth - 1
				MusicQuality = MusicQuality - GuestWealth
				if MusicQuality >= 0 then
					if Rand(100) > 20 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_B_DANCE_COMMENTS_VERYCONFIDENT")
					end
					chr_ModifyFavor("Guest","",5)
					SetProperty("PartyLocation","FavorWonMusic"..i,5)
				elseif MusicQuality == -1 then
					if GuestWealth == 4 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_B_DANCE_COMMENTS_DISAPPOINTED")
						chr_ModifyFavor("Guest","",-2)
						SetProperty("PartyLocation","FavorWonMusic"..i,-2)
					else
						if Rand(100) > 20 then
							camera_CutsceneBothLock("cutscene", "Guest")
							MsgSay("Guest","@L_FEAST_3_FEAST_B_DANCE_COMMENTS_CONFIDENT")
						end
						chr_ModifyFavor("Guest","",3)
						SetProperty("PartyLocation","FavorWonMusic"..i,3)
					end
				elseif MusicQuality == -2 then
					if GuestWealth == 4 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_B_DANCE_COMMENTS_VERYDISAPPOINTED")
						chr_ModifyFavor("Guest","",-4)
						SetProperty("PartyLocation","FavorWonMusic"..i,-4)
					else
						if Rand(100) > 20 then
							camera_CutsceneBothLock("cutscene", "Guest")
							MsgSay("Guest","@L_FEAST_3_FEAST_B_DANCE_COMMENTS_NEUTRAL")
						end
						chr_ModifyFavor("Guest","",1)
						SetProperty("PartyLocation","FavorWonMusic"..i,1)
					end
				elseif MusicQuality == -3 then
					if GuestWealth == 4 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_B_DANCE_COMMENTS_VERYDISAPPOINTED")
						chr_ModifyFavor("Guest","",-4)
						SetProperty("PartyLocation","FavorWonMusic"..i,-4)
					else
						if Rand(100) > 20 then
							camera_CutsceneBothLock("cutscene", "Guest")
							MsgSay("Guest","@L_FEAST_3_FEAST_B_DANCE_COMMENTS_DISAPPOINTED")
						end
						chr_ModifyFavor("Guest","",-2)
						SetProperty("PartyLocation","FavorWonMusic"..i,-2)
					end
				elseif MusicQuality == -4 then
					if Rand(100) > 20 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_B_DANCE_COMMENTS_VERYDISAPPOINTED")
						chr_ModifyFavor("Guest","",-4)
						SetProperty("PartyLocation","FavorWonMusic"..i,-4)
					end
				end
			end
		end
	end
	camera_CutsceneBothLock("cutscene", "")
	MsgSay("","@L_FEAST_3_FEAST_C_EATDRINK_INTRO")
	SetProperty("PartyLocation","StartEat",1)
	SetProperty("PartyLocation","EatFinished",0)
	
	
	CutsceneCameraSetAbsolutePosition("cutscene","CamPos")
	
	PlayAnimation("","eat_standing")
	local FinishedEat = GetProperty("PartyLocation","EatFinished")
	FinishedEat = FinishedEat + 1
	SetProperty("PartyLocation","EatFinished",FinishedEat)
	
	while true do
		NumGuests = Find("SearchPos",GuestFilter,"Guest",-1)
		Finished = GetProperty("PartyLocation","EatFinished")
		if NumGuests == Finished -1 then
			break
		end
		Sleep(1)
	end
	
	RemoveProperty("PartyLocation","StartEat")
	RemoveProperty("PartyLocation","EatFinished")
	
	--finished with eat
	local FoodQuality = GetProperty("PartyLocation","FoodLevel")
	for i=1,6 do
		if HasProperty("PartyLocation","Guest"..i) then
			local GuestID = GetProperty("PartyLocation","Guest"..i)
			if GetAliasByID(GuestID,"Guest") then
				local GuestWealth = SimGetRank("Guest")
				GuestWealth = GuestWealth - 1
				FoodQuality = FoodQuality - GuestWealth
				if FoodQuality >= 0 then
					if Rand(100) > 20 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_C_EATDRINK_COMMENTS_VERYCONFIDENT")
					end
					chr_ModifyFavor("Guest","",5)
					SetProperty("PartyLocation","FavorWonEat"..i,5)
				elseif FoodQuality == -1 then
					if GuestWealth == 4 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_C_EATDRINK_COMMENTS_DISAPPOINTED")
						chr_ModifyFavor("Guest","",-2)
						SetProperty("PartyLocation","FavorWonEat"..i,-2)
					else
						if Rand(100) > 20 then
							camera_CutsceneBothLock("cutscene", "Guest")
							MsgSay("Guest","@L_FEAST_3_FEAST_C_EATDRINK_COMMENTS_CONFIDENT")
						end
						chr_ModifyFavor("Guest","",3)
						SetProperty("PartyLocation","FavorWonEat"..i,3)
					end
				elseif FoodQuality == -2 then
					if GuestWealth == 4 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_C_EATDRINK_COMMENTS_VERYDISAPPOINTED")
						chr_ModifyFavor("Guest","",-4)
						SetProperty("PartyLocation","FavorWonEat"..i,-4)
					else
						if Rand(100) > 20 then
							camera_CutsceneBothLock("cutscene", "Guest")
							MsgSay("Guest","@L_FEAST_3_FEAST_C_EATDRINK_COMMENTS_NEUTRAL")
						end
						chr_ModifyFavor("Guest","",1)
						SetProperty("PartyLocation","FavorWonEat"..i,1)
					end
				elseif FoodQuality == -3 then
					if GuestWealth == 4 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_C_EATDRINK_COMMENTS_VERYDISAPPOINTED")
						chr_ModifyFavor("Guest","",-4)
						SetProperty("PartyLocation","FavorWonEat"..i,-4)
					else
						if Rand(100) > 20 then
							camera_CutsceneBothLock("cutscene", "Guest")
							MsgSay("Guest","@L_FEAST_3_FEAST_C_EATDRINK_COMMENTS_DISAPPOINTED")
						end
						chr_ModifyFavor("Guest","",-2)
						SetProperty("PartyLocation","FavorWonEat"..i,-2)
					end
				elseif FoodQuality == -4 then
					if Rand(100) > 20 then
						camera_CutsceneBothLock("cutscene", "Guest")
						MsgSay("Guest","@L_FEAST_3_FEAST_C_EATDRINK_COMMENTS_VERYDISAPPOINTED")
						chr_ModifyFavor("Guest","",-4)
						SetProperty("PartyLocation","FavorWonEat"..i,-4)
					end
				end
			end
		end
	end
	
	--say goodbye
	camera_CutsceneBothLock("cutscene", "")
	MsgSay("","@L_FEAST_4_GOODBYE_A_BYE_INVITER")
	
	--some comments
	FoodQuality = GetProperty("PartyLocation","FoodLevel")
	MusicQuality = GetProperty("PartyLocation","MusicLevel")
	for i=1,6 do
		if HasProperty("PartyLocation","Guest"..i) then
			local GuestID = GetProperty("PartyLocation","Guest"..i)
			if GetAliasByID(GuestID,"Guest") then
				local FavorWon = GetProperty("PartyLocation","FavorWonMusic"..i) + GetProperty("PartyLocation","FavorWonEat"..i)
				if FavorWon >= 5 then
					camera_CutsceneBothLock("cutscene", "Guest")
					MsgSay("Guest","@L_FEAST_4_GOODBYE_B_COMMENTS_GOOD")
				elseif FavorWon <= -5 then
					camera_CutsceneBothLock("cutscene", "Guest")
					MsgSay("Guest","@L_FEAST_4_GOODBYE_B_COMMENTS_BAD")
				else
					camera_CutsceneBothLock("cutscene", "Guest")
					MsgSay("Guest","@L_FEAST_4_GOODBYE_B_COMMENTS_NEUTRAL")
				end
				RemoveProperty("PartyLocation","FavorWonMusic"..i)
				RemoveProperty("PartyLocation","FavorWonEat"..i)
			end
		end
	end
		
	SetProperty("PartyLocation","FeastFinished",1)			
	chr_GainXP("",GetData("BaseXP"))			
	StopMeasure()	
end

function Guest()
	if not AliasExists("Host") then
		if HasProperty("","InvitedBy") then
			local HostID = GetProperty("","InvitedBy")
			if GetAliasByID(HostID,"Host") then
				if not GetHomeBuilding("Host","PartyLocation") then
					StopMeasure()
				end
			end
		else
			StopMeasure()
		end
	end
	if not GetInsideBuilding("","CurrentBuilding") then
		StopMeasure()
	end
	if not GetID("") == GetID("CurrentBuilding") then
		StopMeasure()
	end
	if not GetState("PartyLocation",STATE_FEAST) then
		StopMeasure()
	end
	local HostGender = SimGetGender("Host")
	local ReplacementlabelHostMissing
	if HostGender == GL_GENDER_MALE then
		ReplacementlabelHostMissing = "@L_FEAST_3_FEAST_A_HELLO_INVITERMISSING_1_MALE"
	else
		ReplacementlabelHostMissing = "@L_FEAST_3_FEAST_A_HELLO_INVITERMISSING_1_FEMALE"
	end
	if GetFreeLocatorByName("PartyLocation","GuestWelcome",1,6,"GuestWelcomePos") then
		if f_BeginUseLocator("","GuestWelcomePos",GL_STANCE_STAND,true)then
			local GuestReady = GetProperty("PartyLocation","GuestsReady")
			GuestReady = GuestReady + 1
			SetProperty("PartyLocation","GuestsReady",GuestReady)
			if HasProperty("PartyLocation","NoHost") then
				if not HasData("Comment1") then
					SetData("Comment1",1)
					MsgSay("",ReplacementlabelHostMissing,GetID("Host"))
				else
					Sleep(5)
				end
				chr_ModifyFavor("","Host",-5)
				StopMeasure()
			end
			while not HasProperty("PartyLocation","GoDance") do
				Sleep(1)
			end
			--dance
			if GetFreeLocatorByName("PartyLocation","Dance",1,7,"DancePos") then
				if f_BeginUseLocator("","DancePos",GL_STANCE_STAND,true) then
					if SimGetGender("")==GL_GENDER_MALE then
						PlayAnimation("","dance_male_1")
						PlayAnimation("","dance_male_2")
					else
						PlayAnimation("","dance_female_1")
						PlayAnimation("","dance_female_2")
					end
				else
					PlayAnimation("","cogitate")
				end
			end
			local Finished = GetProperty("PartyLocation","DanceFinished")
			Finished = Finished + 1
			SetProperty("PartyLocation","DanceFinished",Finished)
			--wait for eating
			while not HasProperty("PartyLocation","StartEat") do
				Sleep(1)
			end
			
			--start to eat
			PlayAnimation("","eat_standing")
			local FinishedEat = GetProperty("PartyLocation","EatFinished")
			FinishedEat = FinishedEat + 1
			SetProperty("PartyLocation","EatFinished",FinishedEat)
			while not HasProperty("PartyLocation","FeastFinished") do
				Sleep(1)
			end
			f_ExitCurrentBuilding("")
			StopMeasure()
			
			
		else	--waiting at the door
			if HasProperty("PartyLocation","NoHost") then
				if not HasData("Comment1") then
					SetData("Comment1",1)
					MsgSay("",ReplacementlabelHostMissing,GetID("Host"))
				end
			end
			chr_ModifyFavor("","Host",-5)
			StopMeasure()
			
		end
	else
		StopMeasure()
	end
	StopMeasure()
end

function Musician()
	GetFreeLocatorByName("PartyLocation","Music",1,3,"MusicianMovePos")
	f_BeginUseLocator("","MusicianMovePos",GL_STANCE_STAND,true)
	while not HasProperty("PartyLocation","GoDance") do
		Sleep(1)
	end
	if GetProperty("","Musician1") then
		local AnimTime = PlayAnimationNoWait("","play_instrument_01_in")
		Sleep(1)
		CarryObject("","Handheld_Device/ANIM_Flute.nif",false)
		Sleep(AnimTime-1)
		while not HasProperty("PartyLocation","FeastFinished") do
			PlayAnimation("","play_instrument_01_loop")
		end
		AnimTime = PlayAnimationNoWait("","play_instrument_01_out")
		Sleep(1.5)
		CarryObject("","",false)
		Sleep(AnimTime-1)
	elseif GetProperty("","Musician2") then
		local AnimTime = PlayAnimationNoWait("","play_instrument_02_in")
		Sleep(1)
		CarryObject("","Handheld_Device/ANIM_Drumstick.nif",false)
		CarryObject("","Handheld_Device/ANIM_Drum.nif",true)
		Sleep(AnimTime-1)
		while not HasProperty("PartyLocation","FeastFinished") do
			PlayAnimation("","play_instrument_02_loop")
		end
		AnimTime = PlayAnimationNoWait("","play_instrument_02_out")
		Sleep(1.5)
		CarryObject("","",false)
		CarryObject("","",true)
		Sleep(AnimTime-1)
	else
		local AnimTime = PlayAnimationNoWait("","play_instrument_03_in")
		Sleep(1)
		CarryObject("","Handheld_Device/ANIM_laute.nif",true)
		Sleep(AnimTime-1)
		while not HasProperty("PartyLocation","FeastFinished") do
			PlayAnimation("","play_instrument_03_loop")
		end
		AnimTime = PlayAnimationNoWait("","play_instrument_03_out")
		Sleep(1.5)
		CarryObject("","",true)
		Sleep(AnimTime-1)
	end
	
	Sleep(1000)
end

function CleanUp()
	if GetProperty("","Host") then
		SetState("PartyLocation",STATE_FEAST,false)
		DestroyCutscene("cutscene")
	end
	if AliasExists("PartyLocation") then
		for i=1,6 do
			if HasProperty("PartyLocation","Guest"..i) then
				local PropID = GetProperty("PartyLocation","Guest"..i)
				if PropID == GetID("") then
					RemoveProperty("PartyLocation","Guest"..i)
				end
			end
		end
	end
	if HasProperty("","Host") then
		RemoveProperty("","Host")
	end
	if HasProperty("","InvitedBy") then
		RemoveProperty("","InvitedBy")
	end
	SimResetBehavior("")
end

