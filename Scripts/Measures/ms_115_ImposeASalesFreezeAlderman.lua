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

	local gradelabel
	if SimGetGender("")==GL_GENDER_MALE then
		gradelabel = "@L_CHECKALDERMAN_ALDERMAN_MALE_+0"
	else
		gradelabel = "@L_CHECKALDERMAN_ALDERMAN_FEMALE_+0"
	end

	MsgNewsNoWait("All","","@C[@L_IMPOSEASALESFREEZE_COOLDOWN_+1,%5i,%6l]","economie",-1,
		"@L_PRIVILEGES_115_IMPOSEASALESFREEZE_MSG_HEAD_+0",
		"@L_PRIVILEGES_115_IMPOSEASALESFREEZE_MSG_BODY_+1",
		gradelabel,GetID(""),GetID("Destination"),GetID("CityAlias"),Elapse,ID)

	local fame = chr_SimGetFameLevel("")
	chr_SimRemoveFame("",fame)
	chr_GainXP("",GetData("BaseXP"))

end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end
