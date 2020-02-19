function Run()

	if AliasExists("Destination") then
		if IsType("Destination", "AISquad") then
			CopyAlias("Destination", "Squad")
			SquadSetReady("Squad", 0, true)
			RemoveAlias("Destination")
		end
	end

	local	TimeOut = GetGametime() + 3
	
	GetSettlement("", "Settlement")
	
	while GetGametime() < TimeOut do
			
		if not AliasExists("Destination") then
			if not ms_checklocation_FindPlace() then
				return 0
			end
		end
		
		if GetOutdoorMovePosition("", "Destination", "OutdoorPos") then
			if not f_MoveTo("", "OutdoorPos", Rand(500)+150) then
				return
			end
		else
			if not f_MoveTo("", "Destination", Rand(500)+150) then
				return
			end
		end

		Sleep(Rand(10)+10)
		f_Stroll("", 500, 8)
		PlayAnimation("", "guard_object")
		Sleep(Rand(10)+10)
		PlayAnimation("", "sentinel_idle")
		Sleep(Rand(10)+10)
		PlayAnimation("", "sentinel_idle")
		Sleep(Rand(10)+10)
		f_Stroll("", 600, 12)
		if Rand(0) == 0 then
			Sleep(5)
			PlayAnimation("", "cogitate")
		else
			Sleep(4)
			PlayAnimation("", "watch_for_guard")
		end
		Sleep(8)
		if SimGetProfession("") == GL_PROFESSION_CITYGUARD or SimGetProfession("") == GL_PROFESSION_ELITEGUARD then
			StopMeasure()
		end
		RemoveAlias("Destination")
	end
	
end


function FindPlace()

	local	Ok
	local Type
	local NumOfObjects
	local	MaxRadius = 2000 + 1000 * CityGetLevel("Settlement")
	
	for trys=0,30 do
		if CityGetRandomBuilding("Settlement", -1, -1, -1, -1, FILTER_IGNORE, "Destination") then
		
			Ok = true
			
			Type = BuildingGetType("Destination")
			if Type == GL_BUILDING_TYPE_ROBBER then
				Ok = false
			end
			
			if Ok and Type == GL_BUILDING_TYPE_THIEF then
				Ok = false
			end

			if Ok and Type == GL_BUILDING_TYPE_RESOURCE then
				Ok = false
			end

			if Ok and Type == GL_BUILDING_TYPE_BUILDABLERESOURCE then
				Ok = false
			end
			
			if Ok and GetDistance("Destination", "Settlement") > MaxRadius then
				Ok = false
			end
			
			if Ok then
				return true
			end
			
		end
	end
	return false

end


function CleanUp()
	if AliasExists("Squad") then
		SquadSetReady("Squad", 0, false)
		SquadDestroy("Squad")
	end
end



