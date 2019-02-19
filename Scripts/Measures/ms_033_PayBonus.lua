-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_033_PayBonus"
----
----	with this measure the player can pay a bonus to the employees in one of his
----	workshops. This increases the employee's loyalty
----
-------------------------------------------------------------------------------


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
		MsgBoxNoWait("","Building","@L_GENERAL_MEASURES_033_PAYBONUS_FAILURES_HEAD_+0","@L_GENERAL_MEASURES_033_PAYBONUS_FAILURES_BODY_+0")
		StopMeasure()
	end
	
	local numFound = 0
	local Alias
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
		MsgQuick("", "@L_GENERAL_MEASURES_033_PAYBONUS_FAILURES_+0", GetID("Building"))
		return
	end

	local Money = GetMoney("") 
	
	if Money < 11 then
		MsgQuick("","@L_INTRIGUE_041_BRIBECHARACTER_FAILURES_+0")
		StopMeasure()
	end
	
	local Buildinglevel = BuildingGetLevel("Building")
	local Skill = GetSkillValue("", BARGAINING)/100 -- every Point reduces the cost by 3%
	local MinMoney = ((200*numFound)*Buildinglevel)*(1-(Skill*3))
	local MedMoney = ((400*numFound)*Buildinglevel)*(1-(Skill*3))
	local BigMoney = ((800*numFound)*Buildinglevel)*(1-(Skill*3))
	
	local result = InitData("@P@B[1,@L%1t,@L%1t,Hud/Buttons/btn_Money_Small.tga]"..
      				"@B[2,@L%2t,@L%2t,Hud/Buttons/btn_Money_Medium.tga]"..
      				"@B[3,@L%3t,@L%3t,Hud/Buttons/btn_Money_Large.tga]",
	ms_033_paybonus_AIInitPayBonus,
	"@L_GENERAL_MEASURES_033_PAYBONUS_FORM_HEAD_+0",
	"@L_GENERAL_MEASURES_033_PAYBONUS_FORM_BODY_+0",
	MinMoney,MedMoney,BigMoney)
	
	if result==1 then
		SetData("TFBonus", MinMoney)
		SetData("TFFavor", 10)
	elseif result==2 then
		SetData("TFBonus", MedMoney)
		SetData("TFFavor", 20)
	elseif result==3 then
		SetData("TFBonus", BigMoney)
		SetData("TFFavor", 30)
	end
	SetData("numFound", numFound)
end 

function AIInitPayBonus()
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
		MsgQuick("", "@L_GENERAL_MEASURES_033_PAYBONUS_FAILURES_+1", Bonus)
		return
	end

	-- move player character to propel position
	if GetLocatorByName("Building", "Propel", "StandPosition") then
		f_MoveTo("","StandPosition")
	end
	
	local	Alias
	
	for loop_var=0, numFound-1 do
		Alias = "Worker"..loop_var
		if SimPauseWorking(Alias) then
			SendCommandNoWait(Alias,"Listen")
		end
	end

	MeasureSetNotRestartable()
	
	
	-- change the check from GetInsideBuilding to SimIsWorkingTime to make it possible to use this measure on outside workers at farms/mines/etc.

	Sleep(1)

	AlignTo("","Worker0")
	Sleep(1)
	
	if GetMoney("Dynasty") < Bonus then
		MsgQuick("", "@L_GENERAL_MEASURES_033_PAYBONUS_FAILURES_+1", Bonus)
		return
	end

	MsgSay("", "@L_GENERAL_MEASURES_033_PAYBONUS_STATEMENT_+0")
	SetMeasureRepeat(TimeOut)
	
	-- loose money
	f_SpendMoney("Dynasty", Bonus, "LaborBonus")
	
	-- play animation
	PlayAnimation("", "use_object_standing")

	-- Play a coin sound for the local player	
	if dyn_IsLocalPlayer("") then
		PlaySound3D("","misc/CoinJingle_s_01.wav", 1.0, 1, "c4")
	end
	
	local AnimTime = 1

	for loop_var=0, numFound-1 do
		Alias = "Worker"..loop_var
		chr_ModifyFavor(Alias , "Owner", FavorModify)
		AnimTime = PlayAnimationNoWait(Alias, "nod")
	end
	
	Sleep(0.6)
	chr_GainXP("",baseXP)

	Sleep(AnimTime)
	StopMeasure()

end

function CleanUp()
	StopAnimation("")
end

function Listen()
  -- simplified this logic to make it possible to pay bonus on farms or alchemist huts if the workers are outside building
	AlignTo("","Owner")
	while true do
		Sleep(42)
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

