-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_157_AssignEmployeeToService"
----
----	with this measure the player can assign an employee to do the service
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	if not SimGetWorkingPlace("","Tavern") then
		if IsPartyMember("") then
			if not GetInsideBuilding("","CurrentBuilding") then
				StopMeasure()
			end
			if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_TAVERN then
				CopyAlias("CurrentBuilding","Tavern")
			else
				StopMeasure()
			end
		else
			StopMeasure()
		end
	else
		if not f_MoveTo("", "Tavern", GL_MOVESPEED_RUN) then
			StopMeasure()
		end

		if not GetInsideBuilding("","CurrentBuilding") then
			StopMeasure()
		end

		if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_TAVERN then
			CopyAlias("CurrentBuilding","Tavern")
		else
			StopMeasure()
		end
	end

	SetProperty("Tavern","ServiceActive",1)
	
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)
		
	while true do
		local NumGuests = BuildingGetSimCount("Tavern")
		if NumGuests == 0 then
			ms_157_assignemployeetoservice_CleanTables()
		else
			ms_157_assignemployeetoservice_Serve()
		end
		Sleep(1)
	end
end

function CleanTables()
	local Type = Rand(4)
	if Type == 0 then	
		GetFreeLocatorByName("Tavern","ServeSitRich",0,3,"MovePos")
		f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
		PlayAnimation("","manipulate_middle_twohand")
		f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	elseif Type == 1 then
		GetFreeLocatorByName("Tavern","ServeStand",0,5,"MovePos")
		f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
		PlayAnimation("","manipulate_middle_twohand")
		f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	elseif Type == 2 then
		GetFreeLocatorByName("Tavern","ServeAloneStand",-1,-1,"MovePos")
		f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
		PlayAnimation("","manipulate_middle_twohand")
		f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	else
		PlayAnimation("","cogitate")
	end
end

function Serve()
	local Type = Rand(4)
	local Locator
	if Type == 0 then
		Locator = Rand(4)
		GetLocatorByName("Tavern","ServeSitRich"..Locator,"MovePos")
		f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
		PlayAnimation("","talk_short")
		f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	else 
		Locator = Rand(6)
		GetLocatorByName("Tavern","ServeStand"..Locator,"MovePos")
		f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
		PlayAnimation("","talk_short")
		f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	end
	Type = Rand(3)
	if Type == 0 then
		if GetLocatorByName("Tavern","ServeAloneStand0","ServePos") then
			f_BeginUseLocator("","ServePos",GL_STANCE_STAND,true)
			PlayAnimation("","manipulate_middle_twohand")
			f_EndUseLocator("","ServePos",GL_STANCE_STAND)
		end
	elseif Type == 1 then
		if GetLocatorByName("Tavern","ServeAloneHigh0","ServePos") then
			f_BeginUseLocator("","ServePos",GL_STANCE_STAND,true)
			PlayAnimation("","manipulate_top_r")
			f_EndUseLocator("","ServePos",GL_STANCE_STAND)
		end
	elseif Type == 2 then
		if GetLocatorByName("Tavern","ServeAloneKnee0","ServePos") then
			f_BeginUseLocator("","ServePos",GL_STANCE_STAND,true)
			PlayAnimation("","manipulate_middle_low_r")
			f_EndUseLocator("","ServePos",GL_STANCE_STAND)
		end
	end
	f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true)
	PlayAnimation("","manipulate_middle_low_r")
	f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	
end

function CleanUp()
	if not AliasExists("Tavern") then
		SimGetWorkingPlace("","Tavern")
	end

	RemoveProperty("Tavern","ServiceActive")
	RemoveProperty("Tavern","GoToService")
end

