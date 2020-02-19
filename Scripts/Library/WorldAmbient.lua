
function CheckAmbient()
	GetScenario("World")
	if HasProperty("World", "ambient") then
		if GetProperty("World", "ambient") == 1 then
			return true
		end
	end
	return false
end

function CreateCityAnimals(city,startup)
	if worldambient_CheckAmbient()==true then
		local count = 1
		CityGetRandomBuilding(city, GL_BUILDING_CLASS_MARKET, -1, -1, -1, FILTER_IGNORE, "Market")
		if startup then
			count = CityGetLevel(city)
			worldambient_CreateAnimal("Dog","Market",count-1)
			worldambient_CreateAnimal("Cat","Market",count-1)
		else
			worldambient_CreateAnimal("Dog","Market",1)
			worldambient_CreateAnimal("Cat","Market",1)
		end
	end
end

function CreateWorldAnimals()
	if worldambient_CheckAmbient()==true then

		-- create dogs
		local num = GetOutdoorLocator("Dog", -1, "locpos")
		if num>0 then
			for l=0,num-1 do
				worldambient_CreateAnimal("Dog","locpos"..l, 1)
			end
		end

		-- create cats
		local num = GetOutdoorLocator("Cat", -1, "locpos")
		if num>0 then
			for l=0,num-1 do
				worldambient_CreateAnimal("Cat","locpos"..l, 1)
			end
		end

		-- create wolves
		local num = GetOutdoorLocator("Wolf", -1, "locpos")
		if num>0 then
			for l=0,num-1 do
				worldambient_CreateAnimal("Wolf","locpos"..l, 1)
			end
		end

		-- create ducks
		local num = GetOutdoorLocator("Duck", -1, "locpos")
		if num>0 then
			for l=0,num-1 do
				worldambient_CreateAnimal("Duck","locpos"..l, 2)
			end
		end

		-- create goose
		local num = GetOutdoorLocator("Goose", -1, "locpos")
		if num>0 then
			for l=0,num-1 do
				worldambient_CreateAnimal("Goose","locpos"..l, 2)
			end
		end

		-- create chicken
		local num = GetOutdoorLocator("Chicken", -1, "locpos")
		if num>0 then
			for l=0,num-1 do
				worldambient_CreateAnimal("Cock","locpos"..l, 1)
				worldambient_CreateAnimal("Chicken","locpos"..l, 2)
			end
		end

		-- create deers
		local num = GetOutdoorLocator("Deer", -1, "locpos")
		if num>0 then
			for l=0,num-1 do
				worldambient_CreateAnimal("Stag","locpos"..l, 1)
				worldambient_CreateAnimal("Deer","locpos"..l, 2)
			end
		end

	end
end

function CreateAnimal(animal,building,count)	
	if worldambient_CheckAmbient()==true then

		if BuildingGetType(building)==-1 then
			local Num = ScenarioGetObjects("cl_Settlement", 20, "Cities")
			local	Value = Rand(Num)
			CopyAlias("Cities"..Value, "City")		
			CopyAlias(building, "SetPos")		
		else
			BuildingGetCity(building, "City")
		  GetLocatorByName(building, "Entry1", "SetPos")
		end

		CityGetRandomBuilding("City",5,14,-1,-1,FILTER_IGNORE,"Home")

		local aID
		if animal=="Dog" then
			aID = 906
		elseif animal=="Cat" then
			aID = 908
		elseif animal=="Wolf" then
			aID = 913
		elseif animal=="Duck" then
			aID = 911
		elseif animal=="Goose" then
			aID = 912
		elseif animal=="Chicken" then
			aID = 909
		elseif animal=="Cock" then
			aID = 910
		elseif animal=="Deer" then
			aID = 914
		elseif animal=="Stag" then
			aID = 915
		end

		for i=0,count-1 do
		  SimCreate(aID,"Home","SetPos","Animal"..count)
			SimSetFirstname("Animal"..count, "@L_"..animal.."_NAME_+0")
			SimSetLastname("Animal"..count, "@L_EMPTY_NAME_+0")
			SetState("Animal"..count, STATE_ANIMAL, true)
		end
	end
end

function CreateSailor(building,count)	
	if worldambient_CheckAmbient()==true then
	  GetLocatorByName(building, "Entry1", "SetPos")

		for i=0,count-1 do
		  SimCreate(916,building,"SetPos","Sailor"..i)

			local name = GetName("Sailor"..i)
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Sailor"..i, "@L_SAILOR_NAME_MALE_+0")
			SimSetLastname("Sailor"..i, newlastname)

			SimSetBehavior("Sailor"..i,"Sailor")
		end
	end
end

function CreateTeamDonkey(startstadt)
	if worldambient_CheckAmbient()==true then
    CityGetRandomBuilding(startstadt, 3, 24, -1, -1, FILTER_IGNORE, "StartPlatz")

		if not AliasExists("#Packo") then
	    SimCreate(934,startstadt,"StartPlatz","#Packo")
	    SimSetFirstname("#Packo", "@L_UPGRADE_DONKEY_NAME_+0")
	    SimSetLastname("#Packo", "@L_EMPTY_NAME_+0")
			SimSetBehavior("#Packo","DonkeyTeam")
		end

		if not AliasExists("#Eseltreiber") then
	    SimCreate(935,startstadt,"StartPlatz","#Eseltreiber")
	    SimSetFirstname("#Eseltreiber", "@L_WORLDAMBIENT_DONKEYCHEF_NAME_+0")
	    SimSetLastname("#Eseltreiber", "@L_WORLDAMBIENT_DONKEYCHEF_NAME_+1")
			SimSetBehavior("#Eseltreiber","DonkeyTeam")
		end			
	end
end

function CreateKontorSim(building,index)	
	if worldambient_CheckAmbient()==true then
    local simse = { 939, 940, 941 }
		local citcount = Rand(3) + 4
		for i=0,citcount-1 do
		  SimCreate(simse[index],building,building,"DummyDude"..i)
			SimSetBehavior("DummyDude"..i,"DummySim")
		end
	end
end

function CreateCityBettler(city,anzahl)

	if worldambient_CheckAmbient()==true then
	  CityGetRandomBuilding(city, 5, 14, -1, -1, FILTER_IGNORE, "StartPlatz")
		local begcount = Rand(2)+anzahl
		for i=0,begcount-1 do
	    SimCreate(942,"StartPlatz","StartPlatz","Bettler"..i)
	
			local name = GetName("Bettler"..i)
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			if SimGetGender("Bettler"..i) == 1 then
	    	SimSetFirstname("Bettler"..i, "@L_BETTLER_NAME_MALE_+0")
			else
	    	SimSetFirstname("Bettler"..i, "@L_BETTLER_NAME_FEMALE_+0")
	    end	
			SimSetLastname("Bettler"..i, newlastname)
			SimSetBehavior("Bettler"..i,"BettlerSim")
		end		
	end
	
end
