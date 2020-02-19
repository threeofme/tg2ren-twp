function Run()
	MoveSetStance("",GL_STANCE_STAND)
	MoveSetActivity("","drunk")
	f_ExitCurrentBuilding("")
	if not GetHomeBuilding("","MyHome") then
		SetState("",STATE_TOTALLYDRUNK,false)
	end
	if GetInsideBuilding("","CurrentBld") then
		GetPosition("CurrentBld","CurrentPos")
	else
		GetPosition("","CurrentPos")
	end
	local XPToGain = 250
	if AliasExists("CurrentPos") then
		GetPosition("MyHome","HomePos")
		XPToGain = GetDistance("CurrentPos","HomePos")/10
		SetData("XPToGain",XPToGain)
	end
	
	while GetState("",STATE_TOTALLYDRUNK)==true do
		if GetInsideBuilding("","CurrentBuilding") then
			if GetID("CurrentBuilding")==GetID("MyHome") then
				ms_trytowalkhome_LayDownToSleep()
			end
		end
		local WhatToDoNext = Rand(7)
		if WhatToDoNext == 0 then
			ms_trytowalkhome_Brawl()
		elseif WhatToDoNext == 1 then
			ms_trytowalkhome_KissCheck()
		elseif WhatToDoNext == 2 then
			ms_trytowalkhome_DanceABit()
		elseif WhatToDoNext > 2 then
			ms_trytowalkhome_MoveHome()
		end
		Sleep(1)
	end
end

function DanceABit()
	CommitAction("bard","","")
	if SimGetGender("")==GL_GENDER_MALE then
		PlaySound3DVariation("","CharacterFX/male_joy_loop",1)
	else
		PlaySound3DVariation("","CharacterFX/female_joy_loop",1)
	end
	if SimGetGender("")==GL_GENDER_MALE then
		if Rand(10)>4 then
			PlayAnimation("","dance_male_1")
		else
			PlayAnimation("","dance_male_2")
		end
	else
		if Rand(10)>4 then
			PlayAnimation("","dance_female_1")
		else
			PlayAnimation("","dance_female_2")
		end
	end
	StopAction("bard","")
end

function Brawl()
	local SimFilter = "__F((Object.GetObjectsByRadius(Sim) == 1000)AND NOT(Object.GetState(townnpc))AND(Object.GetState(idle)))"
	local NumSims = Find("", SimFilter,"Enemy", -1)
	if NumSims <= 0 then
		return
	end
	
	if not ai_StartInteraction("", "Enemy", 1000, 100, "BlockMe") then
		return
	end
	AlignTo("","Enemy")
	AlignTo("Enemy","")
	Sleep(1)
	
	if SimGetGender("")==GL_GENDER_MALE then
		PlaySound3DVariation("","CharacterFX/male_anger_loop",1)
	else
		PlaySound3DVariation("","CharacterFX/female_anger_loop",1)
	end
	PlayAnimation("","threat")
	chr_ModifyFavor("Enemy","",-5)
	if SimGetGender("Enemy")==GL_GENDER_MALE then
		PlaySound3DVariation("","CharacterFX/male_joy_loop",1)
		PlayAnimationNoWait("Enemy","talk_2")
	else
		PlayAnimationNoWait("Enemy","give_a_slap")
		PlayAnimation("","got_a_slap")
	end
	SetData("Blocked",1)
	Sleep(3)
	return
end

function MoveHome()
	f_MoveToNoWait("","MyHome")
	Sleep(Rand(20)+30)
	MoveStop("")
	local Choice = Rand(100)
	if Choice>70 then
		MoveSetActivity("","unconscious")
		Sleep(10)
		if Rand(100)>97 then
			diseases_Sprain("",true)
		end
		MoveSetActivity("","")
		Sleep(9)
		--PlayAnimation("","cogitate")
		MoveSetActivity("","drunk")
	elseif Choice>40 then
		MoveSetStance("",GL_STANCE_KNEEL)
		Sleep(5)
		MoveSetStance("",GL_STANCE_STAND)
		Sleep(5)
	end
	return
end

function KissCheck()
	local SimFilter = "__F((Object.GetObjectsByRadius(Sim) == 1000)AND(Object.HasDifferentSex())AND NOT(Object.GetState(townnpc))AND(Object.GetState(idle)))"
	local NumSims = Find("", SimFilter,"Enemy", -1)
	if NumSims <= 0 then
		return
	end
	if not ai_StartInteraction("", "Enemy", 1000, 100, "BlockMe") then
		return
	end
	AlignTo("","Enemy")
	AlignTo("Enemy","")
	Sleep(1)
	PlayAnimation("","point_at")
	PlayAnimationNoWait("Enemy","push_back_female")
	if SimGetGender("")==GL_GENDER_MALE then
		PlaySound3DVariation("Enemy","CharacterFX/male_anger",1)
	else
		PlaySound3DVariation("Enemy","CharacterFX/female_anger",1)
	end
	chr_ModifyFavor("Enemy","",-5)
	PlayAnimation("","push_back_male")
	GetFleePosition("Enemy","",800,"FleePos")
	f_MoveToNoWait("Enemy","FleePos",GL_MOVESPEED_RUN)
	if SimGetGender("")==GL_GENDER_MALE then
		PlaySound3DVariation("","CharacterFX/male_anger_loop",1)
	else
		PlaySound3DVariation("","CharacterFX/female_anger_loop",1)
	end
	PlayAnimation("","threat")
	AlignTo("","Enemy")
	AlignTo("Enemy","")
	SetData("Blocked",1)
	Sleep(1)
	return
end

function BlockMe()
	SetData("Blocked",0)
	while GetData("Blocked")~=1 do
		Sleep(0.76)
	end
end

function LayDownToSleep()
	if GetFreeLocatorByName("MyHome", "Bed",1,3, "SleepPosition") then
		if not f_BeginUseLocator("", "SleepPosition", GL_STANCE_LAY, true) then
			StopMeasure()
		end
	end
	if IsDynastySim("") then
		local XPToGain = GetData("XPToGain")
		IncrementXP("",XPToGain)
	end
	while GetState("",STATE_TOTALLYDRUNK)==true do
		Sleep(5)
		-- increase the hp due to the recover factor for the residence
		PlaySound3DVariation("","measures/gotosleep",1)
		if GetHP("") < GetMaxHP("") then
			ModifyHP("", 1,false)	
		end
	end
end

function CleanUp()
	StopAction("bard","")
	MoveSetActivity("","")
end


