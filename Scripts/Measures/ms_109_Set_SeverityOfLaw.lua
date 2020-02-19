function Run()	
	if GetData("Cancel")=="Cancel" then
		StopMeasure()
	end
	if not ai_GoInsideBuilding("", "",-1, GL_BUILDING_TYPE_TOWNHALL) then
		StopMeasure()
	end
	
	
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not GetInsideBuilding("","building") then
		StopMeasure()
	end
	
	BuildingGetCity("building","city")
	
	local Level = 0+ GetProperty("city","SeverityOfLaw")
	SetData("Oldlevel",Level)
	local Severity
	
	if Level==0 then
		Severity = "_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+0"
	elseif Level ==1 then
		Severity = "_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+1"
	elseif Level ==2 then
		Severity = "_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+2"
	end
	
	
	local result = InitData("@P"..
	"@B[0,@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+0,@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+0,Hud/Buttons/free.tga]"..
	"@B[1,@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+1,@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+1,Hud/Buttons/jail.tga]"..
	"@B[2,@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+2,@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+2,Hud/Buttons/death.tga]",
	ms_109_set_severityoflaw_AIFunction,
	"@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_ACTION_TEXT_+1",
	"@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_ACTION_TEXT_+0",GetID("city"),Severity)

	if result==0 then
		SetProperty("city","SeverityOfLaw",0)
	elseif result==1 then
		SetProperty("city","SeverityOfLaw",1)
	elseif result==2 then
		SetProperty("city","SeverityOfLaw",2)
	else
		SetData("Cancel","Cancel")
	end
	
	if IsGUIDriven() then
		SetMeasureRepeat(TimeOut)
	else
		SetMeasureRepeat(55)
	end	
	
	
	if (GetProperty("city","SeverityOfLaw")==false) then
		SetProperty("city","SeverityOfLaw",1)
	end
	local Level = 0+ GetProperty("city","SeverityOfLaw")
	local Oldlevel = GetData("Oldlevel")
	local Severity
	if Oldlevel ~= Level then

		if Level==0 then
			Severity = "_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+0"
		elseif Level ==1 then
			Severity = "_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+1"
		elseif Level ==2 then
			Severity = "_PRIVILEGES_109_SETSEVERITYOFTHELAW_LVL_+2"
		end	
	
		MsgNewsNoWait("All","","","politics",-1,
			"@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_MSG_HEADLINE_+0",
			"@L_PRIVILEGES_109_SETSEVERITYOFTHELAW_MSG_BODY",GetID(""),GetID("city"),Severity)
	end
	StopMeasure()
end

function AIFunction()
    if GetProperty("","Class") == 4 then
	    return 0
	end

    if GetProperty("","Class") == 3 then
	    return (Rand(2)+1)
	end	
	
	return Rand(3)
end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

