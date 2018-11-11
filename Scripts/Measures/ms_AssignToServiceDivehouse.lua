-- -----------------------
-- Run
-- -----------------------
function Run()
	if not SimGetWorkingPlace("","Divehouse") then
		if IsPartyMember("") then
			if not GetInsideBuilding("", "CurrentBuilding") then
				StopMeasure()
			end
			if BuildingGetType("CurrentBuilding")==36 then
				CopyAlias("CurrentBuilding", "Divehouse")
			else
				StopMeasure()
			end
		else
			StopMeasure()
		end
	else
		if not f_MoveTo("", "Divehouse", GL_MOVESPEED_RUN, 0, "AIService") then
			StopMeasure()
		end

		if not GetInsideBuilding("","CurrentBuilding") then
			StopMeasure()
		end

		if BuildingGetType("CurrentBuilding")==36 then
			CopyAlias("CurrentBuilding","Divehouse")
		else
			StopMeasure()
		end
	end

	local Filter = "__F((Object.GetObjectsByRadius(Sim) == 2000) AND (Object.Property.ServiceSim==1))"
	local count = Find("", Filter, "Alias", -1)

	if count ~= 0 then
		StopMeasure()
	else
		SetProperty("Divehouse", "ServiceActive",1)
		SetProperty("", "ServiceSim",1)
		SetProperty("Divehouse", "ServiceStartTime", GetGametime())
	end

	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end
	
	SetProperty("Divehouse","ServiceActive",1)

	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)

	BuildingGetOwner("Divehouse", "Boss")

	local BreakNumber = 0
	while true do
		local SearchSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000) AND NOT(Object.BelongsToMe()))"
		local NumGuests = Find("", SearchSimFilter,"Guests", -1)
		
		if TimeOut then
			if TimeOut < GetGametime() and NumGuests == 0 then
				break
			end
		end

		if NumGuests < 2 then
			ms_assigntoservicedivehouse_CleanTables()
		end

		if NumGuests > 2 and Rand(3) == 0 then
			ms_assigntoservicedivehouse_CleanTables()
		else
			ms_assigntoservicedivehouse_Serve()
		end
		
		IncrementXPQuiet("",5)

		if not DynastyIsPlayer("Boss") then
			if NumGuests == 0 then
				BreakNumber = BreakNumber + 1
			else
				BreakNumber = 0
			end
		end

		if BreakNumber > 3 then
			StopMeasure()
		else
			local Stime = Rand(3)+1
			Sleep(Stime)
		end
	end
end

function CleanTables()
	local Type = Rand(4)
	if Type == 0 then
		GetFreeLocatorByName("Divehouse","Service",1,4,"MovePos")
		f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
	    CarryObject("","Handheld_Device/ANIM_besen.nif", false)
	    PlayAnimation("","hoe_in")	
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hoe_loop")
		    Sleep(0.5)
		    PlaySound3DVariation("","Locations/herbs",1.0)
		    Sleep(waite-0.5)
	    end
		PlayAnimation("","hoe_out")
		CarryObject("","",false)
		f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	elseif Type == 1 then
		GetFreeLocatorByName("Divehouse","Barman1",-1,-1,"MovePos")
		f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
		PlayAnimation("","manipulate_middle_twohand")
		f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	elseif Type == 2 then
		GetFreeLocatorByName("Divehouse","Service",1,4,"MovePos")
		f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
		PlayAnimation("","manipulate_middle_twohand")
		f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	else
		GetFreeLocatorByName("Divehouse","Service",1,4,"MovePos")
		f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
		PlayAnimation("","cogitate")
		f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	end
end

function Serve()
	local Type
	local Locator = Rand(4) +1
	if BuildingHasUpgrade("Divehouse",5715) == true then
	    Type = Rand(4)
	else
	    Type = Rand(3)
	end

	if Type == 0 then
		if GetLocatorByName("Divehouse","Barman1","ServePos") then
			f_BeginUseLocator("","ServePos",GL_STANCE_STAND,true)
			PlayAnimation("","manipulate_middle_twohand")
			f_EndUseLocator("","ServePos",GL_STANCE_STAND)
		end
	elseif Type == 1 then
		if GetLocatorByName("Divehouse","Service"..Locator,"ServePos") then
			f_BeginUseLocator("","ServePos",GL_STANCE_STAND,true)
			PlayAnimation("","manipulate_middle_low_r")
			f_EndUseLocator("","ServePos",GL_STANCE_STAND)
		end
	elseif Type == 2 then
		if GetLocatorByName("Divehouse","Service"..Locator,"ServePos") then
			f_BeginUseLocator("","ServePos",GL_STANCE_STAND,true)
			PlayAnimation("","talk_short")
			f_EndUseLocator("","ServePos",GL_STANCE_STAND)
		end	
	else
		if not GetLocatorByName("Divehouse","Barman1","ServePos") then
			    GetFreeLocatorByName("Divehouse","Bar",1,4,"ServePos")
		end
		if not f_BeginUseLocator("","ServePos",GL_STANCE_STAND,true) then
		    return
		end
		MoveSetActivity("","carry")
		Sleep(2)
		CarryObject("","Handheld_Device/ANIM_Pitcher_carry.nif",false)
		f_EndUseLocator("","ServePos",GL_STANCE_STAND)
		if GetLocatorByName("Divehouse","Service"..Locator,"ServePos") then
			f_BeginUseLocator("","ServePos",GL_STANCE_STAND,true)
			MoveSetActivity("","")
			Sleep(2)
			CarryObject("","",false)
			f_EndUseLocator("","ServePos",GL_STANCE_STAND)
		end
	end
	CarryObject("","",false)
end

function CleanUp()
	if HasProperty("", "ServiceSim") then
		RemoveProperty("", "ServiceSim")
		if HasProperty("Divehouse","ServiceActive") then
			RemoveProperty("Divehouse","ServiceActive")
		end
		if HasProperty("Divehouse","GoToService") then
			RemoveProperty("Divehouse","GoToService")
		end
	end
	CarryObject("","",false)
--	SimSetProduceItemID("", -1)
end
