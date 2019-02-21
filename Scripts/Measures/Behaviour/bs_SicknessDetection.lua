function Run()
	
	-- already sick?
	if GetState("",STATE_SICK) then
		return
	end
	
	-- these professions never get sick by infection (only random)
	local Profession = SimGetProfession("")
	if Profession then
		--cityguard, prisonguard, inspector, monitor, eliteguard
		if (Profession > 20) and (Profession < 26) then
			return
		end
		--inquisitor
		if Profession == 28 then
			return
		end
	end
	
	-- if you have Resist (soap?) you don't get sick either
	if GetImpactValue("","Resist")>0 then
		return
	end
	
	if GetInsideBuilding("","CurrentBuilding") then
		-- You don't get sick inside hospitals from sick sims (thank god!)
		if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_HOSPITAL then
			return
		-- NPCs don't infect each other in the worker's huts anymore
		elseif BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_WORKER_HOUSING then 
			return
		end
	end
	
	local Constitution = 40 + GetSkillValue("",CONSTITUTION)*10 -- base immunity is 50, up to 140 (and more)
	local SimAge = SimGetAge("")
	local AgeMalus = 0
	
	-- no children
	if SimAge < 16 then 
		return
	else
		AgeMalus = (SimAge - 16) * 2 -- after 16 years, you lose 2 points of immunity per year of life.
	end
	
	-- calculate the chance to resist the infection
	local Immunity = Constitution - AgeMalus	-- At 19 years + 1 consti you have 46 immunity At 60 + 1 consti you have (-)33 immunity 
									-- At 75 years and 10 consti you have only 22 immunity. You WILL get sick in the old ages
	if Immunity <= 1 then
		Immunity = 0
	end
	
	-- let's do the infection
	local Hazard = 0 -- chance of infection depending on illness
	if GetImpactValue("Actor","Cold")==1 then
		Hazard = 30
		if Rand(Hazard) > Immunity then
			diseases_Cold("",true)
		end
	elseif GetImpactValue("Actor","Influenza")==1 then
		Hazard = 40
		if Rand(Hazard) > Immunity then
			diseases_Influenza("",true)
		end
	elseif GetImpactValue("Actor","Pneumonia")==1 then
		Hazard = 20
		if Rand(Hazard) > Immunity then
			diseases_Influenza("",true)
			SetState("",STATE_CONTAMINATED,true)
		end
	elseif GetImpactValue("Actor","Pox")==1 then
		Hazard = 10
		if Rand(Hazard) > Immunity then
			diseases_Pox("",true)
			SetState("",STATE_CONTAMINATED,true)
		end
		return "flee"
	elseif GetImpactValue("Actor","Blackdeath")==1 then
		local FirstInfection = 0 
		if HasProperty("Actor","YearBlackdeath") then
			-- gets the round of first infection
			FirstInfection = GetProperty("Actor", "YearBlackdeath")
		end
		Hazard = 60
		local ThisRound = GetRound()
		local LowerInfectionRate = (ThisRound-FirstInfection)*10 -- this means, the chance of further infection goes down by 10 per Round
		Hazard = math.max(0, Hazard - LowerInfectionRate)
		
		-- We are immune if we were cured in the last 5 rounds
		if GetImpactValue("","PlagueImmunity")>0 then
			Immunity = 50
		end
		
		if Hazard > 0 then
			if Rand(Hazard) > Immunity then
				GetSettlement("","City")
				local InfectableSims = CityGetCitizenCount("City") / 4
				local CurrentInfected = GetProperty("City","BlackdeathInfected")
				if CurrentInfected < InfectableSims then
					if CurrentInfected < 100 then
						SetProperty("","YearBlackdeath",FirstInfection)
						diseases_Blackdeath("",true,false)
					end
				end
			end
		end
		return "flee"
	end
end

function CleanUp()
	-- whatever happened in this script, you are safe from infections for 4 hours after this script
	AddImpact("","Resist",1,4)
end