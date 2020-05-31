
function Pickpocket(WorkerAlias, HomeAlias)
	--LogMessage("::TOM::Thief Let's pickpocket")
	if GetSettlement(HomeAlias, "City") and f_CityFindCrowdedPlace("City", WorkerAlias, "pick_pos") > 0 then
		f_ExitCurrentBuilding(WorkerAlias)
		f_MoveTo(WorkerAlias, "pick_pos", GL_MOVESPEED_RUN, 250)
		--GetFleePosition(Worker, "NearBld", 400, "pick_pos")
		MeasureRun(WorkerAlias, 0, "PickpocketPeople")
		return true
	end
	return false
end

function BurgleBuilding(WorkerAlias, HomeAlias) 
	--LogMessage("::TOM::Thief Let's burgle")
	if not GetSettlement(HomeAlias, "City") then
		return false
	end
	
	if BuildingGetLevel(HomeAlias) < 2 then	
		return false
	end
	
	local DynID = GetDynastyID(HomeAlias)

	-- filter for buildings that have been scouted
	local DynId = GetDynastyID(HomeAlias)
	local BldCount = Find(HomeAlias, "__F((Object.GetObjectsByRadius(Building)==10000)AND NOT(Object.BelongsToMe())AND NOT(Object.HasImpact(buildingburgledtoday))AND(Object.HasProperty(ScoutedBy"..DynId..")))", "Bld", 10)
	local TargetAlias
	for i = 0, BldCount - 1 do
		TargetAlias = "Bld"..i
		if BuildingGetOwner(TargetAlias, "BuildingOwner") and DynastyGetDiplomacyState(HomeAlias, "BuildingOwner") < DIP_ALLIANCE then
			if Find(TargetAlias, "__F((Object.GetObjectsByRadius(Sim)==500) AND NOT(Object.BelongsToMe()))","Sims",10) < 5 then
				--LogMessage("::TOM::Thief Found a building to burgle."..GetName(TargetAlias).." Diplomacy is "..DynastyGetDiplomacyState(HomeAlias, "BuildingOwner"))
				MeasureRun(WorkerAlias, TargetAlias, "BurgleAHouse")
				return true
			end
		end
	end
	if BldCount <= 0 then
		-- if no scouted buildings are available, go scouting
		local BuildingClass = Rand(2) + 1 -- GL_BUILDING_CLASS_LIVINGROOM == 1, GL_BUILDING_CLASS_WORKSHOP == 2
		for j = 0, 5 do
			CityGetRandomBuilding("City", BuildingClass, -1, -1, -1, FILTER_HAS_DYNASTY, "BuildingToScout")
			if DynId ~= GetDynastyID("BuildingToScout") 
					and BuildingGetOwner("BuildingToScout", "BldOwner") 
					and DynastyGetDiplomacyState(HomeAlias, "BldOwner") <= DIP_NEUTRAL then
				MeasureRun(WorkerAlias, "BuildingToScout", "ScoutAHouse")
				return false
			end
		end
	end
	return false
end

function StealFromCounter(WorkerAlias, HomeAlias) 
	--LogMessage("::TOM::Thief Let's steal from a sales counter")
	if not GetSettlement(HomeAlias, "City") then
		return false
	end
	if BuildingGetLevel(HomeAlias) < 3 then	
		return false
	end
	
	local DynID = GetDynastyID(HomeAlias)

	for i = 0, 10 do
		economy_GetRandomBuildingByRanking("City", "Build", 30)
		CityGetRandomBuilding("City", GL_BUILDING_CLASS_WORKSHOP, -1, -1, -1, FILTER_HAS_DYNASTY, "Build")
		if GetImpactValue("Build", "buildingburgledtoday") <= 0 and CalcDistance(HomeAlias, "Build") <= 10000 then	
			if BuildingGetOwner("Build","BuildingOwner") and DynastyGetDiplomacyState(HomeAlias, "BuildingOwner") < DIP_ALLIANCE then
				--LogMessage("::TOM::Thief Found a building to steal from."..GetName("Build").." Diplomacy is "..DynastyGetDiplomacyState(HomeAlias, "BuildingOwner"))
				MeasureRun(WorkerAlias, "Build", "StealFromCounter")
				return true
			end
		end
	end
	-- if no target was found return false
	return false
end

function Heal(WorkerAlias, HomeAlias)
	--LogMessage("::TOM::Thief I need healing!")
	GetSettlement(HomeAlias, "City")
	CityGetNearestBuilding("City", WorkerAlias, -1, GL_BUILDING_TYPE_LINGERPLACE, -1, -1, FILTER_IGNORE, "LingerPlace")
	MeasureRun(WorkerAlias, "LingerPlace", "Linger")
end

function GetAmbushLocation(RobberBld, RetAlias)
	local Count = GetOutdoorLocator("ambush", -1, "Ambush")
	if (Count==0) or (Count==nil) then
		return false
	end
	
	local	Alias
	local	Dist = -1
	local Location = nil
	local BestDist = 99999
	
	for l=0,Count-1 do
		Alias = "Ambush"..l
		Dist = GetDistance(RobberBld, Alias)
		
		if not Location or Dist < BestDist then
			Location = Alias
			BestDist = Dist
		end
	end
	
	if not Location then
		return false
	end
	
	CopyAlias(Location , RetAlias)
	return true
end