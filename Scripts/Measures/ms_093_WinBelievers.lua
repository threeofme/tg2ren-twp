function Run()

	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_CHURCH_EV, "Church") then
		if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_CHURCH_CATH, "Church") then
			return
		end
	end
	
	MeasureSetStopMode(STOP_CANCEL)

	if IsStateDriven() then

		if not GetSettlement("Church", "City") then
			return
		end

		if not CityGetRandomBuilding("City", GL_BUILDING_CLASS_MARKET, -1, -1, -1, false, "Destination") then
			return
		end

		if CityFindCrowdedPlace("City", "", "Destination")==0 then
			return
		end

	end


	if not f_MoveTo("","Destination") then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if GetInsideBuilding("","Currentbuilding") then
		MsgQuick("","@L_CHURCH_093_WINBELIEVERS_FAILURES_+1")
		StopMeasure()
	end

	SetMeasureRepeat(TimeOut)	
	local Prefix = "@L_CHURCH_093_WINBELIEVERS_BLAZING_SERMON"
	
	local Religion = BuildingGetReligion("church")
	if (Religion==RELIGION_CATHOLIC) then
		Prefix = Prefix.."_CATHOLIC"
	elseif (Religion==RELIGION_EVANGELIC) then
		Prefix = Prefix.."_PROTESTANT"
	else 
		MsgQuick("", "@L_CHURCH_093_WINBELIEVERS_FAILURES_+0")
		return
	end
		
	SetProcessMaxProgress("",14)
	SetProcessProgress("",0)
	CommitAction("preach", "", "")
	MsgSayNoWait("",""..Prefix.."_1ST")
	SetProcessProgress("",1)
	PlayAnimation("","pray_standing")
	SetProcessProgress("",2)
	PlayAnimation("","shake_head")
	SetProcessProgress("",3)
	PlayAnimation("","sing_for_peace")
	SetProcessProgress("",4)
	PlayAnimation("","preach")	
	SetProcessProgress("",5)
	MsgSayNoWait("",""..Prefix.."_2ND")
	SetProcessProgress("",6)
	PlayAnimation("","pray_standing")
	SetProcessProgress("",7)
	PlayAnimation("","shake_head")
	SetProcessProgress("",8)
	PlayAnimation("","sing_for_peace")
	SetProcessProgress("",9)
	PlayAnimation("","preach")
	SetProcessProgress("",10)
	MsgSayNoWait("",""..Prefix.."_3RD")
	SetProcessProgress("",11)
	PlayAnimation("","pray_standing")
	SetProcessProgress("",12)
	PlayAnimation("","shake_head")
	SetProcessProgress("",13)
	PlayAnimation("","sing_for_peace")
	SetProcessProgress("",14)
	PlayAnimation("","preach")
	ResetProcessProgress("")
	StopAction( "preach", "")
	
	-- priest goes back to church
	chr_GainXP("",GetData("BaseXP"))
	f_MoveTo("", "church")
	GetInsideBuilding("", "church")
end

function CleanUp()
	
	ResetProcessProgress("")
	StopAnimation("")
	StopAction( "preach", "")
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


