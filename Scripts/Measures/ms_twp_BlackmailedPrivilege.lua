function Run()
	local VictimID = GetImpactValue("","BlackmailActor")
	GetAliasByID(VictimID, "Victim")
	-- TODO check for death of victim
	if not AliasExists("Victim") then
		RemoveImpact("","BlackmailActor")
	end
	
	local PrivCount, Privileges = dyn_GetPrivilegeImpactsOfSim("Victim")
	local Buttons = ""
	-- TODO filter measures according to filter and cooldown
	for i=1, PrivCount do
		 -- TODO Measure names may not always match the impact names
		 local MeasureName = Privileges[i]
		 -- get measure from DBT and load corresponding icon
		 local MeasureID = MeasureGetID(MeasureName)
		 local MeasureIcon = GetDatabaseValue("Measures", MeasureID, "icon_path")
		 Buttons = Buttons.."@B["..MeasureID..",@L_MEASURE_"..MeasureName.."_NAME_+0,"..MeasureName..","..MeasureIcon.."]"
	end
	
	
	-- use InitData to select measure
	local result = InitData("@P"..Buttons,
		-1,
		"@L_MEASURE_BlackmailedMeasure_TITLE_+0","") -- Title and empty body

	if result and result ~="C" and result > 0 then
		-- TODO initialize Destination(s) where necessary
		local Destination = nil
		MeasureRun("", Destination, result, true)
	end
end

function CleanUp()
end