function Weight()
	if not GetHomeBuilding("", "Hut") then
		return 0
	end

	local	CountHerring = GetItemCount("Hut", "Herring", INVENTORY_STD)
	local	CountSalmon = GetItemCount("Hut", "Salmon", INVENTORY_STD)
	
	if CountHerring<=CountSalmon then
		if CanAddItems("Hut", "Herring", 10, INVENTORY_STD) then
			if ResourceFind("Hut","Herring","Resource", true) then
				return 100
			end
		elseif CanAddItems("Hut", "Salmon", 10, INVENTORY_STD) then
			if ResourceFind("Hut","Salmon","Resource", true) then
				return 100
			end
		else
			return 0
		end
	else
		if CanAddItems("Hut", "Salmon", 10, INVENTORY_STD) then
			if ResourceFind("Hut","Salmon","Resource", true) then
				return 100
			end
		elseif CanAddItems("Hut", "Herring", 10, INVENTORY_STD) then
			if ResourceFind("Hut","Herring","Resource", true) then
				return 100
			end
		else
			return 0
		end
	end
	
	return 0	
end

function Execute()
	MeasureRun("", "Resource", "Fishing")
end
