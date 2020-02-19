function Run()
	-- dont remove this line since it sets the owners dynasty that is needed for later filter
	GetDynasty("", "Dynasty")
	
	while not GetState("", STATE_DEAD) do
	
		if IsType("","Sim") then
			state_scanning_ArrestLoop(false)
		elseif IsType("","Building")then
			state_scanning_WatchtowerLoop() 
			if GetDynastyID("")<1 then
				state_scanning_ArrestLoop(true)
			end
		end
		Sleep(2)
	end
end


function ArrestLoop(IsBuilding)

	if IsBuilding==false and GetState("", STATE_IDLE)==false then
		return
	end
	
	if CityGuardScan("", "Penalty") then	-- find a fugitive (and with no impact "no_arrestable")
		if PenaltyGetOffender("Penalty", "Wanted") then -- wanted found -> arrest him
			if IsBuilding then
				if not GetState("Wanted", STATE_UNCONSCIOUS) then
					gameplayformulas_SimAttackWithRangeWeapon("", "Wanted")
					BattleJoin("", "Wanted", true)
				end
			else
				if GetDistance("","Wanted")<4000 then
					MeasureRun("", "Wanted", "Arrest")
				end
			end
		end
	end
end

function WatchtowerLoop()
	if not GetState("", STATE_FIGHTING) then
		-- Detect enemy ships
		local ShipFilter = "__F((Object.GetObjectsByRadius(Ship)==3000)AND(Object.IsHostile())AND(Object.GetState(fighting))AND NOT(Object.CanBeControlled())AND NOT(Object.BelongsToMe()))"
		local NumOfShips = Find("", ShipFilter,"HostileShip", -1)
		if NumOfShips > 0 then
			if GetDynastyID("HostileShip")~=GetDynastyID("") then
				gameplayformulas_SimAttackWithRangeWeapon("", "HostileShip")
				BattleJoin("","HostileShip", false)
				return
			end
		end
		
		--Detect enemy and fighting Sims
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim)==1800)AND(Object.IsHostile())AND(Object.GetState(fighting))AND NOT(Object.CanBeControlled())AND NOT(Object.BelongsToMe()))"
		local NumOfSims = Find("", SimFilter,"HostileSim", -1) 
		if NumOfSims > 0 then
			if GetDynastyID("HostileSim")~=GetDynastyID("") then
				gameplayformulas_SimAttackWithRangeWeapon("", "HostileSim")
				BattleJoin("","HostileSim", false)
			end
			return
		end
		
		--Detect robbers
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim)==1800)AND(Object.GetProfession()==15)OR(Object.GetProfession()==26)AND NOT(Object.CanBeControlled())AND NOT(Object.BelongsToMe())AND NOT(Object.HasProperty(Guarding)))"
		local NumOfSims = Find("", SimFilter,"RobberSim", -1) 
		if NumOfSims > 0 then
			if GetDynastyID("RobberSim") ~= GetDynastyID("") then
				if GetCurrentMeasureName("RobberSim")=="PlunderBuilding" then
					gameplayformulas_SimAttackWithRangeWeapon("", "RobberSim")
					BattleJoin("","RobberSim", false)
				elseif GetCurrentMeasureName("RobberSim")=="SquadWaylayMember"  and SimGetProfession("RobberSim")==GL_PROFESSION_ROBBER then
					gameplayformulas_SimAttackWithRangeWeapon("", "RobberSim")
					BattleJoin("","RobberSim", false)
				elseif GetCurrentMeasureName("RobberSim")=="BurgleAHouse" then
					gameplayformulas_SimAttackWithRangeWeapon("", "RobberSim")
					BattleJoin("","RobberSim", false)
				end
			end
			return
		end	
	
	end	
end

