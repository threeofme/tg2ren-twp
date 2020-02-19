function Init()

end

function Run()

	if not GetInsideBuilding("","CurrentBuilding") then
		return
	end

	if GetState("CurrentBuilding",STATE_BUILDING) or GetState("CurrentBuilding",STATE_LEVELINGUP) then
		return
	end

	if GetState("CurrentBuilding",STATE_BURNING) then
		return
	end	
	
    if not HasProperty("","EmpfangsBereit") then
	    if GetLocatorByName("CurrentBuilding","SpecPos1","SitPos") then
		    f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true)
		    SetProperty("","EmpfangsBereit",1)
	    end
	end
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")

	GetScenario("scenario")
	local mapid = GetProperty("scenario", "mapid")
	local land = GetDatabaseValue("maps", mapid, "lordship")	
	
	local scenarioname = GetDatabaseValue("maps", mapid, "lordship")
	local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+1"
	local lordid = gameplayformulas_GetDatabaseIdByName("Lordship", scenarioname)

	local wuerdentrager = ""
	local val
	local laune
		
	val = GetProperty("WarChooser","Hostility1")
	laune = chr_GetEnemyMoodLevel(val)
	if laune < 4 then
		local enemy1 = "@L_SCENARIO_WAR_"..GetDatabaseValue("Lordship", lordid, "enemy1").."_+0"
		wuerdentrager = wuerdentrager.."@B[1,"..enemy1.."]"
	end
		
	val = GetProperty("WarChooser","Hostility2")
	laune = chr_GetEnemyMoodLevel(val)
	if laune < 4 then		
		local enemy2 = "@L_SCENARIO_WAR_"..GetDatabaseValue("Lordship", lordid, "enemy2").."_+0"
		wuerdentrager = wuerdentrager.."@B[2,"..enemy2.."]"
	end
		
	val = GetProperty("WarChooser","Hostility3")
	laune = chr_GetEnemyMoodLevel(val)
	if laune < 4 then		
		local enemy3 = "@L_SCENARIO_WAR_"..GetDatabaseValue("Lordship", lordid, "enemy3").."_+0"
	    wuerdentrager = wuerdentrager.."@B[3,"..enemy3.."]"
	end
		
	val = GetProperty("WarChooser","Hostility4")
	laune = chr_GetEnemyMoodLevel(val)
	if laune < 4 then		
		local enemy4 = "@L_SCENARIO_WAR_"..GetDatabaseValue("Lordship", lordid, "enemy4").."_+0"
		wuerdentrager = wuerdentrager.."@B[4,"..enemy4.."]"
	end		
	
	local choice = MsgBox("","", "@P"..wuerdentrager..
							"@B[5,@L_MEASURE_WUERDENTRAGEREMPFANGEN_NONE_+0]",
							"@L_MEASURE_WUERDENTRAGEREMPFANGEN_HEAD_+0", 
							"@L_MEASURE_WUERDENTRAGEREMPFANGEN_BODY_+0") 

	local diploTyp
	if choice == 1 then
	    diploTyp = 945
	elseif choice == 2 then
	    diploTyp = 945
	elseif choice == 3 then
	    diploTyp = 945
	elseif choice == 4 then
	    diploTyp = 945
	else
	    StopMeasure()
	end
	
	GetLocatorByName("CurrentBuilding", "Entry1", "SetPos")
	SimCreate(diploTyp,"","SetPos","Diplomat")
	SimSetFirstname("Diplomat", "@L_DIPLOMAT_NAME_NORM_MALE_+0")
	SimSetLastname("Diplomat", "@L_DIPLOMAT_NAME_"..GetDatabaseValue("Lordship", lordid, "enemy"..choice).."_+0")
    SetState("Diplomat",STATE_LOCKED,true)
	local diid = GetID("Diplomat")
	SetData("DipoID",diid)
	
	if GetLocatorByName("CurrentBuilding","SpecPos2","StehPos") then
		f_BeginUseLocator("Diplomat","StehPos",GL_STANCE_STAND,true)
	end	

	val = GetProperty("WarChooser","Hostility"..choice)
	val2 = GetProperty("WarChooser","WarRisk")
	laune = chr_GetEnemyMoodLevel(val)
	local ort = "@L_DIPLOMAT_NAME_"..GetDatabaseValue("Lordship", lordid, "enemy"..choice).."_+0"
	local moveDipi
	local stimmung = ""
	if laune == 0 then
	    moveDipi = PlayAnimationNoWait("Diplomat","bow")
	    MsgSay("Diplomat","@L_MEASURE_WUERDENTRAGEREMPFANGEN_DIPLOHY_+0")
		stimmung = stimmung.."@L_MEASURE_WUERDENTRAGEREMPFANGEN_BODY_+2"
	elseif laune == 1 then
	    moveDipi = PlayAnimationNoWait("Diplomat","bow")
	    MsgSay("Diplomat","@L_MEASURE_WUERDENTRAGEREMPFANGEN_DIPLOHY_+1")
		stimmung = stimmung.."@L_MEASURE_WUERDENTRAGEREMPFANGEN_BODY_+3"
    elseif laune == 2 then
	    moveDipi = PlayAnimationNoWait("Diplomat","nod")
	    MsgSay("Diplomat","@L_MEASURE_WUERDENTRAGEREMPFANGEN_DIPLOHY_+2")
		stimmung = stimmung.."@L_MEASURE_WUERDENTRAGEREMPFANGEN_BODY_+4"
	else
	    moveDipi = PlayAnimationNoWait("Diplomat","shake_head")
	    MsgSay("Diplomat","@L_MEASURE_WUERDENTRAGEREMPFANGEN_DIPLOHY_+3")
		stimmung = stimmung.."@L_MEASURE_WUERDENTRAGEREMPFANGEN_BODY_+5"
	end
	
	Sleep(moveDipi-1)

	local choice2 = MsgBox("","", "@P"..
	                        "@B[1,@L_MEASURE_WUERDENTRAGEREMPFANGEN_ASK_+0]"..
							"@B[2,@L_MEASURE_WUERDENTRAGEREMPFANGEN_ASK_+1]"..
							"@B[3,@L_MEASURE_WUERDENTRAGEREMPFANGEN_ASK_+2]",
							"@L_MEASURE_WUERDENTRAGEREMPFANGEN_HEAD_+0", 
							"@L_MEASURE_WUERDENTRAGEREMPFANGEN_BODY_+1",stimmung,ort) 

	if choice2 == 1 then
	    moveDipi = PlayAnimationNoWait("","sit_yes")
	    MsgSay("","@L_MEASURE_WUERDENTRAGEREMPFANGEN_FRIENDLY")	
	elseif choice2 == 2 then
	    moveDipi = PlayAnimationNoWait("","sit_no")
	    MsgSay("","@L_MEASURE_WUERDENTRAGEREMPFANGEN_UNFRIENDLY")	
	else
	    moveDipi = PlayAnimationNoWait("","talk_sit_short")
	    MsgSay("","@L_MEASURE_WUERDENTRAGEREMPFANGEN_JUSTGO")		
	end
    Sleep(moveDipi-1)

	SetMeasureRepeat(TimeOut)
	chr_GainXP("",GetData("BaseXP"))
	if choice2 == 1 then
	    moveDipi = PlayAnimationNoWait("Diplomat","devotion")
	    MsgSay("Diplomat","@L_MEASURE_WUERDENTRAGEREMPFANGEN_FRIENDLY_ANS_+0")
		if val < 10 then
		    SetProperty("WarChooser","Hostility"..choice,0)
		else
		    SetProperty("WarChooser","Hostility"..choice,val-10)
		end
		if val2 < 5 then
		    SetProperty("WarChooser","WarRisk", 0)
		else
		    SetProperty("WarChooser","WarRisk", val-5)
		end
		chr_SimAddImperialFame("",10)
	elseif choice2 == 2 then
	    moveDipi = PlayAnimationNoWait("Diplomat","propel")
	    MsgSay("Diplomat","@L_MEASURE_WUERDENTRAGEREMPFANGEN_UNFRIENDLY_ANS_+0")
		SetProperty("WarChooser","Hostility"..choice,val+10)	
		SetProperty("WarChooser","WarRisk", val+5)
		chr_SimRemoveImperialFame("",10)
	else
	    moveDipi = PlayAnimationNoWait("Diplomat","shake_head")
	    MsgSay("Diplomat","@L_MEASURE_WUERDENTRAGEREMPFANGEN_JUSTGO_ANS_+0")
        SetProperty("WarChooser","Hostility"..choice,val+5)		
	end
	Sleep(moveDipi-1)

	GetLocatorByName("CurrentBuilding", "Entry1", "GoPos")
	ReleaseLocator("Diplomat","StehPos")
	f_MoveTo("Diplomat","GoPos",GL_MOVESPEED_WALK)
	InternalDie("Diplomat")
	InternalRemove("Diplomat")

end

function CleanUp()

    local dips = GetData("DipoID")
	if GetAliasByID(dips,"Diplom") then
	    InternalDie("Diplom")
	    InternalRemove("Diplom")
	end
    RemoveProperty("","EmpfangsBereit")
end
