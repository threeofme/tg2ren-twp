function Weight()

	-- only important shadows should court (performance)
	if DynastyIsShadow("SIM") then
		if DynastyGetBuildingCount2("SIM") > 0 then -- we own something
			return 100
		end
		
		if SimGetOfficeLevel("SIM") >= 0 or SimIsAppliedForOffice("SIM") then -- we are political
			return 100
		end
		
		return 0 -- we are unimportant
	end
	
	return 20
end

function Execute()
end