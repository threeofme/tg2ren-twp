-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

function CheckDisease(Objectalias,Force)
	
	if not GetSettlement(Objectalias,"City") then
		return false
	end
	
	if GetState(Objectalias,STATE_DEAD) then
		return false
	end
	
	local CurrentInfected = 0
	local InfectableSims = CityGetCitizenCount("City") / 4
	if InfectableSims <= 0 then
		return false
	end
	if GetImpactValue(Objectalias,"Sickness")>0 then
		return false
	end
	if not Force then
		if GetImpactValue(Objectalias,"Resist")>0 then
			return false
		end
		if GetImpactValue("City","Sickness")>1 then
			return false
		end
	end
	
	if not HasProperty("City","InfectedSims") then
		SetProperty("City","InfectedSims",1)
	else
		CurrentInfected = GetProperty("City","InfectedSims") + 1
		
		if (CurrentInfected <= InfectableSims) or Force then
			SetProperty("City","InfectedSims",CurrentInfected)
		else
			return false
		end
	end
	AddImpact("City","Sickness",1,0.25)
	return true
end
-- -----------------------
-- fever (for workers only)
-- -----------------------
function Fever(ObjectAlias, State)
	-- State: true = character should get a fever

	local duration = 12

	if State == true then
		if not (GetImpactValue(ObjectAlias,"Fever")==1) then
			AddImpact(ObjectAlias,"Fever",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_BLACKDEATH,true)
		end
	else
		if (GetImpactValue(ObjectAlias,"Fever")==1) then
			RemoveImpact(ObjectAlias,"Fever")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_BLACKDEATH,false)
		end
	end

end
-- -----------------------
-- LEVEL 1 DISEASES
-- -----------------------
-- -----------------------
-- Sprain / verstauchung
-- -----------------------
function Sprain(ObjectAlias, State, Force)
	-- State: true = character should get a fracture, false = the fracture should heal
	
	local duration = 16
	local endtime = math.mod(GetGametime(),24)+duration

	if State == true then
		if not diseases_CheckDisease(ObjectAlias,Force) then
			return		
		end
		if not (GetImpactValue(ObjectAlias,"Sprain")==1) then
			AddImpact(ObjectAlias,"Sprain",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_SICK,true)
			SetProperty(ObjectAlias,"SprainTime",endtime)
			
			--AddImpact(ObjectAlias,"MoveSpeed",0.8,duration)
			AddImpact(ObjectAlias,"dexterity",-2,duration)
			AddImpact(ObjectAlias,"craftsmanship",-2,duration) --Fajeth
			AddImpact(ObjectAlias,"fighting",-2,duration) -- Fajeth
		
		end
	else
		if GetImpactValue(ObjectAlias,"Sprain")==1 then
			RemoveImpact(ObjectAlias,"Sprain")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_SICK,false)
			
			--RemoveImpact(ObjectAlias,"MoveSpeed")
			-- instead of RemoveImpact we add a impact for the rest of the time
			if math.mod(GetGametime(),24)<GetProperty(ObjectAlias,"SprainTime") then
				duration = math.floor(GetProperty(ObjectAlias,"SprainTime")-math.mod(GetGametime(),24))
				AddImpact(ObjectAlias,"dexterity",2,duration)
				AddImpact(ObjectAlias,"craftsmanship",2,duration)
				AddImpact(ObjectAlias,"fighting",2,duration)
			
				RemoveProperty(ObjectAlias,"SprainTime")
			end
			
			if GetSettlement(ObjectAlias,"City") then
				chr_decrementInfectionCount("SprainInfected", "City")
			end
		end
	end

end
-- -----------------------
-- Cold / erkaeltung
-- -----------------------
function Cold(ObjectAlias, State, Force)
	-- State: true = character should get a dysentery, false = the dysentery should heal
	
	local duration = 24
	local modifier = 1
	local endtime = math.mod(GetGametime(),24)+duration

	if State == true then
		if not diseases_CheckDisease(ObjectAlias,Force) then
			return		
		end
		if not (GetImpactValue(ObjectAlias,"Cold")==1) then
			AddImpact(ObjectAlias,"Cold",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_SICK,true)
			SetProperty(ObjectAlias,"ColdTime",endtime)

			AddImpact(ObjectAlias,"constitution",-modifier,duration)
			AddImpact(ObjectAlias,"dexterity",-modifier,duration)
			AddImpact(ObjectAlias,"charisma",-modifier,duration)
			AddImpact(ObjectAlias,"fighting",-modifier,duration)
			AddImpact(ObjectAlias,"craftsmanship",-modifier,duration)
			AddImpact(ObjectAlias,"shadow_arts",-modifier,duration)
			AddImpact(ObjectAlias,"rhetoric",-modifier,duration)
			AddImpact(ObjectAlias,"empathy",-modifier,duration)
			AddImpact(ObjectAlias,"bargaining",-modifier,duration)
			AddImpact(ObjectAlias,"secret_knowledge",-modifier,duration)

		end
	else
		if (GetImpactValue(ObjectAlias,"Cold")==1) then
			RemoveImpact(ObjectAlias,"Cold")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_SICK,false)
			-- instead of RemoveImpact we add a impact for the rest of the time
			if math.mod(GetGametime(),24)<GetProperty(ObjectAlias,"ColdTime") then
				duration = math.floor(GetProperty(ObjectAlias,"ColdTime")-math.mod(GetGametime(),24))
			
				AddImpact(ObjectAlias,"constitution",modifier,duration)
				AddImpact(ObjectAlias,"dexterity",modifier,duration)
				AddImpact(ObjectAlias,"charisma",modifier,duration)
				AddImpact(ObjectAlias,"fighting",modifier,duration)
				AddImpact(ObjectAlias,"craftsmanship",modifier,duration)
				AddImpact(ObjectAlias,"shadow_arts",modifier,duration)
				AddImpact(ObjectAlias,"rhetoric",modifier,duration)
				AddImpact(ObjectAlias,"empathy",modifier,duration)
				AddImpact(ObjectAlias,"bargaining",modifier,duration)
				AddImpact(ObjectAlias,"secret_knowledge",modifier,duration)
				RemoveProperty(ObjectAlias,"ColdTime")
			end
			
			if GetSettlement(ObjectAlias,"City") then
				chr_decrementInfectionCount("ColdInfected", "City")
			end
		end
	end
end
-- -----------------------
-- LEVEL 2 DISEASES
-- -----------------------
-- -----------------------
-- Influenza / grippe
-- -----------------------
function Influenza(ObjectAlias, State, Force)
	-- State: true = character should get a dysentery, false = the dysentery should heal
	
	local duration = 16
	local modifier = 3
	local endtime = math.mod(GetGametime(),24)+duration

	if State == true then
		if not diseases_CheckDisease(ObjectAlias,Force) then
			return		
		end
		if not (GetImpactValue(ObjectAlias,"Influenza")==1) then
			AddImpact(ObjectAlias,"Influenza",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_SICK,true)
			SetProperty(ObjectAlias,"InfluenzaTime",endtime)

			AddImpact(ObjectAlias,"constitution",-modifier,duration)
			AddImpact(ObjectAlias,"dexterity",-modifier,duration)
			AddImpact(ObjectAlias,"charisma",-modifier,duration)
			AddImpact(ObjectAlias,"fighting",-modifier,duration)
			AddImpact(ObjectAlias,"craftsmanship",-modifier,duration)
			AddImpact(ObjectAlias,"shadow_arts",-modifier,duration)
			AddImpact(ObjectAlias,"rhetoric",-modifier,duration)
			AddImpact(ObjectAlias,"empathy",-modifier,duration)
			AddImpact(ObjectAlias,"bargaining",-modifier,duration)
			AddImpact(ObjectAlias,"secret_knowledge",-modifier,duration)

		end
	else
		if (GetImpactValue(ObjectAlias,"Influenza")==1) then
			RemoveImpact(ObjectAlias,"Influenza")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_SICK,false)
			-- instead of RemoveImpact we add a impact for the rest of the time
			if math.mod(GetGametime(),24)<GetProperty(ObjectAlias,"InfluenzaTime") then
				duration = math.floor(GetProperty(ObjectAlias,"InfluenzaTime")-math.mod(GetGametime(),24))
				
				AddImpact(ObjectAlias,"constitution",modifier,duration)
				AddImpact(ObjectAlias,"dexterity",modifier,duration)
				AddImpact(ObjectAlias,"charisma",modifier,duration)
				AddImpact(ObjectAlias,"fighting",modifier,duration)
				AddImpact(ObjectAlias,"craftsmanship",modifier,duration)
				AddImpact(ObjectAlias,"shadow_arts",modifier,duration)
				AddImpact(ObjectAlias,"rhetoric",modifier,duration)
				AddImpact(ObjectAlias,"empathy",modifier,duration)
				AddImpact(ObjectAlias,"bargaining",modifier,duration)
				AddImpact(ObjectAlias,"secret_knowledge",modifier,duration)
				RemoveProperty(ObjectAlias,"InfluenzaTime")
			end
			
			if GetSettlement(ObjectAlias,"City") then
				chr_decrementInfectionCount("InfluenzaInfected", "City")				
			end
		end
	end
end
-- -----------------------
-- Burn / brandwunde
-- -----------------------
function BurnWound(ObjectAlias, State)
	-- State: true = character should get a fracture, false = the fracture should heal
	
	local duration = 8

	if State == true then
		if not (GetImpactValue(ObjectAlias,"BurnWound")==1) then
			AddImpact(ObjectAlias,"BurnWound",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_SICK,true)
		end
	else
		if GetImpactValue(ObjectAlias,"BurnWound")==1 then
			RemoveImpact(ObjectAlias,"BurnWound")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_SICK,false)

			if GetSettlement(ObjectAlias,"City") then
				chr_decrementInfectionCount("BurnWoundInfected", "City")	
			end
		end
	end
end
-- -----------------------
-- Lepra (intern Pocken)
-- -----------------------
function Pox(ObjectAlias, State, Force)
	-- State: true = character should get a fracture, false = the fracture should heal
	
	local duration = -1
	local modifier = 6

	if State == true then
		if not diseases_CheckDisease(ObjectAlias,Force) then
			return		
		end
		if not (GetImpactValue(ObjectAlias,"Pox")==1) then
			AddImpact(ObjectAlias,"Pox",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_SICK,true)
			
			AddImpact(ObjectAlias,"LifeExpanding",-1,-1) -- lose lifetime on infection
			AddImpact(ObjectAlias,"constitution",-modifier,duration)
			AddImpact(ObjectAlias,"charisma",-modifier,duration)
			AddImpact(ObjectAlias,"dexterity",-modifier,duration) -- Fajeth
		end
	else
		if GetImpactValue(ObjectAlias,"Pox")==1 then
			RemoveImpact(ObjectAlias,"Pox")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_SICK,false)
			
			AddImpact(ObjectAlias,"constitution",modifier,duration)
			AddImpact(ObjectAlias,"charisma",modifier,duration)
			AddImpact(ObjectAlias,"dexterity",modifier,duration) -- Fajeth


			if GetSettlement(ObjectAlias,"City") then
				chr_decrementInfectionCount("PoxInfected", "City")				
			end
		end
	end
end
-- -----------------------
-- LEVEL 3 DISEASES
-- -----------------------
-- -----------------------
-- Pneumonia / lungenentzuendung
-- -----------------------
function Pneumonia(ObjectAlias, State, Force)
	-- State: true = character should get a dysentery, false = the dysentery should heal
	
	local duration = 24
	local modifier = 5
	local endtime = math.mod(GetGametime(),24)+duration
	
	Sleep(1)
	if State == true then
		if not diseases_CheckDisease(ObjectAlias,Force) then
			return		
		end
		if not (GetImpactValue(ObjectAlias,"Pneumonia")==1) then
			AddImpact(ObjectAlias,"LifeExpanding",-2,-1) -- lose lifetime on infection
			AddImpact(ObjectAlias,"Pneumonia",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_SICK,true)
			SetProperty(ObjectAlias,"PneumoniaTime",endtime)

			AddImpact(ObjectAlias,"constitution",-modifier,duration)
			AddImpact(ObjectAlias,"dexterity",-modifier,duration)
			AddImpact(ObjectAlias,"charisma",-modifier,duration)
			AddImpact(ObjectAlias,"fighting",-modifier,duration)
			AddImpact(ObjectAlias,"craftsmanship",-modifier,duration)
			AddImpact(ObjectAlias,"shadow_arts",-modifier,duration)
			AddImpact(ObjectAlias,"rhetoric",-modifier,duration)
			AddImpact(ObjectAlias,"empathy",-modifier,duration)
			AddImpact(ObjectAlias,"bargaining",-modifier,duration)
			AddImpact(ObjectAlias,"secret_knowledge",-modifier,duration)
		end
	else
		if (GetImpactValue(ObjectAlias,"Pneumonia")==1) then
			RemoveImpact(ObjectAlias,"Pneumonia")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_SICK,false)
			-- instead of RemoveImpact we add a impact for the rest of the time
			if math.mod(GetGametime(),24)<GetProperty(ObjectAlias,"PneumoniaTime") then
				duration = math.floor(GetProperty(ObjectAlias,"PneumoniaTime")-math.mod(GetGametime(),24))
				
				AddImpact(ObjectAlias,"constitution",modifier,duration)
				AddImpact(ObjectAlias,"dexterity",modifier,duration)
				AddImpact(ObjectAlias,"charisma",modifier,duration)
				AddImpact(ObjectAlias,"fighting",modifier,duration)
				AddImpact(ObjectAlias,"craftsmanship",modifier,duration)
				AddImpact(ObjectAlias,"shadow_arts",modifier,duration)
				AddImpact(ObjectAlias,"rhetoric",modifier,duration)
				AddImpact(ObjectAlias,"empathy",modifier,duration)
				AddImpact(ObjectAlias,"bargaining",modifier,duration)
				AddImpact(ObjectAlias,"secret_knowledge",modifier,duration)
				RemoveProperty(ObjectAlias,"PneumoniaTime")
			end

			if GetSettlement(ObjectAlias,"City") then
				chr_decrementInfectionCount("PneumoniaInfected", "City")				
			end
		end
	end
end
-- -----------------------
-- Blackdeath / pest
-- -----------------------
function Blackdeath(ObjectAlias, State, Force)
	-- State: true = character should get a dysentery, false = the dysentery should heal
	
	local duration = 24
	local modifier = 7
	local endtime = math.mod(GetGametime(),24)+duration
	
	if State == true then
		if not diseases_CheckDisease(ObjectAlias,Force) then
			return		
		end
		if not (GetImpactValue(ObjectAlias,"Blackdeath")==1) then
			-- make sure that year of infection is known for sim
			if not HasProperty(ObjectAlias, "YearBlackdeath") then
				SetProperty(ObjectAlias, "YearBlackdeath", GetRound())
				MsgNewsNoWait("All","Destination","","intrigue",-1,"@L_HPFZ_KATASTR_STOD_KOPF",
	                    "@L_HPFZ_KATASTR_STOD_RUMPF",GetID("City"))	-- send a message to the city
			end
		
			AddImpact(ObjectAlias,"LifeExpanding",-3,-1) -- lose lifetime on infection
			AddImpact(ObjectAlias,"Blackdeath",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_SICK,true)
			SetProperty(ObjectAlias,"BlackdeathTime",endtime)

			AddImpact(ObjectAlias,"constitution",-modifier,duration)
			AddImpact(ObjectAlias,"dexterity",-modifier,duration)
			AddImpact(ObjectAlias,"charisma",-modifier,duration)
			AddImpact(ObjectAlias,"fighting",-modifier,duration)
			AddImpact(ObjectAlias,"craftsmanship",-modifier,duration)
			AddImpact(ObjectAlias,"shadow_arts",-modifier,duration)
			AddImpact(ObjectAlias,"rhetoric",-modifier,duration)
			AddImpact(ObjectAlias,"empathy",-modifier,duration)
			AddImpact(ObjectAlias,"bargaining",-modifier,duration)
			AddImpact(ObjectAlias,"secret_knowledge",-modifier,duration)

		end
	else
		if (GetImpactValue(ObjectAlias,"Blackdeath")==1) then
			RemoveImpact(ObjectAlias,"Blackdeath")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_SICK,false)
			-- instead of RemoveImpact we add a impact for the rest of the time
			if math.mod(GetGametime(),24)<GetProperty(ObjectAlias,"BlackdeathTime") then
				duration = math.floor(GetProperty(ObjectAlias,"BlackdeathTime")-math.mod(GetGametime(),24))
				
				AddImpact(ObjectAlias,"constitution",modifier,duration)
				AddImpact(ObjectAlias,"dexterity",modifier,duration)
				AddImpact(ObjectAlias,"charisma",modifier,duration)
				AddImpact(ObjectAlias,"fighting",modifier,duration)
				AddImpact(ObjectAlias,"craftsmanship",modifier,duration)
				AddImpact(ObjectAlias,"shadow_arts",modifier,duration)
				AddImpact(ObjectAlias,"rhetoric",modifier,duration)
				AddImpact(ObjectAlias,"empathy",modifier,duration)
				AddImpact(ObjectAlias,"bargaining",modifier,duration)
				AddImpact(ObjectAlias,"secret_knowledge",modifier,duration)
				RemoveProperty(ObjectAlias,"BlackdeathTime")
				RemoveProperty(ObjectAlias, "YearBlackdeath")
			end
			
			if GetSettlement(ObjectAlias,"City") then
				chr_decrementInfectionCount("BlackdeathInfected", "City")				
			end
		end
	end
end
-- -----------------------
-- Fracture / knochenbruch
-- -----------------------
function Fracture(ObjectAlias, State,Force)
	-- State: true = character should get a fracture, false = the fracture should heal
	
	local duration = 24
	local endtime = math.mod(GetGametime(),24)+duration

	if State == true then
		if not diseases_CheckDisease(ObjectAlias,Force) then
			return		
		end
		if not (GetImpactValue(ObjectAlias,"Fracture")==1) then
			AddImpact(ObjectAlias,"Fracture",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_SICK,true)
			SetProperty(ObjectAlias,"FractureTime",endtime)
			
			--AddImpact(ObjectAlias,"MoveSpeed",0.6,duration)
			AddImpact(ObjectAlias,"craftsmanship",-4,duration)
			AddImpact(ObjectAlias,"Fighting",-4,duration)
			AddImpact(ObjectAlias,"dexterity",-4,duration)
		end
	else
		if GetImpactValue(ObjectAlias,"Fracture")==1 then
			RemoveImpact(ObjectAlias,"Fracture")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_SICK,false)
			
			--RemoveImpact(ObjectAlias,"MoveSpeed")
			-- instead of RemoveImpact we add a impact for the rest of the time
			if math.mod(GetGametime(),24)<GetProperty(ObjectAlias,"FractureTime") then
				duration = math.floor(GetProperty(ObjectAlias,"FractureTime")-math.mod(GetGametime(),24))
				AddImpact(ObjectAlias,"craftsmanship",4,duration)
				AddImpact(ObjectAlias,"Fighting",4,duration)
				AddImpact(ObjectAlias,"dexterity",4,duration)
				RemoveProperty(ObjectAlias,"FractureTime")
			end
			
			if GetSettlement(ObjectAlias,"City") then
				chr_decrementInfectionCount("FractureInfected", "City")				
			end
		end
	end

end
-- -----------------------
-- Caries / zahnfaeule
-- -----------------------
function Caries(ObjectAlias, State,Force)
	-- State: true = character should get a fracture, false = the fracture should heal
	
	local duration = -1
	local modifier = 3

	if State == true then
		if not diseases_CheckDisease(ObjectAlias,Force) then
			return		
		end
		if not (GetImpactValue(ObjectAlias,"Caries")==1) then
			AddImpact(ObjectAlias,"Caries",1,duration)
			AddImpact(ObjectAlias,"Sickness",1,duration)
			SetState(ObjectAlias,STATE_SICK,true)
			
			AddImpact(ObjectAlias,"rhetoric",-modifier,duration)
			AddImpact(ObjectAlias,"charisma",-modifier,duration)
		end
	else
		if GetImpactValue(ObjectAlias,"Caries")==1 then
			RemoveImpact(ObjectAlias,"Caries")
			RemoveImpact(ObjectAlias,"Sickness")
			SetState(ObjectAlias,STATE_SICK,false)
			
			AddImpact(ObjectAlias,"rhetoric",modifier,duration)
			AddImpact(ObjectAlias,"charisma",modifier,duration)
			
			if GetSettlement(ObjectAlias,"City") then
				chr_decrementInfectionCount("CariesInfected", "City")				
			end
		end
	end
end

-- -----------------------
-- GetTreatmentCost
-- -----------------------
function GetTreatmentCost(Disease)
	if Disease == "Sprain" then
		return 200
	elseif Disease == "Cold" then
		return 250
	elseif Disease == "Influenza" then
		return 400
	elseif Disease == "BurnWound" then
		return 500
	elseif Disease == "Pox" then
		return 750
	elseif Disease == "Pneumonia" then
		return 850
	elseif Disease == "Blackdeath" then
		return 1000
	elseif Disease == "Fracture" then
		return 700
	elseif Disease == "Caries" then
		return 800
	else
		return 50
	end
end

