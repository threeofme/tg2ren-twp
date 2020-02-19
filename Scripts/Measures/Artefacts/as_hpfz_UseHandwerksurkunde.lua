function Run()

	if IsStateDriven() then
		local ItemName = "Handwerksurkunde"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	if not GetInsideBuilding("", "Building") or not BuildingIsWorkingTime("Building") then
		MsgQuick("", "_HPFZ_ARTEFAKT_SOCKEN_FEHLER_+0")
		StopMeasure()
	end

	local numFound = 0
	local	Alias
	local count = BuildingGetWorkerCount("Building")	
	for number=0, count-1 do
		Alias = "Worker"..numFound
		if BuildingGetWorker("Building", number, Alias) then
			if SimIsWorkingTime(Alias) then
				numFound = numFound + 1
			end
		end
	end
	
	if (numFound ==0) then
		MsgQuick("", "_HPFZ_ARTEFAKT_SOCKEN_FEHLER_+1")
		StopMeasure()
	end

	local MeasureID = GetCurrentMeasureID("") 
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if GetLocatorByName("Building", "Propel", "StandPosition") then
		f_MoveTo("","StandPosition")
	end
	
	local Alias
	for loop_var=0, numFound-1 do
		Alias = "Worker"..loop_var
		if SimPauseWorking(Alias) then
			SendCommandNoWait(Alias,"Listen")
		end
	end
	
	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)
	
	AlignTo("","Worker0")
	Sleep(1)	
	PlayAnimationNoWait("","use_book_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/Anim_book.nif",false)
	if SimGetGender("") == 1 then
		PlaySound3D("","CharacterFX/male_neutral/male_neutral+9.ogg", 1.0)
	else
		PlaySound3D("","CharacterFX/female_cheer/female_cheer+1.ogg", 1.0)
	end
	
	Sleep(5)
	CarryObject("","",false)								
	if RemoveItems("","Handwerksurkunde",1) then
		GetPosition("", "ParticleSpawnPos")
		StartSingleShotParticle("particles/pray_glow.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)	
		Sleep(1)

		local AnimTime = 1
		for loop_var=0, numFound-1 do
			Alias = "Worker"..loop_var
			chr_ModifyFavor(Alias, "Owner", 20)
			Sleep(0.5)
			chr_GainXP(Alias, 500)
			if SimGetGender(Alias) == 1 then
				AnimTime = PlayAnimationNoWait(Alias, "cheer_02")
				PlaySound3D(Alias,"CharacterFX/male_cheer/male_cheer+4.ogg", 1.0)
			else
				AnimTime = PlayAnimationNoWait(Alias, "cheer_02")
				PlaySound3D(Alias,"CharacterFX/female_cheer/female_cheer+3.ogg", 1.0)
			end
		end
		Sleep(0.5)
		chr_GainXP("", GetData("BaseXP"))
	end
end

function CleanUp()
	StopAnimation("")
	CarryObject("","",false)
end

function Listen()
	AlignTo("","Owner")
	while true do
		Sleep(6)
	end
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
