function Run()
	if not SimGetWorkingPlace("", "WorkingPlace") then
		return
	end
	if not BuildingGetOwner("WorkingPlace", "BldOwner") then
		return
	end	

	local PanelParam = "@P@B[0,@L_MEASURE_ManageEmployee_OPTION_+0]@B[1,@L_MEASURE_ManageEmployee_OPTION_+1]"    
	local Result = MsgBox(
		"BldOwner",
		"",
		PanelParam,
		"@L_MEASURE_ManageEmployee_HEAD_+0",
		"@L_MEASURE_ManageEmployee_BODY_+0",
		GetID(""))
	
	if not Result or Result == "C" then
		return
	end
	
	if Result == 0 then
		-- wait for my command (default)
		LogMessage("AITWP::ManageEmployee I'll wait for commands")
		if HasProperty("", "TWP_ManageEmployee") then
			RemoveProperty("", "TWP_ManageEmployee")
		end
	elseif Result == 1 then
		LogMessage("AITWP::ManageEmployee I'll look for work")
		-- look for work
		SetProperty("", "TWP_ManageEmployee", 1)
	end
	
end
