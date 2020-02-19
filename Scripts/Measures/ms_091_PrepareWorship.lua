function Run()

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local OriginalDuration = duration
	MeasureSetStopMode(STOP_NOMOVE)
	
	if IsDynastySim("") then
		if SimGetClass("")~=3 then
			return 0
		end
	end
	
	-- for the ai
	if IsPartyMember("") then
		if not GetInsideBuilding("","CurrentBuilding") then
			StopMeasure()
		end
		if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_CHURCH_CATH or BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_CHURCH_EV then
			CopyAlias("CurrentBuilding","church")
		else
			StopMeasure()
		end
	elseif not SimGetWorkingPlace("","church") then
		StopMeasure()
	end
	
	-- for the ai
	if GetInsideBuildingID("") ~= GetID("church") then
		if not f_MoveTo("", "church", GL_MOVESPEED_RUN) then
			return
		end
	end
	
	-- clean the inventory in case of AI from holy water
	if IsStateDriven() then
		local HolyWaterCount = GetItemCount("", "HolyWater", INVENTORY_STD)
		if HolyWaterCount >0 then
			if CanAddItems("church", "HolyWater", HolyWaterCount, INVENTORY_STD) then
				RemoveItems("", "HolyWater", HolyWaterCount, INVENTORY_STD)
				AddItems("church", "HolyWater", HolyWaterCount, INVENTORY_STD)
			end
		end
	end
	
	local MassInProgress = GetProperty("church", "MassInProgress")
	if MassInProgress and MassInProgress~=GetID("") then
		return
	end
	SetProperty("church", "MassInProgress", GetID(""))
	
	-- mass setup first-time or re-enter after sub-measure (WorshipPraise or WorshipScold)
	--local duration = 8
	local TimerLeft = GetRepeatTimerLeft("church",GetMeasureRepeatName())
	if (TimerLeft>0) then
		duration = duration - (TimeOut-TimerLeft)
	else
		SetRepeatTimer("church", GetMeasureRepeatName(), TimeOut)
	end

	if duration<0 then
		StopMeasure()
	end
	
	local Level = BuildingGetLevel("church")
	if Level < 3 then
		PlaySound3D("church","Locations/bell_stroke_minster_loop+0.wav",2)	
	else
		PlaySound3D("church","Locations/bell_stroke_cathedral_loop+0.wav",2)
	end
	
	if GetImpactValue("church","MassInProgress")==0 then
		AddImpact("church","MassInProgress",1,duration)
	end
	if GetImpactValue("","MassInProgress")==0 then
		AddImpact("","MassInProgress",1,duration)
	end
	
	-- worship loop
	GetLocatorByName("church","Priest1","PriestPos")
	f_MoveTo("","PriestPos")
	Sleep(1)
	SetData("WorshipInProgress",1)
	local Replacement
	local Religion = BuildingGetReligion("church")
	if Religion == RELIGION_CATHOLIC then
		Replacement = "_CATHOLIC"
	else
		Replacement = "_PROTESTANT"
	end
	SetProcessMaxProgress("",40)
	local TimeLeft = ImpactGetMaxTimeleft("","MassInProgress") * 10
	
	Sleep(8)
	MsgSay("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_WELCOME")
	while (GetImpactValue("","MassInProgress")==1) do
		TimeLeft = ImpactGetMaxTimeleft("","MassInProgress") * 10
		TimeLeft = (OriginalDuration*10) - TimeLeft
		SetProcessProgress("",TimeLeft)
		PlayAnimationNoWait("","preach")
		MsgSay("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_PREACHING")
		Sleep(6)
		TimeLeft = ImpactGetMaxTimeleft("","MassInProgress") * 10
		TimeLeft = (OriginalDuration*10) - TimeLeft
		SetProcessProgress("",TimeLeft)
		PlayAnimationNoWait("","preach")
		MsgSay("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_BLESSING"..Replacement)
		Sleep(6)
		-- do worship activities here
		if HasProperty("church", "PraiseSomeone") and ReadyToRepeat("", GetMeasureRepeatName2("WorshipPraise")) then
			local PraiseID = GetProperty("church", "PraiseSomeone")
			GetAliasByID(PraiseID, "Target")
			RemoveProperty("church", "PraiseSomeone")
			MeasureRun("", "Target", "WorshipPraise", true)
			return
		elseif HasProperty("church", "ScoldSomeone") and ReadyToRepeat("", GetMeasureRepeatName2("WorshipScold")) then
			local ScoldID = GetProperty("church", "ScoldSomeone")
			GetAliasByID(ScoldID, "Target")
			RemoveProperty("church", "ScoldSomeone")
			MeasureRun("", "Target", "WorshipScold", true)
			return
		end
	end
	SetData("WorshipInProgress",0)
	ResetProcessProgress("")
	IncrementXP("",GetData("BaseXP"))
	SimSetFaith("",SimGetFaith("")+5)
end

function CleanUp()
	StopAnimation("")
	if GetID("church")~=-1 then
	
		local MassInProgress = GetProperty("church", "MassInProgress")
		if MassInProgress and MassInProgress==GetID("") then
			RemoveProperty("church", "MassInProgress")
			RemoveImpact("church","MassInProgress")
			RemoveImpact("","MassInProgress")
		end
	end
	
	if GetImpactValue("","MassInProgress")==0 then
		ResetProcessProgress("")
	end
	
	if not SimIsWorkingTime("") then
		ResetProcessProgress("")
	end
	
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

