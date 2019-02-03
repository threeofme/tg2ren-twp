function Weight()
	aitwp_Log("Weight::HireMyrmidon", "dynasty")
	if not ReadyToRepeat("dynasty", "AI_HireMyrmidon") then
		return 0
	end

	if GetMoney("dynasty") < 3000 then
		return 0
	end
	
	if not GetHomeBuilding("dynasty", "myrm_home") then
		return 0
	end
	
	if not BuildingGetType("myrm_home") == GL_BUILDING_TYPE_RESIDENCE then
		return 0
	end
	
	if not BuildingCanHireNewWorker("myrm_home") then
		return 0
	end
	
	return 10
end

function Execute()
	local Difficulty = ScenarioGetDifficulty()
	SetRepeatTimer("dynasty", "AI_HireMyrmidon", 2 * (5 - Difficulty))
	MeasureRun("myrm_home", 0, "HireEmployeeBuildingRandom")
end

