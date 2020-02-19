function Run()

	local Name
	local	Failed = 0

	while true do
	
		if GetOutdoorMovePosition(nil, "GuardBuilding", "GuardPosition") then
			Failed = 0
			
			local Number = GetData("GuardNumber")
			
			if Number == 0 then
				PositionMove("GuardPosition", 200, "GuardBuilding", 135)
			else
				PositionMove("GuardPosition", 200, "GuardBuilding", 222)
			end
			
			-- if more than one meter from the entry of the building, go back to position
			if GetDistance("", "GuardPosition") > 100 then
				Name = GetName("GuardPosition")
--				MsgMeasure("","Moving to ("..Name..")")
				f_MoveTo("","GuardPosition",GL_MOVESPEED_WALK)
			end
		
			AlignTo("", "GuardBuilding", true)
			Name = GetName("GuardPosition")
			MsgMeasure("","bewache "..Name)
			Sleep(30)
		else
			Failed = Failed + 1
			if Failed > 10 then
				return
			end
			Sleep(1)
		end
	end
	
end

