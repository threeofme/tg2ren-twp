function Weight()
	
	if not GetHomeBuilding("SHIP","MyBase") then
		return 0
	end 
	
	local OwnCargo = chr_GetBootyCount("SHIP",INVENTORY_STD)
	if OwnCargo > 0 then
		return -100
	end
		
	return 0
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "IsShip", 1)
	MeasureStart("Measure", "SHIP", "MyBase", "SendCartAndUnload")
end
