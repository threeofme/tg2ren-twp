function Weight()

	local Count = DynastyGetMemberCount("dynasty")
	
	if not ReadyToRepeat("dynasty", "AI_CheckChilds") then
		return 0
	end
	
	for i=0, Count-1 do
		if DynastyGetMember("dynasty", i, "Parent") then
			if SimGetAge("Parent") >= 18 then
				local Childs = SimGetChildrenCount("Parent")
				for c=0, Childs-1 do
					if SimGetChildren("Parent", c, "Child") and GetSettlement("Child", "City") and not GetState("Child", STATE_DEAD) then
						local ChildAge = SimGetAge("Child")
						local Education = 0
						if HasProperty("Child", "EduLevel") then
							Education = GetProperty("Child", "EduLevel")
						end
						
						if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "School") and (gameplayformulas_CheckPublicBuilding("City", GL_BUILDING_TYPE_BANK)[1]>0) then
							-- check for school
							if ChildAge >= 5 and Education == 0 then
								SetData("ToDo", "School")
								return 100
							-- check for apprenticeship
							elseif ChildAge >= 9 and not HasProperty("Child", "is_apprentice") then
								SetData("ToDo", "Apprentice")
								return 100
							-- check for university
							elseif ChildAge >= 15 and SimGetClass("Child") == 3 then 
								if Education == 1 or Education == 2 then
									SetData("ToDo", "Uni")
									return 100
								end
							end
						else
							return 0
						end
					end
				end
			end
		end
	end
	
	return 0
end
			
function Execute()
	local ToDo = GetData("ToDo")
	
	if not AliasExists("School") then
		return
	end
	
	SetRepeatTimer("dynasty", "AI_CheckChilds", 3)
	
	if ToDo == "School" then
		MeasureRun("Child", "School", "AttendSchool")
		return
	end
	
	if ToDo == "Apprentice" then
		MeasureRun("Child", "School", "AttendApprenticeship")
		return
	end

	if ToDo == "Uni" then
		MeasureRun("Child", "School", "AttendUniversity")
		return
	end
end

