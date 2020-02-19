function Run()
	local CanBuild = false
	
	GetSettlement("#Player","Settlement")

	local Count = CityGetBuildings("Settlement", GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_HOSPITAL, -1, -1, FILTER_IGNORE, "CityHospitals")
	
	for l=0,Count-1 do
		Alias	= "CityHospitals"..l
		if BuildingGetOwner(Alias,"BuildingOwner") then
			if GetID("BuildingOwner") == GetID("#Player") then
				if ( (GetItemCount("#Player","StaffOfAesculap") > 0) or (GetItemCount(Alias,"StaffOfAesculap") > 0) ) then
					if ( (GetItemCount("#Player","Perfume") > 0) or (GetItemCount(Alias,"Perfume") > 0) ) then
						if ( (GetItemCount("#Player","Medicine") > 0) or (GetItemCount(Alias,"Medicine") > 0) ) then
							if ( (GetItemCount("#Player","Bandage") > 0) or (GetItemCount(Alias,"Bandage") > 0) ) then
								if (GetInsideBuildingID("#Player") == GetID(Alias)) then
									CanBuild = true
								end
							end
						end
					end
				end	
			end
		end
	end	
		
	
	
	if CanBuild == true then
		SetProperty("#Player","BuildPestMask",1)
	else
		MsgQuick("#Player", "@L_MEASURE_QuestBuildPestMask_FAILURE")
	end
	
	StopMeasure("")
end

function CleanUp()
	
end


