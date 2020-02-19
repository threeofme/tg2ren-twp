function Run()
	if SimGetWorkingPlace("", "WorkingPlace") then
	
		-- temporary productivity bonus via boss
		if BuildingGetOwner("WorkingPlace", "MyBoss") and GetID("") ~= GetID("MyBoss") then	
			local ProdSkillBonus = 0
			local MyClass = SimGetClass("")
			if MyClass == 1 or MyClass == 2 then
				ProdSkillBonus = GetSkillValue("MyBoss", CRAFTSMANSHIP)
			elseif MyClass == 3 then
				ProdSkillBonus = GetSkillValue("MyBoss", SECRET_KNOWLEDGE) / 2
			elseif MyClass == 4 then
				ProdSkillBonus = GetSkillValue("MyBoss", CRAFTSMANSHIP)
			end

			ProdSkillBonus = ProdSkillBonus / 10
			AddImpact("", "Productivity", ProdSkillBonus, -1)
		end
	end

	SetProperty("", "StartWorkingTime", 1)
	
	while true do
		Sleep(5)
	end
end

function CleanUp()

	if HasProperty("", "StartWorkingTime") then
		RemoveProperty("", "StartWorkingTime")
	end
	
	if SimGetWorkingPlace("", "WorkingPlace") then
		RemoveImpact("", "Productivity")
	end
end
