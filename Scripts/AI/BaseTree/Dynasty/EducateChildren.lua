-- Action: Make sure all children are getting education
function Weight()
	local PartyCount = DynastyGetMemberCount("dynasty")
	local FamilyCount = DynastyGetFamilyMemberCount("dynasty")
	if FamilyCount > PartyCount then
		return 10
	end
	return 0
end

----	The script uses the sim-property "EduLevel" which can be:
----	EDULEVEL_NONE = 0
----	EDULEVEL_SCHOOL = 1
----	EDULEVEL_UNIVERSITY1 = 2
----	EDULEVEL_UNIVERSITY2 = 3
function Execute()
	if not DynastyGetRandomBuilding("dynasty", GL_BUILDING_CLASS_LIVINGROOM, GL_BUILDING_TYPE_RESIDENCE, "home") then
		return
	end
	
	if not GetSettlement("home", "City") then
		return
	end
	
	if not (CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "School") and (gameplayformulas_CheckPublicBuilding("City", GL_BUILDING_TYPE_BANK)[1]>0)) then
		return
	end

	-- send children to school/apprenticeship
	local FamilyCount = DynastyGetFamilyMemberCount("dynasty")
	for i=0, FamilyCount-1 do
		DynastyGetFamilyMember("dynasty", i, "sim")
		
		local Education = EDULEVEL_NONE
		if HasProperty("sim", "EduLevel") then
			Education = GetProperty("sim", "EduLevel")
		end

		local Age = SimGetAge("sim")
		
		-- check for school
		if SimGetBehavior("sim") == "SchoolDays" and Education == EDULEVEL_NONE then
			MeasureRun("sim", "School", "AttendSchool")
			return
		end
		
		-- check for apprenticeship
		if SimGetBehavior("sim") == "Apprenticeship" and not HasProperty("sim", "is_apprentice") then
			MeasureRun("sim", "School", "AttendApprenticeship")
			return
		end
		
		-- check for university
		if Age >= 15 and SimGetClass("sim") == 3 then 
			if Education == 1 or Education == 2 then
				MeasureRun("sim", "School", "AttendUniversity")
				return
			end
		end
	end
end
