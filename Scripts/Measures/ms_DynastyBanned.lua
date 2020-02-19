function Run()
	if GetImpactValue("", "banned")==0 then
		StopMeasure()
	end

	GetSettlement("","CityAlias")
	if not CityGetNearestBuilding("CityAlias", "", -1, GL_BUILDING_TYPE_ROBBER, -1, -1, FILTER_IGNORE, "FleeBuilding") then
		if not CityGetNearestBuilding("CityAlias", "", -1, GL_BUILDING_TYPE_MERCENARY, -1, -1, FILTER_IGNORE, "FleeBuilding") then
			CityGetNearestBuilding("CityAlias", "", -1, GL_BUILDING_TYPE_FARM, -1, -1, FILTER_IGNORE, "FleeBuilding")
		end
	end

	if AliasExists("FleeBuilding") then
		if GetOutdoorMovePosition("", "FleeBuilding", "FleePos") then
			f_MoveTo("","FleePos",GL_MOVESPEED_RUN,300)

			while GetImpactValue("", "banned")>0 do
				Sleep(4)
			end
		end
	end
end
