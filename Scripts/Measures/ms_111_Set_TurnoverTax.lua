function Run()
	if GetData("Cancel")=="Cancel" then
		StopMeasure()
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not ai_GoInsideBuilding("", "",-1, GL_BUILDING_TYPE_TOWNHALL) then
		StopMeasure()
	end
	if not GetInsideBuilding("","building") then
		StopMeasure()
	end

	BuildingGetCity("building","city")
	local Percent = 0+ GetProperty("city","TurnoverTax")
	SetData("Oldpercent",Percent)
	local result = InitData("@P"..
	"@B[0,0,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+0,Hud/Buttons/btn_Money_Small.tga]"..
	"@B[1,10,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+1,Hud/Buttons/btn_Money_SmallLarge.tga]"..
	"@B[2,15,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+2,Hud/Buttons/btn_Money_Medium.tga]"..
	"@B[3,20,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+3,Hud/Buttons/btn_Money_MediumLarge.tga]"..
	"@B[4,30,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+4,Hud/Buttons/btn_Money_Large.tga]",
	ms_111_set_turnovertax_AIFunction,
	"@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_TEXT_+1",
	"@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_TEXT_+0",Percent)

	if result==0 then
		SetProperty("city","TurnoverTax",0)
	elseif result==1 then
		SetProperty("city","TurnoverTax",10)
	elseif result==2 then
		SetProperty("city","TurnoverTax",15)
	elseif result==3 then
		SetProperty("city","TurnoverTax",20)
	elseif result==4 then
		SetProperty("city","TurnoverTax",30)
	else
		SetData("Cancel","Cancel")
	end
	
	if IsGUIDriven() then
		SetMeasureRepeat(TimeOut)
	else
		SetMeasureRepeat(50)
	end
	BuildingGetCity("building","city")
	local TaxValue = 0+ GetProperty("city","TurnoverTax")
	local Oldpercent = GetData("Oldpercent")
	if Oldpercent ~= TaxValue then
		MsgNewsNoWait("All","","","politics",-1,
			"@L_PRIVILEGES_111_SETTURNOVERTAX_MSG_HEADLINE_+0",
			"@L_PRIVILEGES_111_SETTURNOVERTAX_MSG_BODY",GetID(""),GetID("city"),TaxValue)
	end
	StopMeasure()
end

function AIFunction()
    if GetProperty("","Class") == 2 then
	    return Rand(2)
	end

    if SimGetOfficeLevel("") == 3 or SimGetOfficeLevel("") == 4 or SimGetOfficeLevel("") == 5 or SimGetOfficeLevel("") == 6 or SimGetOfficeLevel("") == 7 then
	    return (Rand(2)+3)
	end	
	
    return Rand(5)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

