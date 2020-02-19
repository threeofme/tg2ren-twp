function Run()
	SetState("",STATE_TOWNNPC,true)
	GetHomeBuilding("","home")
	BuildingGetCity("home","homecity")
	CityGetRandomBuilding("homecity",-1,GL_BUILDING_TYPE_GRAVEYARD, -1, -1, FILTER_IGNORE,"graveyard")
	
	while true do
		-- try to walk to the duel_place
		if GetID("graveyard")~=-1 then
			if GetLocatorByName("graveyard","priest","priestpos") then
				f_BeginUseLocator("","priestpos", GL_STANCE_STAND, true)
					
			end
		end

		while true do
			Sleep(100)
		end
	end
	
	Sleep(5)
end

function CleanUp()
	if AliasExists("priestpos") then
		f_EndUseLocator("","priestpos",GL_STANCE_STAND)
	end
end

