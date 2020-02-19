function Run()
	SetState("",STATE_TOWNNPC,true)
	SimSetMortal("",false)
	GetHomeBuilding("","home")
	BuildingGetCity("home","homecity")
	CityGetRandomBuilding("homecity",-1,GL_BUILDING_TYPE_BANK,-1,-1, FILTER_IGNORE,"myguildhouse")

	local PatronElder = GetProperty("myguildhouse", "PatronElder")
	local ArtisanElder = GetProperty("myguildhouse", "ArtisanElder")
	local ScholarElder = GetProperty("myguildhouse", "ScholarElder")
	local ChiselerElder = GetProperty("myguildhouse", "ChiselerElder")

	local locator
	if PatronElder==GetID("") then
		locator = "PatronElder"
	elseif ArtisanElder==GetID("") then
		locator = "ArtisanElder"
	elseif ScholarElder==GetID("") then
		locator = "ScholarElder"
	elseif ChiselerElder==GetID("") then
		locator = "ChiselerElder"
	else
		StopMeasure()
	end

	while true do
		-- try to walk to the wedding chapel
		if GetID("myguildhouse")~=-1 then
			if GetLocatorByName("myguildhouse",locator,"destpos") then
				while true do
					if f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
						break 
					end
					Sleep(2)
				end
	
				if (gameplayformulas_CheckPublicBuilding("homecity", GL_BUILDING_TYPE_BANK)[1]>0) then
					SetExclusiveMeasure("", "StartDialog",EN_PASSIVE)	
					break
				else
					Sleep(25)
					std_guildelder_CheckAge()
				end
			end
		end

		while true do
			Sleep(50)
			std_guildelder_CheckAge()
		end
	end
	
	Sleep(5)
end

function CheckAge()
	if SimGetAge("")>65 then
		SimSetAge("", 60)
	end
end

function CleanUp()
	if AliasExists("destpos") then
		f_EndUseLocator("","destpos",GL_STANCE_STAND)
	end
	AllowAllMeasures("")
end


