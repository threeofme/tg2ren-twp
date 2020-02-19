function Run()
	local modval = 0
	local kamm = 0

	if (GetProperty("Actor", "jewellery")==nil) or (GetProperty("Actor", "jewellery")==8) then
		modval = 3 + chr_SimGetFameLevel("Actor")
		if GetSettlement("", "my_settlement") then
			if (gameplayformulas_CheckPublicBuilding("my_settlement", GL_BUILDING_TYPE_BANK)[1]>0) and CityGetRandomBuilding("my_settlement", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "GuildHouse") then
				if chr_CheckGuildMaster("Actor","GuildHouse")==true then
					modval = modval + 2
				end
			end
		end
	elseif GetProperty("Actor", "jewellery") == 7 then
		if not (SimGetGender("") == SimGetGender("Actor")) then
			chr_ModifyFavor("","Actor",7)
		end
		return ""
	elseif GetProperty("Actor", "jewellery") == 6 then
			modval = 2
			kamm = 1
	elseif GetProperty("Actor", "jewellery") == 5 then
			modval = 5
	elseif GetProperty("Actor", "jewellery") == 4 then
			modval = 4
	elseif GetProperty("Actor", "jewellery") == 3 then
			modval = 3
	elseif GetProperty("Actor", "jewellery") == 2 then
			modval = 2
	elseif GetProperty("Actor", "jewellery") == 1 then
			modval = 1
	end

	if kamm > 0 then
		if SimGetOfficeLevel("")<0 then
			modval = modval + 3
		end
		chr_ModifyFavor("","Actor",modval)
	elseif modval > 0 then
		chr_ModifyFavor("","Actor",modval)
	end

	return ""
end

