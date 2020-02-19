function Run()

	local		Number = 1
	local		Point
	
	while true do
	
		Point = "Point"..Number
		
		if HasProperty("", Point) then
			local PositionName = GetProperty("", Point)

			if GetOutdoorLocator(PositionName, 1, "Position")==1 then
				f_MoveTo("", "Position")
			end
			
			Sleep(Rand(4)+2)
			Number = Number + 1
			
		else
			Number = 1
		end
		
		Sleep(1)
	end
end

