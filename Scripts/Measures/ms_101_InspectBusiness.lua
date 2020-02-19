-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_101_InspectBusiness"
----
----	with this privilege measure, the player can send one inspector to an 
----	workshop, to inspect it for an duration of 6h. in this time, production
----	is stopped
----
-------------------------------------------------------------------------------


function Run()
	
	local Worker
	local i
	--time before building can be inspected again, in hours
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--check if building is ready to inspect
	GetSettlement("","InspectingCity")
	
	if (GetImpactValue("Dynasty","BeeingInspected")==1) then
		StopMeasure()
	end
	
	--check if destination is too far from city
	GetPosition("InspectingCity","CityPos")
	if not AliasExists("Destination") then
		StopMeasure()
	end
	GetPosition("Destination","BuildingPos")
	if GetDistance("BuildingPos","CityPos") > 10000 then
		MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
		StopMeasure()
	end
	
	
	--add impact, and move the inspector in the building
	if not f_MoveTo("","Destination") then
		MsgQuick("Dynasty", "@L_PRIVILEGES_101_INSPECTBUSINESS_FAILURES_+0", GetID("Building"))
		StopMeasure()
	end
	AddImpact("Dynasty","BeeingInspected",1,duration)
	
	SimGetWorkingPlace("","Workbuilding")
	SetRepeatTimer("Workbuilding", GetMeasureRepeatName(), TimeOut)
	
	--check workers, no workers in building, then stop it
	WorkerCount = BuildingGetWorkerCount("Destination")
	if WorkerCount > 0 then
		for i=0,WorkerCount-1 do
			if BuildingGetWorker("Destination",i,"Worker") then
				SendCommandNoWait("Worker","StopDoingAnything")
			end
		end
	end
		
	local	Type =  BuildingGetType("Destination")	
		
	StartGameTimer(duration)
	
	SetData("Time",duration)
	local StartTime = GetGametime()
	local EndTime = StartTime + duration
	SetData("EndTime",EndTime)
	SetProcessMaxProgress("",duration*10)
	SendCommandNoWait("","Progress")
	
	feedback_MessageWorkshop("Destination",
		"@L_PRIVILEGES_101_INSPECTBUSINESS_MSG_DESTINATION_HEAD_+0",
		"@L_PRIVILEGES_101_INSPECTBUSINESS_MSG_DESTINATION_BODY_+0", GetID("Destination"))
	
	
	--SetMeasureRepeat(TimeOut)
	
	while not(CheckGameTimerEnd()) do
		if (Type==GL_BUILDING_TYPE_SMITHY) then
			ms_101_inspectbusiness_Inspect("Jewelbox", "manipulate_middle_twohand","Magnglass", "manipulate_middle_twohand",
							"Anvil","manipulate_middle_twohand","HammerInstallation","manipulate_middle_twohand",
							"Meltingpot","manipulate_middle_twohand","Shelf_in_the_wall","manipulate_middle_twohand",
							"Waterbucket","manipulate_middle_twohand","Forge","manipulate_middle_twohand",
							"Fileshelf","manipulate_bottom_r")
		elseif (Type==GL_BUILDING_TYPE_TAVERN) then
			ms_101_inspectbusiness_Inspect("ServeAloneKnee0", "manipulate_middle_twohand", "ServeAloneHigh0", "manipulate_bottom_r",
							"ServeSitRich1", "watch_for_guard","Cooking3","manipulate_middle_twohand",
							"Brewer","manipulate_middle_twohand","CookingPot","manipulate_middle_twohand",
							"Spice2","watch_for_guards","Barrel","manipulate_middle_twohand","Bath1","manipulate_middle_twohand")
		elseif (Type==GL_BUILDING_TYPE_ALCHEMIST) then
			ms_101_inspectbusiness_Inspect("CopperCaldron","manipulate_middle_twohand","Shelf","manipulate_middle_up_l",
							"Mandrake","manipulate_middle_twohand","DryingMachine","watch_for_guard",
							"DryingMachine2","cogitate","Ritual1","manipulate_middle_twohand",
							"Ritual3","cogitate","AutomaticSprinkler","cogitate","Oilsqueezer","watch_for_guard")
		elseif (Type==GL_BUILDING_TYPE_TAILORING) then
			ms_101_inspectbusiness_Inspect("Hallstand_01","manipulate_middle_twohand","Dressform","manipulate_middle_twohand",
							"Bobbin2","manipulate_bottom_l","IronMachine_fire","manipulate_bottom_r",
							"IronMachine_manipulate","manipulate_middle_twohand","Hallstand_02_2","manipulate_middle_twohand",
							"SewingMachine_cloth","watch_for_guard","Hallstand_02","cogitate","Bobbin","manipulate_middle_twohand")
		elseif (Type==GL_BUILDING_TYPE_JOINERY) then
			ms_101_inspectbusiness_Inspect("SawPos","manipulate_middle_twohand","FilePos","manipulate_top_r","ToolCasePos","cogitate",
							"PlanerPos","cogitate","UsePlanerPos","watch_for_guard","AutomaticHammerOvenPos","manipulate_bottom_r",
							"AutomaticHammerPos","manipulate_middle_twohand","StrainPos","manipulate_middle_twohand",
							"AutomaticSawPos","cogitate")
		elseif (Type==GL_BUILDING_TYPE_BAKERY) then
			ms_101_inspectbusiness_Inspect("MakeCake","manipulate_middle_twohand","AutomaticDoughRoller","manipulate_middle_twohand",
							"Oven","watch_for_guard","SaleTable","cogitate","SaleBoard","manipulate_middle_twohand",
							"Mixer","manipulate_middle_twohand","Flour","cogitate","Dough","manipulate_middle_low_r",
							"SpicerySafe","watch_for_guard")
		elseif (Type==GL_BUILDING_TYPE_CHURCH_EV) or (Type==GL_BUILDING_TYPE_CHURCH_CATH) then
			ms_101_inspectbusiness_Inspect("ShelfA","manipulate_top_r","ShelfB","manipulate_top_r",
							"ShelfC","watch_for_guard","ShelfD","cogitate","ShelfE","manipulate_middle_twohand",
							"ShelfF","manipulate_top_l","ShelfG","cogitate","Desk","manipulate_middle_twohand")
		else
			if Rand(100) < 50 then
				PlayAnimation("","cogitate")
			else
				PlayAnimation("","watch_for_guard")
			end
			Sleep(2)
		end
		
		Sleep(1)
	end
	
	Sleep(2)
	StopMeasure()
end

function StopDoingAnything()
	--SimStopMeasure("")
	ExitCurrentBuildingNoWait("")
	while true do
		
		Sleep(10)
	end
end

function Inspect(...)

	local Number = 0
	while arg[Number+1]~=nil do
		Number = Number + 2
	end
	Number  = Number / 2
	
	local runs
	for runs = 0, 8 do
		local pos = ((Rand(Number)*2)+1)
		local locname = arg[pos]
		
		if CheckGameTimerEnd() then
			StopMeasure()
		end
		
		
		GetLocatorByName("Destination",locname,"MovePos")
		f_MoveTo("", "MovePos")
		PlayAnimation("", arg[pos+1])
		
		Sleep(2)
	end
end

function CleanUp()

	ResetProcessProgress("")
end

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

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end


