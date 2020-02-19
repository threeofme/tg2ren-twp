function CheckPosition()

	-- implemented in sourcecode
	-- DynastyGetMember("dynasty",0,"boss")
	-- if GetNobilityTitle("boss")<8 then
		-- return "@L_GENERAL_BUILDING_CASTLE_FAILURE_+0"
	-- end

	-- implemented in sourcecode
	-- local	Count = DynastyGetBuildingCount2("Dynasty")
	-- for l=0,Count-1 do
		-- if DynastyGetBuilding2("Dynasty", l, "Check") then
			-- if BuildingGetType("Check")==111 then
				-- return "@L_GENERAL_BUILDING_CASTLE_FAILURE_+1"
			-- end
		-- end
	-- end

	-- return nil
end

function Run()
end


function OnLevelUp()
end


function Setup()
	worldambient_CreateAnimal("Dog","",1)
end


function PingHour()
end
