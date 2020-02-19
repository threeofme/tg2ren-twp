-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_LeadCrusade"
----
----	With this measure the player can lead a crusade
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	--do the init stuff
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	--check indoor/outdoor
	local PositionArea = PositionGetArea("Destination")
	if PositionArea ~= 4 then
		MsgQuick("","@L_PRIVILEGES_LEADCRUSADE_FAILED_+0")
		StopMeasure()
	end
	
	GetSettlement("","DestCity")

	if not GetOutdoorLocator("MapExit1",1,"CrusadeDestination") then
		if not GetOutdoorLocator("MapExit2",1,"CrusadeDestination") then
			if not GetOutdoorLocator("MapExit3",1,"CrusadeDestination") then
				StopMeasure()
			end
		end
	end
	
	if not CityGetRandomBuilding("DestCity",0,GL_BUILDING_TYPE_DUELPLACE,-1,-1,FILTER_IGNORE,"CrusadeContainer") then
		if not FindNearestBuilding("", -1, GL_BUILDING_TYPE_SOLDIERPLACE, -1, false, "CrusadeContainer") then
			StopMeasure()
		end
	end
	
	SetProperty("","CrusadeContainerID",GetID("CrusadeContainer"))
	
	MsgNewsNoWait("All","","","politics",-1,
			"@L_PRIVILEGES_LEADCRUSADE_MSG_CRUSADE_BEGIN_HEAD_+0",
			"@L_PRIVILEGES_LEADCRUSADE_MSG_CRUSADE_BEGIN_BODY_+0",
			GetID(""),GetID("DestCity"))
	
	--walk to destination an wait
	if not f_MoveTo("", "Destination") then
		StopMeasure()
	end

	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	SetExclusiveMeasure("", "LeadCrusade", EN_BOTH)
	
	local CrusadeRecruitTime = GetGametime() + 4
	
	SetProperty("","NumCrusaders",0)
	
	CommitAction("crusade","","")
	
	CarryObject("","Handheld_Device/ANIM_crossofprotection.nif",false)
	CarryObject("","Handheld_Device/ANIM_Book_L.nif",true)
	
	--do the progress bar stuff
	local Time = GetGametime()
	local EndTime = Time + 4
	SetData("Time",4)
	SetData("EndTime",EndTime)
	SetProcessMaxProgress("",4*10)
	SendCommandNoWait("","Progress")
	
	while (GetGametime() < CrusadeRecruitTime) and (GetProperty("","NumCrusaders")<GL_MAX_CRUSADERS) do
		MsgSay("","@L_PRIVILEGES_LEADCRUSADE_SPEECH_RECRUITING")
		if Rand(3) == 0 then
			PlayAnimation("","pray_standing")
		else
			PlayAnimation("","preach")
		end
		Sleep(2)
	end
	
	StopAction("crusade","")
	Sleep(2)
	
	--test
	local ReadyPeopleFilter = "__F((Object.GetObjectsByRadius(Sim)==5000)AND(Object.GetState(crusade)))"
	local NumReadyPeople = Find("",ReadyPeopleFilter,"ReadySim",-1)
	for i=0,NumReadyPeople-1 do
		SendCommandNoWait("ReadySim"..i,"AttackThem")
	end
	
	ResetProcessProgress("")
	
	Sleep(4)
	
	--time is up, or enough crusaders joined
	SetProperty("","CrusadeDestinationID",1)
	
	if not f_MoveTo("","CrusadeDestination",GL_MOVESPEED_WALK) then
		StopMeasure()
	end
	
	local CrusadeDuration = duration
	
	SetState("",STATE_LOCKED,true) 
	SetInvisible("", true)
	AddImpact("", "Hidden", 1 , -1)
	SimBeamMeUp("","CrusadeContainer",false)
	
	AddImpact("","IsOnCrusade",1,CrusadeDuration)
	
	--create the reward
	local Skill = GetSkillValue("",FIGHTING)
	local Reward = (Rand(GetProperty("","NumCrusaders") * 100)*Skill)+GetProperty("","NumCrusaders")*(100*Skill)
	SimSetFaith("",SimGetFaith("")+5)
	local MyFaith = SimGetFaith("")
	GetSettlement("","city")
	CityGetDynastyCharList("city","dyn_chars")
	for i=0,ListSize("dyn_chars")-1 do
		ListGetElement("dyn_chars",i,"char")
		if GetDynasty("char","dyn") then
			local BossID = dyn_GetValidMember("dyn")
			GetAliasByID(BossID, "member")
			if GetID("member")==GetID("char") then
				if SimGetReligion("")==SimGetReligion("char") then
					ModifyFavorToDynasty("","dyn",MyFaith*SimGetFaith("char")/1000) -- 0..10
				end
			end
		end
	end	
	
	while GetImpactValue("","IsOnCrusade")>0 do
		Sleep(1)
	end
	
	SimBeamMeUp("","CrusadeDestination",false)
	SetInvisible("", false)
	SetState("",STATE_LOCKED,true)
	RemoveProperty("","NumCrusaders")
	
	local RewardArray = {"EpicBracers","EpicHelmet","WarCuirass","Excalibur","EpicAxe","OrientalCarpet","OrientalStatues","OrientalTobacco"}
	local NumItems = 8

	local ItemReward = RewardArray[Rand(NumItems) + 1]
	
	feedback_MessagePolitics("","@L_PRIVILEGES_LEADCRUSADE_MSG_CRUSADE_END_HEAD_+0",
					"@L_PRIVILEGES_LEADCRUSADE_MSG_CRUSADE_END_BODY_+1",Reward,ItemGetLabel(ItemReward))
	AddItems("",ItemReward,1,INVENTORY_STD)
	f_CreditMoney("",Reward, "IncomeOther")
	
	local xp = GetData("BaseXP")+25*Skill
	chr_GainXP("",xp)
	
	if not f_MoveTo("","Destination",GL_MOVESPEED_WALK) then
		StopMeasure()
	end
	SetState("",STATE_LOCKED,false)
	
	StopMeasure()
	
end

-- -----------------------
-- Progress
-- -----------------------
function Progress()
	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime") 
		local CurrentTime = GetGametime() 
		CurrentTime = EndTime - CurrentTime 
		CurrentTime = Time - CurrentTime 
		SetProcessProgress("",CurrentTime*10)
		Sleep(3)
	end
end

function AttackThem()
	PlayAnimation("","attack_them")
	if not GetOutdoorLocator("MapExit1",1,"CrusadeDestination") then
		if not GetOutdoorLocator("MapExit2",1,"CrusadeDestination") then
			if not GetOutdoorLocator("MapExit3",1,"CrusadeDestination") then	
			end
		end
	end
	f_MoveTo("","CrusadeDestination",GL_MOVESPEED_WALK)

end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	AllowAllMeasures("")
	RemoveProperty("","CrusadeContainerID")
	SetState("",STATE_LOCKED,false)
	SetInvisible("", false)
	RemoveImpact("","Hidden")
	ResetProcessProgress("")
	if HasProperty("","NumCrusaders") then
		RemoveProperty("","NumCrusaders")
	end
	if HasProperty("","CrusadeDestinationID") then
		RemoveProperty("","CrusadeDestinationID")
	end
	CarryObject("","",false)
	CarryObject("","",true)
	StopAction("crusade","")
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

