function Run()
	if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
		return
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	if not GetSettlement("","city") then
		StopMeasure()
	end

	local CityTreasure = GetMoney("city")
	local CityTreasureMin = 1000
	local money = 0
	local MaxMoney = 0
	local round = GetRound()
	
	if round<3 then
		MaxMoney = 2000
	elseif round<6 then
		MaxMoney = 4000
	elseif round<9 then
		MaxMoney = 5000
	elseif round<12 then
		MaxMoney = 6000
	else
		MaxMoney = 7000
	end
	
	if CityTreasure<CityTreasureMin then
		MsgQuick("", "@L_MEASURE_EMBEZZLEPUBLICMONEY_FAILURE_+0", GetID("city"))
		StopMeasure()
	else
		if (CityTreasure-MaxMoney)<CityTreasureMin then
			money = CityTreasure-CityTreasureMin
		else
			money = MaxMoney
		end
	end
	
	GetInsideBuilding("","Townhall")
	if GetLocatorByName("Townhall","EmbezzleMoney","Result") then
		f_MoveTo("","Result")
	end
	PlayAnimation("","manipulate_middle_twohand")

	f_SpendMoney("city",money,"EmbezzledPublicMoney")
	f_CreditMoney("",money,"EmbezzledPublicMoney")
	
	feedback_MessageCharacter("Owner",
		"@L_PRIVILEGES_108_EMBEZZLEPUBLICMONEY_SUCCESS_HEAD_+0",
		"@L_PRIVILEGES_108_EMBEZZLEPUBLICMONEY_SUCCESS_BODY_+0", GetID("Owner"), GetID("city"), money)

	SetMeasureRepeat(TimeOut)
	chr_GainXP("",GetData("BaseXP"))

	--for the mission
	mission_ScoreCrime("",money)
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

