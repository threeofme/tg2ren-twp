function Weight()

	local Difficulty = ScenarioGetDifficulty() 

	if GetMoney("dynasty") < 3000 then
		return 0
	end
	
	if not GetHomeBuilding("SIM", "myrm_home") then
		return 0
	end
	
	if not BuildingGetType("myrm_home") == GL_BUILDING_TYPE_RESIDENCE then
		return 0
	end
	
	if not BuildingCanHireNewWorker("myrm_home") then
		return 0
	end
	
	return 100
end

function Execute()
	HireWorker("myrm_home")
end

