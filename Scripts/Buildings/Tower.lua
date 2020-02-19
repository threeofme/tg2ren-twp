function CheckPosition()
	if not AliasExists("Dynasty") then
		return nil
	end
	local	MaxCount	= GetNobilityTitle("Dynasty", false) * 0.5
	local	Have		= DynastyGetBuildingCount("Dynasty", GL_BUILDING_CLASS_MILITARY, -1)
	
	if MaxCount>4 then
		MaxCount = 4
	end
	
	if Have >= 4 then
		return "@L_GENERAL_BUILDING_MAX_TOWER"
	end
	
	if Have >= MaxCount then
		return "@L_GENERAL_BUILDING_NEED_TITLE"
	end
	
	if GetID("Dynasty")>0 then
		if GetNearestSettlement("Position", "City") then
			if GetDistance("Position", "City") < 6000 then
				return "@L_GENERAL_BUILDING_TONEAR_CITY"
			end
		end
	end

	local	Count = DynastyGetBuildingCount2("Dynasty")
	local Type
	
	for l=0,Count-1 do
		if DynastyGetBuilding2("Dynasty", l, "Check") then
			Type = BuildingGetClass("Check")
			if Type==GL_BUILDING_CLASS_WORKSHOP or Type==GL_BUILDING_CLASS_LIVINGROOM then
				if GetDistance("Check", "Position")<2000 then
					return nil
				end
			end
		end
	end
	return "@L_GENERAL_BUILDING_NEED_WORKSHOP"
end

--
-- Setup is called after the building is build. The function is called after OnLevelUp
-- attention: this function call is unscheduled
--
function Setup()
	SetState("", STATE_SCANNING, true)
end

--
-- PingHour is called every full hour (ingame)
-- attention: this function call is unscheduled
--
function PingHour()
	if not GetDynasty("", "Dynasty") then
		return
	end
	
	local	Count = DynastyGetBuildingCount2("Dynasty")
	local Type
	
	for l=0,Count-1 do
		if DynastyGetBuilding2("Dynasty", l, "Check") then
			Type = BuildingGetClass("Check")
			if Type==GL_BUILDING_CLASS_WORKSHOP or Type==GL_BUILDING_CLASS_LIVINGROOM then
				if GetDistance("Check", "")<2000 then
					return
				end
			end
		end
	end
	
	ModifyHP("", -99999999, false, 0)
end

function Run()

end

function OnLevelUp()

end
