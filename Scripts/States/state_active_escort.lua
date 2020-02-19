function Run()
	if not IsType("", "Cart") then
		return
	end
	
	if CartGetEscortCount("")==0 then
		return
	end
	
	if not CartCreateEscort("") then
		return
	end
	
	local	TimeOut = Gametime2Realtime(0.5)
	
	while CartCheckEscort("") do
		if CartGetEscortCount("")==0 then
			return
		end
		Sleep(5)
		if TimeOut<0 then
			if not CartCheckFighting("") then
				break
			end
		else
			TimeOut = TimeOut - 5
		end
	end
end

function CleanUp()
	CartRemoveEscort("")
end

