function Init()
	SimSetHireable("", false)
	SetExclusiveMeasure("", "StartDialog",EN_BOTH)
end

function Run()

	local City
	if GetSettlement("", "HomeCity") then
		City = "HomeCity"
	else
		City = "#Capital"
	end
	
	while true do
		if GetID(City) ~= -1 then
			if CityGetRandomBuilding(City, GL_BUILDING_CLASS_MARKET, -1, -1, -1 ,false, "Destination") then
				if GetOutdoorMovePosition("", "Destination", "MoveToPosition") then
					f_MoveTo("","MoveToPosition", GL_MOVESPEED_WALK, 300)
				end
			end
		end
		Sleep(Rand(30)+15)
	end
end

function CleanUp()
	SimSetHireable("", true)
	AllowAllMeasures("")
end

