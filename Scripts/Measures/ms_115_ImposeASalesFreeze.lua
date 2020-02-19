-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_115_ImposeASalesFreeze"
----
-------------------------------------------------------------------------------
 
function Run()
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not AliasExists("Destination") then
		StopMeasure()
	end

  if GetImpactValue("Destination", "sale_freezed")==1 then
		MsgQuick("", "_IMPOSEASALESFREEZE_FAILURE_+0")
	 	StopMeasure()
	end
    
	GetSettlement("","OwnerCity")
	GetSettlement("Destination","DestCity")
	if GetID("OwnerCity")~=GetID("DestCity") then
		MsgQuick("","_IMPOSEASALESFREEZE_FAILURE_+1")
		StopMeasure()
	end
	
	GetPosition("","OwnerPos")
	GetPosition("Destination","MarketPos")
	if GetDistance("OwnerPos","MarketPos") > 5000 then
		MsgQuick("","_IMPOSEASALESFREEZE_FAILURE_+2")
		StopMeasure()
	end


	if GetLocatorByName("Destination","vendor","VendorPos") then
		if not f_MoveTo("","VendorPos",GL_MOVESPEED_WALK,150) then
			if not f_MoveTo("","Destination",GL_MOVESPEED_WALK,150) then
				StopMeasure()
			end
			AlignTo("","Destination")
			Sleep(1)
		end
		AlignTo("","VendorPos")
		Sleep(1)
	else
		if not f_MoveTo("","Destination",GL_MOVESPEED_WALK,150) then
			StopMeasure()
		end
		AlignTo("","Destination")
		Sleep(1)
	end
	
	PlayAnimationNoWait("","propel")
	MsgSay("","@L_PRIVILEGES_115_IMPOSEASALESFREEZE_COMMENT_ACTOR_+0")

	SetData("Freezed",1)
	StartGameTimer(duration)
	SimGetWorkingPlace("","Workbuilding")
	SetRepeatTimer("Workbuilding", GetMeasureRepeatName(), TimeOut)

	AddImpact("Destination", "sale_freezed", 1, duration)
	GetSettlement("","CityAlias")
	local Elapse = GetGametime() + duration
	local ID = "Event"..GetID("")
	local BossID = dyn_GetValidMember("dynasty")
	GetAliasByID(BossID, "MrFreeze")

	MsgNewsNoWait("All","MrFreeze","@C[@L_IMPOSEASALESFREEZE_COOLDOWN_+0,%4i,%5l]","economie",-1,
		"@L_PRIVILEGES_115_IMPOSEASALESFREEZE_MSG_HEAD_+0",
		"@L_PRIVILEGES_115_IMPOSEASALESFREEZE_MSG_BODY_+0",
		GetID("MrFreeze"),GetID("Destination"),GetID("CityAlias"),Elapse,ID)

	chr_GainXP("MrFreeze", GetData("BaseXP"))	
	SetState("",STATE_LOCKED,true)
	while not CheckGameTimerEnd() do
    if GetImpactValue("Destination", "sale_freezed") < 1 then
      SetState("",STATE_LOCKED,false)
	  	StopMeasure()
	  end
		if Rand(3) == 0 then
			PlayAnimation("","sentinel_idle")
		elseif Rand(3) == 1 then
			PlayAnimation("","propel")
		elseif Rand(3) == 2 then
			PlayAnimation("","watch_for_guard")
		end
		Sleep(Rand(3)+2)
	end
	
	SetState("",STATE_LOCKED,false)
end

function CleanUp()
	SetState("",STATE_LOCKED,false)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end
