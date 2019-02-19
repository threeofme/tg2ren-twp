function Weight()

	if DynastyGetBuildingCount("SIM", GL_BUILDING_CLASS_WORKSHOP, -1) < 1 then
		return 0
	end
	
	if not ReadyToRepeat("SIM", "AI_Workshop") then
		return 0
	end

	if SimGetAge("SIM") < 16 then
		return 0
	end
	
	if not f_SimIsValid("SIM") then
		return 0
	end
	
	for trys=0, 4 do -- we can only get a random building, so try 5 times to find the right one
		if DynastyGetRandomBuilding("SIM", GL_BUILDING_CLASS_WORKSHOP, -1, "Workshop") then
			if BuildingGetType("Workshop") ~= GL_BUILDING_TYPE_RESIDENCE then
				if BuildingGetOwner("Workshop", "MyBoss") then
					if GetID("SIM") == GetID("MyBoss") then
						CopyAlias("Workshop", "MyWorkshop")
						break
					end
				end
			end
		end
	end
	
	if not AliasExists("MyWorkshop") then
		return 0
	end
	
	if not GetInsideBuilding("SIM", "Inside") then
		if GetDistance("SIM", "MyWorkshop") > 21000 then -- Too far, try later
			SetRepeatTimer("SIM", "AI_Workshop", 1.25)
			return 0
		end
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_Workshop", 0.25)
end