function Run()

	local	PosCount = 0

	for n=1, 10 do
		if GetOutdoorLocator("Water"..n, 1, "Position"..PosCount )~=0 then
			PosCount = PosCount + 1
		end

		if GetOutdoorLocator("WaterEnd"..n, 1, "Position"..PosCount )~=0 then
			PosCount = PosCount + 1
		end
	end

	while true do
		Point = "Position"..Rand(PosCount)
		f_MoveTo("", Point)
		Sleep(Rand(15)+5)
	end
	
end

