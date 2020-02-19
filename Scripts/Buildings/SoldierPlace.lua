function Run()
end


function OnLevelUp()
	
end


function Setup()
  SetState("", STATE_MOVING_BUILDING, true)
	-- War Chooser
	if GetData("#WarChooser")==nil then
		SetData("#WarChooser",GetID(""))
	elseif GetData("#WarChooser")==0 then
		SetData("#WarChooser",GetID(""))
	end
	if GetData("#WarChooser")==GetID("") then
		if GetCurrentMeasureName("") ~= "GlobalEvent" then
			MeasureRun("", nil, "GlobalEvent")
		end
	end	
end


function PingHour()
	-- War Chooser
	if GetData("#WarChooser")==nil then
		SetData("#WarChooser",GetID(""))
	elseif GetData("#WarChooser")==0 then
		SetData("#WarChooser",GetID(""))
	end
	if GetData("#WarChooser")==GetID("") then
		if GetCurrentMeasureName("") ~= "GlobalEvent" then
			MeasureRun("", nil, "GlobalEvent")
		end
	end
end
