function Run()
	SetState("",STATE_TOWNNPC,true)
	GetHomeBuilding("","home")
	BuildingGetCity("home","homecity")
	CityGetRandomBuilding("homecity",-1,GL_BUILDING_TYPE_SCHOOL,-1,-1, FILTER_IGNORE,"myarsenal")

	while true do
		-- try to walk to the arsenal
		if GetID("myarsenal")~=-1 then
			if GetLocatorByName("myarsenal","Materialguardpos","destpos") then
				while true do
					if f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
						break 
					end
					Sleep(2)
				end
	
				SetExclusiveMeasure("", "StartDialog",EN_PASSIVE)	
			end
		end

		while true do
			Sleep(50)
		end
	end
	
	Sleep(5)
end

function CleanUp()
	if AliasExists("destpos") then
		f_EndUseLocator("","destpos",GL_STANCE_STAND)
	end
	AllowAllMeasures("")
end


