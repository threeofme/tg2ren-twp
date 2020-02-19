function Init()

	if not GetInsideBuilding("", "Building") then
		if AliasExists("Destination") then
			if f_MoveTo("", "Destination", GL_MOVESPEED_RUN, false) then
				CopyAlias("Destination", "Building")
			else
				StopMeasure()
			end
		else
			StopMeasure()
		end
	end

	if not BuildingIsWorkingTime("Building") then
		MsgQuick("", "@L_HPFZ_GELAGE_BADTIME_+0")
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
	
	if (numFound==0) then
		MsgQuick("", "@L_HPFZ_GELAGE_MISSLUNGEN_+0", GetID("Building"))
		return
	end
	
	local Buildinglevel = BuildingGetLevel("Building")
	local Skill = GetSkillValue("", BARGAINING)/100 -- every Point reduces the cost by 3%
	local MinSaufen = ((200*numFound)*Buildinglevel)*(1-(Skill*3))
	local MedSaufen = ((600*numFound)*Buildinglevel)*(1-(Skill*3))
	local BigSaufen = ((1200*numFound)*Buildinglevel)*(1-(Skill*3))
	
	local result = InitData("@P@B[1,@L%1t,@L%1t,Hud/Buttons/btn_Money_Small.tga]"..
      				"@B[2,@L%2t,@L%2t,Hud/Buttons/btn_Money_Medium.tga]"..
      				"@B[3,@L%3t,@L%3t,Hud/Buttons/btn_Money_Large.tga]",
					ms_hpfz_gelage_AIInitGelageGeben,
					"@L_GENERAL_MEASURES_033_PAYBONUS_FORM_HEAD_+0",
					"@L_GENERAL_MEASURES_033_PAYBONUS_FORM_BODY_+0",
					MinSaufen,MedSaufen,BigSaufen)
	
	if result==1 then
		SetData("TFBonus", MinSaufen)
		SetData("TFFavor", 10)
		SetData("Drunk", 1)
	elseif result==2 then
		SetData("TFBonus", MedSaufen)
		SetData("TFFavor", 30)
		SetData("Drunk", 2)
	elseif result==3 then
		SetData("TFBonus", BigSaufen)
		SetData("TFFavor", 50)
		SetData("Drunk", 3)
	end
	SetData("numFound", numFound)
end 

function AIInitGelageGeben()
	return "1"
end

function Run()

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut		= mdata_GetTimeOut(MeasureID)
	if not HasData("TFBonus") then
		StopMeasure()
	end
	local Bonus				= GetData("TFBonus")
	local FavorModify = GetData("TFFavor")
	local numFound		= GetData("numFound")
	local baseXP			= GetData("BaseXP") * numFound
	if GetMoney("Dynasty") < Bonus then
		MsgQuick("", "@L_HPFZ_GELAGE_MISSLUNGEN_+1", Bonus)
		return
	end
	if GetLocatorByName("Building", "Propel", "StandPosition") then
		f_MoveTo("","StandPosition")
	end
	local	Alias
	for g=0, numFound-1 do
		Alias = "Worker"..g
		if SimPauseWorking(Alias) then
			SendCommandNoWait(Alias,"Listen")
		end
	end
	MeasureSetNotRestartable()
	Sleep(1)
	AlignTo("","Worker0")
	Sleep(1)
	if GetMoney("Dynasty") < Bonus then
		MsgQuick("", "@L_HPFZ_GELAGE_MISSLUNGEN_+1", Bonus)
		return
	end

	MsgSay("", "@L_HPFZ_GELAGE_SPRUCH_+0")
	SetMeasureRepeat(TimeOut)
	f_SpendMoney("Dynasty", Bonus, "LaborBonus")
	for g=0, numFound-1 do
		Alias = "Worker"..g
		if SimPauseWorking(Alias) then
			SendCommandNoWait(Alias,"GetADrink")
		end
	end
	
	local meDrinking = GetData("Drunk")
	for g=1, meDrinking do
	    if g < 2 then
		   MsgSay("", "@L_HPFZ_GELAGE_SPRUCH_+3")
		   Sleep(2)
		end
		local trunkSpruch = Rand(3)
		if trunkSpruch == 0 then
		    MsgSay("","@L_HPFZ_GELAGE_SPRUCH_+4")
		elseif trunkSpruch == 1 then
		    MsgSay("","@L_HPFZ_GELAGE_SPRUCH_+5")
		else
			MsgSayNoWait("", "@L_HPFZ_GELAGE_SPRUCH_+6")
	    end
		local dotimeDR = PlayAnimationNoWait("","clink_glasses")
		Sleep(1)
		CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
		Sleep(dotimeDR-2)
		PlaySound3DVariation("","CharacterFX/male_belch",1)
		CarryObject("","",false)
	end
	
	chr_GainXP("",baseXP)
	
	for g=0, numFound-1 do
	  Alias = "Worker"..g
		chr_ModifyFavor(Alias , "Owner", FavorModify)
		feedback_OverheadComment(Alias, "@L$S[2007]", false, false, FavorModify )
		if GetData("Drunk") == 3 then
			if Rand(100)>60 then
		  	AddImpact(Alias,"totallydrunk",1,6)
	      AddImpact(Alias,"MoveSpeed",0.7,6)
	      SetState(Alias,STATE_TOTALLYDRUNK,true)
		  end
	  end
	end
	
	if GetData("Drunk") == 3 then
	    if Rand(100) > 70 then
		    AddImpact("","totallydrunk",1,6)
	        AddImpact("","MoveSpeed",0.7,6)
	        SetState("",STATE_TOTALLYDRUNK,true)
	    end
	end
	
	StopMeasure()

end

function CleanUp()
	CarryObject("", "", false)
	StopAnimation("")
end

function Listen()
	AlignTo("","Owner")
	while true do
		Sleep(42)
	end
end

function GetADrink()

    local drinkRounds = GetData("Drunk")
    for p=1, drinkRounds do
        local spruch = Rand(3)
	    local animme
        if reaktion == 1 then
		    MsgSayNoWait("", "_HPFZ_GELAGE_SPRUCH_+1")
	    elseif reaktion == 2 then
		    MsgSayNoWait("", "_HPFZ_GELAGE_SPRUCH_+2")
	    end
		local dotimeDRt = PlayAnimationNoWait("","clink_glasses")
		Sleep(1)
		CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
		Sleep(dotimeDRt-2)
		PlaySound3DVariation("","CharacterFX/male_belch",1)
		CarryObject("","",false)
		Sleep(Rand(2)+2)
	end
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

